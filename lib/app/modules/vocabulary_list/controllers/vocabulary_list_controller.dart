import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/vocabulary_model.dart';
import '../../../data/services/realm_service.dart';

class VocabularyListController extends GetxController {
  static VocabularyListController get to => Get.find();

  // Category info
  String categoryId = '';
  String categoryName = 'Từ vựng';

  // Vocabulary list
  final _vocabularies = <Vocabulary>[].obs;
  final _userVocabularies = <UserVocabulary>[].obs;
  final _isLoading = false.obs;

  // Index để tra nhanh O(1) thay vì O(N)
  final Map<String, UserVocabulary> _userVocabIndex = {};

  List<Vocabulary> get vocabularies => _vocabularies;
  List<UserVocabulary> get userVocabularies => _userVocabularies;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();

    // Lấy thông tin category từ arguments
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      categoryName = args['categoryName'] ?? 'Từ vựng';
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Load vocabularies sau khi build xong
    // Chạy async để không block UI thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVocabularies();
    });
  }

  /// Load danh sách từ vựng theo category
  Future<void> loadVocabularies() async {
    print('🔵 START: Loading vocabularies for category: $categoryName');

    // Set loading true FIRST
    _isLoading.value = true;

    try {
      // Check if RealmService exists
      if (!Get.isRegistered<RealmService>()) {
        print('❌ RealmService not registered');
        return;
      }

      print('✅ RealmService registered');

      final realm = RealmService.to.realm;
      if (realm == null) {
        print('❌ Realm instance is null');
        return;
      }

      print('✅ Realm instance OK');

      // Query vocabularies - sử dụng lazy query không toList() ngay
      print('🔍 Querying vocabularies...');

      // Query với limit để tránh load hết
      final vocabsQuery = realm.query<Vocabulary>(
        'category == \$0 AND isActive == true LIMIT(100)',
        [categoryName]
      );

      // Đọc từng phần, không .toList() toàn bộ
      final vocabs = <Vocabulary>[];
      for (final vocab in vocabsQuery) {
        vocabs.add(vocab);
        // Yield để tránh block UI thread quá lâu
        if (vocabs.length % 20 == 0) {
          await Future.delayed(Duration.zero);
        }
      }

      print('✅ Found ${vocabs.length} vocabularies');
      _vocabularies.value = vocabs;

      if (vocabs.isNotEmpty) {
        final vocabularyIds = vocabs.map((e) => e.id).toSet();
        const userId = 'current_user_id';

        print('🔍 Querying user vocabularies...');

        // Query user vocabs của user này, sau đó filter trong memory
        final userVocabsQuery = realm.query<UserVocabulary>(
          'userId == \$0 LIMIT(1000)',
          [userId]
        );

        final filtered = <UserVocabulary>[];
        int count = 0;
        for (final uv in userVocabsQuery) {
          // Chỉ giữ lại những từ thuộc chủ đề này
          if (vocabularyIds.contains(uv.vocabularyId)) {
            filtered.add(uv);
          }
          // Yield mỗi 20 items để tránh block UI thread
          count++;
          if (count % 20 == 0) {
            await Future.delayed(Duration.zero);
          }
        }

        print('✅ Found ${filtered.length} relevant user vocabularies');
        _userVocabularies.value = filtered;

        // Xây index O(1)
        _userVocabIndex.clear();
        for (final uv in filtered) {
          _userVocabIndex[uv.vocabularyId] = uv;
        }

        print('✅ Index built successfully');
      }

    } catch (e, stackTrace) {
      print('❌ Error loading vocabularies: $e');
      print('Stack: $stackTrace');
    } finally {
      _isLoading.value = false;
      print('🏁 END: Loading completed');
    }
  }

  /// Lấy trạng thái học của một từ - O(1) lookup
  String getWordStatus(String vocabularyId) {
    return _userVocabIndex[vocabularyId]?.status ?? 'new';
  }

  /// Phát âm từ
  Future<void> playPronunciation(String audioUrl) async {
    // TODO: Implement audio player
    // Use audioplayers package
    Get.snackbar(
      'Phát âm',
      'Đang phát âm...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// Đánh dấu từ là yêu thích
  Future<void> toggleFavorite(String vocabularyId) async {
    try {
      final realm = RealmService.to.realm;
      if (realm == null) {
        throw Exception('Realm not initialized');
      }

      const userId = 'current_user_id'; // TODO: Replace with actual userId

      final userVocab = realm.query<UserVocabulary>(
        'userId == \$0 AND vocabularyId == \$1',
        [userId, vocabularyId]
      ).firstOrNull;

      if (userVocab != null) {
        realm.write(() {
          userVocab.isFavorite = !userVocab.isFavorite;
        });

        // Cập nhật index
        _userVocabIndex[vocabularyId] = userVocab;

        // Cập nhật list để Obx rebuild mục đó
        final index = _userVocabularies.indexWhere(
          (e) => e.vocabularyId == vocabularyId
        );
        if (index != -1) {
          _userVocabularies[index] = userVocab;
        }

        Get.snackbar(
          'Thành công',
          'Đã cập nhật yêu thích',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Xóa từ khỏi danh sách học
  Future<void> deleteWord(String vocabularyId) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa từ này?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final realm = RealmService.to.realm;
        if (realm == null) {
          throw Exception('Realm not initialized');
        }

        const userId = 'current_user_id'; // TODO: Replace with actual userId

        final userVocab = realm.query<UserVocabulary>(
          'userId == \$0 AND vocabularyId == \$1',
          [userId, vocabularyId]
        ).firstOrNull;

        if (userVocab != null) {
          realm.write(() {
            realm.delete(userVocab);
          });

          // Xóa khỏi index
          _userVocabIndex.remove(vocabularyId);

          // Xóa khỏi list để Obx rebuild
          _userVocabularies.removeWhere(
            (e) => e.vocabularyId == vocabularyId
          );

          Get.snackbar(
            'Thành công',
            'Đã xóa từ khỏi danh sách học',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Thêm từ mới
  void addNewWord() {
    Get.snackbar(
      'Thông báo',
      'Tính năng thêm từ đang được phát triển',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate to add word screen
  }

  /// Mở flashcard
  void openFlashcard() {
    Get.snackbar(
      'Flashcard',
      'Đang mở Flashcard mode...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate to flashcard screen with this category
    // Get.toNamed(Routes.FLASHCARD, arguments: {
    //   'categoryId': categoryId,
    //   'vocabularies': vocabularies,
    // });
  }

  /// Hiển thị menu options cho từ
  void showWordOptions(Vocabulary vocab) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Thêm vào yêu thích'),
              onTap: () {
                Get.back();
                toggleFavorite(vocab.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Chỉnh sửa'),
              onTap: () {
                Get.back();
                Get.snackbar('Thông báo', 'Tính năng đang phát triển');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                deleteWord(vocab.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
