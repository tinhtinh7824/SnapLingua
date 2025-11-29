import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../data/services/user_service.dart';
import '../../../data/services/auth_service.dart';
import '../../community/controllers/community_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class ProfileEditController extends GetxController {
  ProfileEditController({UserService? userService})
      : _userService = userService ?? UserService.to;

  final UserService _userService;

  final TextEditingController nameController = TextEditingController();

  final RxString selectedAvatar = ''.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  static const List<String> avatarOptions = [
    'assets/images/chimcanhcut/chim_vui1.png',
    'assets/images/chimcanhcut/chim_mung.png',
    'assets/images/chimcanhcut/chim_ok.png',
    'assets/images/chimcanhcut/chim_thich.png',
    'assets/images/chimcanhcut/chim_vui.png',
  ];

  @override
  void onInit() {
    super.onInit();
    _prefillFromCurrentSummary();
    Future.microtask(_loadProfileFromService);
  }

  void _prefillFromCurrentSummary() {
    if (Get.isRegistered<ProfileController>()) {
      final summary = Get.find<ProfileController>().summary.value;
      nameController.text =
          summary.displayName.isNotEmpty ? summary.displayName : 'Bạn học Snaplingua';
      selectedAvatar.value = summary.avatarUrl ?? avatarOptions.first;
    } else {
      nameController.text = 'Bạn học Snaplingua';
      selectedAvatar.value = avatarOptions.first;
    }
  }

  Future<void> _loadProfileFromService() async {
    try {
      final profile = await _userService.getUserProfile();
      if (profile == null) return;

      final displayName = profile['displayName'] as String?;
      final avatarUrl = profile['avatarUrl'] as String?;

      nameController.text = displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : nameController.text;
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        selectedAvatar.value = avatarUrl;
      }
    } catch (e) {
      // Ignore errors and keep prefilled values
      Get.log('Failed to load profile in editor: $e');
    }
  }

  void chooseAvatar(String path) {
    selectedAvatar.value = path;
  }

  Future<void> pickAvatarFromDevice() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        selectedAvatar.value = file.path; // local file path
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chọn ảnh: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveProfile() async {
    if (isSaving.value) return;
    final name = nameController.text.trim();
    if (name.isEmpty) {
      errorMessage.value = 'Tên người dùng không được để trống';
      return;
    }
    if (name.length < 2) {
      errorMessage.value = 'Tên người dùng phải có ít nhất 2 ký tự';
      return;
    }

    errorMessage.value = '';
    isSaving.value = true;

    try {
      String avatarUrlToSave = selectedAvatar.value;

      // If it's a local file path (picked from device), upload it.
      // Do NOT try to upload asset paths (assets/...) or already-remote http(s) URLs.
      if (avatarUrlToSave.isNotEmpty &&
          !avatarUrlToSave.startsWith('http') &&
          !avatarUrlToSave.startsWith('assets/')) {
        try {
          final localFile = File(avatarUrlToSave);
          if (await localFile.exists()) {
            avatarUrlToSave = await _userService.uploadAvatar(avatarUrlToSave);
          } else {
            // Not an existing local file; leave as-is (could be a relative path) or clear
            // so backend won't receive an invalid path. We'll clear to avoid server errors.
            avatarUrlToSave = '';
          }
        } catch (uploadErr) {
          // If upload fails, show detailed message and stop saving.
          errorMessage.value = 'Không thể upload ảnh đại diện: $uploadErr';
          return;
        }
      }

      final result = await _userService.updateProfile(
        displayName: name,
        avatarUrl: avatarUrlToSave.isNotEmpty ? avatarUrlToSave : null,
      );

      if (result['success'] == true) {
        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().loadProfile();
        }
        // Push fresh profile data to community (feed, groups, leaderboard)
        try {
          final auth = Get.isRegistered<AuthService>() ? AuthService.to : null;
          final userId = auth?.currentUserId ?? '';
          if (userId.isNotEmpty && Get.isRegistered<CommunityController>()) {
            final community = Get.find<CommunityController>();
            community.applyCurrentUserProfileLocal(
              userId: userId,
              displayName: name,
              avatarUrl: avatarUrlToSave,
            );
            await community.refreshPostsForUser(userId);
          }
        } catch (_) {
          // Best-effort only; ignore failures to keep the flow smooth.
        }
        Get.back(result: true);
        Get.snackbar(
          'Đã cập nhật',
          'Thông tin hồ sơ đã được cập nhật.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = result['message'] as String? ??
            'Không thể cập nhật thông tin. Vui lòng thử lại.';
      }
    } catch (e) {
      errorMessage.value =
          'Có lỗi xảy ra khi cập nhật hồ sơ: $e';
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
