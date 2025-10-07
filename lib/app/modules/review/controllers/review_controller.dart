import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class VocabularyCategory {
  final String id;
  final String name;
  final String icon;
  final int wordCount;
  final double progress;

  VocabularyCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.wordCount,
    required this.progress,
  });
}

class ReviewController extends GetxController {
  final searchController = TextEditingController();
  final RxList<VocabularyCategory> categories = <VocabularyCategory>[].obs;
  final RxList<VocabularyCategory> filteredCategories = <VocabularyCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadCategories() {
    // Mock data for demo - replace with actual data from service
    categories.value = [
      VocabularyCategory(
        id: '1',
        name: 'Con người & phụ kiện',
        icon: '👤',
        wordCount: 18,
        progress: 0.7,
      ),
      VocabularyCategory(
        id: '2',
        name: 'Động vật',
        icon: '🐶',
        wordCount: 22,
        progress: 0.5,
      ),
      VocabularyCategory(
        id: '3',
        name: 'Trái cây',
        icon: '🍎',
        wordCount: 25,
        progress: 0.0,
      ),
      VocabularyCategory(
        id: '4',
        name: 'Nội thất & gia dụng',
        icon: '🛋️',
        wordCount: 13,
        progress: 1.0,
      ),
    ];
    filteredCategories.value = categories;
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void onCategoryTap(VocabularyCategory category) {
    // Navigate to vocabulary list
    Get.toNamed(
      Routes.vocabularyList,
      arguments: {
        'categoryId': category.id,
        'categoryName': category.name,
      },
    );
  }

  void onAddCategory() {
    // Navigate to add category screen
    Get.snackbar(
      'Thêm chủ đề',
      'Chức năng đang được phát triển',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
