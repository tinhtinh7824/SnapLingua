import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../../core/utils/platform_detector.dart';
import '../../../routes/app_pages.dart';
import '../views/custom_camera_view.dart';

class CameraDetectionController extends GetxController {
  static CameraDetectionController get to => Get.find();

  final _image = Rxn<File>();
  final _isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  File? get image => _image.value;
  bool get isLoading => _isLoading.value;

  /// Chụp ảnh từ camera với khung vuông
  Future<void> takePhoto() async {
    try {
      // Open custom camera with square frame
      final result = await Get.to<String>(() => const CustomCameraView());

      if (result != null) {
        print('📷 Đã chụp ảnh: $result');
        // Crop ảnh thành hình vuông programmatically
        await _cropImageToSquare(result);
      } else {
        print('❌ Người dùng hủy chụp ảnh');
      }
    } catch (e) {
      print('❌ Lỗi khi chụp ảnh: $e');
      _showError('Không thể chụp ảnh: $e');
    }
  }

  /// Chọn ảnh từ thư viện
  Future<void> pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        print('🖼️ Đã chọn ảnh: ${pickedFile.path}');
        // Crop ảnh thành hình vuông programmatically
        await _cropImageToSquare(pickedFile.path);
      } else {
        print('❌ Người dùng hủy chọn ảnh');
      }
    } catch (e) {
      print('❌ Lỗi khi chọn ảnh: $e');
      _showError('Không thể chọn ảnh: $e');
    }
  }

  /// Crop ảnh thành hình vuông (center crop)
  Future<void> _cropImageToSquare(String imagePath) async {
    try {
      print('✂️ Đang crop ảnh thành hình vuông...');

      // Read image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        _showError('Không thể đọc ảnh');
        return;
      }

      // Calculate square size (use smaller dimension)
      final size = image.width < image.height ? image.width : image.height;

      // Calculate crop position (center)
      final x = (image.width - size) ~/ 2;
      final y = (image.height - size) ~/ 2;

      // Crop to square
      final cropped = img.copyCrop(image, x: x, y: y, width: size, height: size);

      // Save cropped image
      final tempDir = await getTemporaryDirectory();
      final croppedPath = '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final croppedFile = File(croppedPath);
      await croppedFile.writeAsBytes(img.encodeJpg(cropped, quality: 85));

      _image.value = croppedFile;
      print('✂️ Đã crop ảnh: $croppedPath');

      await _uploadAndDetect();
    } catch (e) {
      print('❌ Lỗi khi crop ảnh: $e');
      _showError('Không thể xử lý ảnh: $e');
    }
  }

  /// Upload ảnh lên YOLO service và nhận diện
  Future<void> _uploadAndDetect() async {
    if (_image.value == null) return;

    _isLoading.value = true;

    try {
      print('⚡ Bắt đầu gửi ảnh đến YOLO service...');

      // Get backend URL (auto-detect emulator/real device)
      final baseUrl = PlatformDetector.getBackendUrl(
        localIp: '192.168.0.102', // TODO: Replace with your machine IP
        port: 8001,
        useHttps: false,
      );

      final uri = Uri.parse('$baseUrl/predict');

      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _image.value!.path,
        ),
      );

      print('⚡ Đang gửi ảnh: ${_image.value!.path}');
      print('⚡ API URL: $uri');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('⚡ Response Data: $responseData');

      var jsonResponse = jsonDecode(responseData);

      // Kiểm tra lỗi
      if (jsonResponse.containsKey('error')) {
        _showError('Lỗi từ server: ${jsonResponse['error']}');
        return;
      }

      if (!jsonResponse.containsKey('processed_image_url') ||
          !jsonResponse.containsKey('detections')) {
        _showError('API không trả về đủ dữ liệu');
        return;
      }

      // Extract detected words
      Set<String> detectedWords = {};
      for (var detection in jsonResponse['detections']) {
        detectedWords.add(detection['class']);
      }

      String processedImageUrl = jsonResponse['processed_image_url'];

      print('✅ Nhận diện được ${detectedWords.length} từ vựng');
      print('✅ URL ảnh đã xử lý: $processedImageUrl');

      // Navigate to result page
      Get.toNamed(
        Routes.detectionResult,
        arguments: {
          'detectedImageUrl': processedImageUrl,
          'words': detectedWords.toList(),
          'originalImage': _image.value,
        },
      );
    } catch (e) {
      print('❌ Lỗi khi gửi ảnh: $e');
      _showError('Không thể kết nối đến server: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Lỗi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
