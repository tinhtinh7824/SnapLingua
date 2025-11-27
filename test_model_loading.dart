#!/usr/bin/env dart

/// Test script to verify YOLOv8n TFLite model loading
/// Run with: dart test_model_loading.dart

import 'dart:io';
import 'dart:typed_data';

void main() async {
  print('🧪 Testing YOLOv8n TFLite model loading...');
  print('=' * 50);

  // Check if model file exists
  final modelPath = '/Users/admin/Desktop/snaplingua/assets/ml_models/yolov8n_float16.tflite';
  final modelFile = File(modelPath);

  if (!await modelFile.exists()) {
    print('❌ Model file not found: $modelPath');
    exit(1);
  }

  // Check model file size
  final fileSize = await modelFile.length();
  print('✅ Model file found');
  print('📏 Model size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB');

  // Check if file is a valid TFLite model by reading magic bytes
  final bytes = await modelFile.openRead(0, 8).first;
  final header = String.fromCharCodes(bytes.take(4));

  if (header == 'TFL3') {
    print('✅ Valid TensorFlow Lite model (TFL3 format)');
  } else {
    print('⚠️ Unknown format - header: $header');
    print('🔍 First 8 bytes: ${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
  }

  // Check labels file
  final labelsPath = '/Users/admin/Desktop/snaplingua/assets/ml_models/labels.txt';
  final labelsFile = File(labelsPath);

  if (await labelsFile.exists()) {
    final labelsContent = await labelsFile.readAsString();
    final labels = labelsContent.split('\n').where((l) => l.trim().isNotEmpty).toList();
    print('✅ Labels file found with ${labels.length} classes');
    print('📋 First 5 labels: ${labels.take(5).join(', ')}');
  } else {
    print('❌ Labels file not found: $labelsPath');
  }

  print('\n🎯 Model loading test completed!');
  print('\nNext steps:');
  print('   1. Run Flutter app: flutter run');
  print('   2. Test camera detection');
  print('   3. Check console for "✅ YOLOv8n TFLite model loaded successfully"');
}