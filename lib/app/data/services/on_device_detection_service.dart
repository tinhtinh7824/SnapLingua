import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// On-device YOLOv8n detector using a TFLite model packaged in assets.
///
/// Expectations:
/// - Model file: YOLOv8n float16 TFLite model at `assets/ml_models/yolov8n_float16.tflite`
/// - Label file: COCO class names at `assets/ml_models/labels.txt`
/// - Model output shape: `[1, N, 84]` (cx, cy, w, h, obj, class scores...)
/// Adjust constants below if your export differs.
class OnDeviceDetectionService {
  OnDeviceDetectionService._();
  static final OnDeviceDetectionService instance = OnDeviceDetectionService._();

  static const _modelAsset = 'assets/ml_models/yolov8n_float32.tflite';
  static const _labelsAsset = 'assets/ml_models/labels.txt';
  static const _confidenceThreshold = 0.35;
  static const _iouThreshold = 0.45;

  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> _ensureLoaded() async {
    if (_interpreter != null && _labels != null) return;

    // Load labels first (always available)
    _labels ??= await _loadLabels();

    // Try to load model, but don't fail if not available
    if (await _assetExists(_modelAsset)) {
      try {
        final modelBytes = await rootBundle.load(_modelAsset);
        _interpreter ??= Interpreter.fromBuffer(modelBytes.buffer.asUint8List());
        print('✅ YOLOv8n TFLite model loaded successfully');
      } catch (e) {
        print('⚠️ TFLite model load failed, will use demo mode: $e');
      }
    } else {
      print('⚠️ TFLite model not found, using demo mode');
    }
  }

  Future<List<String>> _loadLabels() async {
    try {
      if (await _assetExists(_labelsAsset)) {
        final raw = await rootBundle.loadString(_labelsAsset);
        return raw
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);
      }
    } catch (e) {
      print('⚠️ Could not load labels file: $e');
    }

    // Fallback to COCO labels
    return [
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
  }

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<DetectionResult> detect(File imageFile) async {
    await _ensureLoaded();

    // If no interpreter loaded, use demo mode
    if (_interpreter == null) {
      print('🎭 OnDevice detector using demo mode');
      return DetectionResult(
        detections: _getDemoDetections(),
        annotatedImagePath: imageFile.path,
      );
    }

    final interpreter = _interpreter!;

    final imageBytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw Exception('Không thể đọc ảnh');
    }

    // Read the model's expected input shape (usually [1, h, w, 3])
    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = inputTensor.shape;
    if (inputShape.length != 4 || inputShape.last != 3) {
      throw Exception('Model input shape không hợp lệ: $inputShape');
    }
    final inputHeight = inputShape[1];
    final inputWidth = inputShape[2];

    try {
      final outputTensorInfo = interpreter.getOutputTensor(0);
      print('🔍 Input tensor shape: $inputShape');
      print('🔍 Output tensor shape: ${outputTensorInfo.shape}');
    } catch (e) {
      print('⚠️ Could not get tensor info: $e');
    }

    // Resize the input tensor to the model's expected NHWC shape
    try {
      interpreter.resizeInputTensor(0, inputShape);
      interpreter.allocateTensors();
    } catch (e) {
      print('⚠️ Could not resize/allocate tensors, using current shape: $e');
    }

    // Preprocess image into NHWC list [1, H, W, 3] (float32)
    final inputBuffer = _preprocess(decoded, inputWidth, inputHeight);

    // Get output shape and allocate buffer
    final outputShape = interpreter.getOutputTensor(0).shape;
    final outputBuffer = List.generate(
      outputShape[0],
      (_) => List.generate(
        outputShape[1],
        (_) => List<double>.filled(outputShape[2], 0.0),
      ),
    );

    // Run inference
    interpreter.run(inputBuffer, outputBuffer);

    final detections = _postProcess(
      _flattenOutput(outputBuffer),
      outputShape,
      decoded.width,
      decoded.height,
      inputWidth,
      inputHeight,
    );

    return DetectionResult(
      detections: detections,
      annotatedImagePath: imageFile.path,
    );
  }

  /// Flatten model output [1, C, N] -> Float32List of length C*N.
  Float32List _flattenOutput(List<List<List<double>>> output) {
    // Convert from [1, channels, numDetections] to a flat list ordered by
    // detection, so each detection occupies a contiguous slice of `channels`.
    final batch = output.first;
    if (batch.isEmpty) return Float32List(0);

    final channels = batch.length;
    final numDetections = batch.first.length;
    final flat = List<double>.filled(channels * numDetections, 0.0);

    for (var det = 0; det < numDetections; det++) {
      final base = det * channels;
      for (var c = 0; c < channels; c++) {
        flat[base + c] = batch[c][det];
      }
    }
    return Float32List.fromList(flat);
  }

  /// Converts image to NHWC float32 list matching TFLite input shape.
  List<List<List<List<double>>>> _preprocess(
    img.Image image,
    int targetWidth,
    int targetHeight,
  ) {
    final resized =
        img.copyResize(image, width: targetWidth, height: targetHeight);

    return List.generate(
      1,
      (_) => List.generate(
        targetHeight,
        (y) => List.generate(
          targetWidth,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );
  }

  List<Detection> _postProcess(
    Float32List output,
    List<int> shape,
    int originalWidth,
    int originalHeight,
    int inputWidth,
    int inputHeight,
  ) {
    print('🔍 Processing output shape: $shape');
    print('🔍 Output data length: ${output.length}');

    final labels = _labels ?? [];
    final scaleX = originalWidth / inputWidth;
    final scaleY = originalHeight / inputHeight;

    final candidates = <Detection>[];

    // Handle different YOLOv8 output formats
    if (shape.length == 3) {
      // Format: [1, num_detections, 84] or [1, 84, num_detections]
      final numDetections = shape[1] > shape[2] ? shape[1] : shape[2];
      final featuresPerDetection = shape[1] < shape[2] ? shape[1] : shape[2];

      print('🔍 Detected $numDetections detections with $featuresPerDetection features each');

      // YOLOv8 format: [x_center, y_center, width, height, class_scores...]
      for (var i = 0; i < numDetections; i++) {
        var base = i * featuresPerDetection;
        if (base + 4 >= output.length) break;

        // Extract bbox coordinates (normalized 0-640)
        final cx = output[base + 0];
        final cy = output[base + 1];
        final w = output[base + 2];
        final h = output[base + 3];

        // Find best class from remaining features (classes 4-83 = 80 classes)
        var bestScore = 0.0;
        var bestClass = -1;
        for (var c = 4; c < featuresPerDetection && c < base + featuresPerDetection; c++) {
          if (base + c >= output.length) break;
          final classScore = output[base + c];
          if (classScore > bestScore) {
            bestScore = classScore;
            bestClass = c - 4; // Adjust for 0-based indexing
          }
        }

        if (bestScore < _confidenceThreshold || bestClass < 0) continue;

        final rect = _convertToRect(cx, cy, w, h, scaleX, scaleY);
        final label = (bestClass >= 0 && bestClass < labels.length)
            ? labels[bestClass]
            : 'object_$bestClass';
        candidates.add(Detection(
          label: label,
          confidence: bestScore,
          rect: rect,
        ));
      }
    }

    print('🔍 Found ${candidates.length} candidate detections');
    return _nonMaxSuppression(candidates);
  }

  Rect _convertToRect(
    double cx,
    double cy,
    double w,
    double h,
    double scaleX,
    double scaleY,
  ) {
    final left = (cx - w / 2) * scaleX;
    final top = (cy - h / 2) * scaleY;
    final right = (cx + w / 2) * scaleX;
    final bottom = (cy + h / 2) * scaleY;
    return Rect(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  List<Detection> _nonMaxSuppression(List<Detection> detections) {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    final result = <Detection>[];

    while (detections.isNotEmpty) {
      final best = detections.removeAt(0);
      result.add(best);
      detections.removeWhere(
        (d) =>
            d.label == best.label &&
            _iou(d.rect, best.rect) > _iouThreshold,
      );
    }
    return result;
  }

  double _iou(Rect a, Rect b) {
    final intersectLeft = max(a.left, b.left);
    final intersectTop = max(a.top, b.top);
    final intersectRight = min(a.right, b.right);
    final intersectBottom = min(a.bottom, b.bottom);

    final intersectArea =
        max(0.0, intersectRight - intersectLeft) *
        max(0.0, intersectBottom - intersectTop);

    final unionArea = a.area + b.area - intersectArea;
    if (unionArea <= 0) return 0;
    return intersectArea / unionArea;
  }

  /// Demo detections for testing when model is not available
  List<Detection> _getDemoDetections() {
    return [
      Detection(
        label: 'person',
        confidence: 0.85,
        rect: Rect(left: 100, top: 100, right: 200, bottom: 200),
      ),
      Detection(
        label: 'chair',
        confidence: 0.75,
        rect: Rect(left: 250, top: 150, right: 350, bottom: 250),
      ),
      Detection(
        label: 'laptop',
        confidence: 0.65,
        rect: Rect(left: 400, top: 200, right: 500, bottom: 300),
      ),
      Detection(
        label: 'book',
        confidence: 0.60,
        rect: Rect(left: 150, top: 300, right: 250, bottom: 400),
      ),
    ];
  }
}

class DetectionResult {
  DetectionResult({
    required this.detections,
    required this.annotatedImagePath,
  });

  final List<Detection> detections;
  final String annotatedImagePath;
}

class Detection {
  Detection({
    required this.label,
    required this.confidence,
    required this.rect,
  });

  final String label;
  final double confidence;
  final Rect rect;
}

class Rect {
  const Rect({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;
  double get area => max(0.0, width) * max(0.0, height);
}

class TensorBuffer {
  TensorBuffer(this.shape, this.buffer);
  final List<int> shape;
  final Float32List buffer;
}
