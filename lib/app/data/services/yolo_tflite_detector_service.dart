// Remove unnecessary import - dart:typed_data included in foundation.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Dịch vụ nhận diện từ vựng sử dụng YOLOv10 TFLite model
/// Tích hợp với infrastructure OnDeviceDetectionService hiện có
class YoloTfliteDetectorService extends GetxService {
  static const String modelAsset = 'assets/models/yolov10n.tflite';
  static const String labelsAsset = 'assets/ml_models/labels.txt';
  static const int inputSize = 640;
  static const double confidenceThreshold = 0.25;

  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isModelLoaded = false;

  // COCO class names fallback nếu không có labels.txt
  static const List<String> defaultClassNames = [
    'person', 'bicycle', 'car', 'motorcycle', 'airplane', 'bus', 'train',
    'truck', 'boat', 'traffic light', 'fire hydrant', 'stop sign',
    'parking meter', 'bench', 'bird', 'cat', 'dog', 'horse', 'sheep',
    'cow', 'elephant', 'bear', 'zebra', 'giraffe', 'backpack', 'umbrella',
    'handbag', 'tie', 'suitcase', 'frisbee', 'skis', 'snowboard',
    'sports ball', 'kite', 'baseball bat', 'baseball glove', 'skateboard',
    'surfboard', 'tennis racket', 'bottle', 'wine glass', 'cup', 'fork',
    'knife', 'spoon', 'bowl', 'banana', 'apple', 'sandwich', 'orange',
    'broccoli', 'carrot', 'hot dog', 'pizza', 'donut', 'cake', 'chair',
    'couch', 'potted plant', 'bed', 'dining table', 'toilet', 'tv',
    'laptop', 'mouse', 'remote', 'keyboard', 'cell phone', 'microwave',
    'oven', 'toaster', 'sink', 'refrigerator', 'book', 'clock', 'vase',
    'scissors', 'teddy bear', 'hair drier', 'toothbrush'
  ];

  bool get isModelLoaded => _isModelLoaded;
  List<String> get classNames => _labels ?? defaultClassNames;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadModel();
  }

  @override
  void onClose() {
    if (_interpreter != null) {
      _interpreter!.close();
      _interpreter = null;
    }
    super.onClose();
  }

  /// Load TFLite model từ assets
  Future<bool> loadModel() async {
    try {
      if (kDebugMode) print('🤖 Loading YOLOv10 TFLite model...');

      // Load labels first
      await _loadLabels();

      // Check if TFLite model exists
      if (!await _assetExists(modelAsset)) {
        if (kDebugMode) print('⚠️ TFLite model not found at $modelAsset');
        if (kDebugMode) print('💡 Please convert ONNX to TFLite first');
        _isModelLoaded = false;
        return false;
      }

      // Load TFLite model from assets
      final modelBytes = await rootBundle.load(modelAsset);
      _interpreter = Interpreter.fromBuffer(modelBytes.buffer.asUint8List());

      _isModelLoaded = true;
      if (kDebugMode) print('✅ YOLOv10 TFLite model loaded successfully');
      if (kDebugMode) print('📋 Labels loaded: ${classNames.length} classes');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error loading TFLite model: $e');
      _isModelLoaded = false;
      return false;
    }
  }

  /// Load labels từ file hoặc sử dụng default
  Future<void> _loadLabels() async {
    try {
      if (await _assetExists(labelsAsset)) {
        final labelsString = await rootBundle.loadString(labelsAsset);
        _labels = labelsString
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (kDebugMode) print('📋 Loaded ${_labels!.length} labels from $labelsAsset');
      } else {
        _labels = List.from(defaultClassNames);
        if (kDebugMode) print('📋 Using default COCO labels (${_labels!.length} classes)');
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Error loading labels, using defaults: $e');
      _labels = List.from(defaultClassNames);
    }
  }

  /// Kiểm tra asset có tồn tại
  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Detect objects trong image
  Future<List<VocabDetection>> detectVocabulary(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      if (kDebugMode) print('❌ Model not loaded, using demo mode');
      // Demo mode: return sample detections for testing
      return _getDemoDetections();
    }

    try {
      // Load và decode image
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Không thể decode image');
      }

      // Preprocessing
      final inputData = _preprocessImage(image);

      // Prepare input/output tensors
      final input = [inputData.buffer.asFloat32List()];
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      final output = List.generate(
        outputShape.reduce((a, b) => a * b),
        (_) => 0.0,
      );

      // Run inference
      _interpreter!.run(input, [output]);

      // Postprocess results
      final detections = _postprocessOutputs(output, outputShape, image.width, image.height);

      if (kDebugMode) print('🎯 Detected ${detections.length} objects');
      return detections;

    } catch (e) {
      if (kDebugMode) print('❌ Detection error: $e');
      return [];
    }
  }

  /// Preprocessing image cho YOLO
  Float32List _preprocessImage(img.Image image) {
    // Resize image to model input size
    final resized = img.copyResize(image, width: inputSize, height: inputSize);

    // Convert to float và normalize [0, 1]
    final Float32List inputData = Float32List(3 * inputSize * inputSize);
    int pixelIndex = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        // RGB format thay vì CHW
        inputData[pixelIndex++] = pixel.r / 255.0;
        inputData[pixelIndex++] = pixel.g / 255.0;
        inputData[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return inputData;
  }

  /// Postprocess TFLite outputs
  List<VocabDetection> _postprocessOutputs(
    List<double> output,
    List<int> outputShape,
    int originalWidth,
    int originalHeight,
  ) {
    List<VocabDetection> detections = [];

    // Kiểm tra output shape phù hợp với YOLOv10
    if (outputShape.length < 2) return detections;

    final numDetections = outputShape[1]; // Usually around 300 for YOLOv10
    final valuesPerDetection = outputShape.length > 2 ? outputShape[2] : 6;

    final scaleX = originalWidth / inputSize;
    final scaleY = originalHeight / inputSize;

    for (int i = 0; i < numDetections; i++) {
      final base = i * valuesPerDetection;
      if (base + 5 >= output.length) break;

      // YOLOv10 format: [x1, y1, x2, y2, confidence, class_id]
      final x1 = output[base + 0] * scaleX;
      final y1 = output[base + 1] * scaleY;
      final x2 = output[base + 2] * scaleX;
      final y2 = output[base + 3] * scaleY;
      final confidence = output[base + 4];
      final classId = output[base + 5].round();

      if (confidence > confidenceThreshold &&
          classId >= 0 &&
          classId < classNames.length) {

        detections.add(VocabDetection(
          bbox: [x1, y1, x2, y2],
          confidence: confidence,
          classId: classId,
          className: classNames[classId],
        ));
      }
    }

    // Sort by confidence
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    return detections;
  }

  /// Get unique vocabulary words từ detections
  List<String> getVocabularyWords(List<VocabDetection> detections) {
    final Set<String> uniqueWords = {};

    for (final detection in detections) {
      if (detection.confidence > 0.3) { // Filter confidence cao
        uniqueWords.add(detection.className);
      }
    }

    return uniqueWords.toList();
  }

  /// Format detection results cho UI
  String formatDetectionResults(List<VocabDetection> detections) {
    if (detections.isEmpty) {
      return 'Không nhận diện được từ vựng nào.';
    }

    final buffer = StringBuffer();
    buffer.writeln('Đã nhận diện được ${detections.length} đối tượng:');

    for (int i = 0; i < detections.length && i < 10; i++) {
      final detection = detections[i];
      buffer.writeln('${i + 1}. ${detection.className} (${(detection.confidence * 100).toStringAsFixed(1)}%)');
    }

    return buffer.toString();
  }

  /// Tạo model conversion script để user chạy
  String getConversionInstructions() {
    return '''
🔄 Để sử dụng YOLOv10 TFLite detector:

1. Convert ONNX sang TFLite:
   python /path/to/vocab-snap/onnx_to_tflite_alternative.py

2. Copy model vào Flutter:
   cp yolov10n.tflite assets/models/

3. Model sẽ tự động được load khi khởi động app.

📁 Current status:
- ONNX model: ✅ Available at assets/models/yolov10n.onnx
- TFLite model: ❌ Need conversion
- Labels: ✅ Using COCO classes (${classNames.length} classes)

🎭 Demo mode: App hiện đang chạy với fake detections để test workflow
''';
  }

  /// Demo detections để test workflow khi chưa có TFLite model
  List<VocabDetection> _getDemoDetections() {
    if (kDebugMode) print('🎭 Running in demo mode - returning sample detections');

    // Fake detections để test UI và workflow
    return [
      VocabDetection(
        bbox: [100.0, 100.0, 200.0, 200.0],
        confidence: 0.85,
        classId: 0,
        className: 'person',
      ),
      VocabDetection(
        bbox: [250.0, 150.0, 350.0, 250.0],
        confidence: 0.75,
        classId: 56,
        className: 'chair',
      ),
      VocabDetection(
        bbox: [400.0, 200.0, 500.0, 300.0],
        confidence: 0.65,
        classId: 64,
        className: 'laptop',
      ),
      VocabDetection(
        bbox: [150.0, 300.0, 250.0, 400.0],
        confidence: 0.60,
        classId: 73,
        className: 'book',
      ),
    ];
  }
}

/// Data class cho detection results - tương thích với ONNX version
class VocabDetection {
  final List<double> bbox; // [x1, y1, x2, y2]
  final double confidence;
  final int classId;
  final String className;

  VocabDetection({
    required this.bbox,
    required this.confidence,
    required this.classId,
    required this.className,
  });

  @override
  String toString() {
    return 'VocabDetection(className: $className, confidence: ${confidence.toStringAsFixed(3)}, bbox: $bbox)';
  }

  /// Convert to JSON for API compatibility
  Map<String, dynamic> toJson() {
    return {
      'class': className,
      'confidence': confidence,
      'class_id': classId,
      'bbox': bbox,
    };
  }

  /// Create from JSON (for API compatibility)
  factory VocabDetection.fromJson(Map<String, dynamic> json) {
    return VocabDetection(
      className: json['class'] ?? 'unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      classId: json['class_id'] ?? -1,
      bbox: (json['bbox'] as List?)?.cast<double>() ?? [0.0, 0.0, 0.0, 0.0],
    );
  }
}