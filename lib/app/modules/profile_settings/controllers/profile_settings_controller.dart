import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../routes/app_pages.dart' as routes;

class ProfileSettingsController extends GetxController {
  ProfileSettingsController({AuthService? authService})
      : _authService = authService ?? AuthService.to;

  final AuthService _authService;
  final RxBool isProcessing = false.obs;

  void openGoals() {
    Get.toNamed(Routes.profileGoal);
  }

  Future<void> openEditProfile() async {
    final result = await Get.toNamed(Routes.profileEdit);
    if (result == true && Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().loadProfile();
    }
  }

  Future<void> openChangePassword() async {
    final result = await Get.toNamed(Routes.profileChangePassword);
    if (result == true) {
      Get.snackbar(
        'Thành công',
        'Bạn đã đổi mật khẩu.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openNotifications() async {
    await Get.toNamed(Routes.profileNotification);
  }

  void openGuide() {
    Get.toNamed(routes.Routes.profileGuide);
  }

  Future<void> logout() async {
    if (isProcessing.value) return;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi Snaplingua?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8505B),
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isProcessing.value = true;
    try {
      await _authService.logout();
      Get.offAllNamed(Routes.login);
      Get.snackbar(
        'Đăng xuất thành công',
        'Hẹn gặp lại bạn trong buổi học tiếp theo!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể đăng xuất. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }
}
