import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/goal_service.dart';

class ProfileGoalController extends GetxController {
  ProfileGoalController({GoalService? goalService})
      : _goalService = goalService ?? GoalService.to;

  final GoalService _goalService;

  late final TextEditingController learnController;
  late final TextEditingController reviewController;

  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    learnController = TextEditingController(
      text: _goalService.dailyLearnGoal.value.toString(),
    );
    reviewController = TextEditingController(
      text: _goalService.dailyReviewGoal.value.toString(),
    );
  }

  Future<void> saveGoals() async {
    if (isSaving.value) return;
    final learn = int.tryParse(learnController.text.trim());
    final review = int.tryParse(reviewController.text.trim());

    if (learn == null || learn <= 0) {
      errorMessage.value = 'Số từ vựng học mỗi ngày phải lớn hơn 0';
      return;
    }
    if (review == null || review <= 0) {
      errorMessage.value = 'Số từ vựng ôn tập mỗi ngày phải lớn hơn 0';
      return;
    }

    errorMessage.value = '';
    isSaving.value = true;

    try {
      await _goalService.updateGoals(
        learnGoal: learn,
        reviewGoal: review,
      );
      Get.back(result: true);
      Get.snackbar(
        'Đã cập nhật',
        'Mục tiêu học tập đã được lưu.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Không thể cập nhật mục tiêu. Vui lòng thử lại.';
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    learnController.dispose();
    reviewController.dispose();
    super.onClose();
  }
}
