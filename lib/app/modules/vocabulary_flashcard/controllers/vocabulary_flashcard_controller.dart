import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../vocabulary_topic/controllers/vocabulary_topic_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';

class VocabularyFlashcardController extends GetxController {
  late final List<VocabularyTopicItem> items;
  late final String topicName;
  late final PageController pageController;

  final RxInt _currentIndex = 0.obs;
  final RxBool _showBack = false.obs;

  int get currentIndex => _currentIndex.value;
  bool get isBackVisible => _showBack.value;
  bool get canGoBack => _currentIndex.value > 0;
  bool get canGoNext => _currentIndex.value < total - 1;
  int get total => items.length;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final incomingItems =
        args != null && args['items'] is List<VocabularyTopicItem>
            ? args['items'] as List<VocabularyTopicItem>
            : null;
    if (incomingItems == null || incomingItems.isEmpty) {
      items = [];
      topicName = 'Flashcard';
      pageController = PageController();
      Future.microtask(Get.back);
      return;
    }
    items = incomingItems;
    topicName = args?['topicName'] as String? ?? 'Flashcard';
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    _currentIndex.value = index;
    _showBack.value = false;
  }

  void toggleSide() {
    _showBack.toggle();
  }

  void toggleSideFor(int index) {
    if (_currentIndex.value != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }
    toggleSide();
  }

  void completeSession() async {
    final auth = Get.isRegistered<AuthService>() ? AuthService.to : null;
    final userId = (auth != null && auth.isLoggedIn && auth.currentUserId.isNotEmpty)
        ? auth.currentUserId
        : 'guest';
    final progressService =
        Get.isRegistered<DailyProgressService>() ? DailyProgressService.to : null;
    final xpAmount = items.isNotEmpty ? items.length : 0;

    if (progressService != null) {
      if (xpAmount > 0) {
        await progressService.awardXp(
          userId: userId,
          amount: xpAmount,
          activity: DailyActivityType.flashcard,
          sourceType: 'flashcard',
          action: 'flashcard_session',
          wordsCount: items.length,
          metadata: {'topic': topicName},
        );
      } else {
        await progressService.markActivity(
          userId: userId,
          activity: DailyActivityType.flashcard,
        );
      }
    }

    Get.back();
    Get.snackbar('Flashcard', 'Bạn đã hoàn thành ôn tập "$topicName"');
  }

  void playAudio(VocabularyTopicItem item) {
    Get.snackbar(
      'Đang phát âm',
      'Tính năng âm thanh đang được phát triển',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void previousCard() {
    if (!canGoBack) return;
    _showBack.value = false;
    pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void nextCard() {
    if (!canGoNext) return;
    _showBack.value = false;
    pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
