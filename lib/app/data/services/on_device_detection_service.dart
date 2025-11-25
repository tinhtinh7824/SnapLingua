import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Simple on-device YOLOv8 style detector using a TFLite model packaged in assets.
///
/// Expectations:
/// - Model file placed at `assets/ml_models/model.tflite`
/// - Label file placed at `assets/ml_models/labels.txt`
/// - Model output shape is `[1, N, 84]` (cx, cy, w, h, obj, class scores...)
/// Adjust constants below if your export differs.
class OnDeviceDetectionService {
  OnDeviceDetectionService._();
  static final OnDeviceDetectionService instance = OnDeviceDetectionService._();

  static const _modelAsset = 'assets/ml_models/model.tflite';
  static const _labelsAsset = 'assets/ml_models/labels.txt';
  static const _inputSize = 640;
  static const _confidenceThreshold = 0.35;
  static const _iouThreshold = 0.45;

  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> _ensureLoaded() async {
    if (_interpreter != null && _labels != null) return;

    if (!await _assetExists(_modelAsset)) {
      throw Exception(
        'Thiếu file model TFLite tại $_modelAsset. Hãy đặt file model ở thư mục assets/ml_models và đảm bảo pubspec.yaml khai báo assets.',
      );
    }
    if (!await _assetExists(_labelsAsset)) {
      throw Exception(
        'Thiếu file labels tại $_labelsAsset. Hãy thêm labels.txt tương ứng với model.',
      );
    }

    // Load model from asset buffer to avoid path issues on some platforms.
    final modelBytes = await rootBundle.load(_modelAsset);
    _interpreter ??= await Interpreter.fromBuffer(modelBytes.buffer.asUint8List());
    _labels ??= await _loadLabels();
  }

  Future<List<String>> _loadLabels() async {
    final raw = await rootBundle.loadString(_labelsAsset);
    return raw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
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
    final interpreter = _interpreter!;

    final imageBytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw Exception('Không thể đọc ảnh');
    }

    final input = _preprocess(decoded);
    final outputShape = interpreter.getOutputTensor(0).shape;

    // Allocate output buffer dynamically based on model output shape.
    final output = List.generate(
      outputShape.reduce((a, b) => a * b),
      (_) => 0.0,
    );
    final outputBuffer = Float32List.fromList(output);
    final outputTensor = TensorBuffer(outputShape, outputBuffer);

    interpreter.run(input.buffer.asFloat32List(), outputTensor.buffer);

    final detections = _postProcess(
      outputTensor.buffer,
      outputShape,
      decoded.width,
      decoded.height,
    );

    return DetectionResult(
      detections: detections,
      annotatedImagePath: imageFile.path,
    );
  }

  Float32List _preprocess(img.Image image) {
    final resized =
        img.copyResize(image, width: _inputSize, height: _inputSize);
    final imageBytes = Float32List(_inputSize * _inputSize * 3);
    var pixelIndex = 0;
    for (var y = 0; y < _inputSize; y++) {
      for (var x = 0; x < _inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        imageBytes[pixelIndex++] = pixel.r / 255.0;
        imageBytes[pixelIndex++] = pixel.g / 255.0;
        imageBytes[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return imageBytes;
  }

  List<Detection> _postProcess(
    Float32List output,
    List<int> shape,
    int originalWidth,
    int originalHeight,
  ) {
    final numBoxes = shape[1];
    final valuesPerBox = shape[2];
    final labels = _labels ?? [];

    final scaleX = originalWidth / _inputSize;
    final scaleY = originalHeight / _inputSize;

    final candidates = <Detection>[];
    for (var i = 0; i < numBoxes; i++) {
      final base = i * valuesPerBox;
      final cx = output[base + 0];
      final cy = output[base + 1];
      final w = output[base + 2];
      final h = output[base + 3];
      final obj = output[base + 4];

      var bestScore = 0.0;
      var bestClass = -1;
      for (var c = 5; c < valuesPerBox; c++) {
        final classScore = output[base + c] * obj;
        if (classScore > bestScore) {
          bestScore = classScore;
          bestClass = c - 5;
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
