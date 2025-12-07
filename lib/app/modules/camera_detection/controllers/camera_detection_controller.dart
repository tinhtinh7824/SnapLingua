import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../routes/app_pages.dart';
import '../views/custom_camera_view.dart';
import '../../../data/services/yolo_api_service.dart';

class CameraDetectionController extends GetxController {
  static CameraDetectionController get to => Get.find();

  final _image = Rxn<File>();
  final _isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  final YoloApiService _yoloApiService = YoloApiService();

  File? get image => _image.value;
  bool get isLoading => _isLoading.value;

  /// Chụp ảnh từ camera với khung vuông
  Future<void> takePhoto() async {
    try {
      // Open custom camera with square frame
      final result = await Get.to<String>(() => const CustomCameraView());

      if (result == null) {
        print('❌ Người dùng hủy chụp ảnh');
        return;
      }

      if (result == CustomCameraView.galleryResultTag) {
        await pickFromGallery();
        return;
      }

      print('📷 Đã chụp ảnh: $result');
      // Crop ảnh thành hình vuông programmatically
      await _cropImageToSquare(result);
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

  /// Upload ảnh lên detection service và nhận diện
  Future<void> _uploadAndDetect() async {
    if (_image.value == null) return;

    _isLoading.value = true;

    try {
      print('⚡ Gửi ảnh tới YOLO API...');
      final result = await _yoloApiService.detect(_image.value!);

      if (result.labels.isEmpty) {
        _showError('Không phát hiện được đối tượng nào');
        return;
      }

      final detectedWords = <String>{...result.labels};

      print('✅ YOLO API nhận diện được ${detectedWords.length} từ: $detectedWords');

      // Nếu YOLO trả về ảnh annotate qua URL, tải về file tạm riêng để tránh bị backend ghi đè.
      String resolvedImagePath = _image.value!.path;
      if ((result.processedImageUrl ?? '').isNotEmpty) {
        final downloaded = await _downloadProcessedImage(result.processedImageUrl!);
        if (downloaded != null) {
          resolvedImagePath = downloaded.path;
        }
      }

      // Navigate to result page
      Get.toNamed(
        Routes.detectionResult,
        arguments: {
          // Hiển thị ảnh gốc (hoặc ảnh annotate nếu bạn vẽ bounding boxes sau)
          'detectedImageUrl': resolvedImagePath,
          'words': detectedWords.toList(),
          'originalImage': _image.value,
        },
      );
    } catch (e) {
      print('❌ Lỗi khi gọi YOLO API: $e');
      _showError('Không thể nhận diện: $e');
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

  Future<File?> _downloadProcessedImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return null;
      }
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/community_post_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (_) {
      return null;
    }
  }
}
