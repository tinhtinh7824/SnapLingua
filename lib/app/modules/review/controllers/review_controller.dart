import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/data/services/auth_service.dart';
import 'package:snaplingua/app/data/services/goal_service.dart';
import 'package:snaplingua/app/modules/learning_session/controllers/learning_session_controller.dart';
import '../../../data/models/realm/vocabulary_model.dart';
import '../../../data/services/example_sentence_service.dart';
import '../../../data/services/vocabulary_service.dart';
import '../../../data/services/realm_service.dart';
import '../../../routes/app_pages.dart';
import '../../vocabulary_topic/controllers/vocabulary_topic_controller.dart';
import '../../../data/models/firestore_dictionary_word.dart';
import '../../../data/models/firestore_topic.dart';
import '../../add_vocabulary_category/bindings/add_vocabulary_category_binding.dart';
import '../../add_vocabulary_category/views/add_vocabulary_category_view.dart';
import '../../../data/services/firestore_service.dart';

class VocabularyCategory {
  const VocabularyCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.progress,
    required this.words,
    this.isSystem = false,
  });

  final String id;
  final String name;
  final String icon;
  final double progress;
  final List<VocabularyTopicItem> words;
  final bool isSystem;

  int get wordCount => words.length;
}

class VocabularySearchResult {
  const VocabularySearchResult({
    required this.category,
    required this.item,
  });

  final VocabularyCategory category;
  final VocabularyTopicItem item;
}

class ReviewController extends GetxController {
  final searchController = TextEditingController();
  final RxList<VocabularyCategory> categories = <VocabularyCategory>[].obs;
  final RxList<VocabularyCategory> filteredCategories =
      <VocabularyCategory>[].obs;
  final RxList<VocabularySearchResult> searchResults =
      <VocabularySearchResult>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isSeedingDefault = false.obs;
  final RxString currentQuery = ''.obs;
  final RxList<FirestoreTopic> recommendedTopics = <FirestoreTopic>[].obs;
  final RxBool isLoadingRecommendations = false.obs;
  final RxSet<String> savedTopicIds = <String>{}.obs;
  final RxSet<String> savedTopicNames = <String>{}.obs;
  final RxSet<String> savingTopicIds = <String>{}.obs;
  final FlutterTts _tts = FlutterTts();

  // Cache for search results to improve performance
  final Map<String, List<VocabularySearchResult>> _searchCache = {};
  final Map<String, String> _categoryIcons = const {
    'Con người & phụ kiện': '👤',
    'Động vật': '🐶',
    'Thực phẩm': '🍱',
    'Đồ vật': '📦',
    'Nội thất & gia dụng': '🛋️',
    'Giao thông': '🚗',
    'Thiên nhiên': '🌿',
    'Công nghệ': '💻',
    'Giáo dục': '🎓',
    'Y tế': '🏥',
    'Thể thao': '⚽️',
    'Du lịch': '✈️',
    'Khác': '🗂️',
  };

  @override
  void onInit() {
    super.onInit();
    _initTts();
    loadCategories();
    loadRecommendedTopics();
  }

  @override
  void onClose() {
    searchController.dispose();
    _tts.stop();
    _searchCache.clear(); // Clear search cache to free memory
    super.onClose();
  }

  Future<void> startReviewSession() async {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      Get.snackbar('Lỗi', 'Bạn cần đăng nhập để bắt đầu ôn tập.');
      return;
    }

    final goalService = Get.find<GoalService>();
    final reviewGoal = goalService.dailyReviewGoal.value;
    final normalizedGoal = reviewGoal <= 0 ? 10 : reviewGoal;
    final sessionSize = normalizedGoal > 10 ? 10 : normalizedGoal;

    final sessionWords = await buildReviewDeck(limit: sessionSize);
    if (sessionWords.isEmpty) {
      Get.snackbar(
        'Chưa có từ để ôn tập',
        'Bạn cần hoàn thành ít nhất một từ đang học hoặc đã học trước khi ôn tập.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Future.microtask(() {
      Get.toNamed(
        Routes.learningSession,
        arguments: LearningSessionArguments(
          words: sessionWords,
          round: LearningSessionController.roundFinalCheck,
          sessionType: 'review',
        ),
      );
    });
  }

  Future<List<LearningWord>> buildReviewDeck({
    required int limit,
    bool silent = false,
  }) async {
    if (limit <= 0) {
      return const [];
    }

    if (!Get.isRegistered<AuthService>()) {
      return const [];
    }

    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      return const [];
    }

    final realm = RealmService.to.realm;
    if (realm == null) {
      if (!silent) {
        Get.snackbar('Lỗi', 'Không thể kết nối đến cơ sở dữ liệu.');
      }
      return const [];
    }

    final userVocabs =
        realm.query<UserVocabulary>('userId == \$0', [authService.currentUserId]);
    final learningVocabs = <UserVocabulary>[];
    final learnedVocabs = <UserVocabulary>[];

    for (final uv in userVocabs) {
      final status = uv.status;
      if (status == VocabularyService.statusLearning) {
        learningVocabs.add(uv);
      } else if (status == VocabularyService.statusLearned ||
          status == 'mastered') {
        learnedVocabs.add(uv);
      }
    }

    final prioritized = [
      ...learningVocabs,
      ...learnedVocabs,
    ];

    if (prioritized.isEmpty) {
      return const [];
    }

    final limited = prioritized.take(limit).toList();

    final vocabIds = limited.map((item) => item.vocabularyId).toList();
    final vocabObjects = realm.query<Vocabulary>('id IN \$0', [vocabIds]);
    final vocabMap = {for (var v in vocabObjects) v.id: v};

    final sessionWords = <LearningWord>[];
    for (final item in limited) {
      final vocab = vocabMap[item.vocabularyId];
      if (vocab != null) {
        final pair = ExampleSentenceService.resolveForVocabulary(
          word: vocab.word,
          translation: vocab.translation,
          definition: vocab.definition,
          category: vocab.category,
          example: vocab.example,
          tags: vocab.tags,
        );
        sessionWords.add(LearningWord(
          vocabularyId: vocab.id,
          personalWordId: item.id,
          word: vocab.word,
          translation: vocab.translation ?? '',
          phonetic: vocab.phonetic ?? '',
          exampleEn: pair.english,
          exampleVi: pair.vietnamese,
          status: item.status,
          srsStage: item.level,
          srsEase: (item.easeFactor * 100).round(),
          srsIntervalDays: item.interval,
          srsDueAt: item.nextReviewDate,
          repetitions: item.repetitions,
          wrongStreak: item.incorrectCount, // Using incorrectCount as wrongStreak
          lapses: 0, // Default to 0 since not available
          isLeech: false, // Default to false since not available
        ));
      }
    }

    return sessionWords;
  }

  Future<void> _initTts() async {
    try {
      final languages = await _tts.getLanguages;
      if (languages != null && languages.contains('en-US')) {
        await _tts.setLanguage('en-US');
      }
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
    } catch (_) {
      // ignore TTS init errors
    }
  }

  Future<void> loadCategories({bool skipHydration = false}) async {
    final realmInstance = RealmService.to.realm;
    if (realmInstance == null) {
      await _loadCategoriesFromFirestore();
      return;
    }

    final authService = Get.find<AuthService>();
    final userId = authService.isLoggedIn ? authService.currentUserId : '';
    final isUserLoggedIn = authService.isLoggedIn && userId.isNotEmpty;

    final categoryResults = realmInstance.all<Category>();
    final Map<String, Category> categoryByName = {
      for (final category in categoryResults) category.name: category,
    };
    final Map<String, String> iconOverrides = {
      for (final entry in categoryByName.entries)
        if (entry.value.iconUrl != null && entry.value.iconUrl!.isNotEmpty)
          entry.key: entry.value.iconUrl!,
    };

    // Load only the vocabulary linked to the current user to avoid leaking
    // another user's library. Fall back to all active vocabulary for guests.
    Iterable<UserVocabulary> userVocabulary = const [];
    if (isUserLoggedIn) {
      userVocabulary = realmInstance.query<UserVocabulary>(
        'userId == \$0',
        [userId],
      );

      // Seed the library for first-time users before continuing.
      final shouldHydrate = userVocabulary.isEmpty &&
          !skipHydration &&
          Get.isRegistered<VocabularyService>();
      if (shouldHydrate) {
        try {
          final hydrated = await VocabularyService.to.hydrateUserLibrary(
            userId: userId,
          );
          if (hydrated) {
            await loadCategories(skipHydration: true);
            return;
          }
        } catch (e) {
          Get.log('Hydrate vocabulary failed: $e');
        }
      }
    }

    final Iterable<Vocabulary> vocabularies;
    if (isUserLoggedIn) {
      final vocabIds = userVocabulary.map((uv) => uv.vocabularyId).toSet();
      if (vocabIds.isEmpty) {
        vocabularies = const [];
      } else {
        vocabularies = realmInstance
            .query<Vocabulary>('id IN \$0 AND isActive == true', [vocabIds.toList()])
            .toList();
      }
    } else {
      vocabularies = realmInstance
          .query<Vocabulary>('isActive == true')
          .toList();
    }

    final Map<String, List<Vocabulary>> grouped = {};
    for (final vocab in vocabularies) {
      final categoryName = vocab.category.isNotEmpty ? vocab.category : 'Khác';
      grouped.putIfAbsent(categoryName, () => <Vocabulary>[]).add(vocab);
    }
    final List<Category> categoriesToDeactivate = [];
    final List<Category> categoriesToActivate = [];
    for (final entry in categoryByName.entries) {
      final hasWords = grouped.containsKey(entry.key);
      if (hasWords && !entry.value.isActive) {
        categoriesToActivate.add(entry.value);
      } else if (!hasWords && entry.value.isActive) {
        categoriesToDeactivate.add(entry.value);
      }
    }
    if (categoriesToActivate.isNotEmpty || categoriesToDeactivate.isNotEmpty) {
      realmInstance.write(() {
        for (final category in categoriesToDeactivate) {
          category.isActive = false;
        }
        for (final category in categoriesToActivate) {
          category.isActive = true;
        }
      });
    }

    // If there are no vocabularies grouped by category but there are
    // category records present in Realm (e.g. user just created a new
    // empty category), we still want to surface those categories in the
    // UI.
    if (grouped.isEmpty && categoryByName.isEmpty) {
      categories.clear();
      filteredCategories.clear();
      searchResults.clear();
      isSearching.value = false;
      currentQuery.value = '';
      searchController.clear();
      _updateSavedTopicCache();
      recommendedTopics.refresh();
      return;
    }

    final userVocabResults = realmInstance.query<UserVocabulary>(
      'userId == \$0',
      [userId],
    );
    final Map<String, UserVocabulary> userVocabMap = {
      for (final userVocab in userVocabResults)
        userVocab.vocabularyId: userVocab
    };

    // Build categories from all Category records in Realm so that even
    // categories with zero words (recently created by the user) are
    // shown. Use the grouped map to supply words when available.
    final List<VocabularyCategory> loadedCategories = categoryByName.entries
        .map((entry) {
      final categoryName = entry.key;
      final vocabList = grouped[categoryName] ?? <Vocabulary>[];
      final items = vocabList.map((vocab) {
        final userVocab = userVocabMap[vocab.id];
        final examplePair = ExampleSentenceService.resolveForVocabulary(
          word: vocab.word,
          translation: vocab.translation,
          definition: vocab.definition,
          category: vocab.category,
          example: vocab.example,
          tags: vocab.tags,
        );
        return VocabularyTopicItem(
          word: vocab.word,
          ipa: vocab.phonetic ?? '',
          translation: vocab.translation ?? '',
          exampleEn: examplePair.english,
          exampleVi: examplePair.vietnamese,
          status: _mapLearningStatus(userVocab),
        );
      }).toList();

      final progress = _calculateProgress(vocabList, userVocabMap);
      final categoryRealm = entry.value;
      final icon = iconOverrides[categoryName] ??
          _categoryIcons[categoryName] ??
          '📘';
      return VocabularyCategory(
        id: categoryRealm.id,
        name: categoryName,
        icon: icon,
        progress: progress,
        words: items,
      );
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    categories.assignAll(loadedCategories);
    filteredCategories.assignAll(loadedCategories);
    searchResults.clear();
    isSearching.value = false;
    currentQuery.value = '';
    searchController.clear();
    _updateSavedTopicCache();
    recommendedTopics.refresh();
  }

  Future<void> loadRecommendedTopics() async {
    if (isLoadingRecommendations.value) return;
    try {
      isLoadingRecommendations.value = true;
      final topics = await FirestoreService.to.getSystemTopics();
      recommendedTopics.assignAll(topics);
    } catch (e) {
      Get.log('Load recommended topics error: $e');
    } finally {
      isLoadingRecommendations.value = false;
    }
  }

  Future<void> ensureRecommendedTopicsLoaded() async {
    if (recommendedTopics.isNotEmpty || isLoadingRecommendations.value) {
      return;
    }
    await loadRecommendedTopics();
  }

  bool isTopicSaved(FirestoreTopic topic) {
    // RxSet implements Set, so use it directly for membership checks.
    return savedTopicIds.contains(topic.topicId) ||
        savedTopicNames.contains(topic.name);
  }

  bool isTopicSaving(String topicId) {
    return savingTopicIds.contains(topicId);
  }

  Future<void> onSaveTopic(FirestoreTopic topic) async {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn || authService.currentUserId.isEmpty) {
      Get.snackbar('Đăng nhập', 'Bạn cần đăng nhập để lưu chủ đề.');
      return;
    }

    if (isTopicSaving(topic.topicId) || isTopicSaved(topic)) {
      return;
    }

  // Add topicId into the reactive set atomically via assignAll.
  final newSet = Set<String>.from(savingTopicIds)..add(topic.topicId);
  savingTopicIds.assignAll(newSet);

    try {
      final summary = await FirestoreService.to.saveTopicToPersonal(
        userId: authService.currentUserId,
        topicId: topic.topicId,
      );

      await _persistTopicToRealm(
        userId: authService.currentUserId,
        topic: summary.topic,
        words: summary.words,
      );
      await loadCategories();
      recommendedTopics.refresh();

      final created = summary.createdCount;
      final existing = summary.existingCount;
      final total = summary.words.length;
      final buffer = StringBuffer();
      buffer.write('Đã thêm chủ đề "${summary.topic.name}" vào thư viện.');
      if (total > 0) {
        if (created > 0) {
          buffer.write(' Đã lưu mới $created/$total từ vựng.');
        }
        if (existing > 0) {
          buffer.write(' $existing từ đã có sẵn.');
        }
      }

      Get.snackbar('Thành công', buffer.toString());
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể lưu chủ đề: $e',
      );
    } finally {
      final updated = Set<String>.from(savingTopicIds)..remove(topic.topicId);
      savingTopicIds.assignAll(updated);
    }
  }

  Future<void> _persistTopicToRealm({
    required String userId,
    required FirestoreTopic topic,
    required List<FirestoreDictionaryWord> words,
  }) async {
    final realmInstance = RealmService.to.realm;
    if (realmInstance == null) return;

    final now = DateTime.now();
    realmInstance.write(() {
      final existingCategory = realmInstance
          .query<Category>('id == \$0', [topic.topicId])
          .firstOrNull;
      if (existingCategory != null) {
        existingCategory.name = topic.name;
        existingCategory.iconUrl = topic.icon;
        existingCategory.isActive = true;
      } else {
        final sortOrder = realmInstance.all<Category>().length;
        realmInstance.add(
          Category(
            topic.topicId,
            topic.name,
            sortOrder,
            true,
            now,
            iconUrl: topic.icon,
          ),
        );
      }

      for (final word in words) {
        final existingVocabulary = realmInstance.find<Vocabulary>(word.wordId);
        if (existingVocabulary != null) {
          existingVocabulary.word = word.headword;
          existingVocabulary.definition = word.meaningVi;
          existingVocabulary.translation = word.meaningVi;
          existingVocabulary.example = word.exampleEn;
          existingVocabulary.phonetic = word.ipa;
          existingVocabulary.category = topic.name;
          existingVocabulary.isActive = true;
          existingVocabulary.updatedAt = now;
        } else {
          realmInstance.add(
            Vocabulary(
              word.wordId,
              word.headword,
              word.meaningVi,
              'easy',
              topic.name,
              0,
              true,
              now,
              pronunciation: word.ipa,
              phonetic: word.ipa,
              example: word.exampleEn,
              translation: word.meaningVi,
            ),
          );
        }

        // Ensure the user has a UserVocabulary record linked to this word.
        final existingUserVocab = realmInstance.query<UserVocabulary>(
          'userId == \$0 AND vocabularyId == \$1',
          [userId, word.wordId],
        );
        if (existingUserVocab.isEmpty) {
          final userVocabId = '${userId}_${word.wordId}';
          realmInstance.add(
            UserVocabulary(
              userVocabId,
              userId,
              word.wordId,
              0, // level
              0, // repetitions
              2.5, // easeFactor
              1, // interval
              0, // correctCount
              0, // incorrectCount
              false, // isMastered
              false, // isFavorite
              VocabularyService.statusNotStarted,
              now,
              nextReviewDate: now.add(const Duration(days: 1)),
              lastReviewedAt: null,
              updatedAt: now,
            ),
          );
        }
      }
    });
  }

  void onSearchChanged(String query) {
    final normalized = query.trim();
    currentQuery.value = normalized;

    if (normalized.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      filteredCategories.assignAll(categories);
      _searchCache.clear(); // Clear cache when not searching
      return;
    }

    final normalizedQuery = _normalize(normalized);

    // Check cache first
    if (_searchCache.containsKey(normalizedQuery)) {
      searchResults.assignAll(_searchCache[normalizedQuery]!);
      isSearching.value = true;
      return;
    }

    final results = <VocabularySearchResult>[];

    for (final category in categories) {
      for (final item in category.words) {
        final normalizedWord = _normalize(item.word);
        final normalizedTranslation = _normalize(item.translation);
        if (normalizedWord.contains(normalizedQuery) ||
            normalizedTranslation.contains(normalizedQuery)) {
          results.add(
            VocabularySearchResult(category: category, item: item),
          );
        }
      }
    }

    // Cache the results
    _searchCache[normalizedQuery] = results;

    // Limit cache size to prevent memory issues
    if (_searchCache.length > 50) {
      final keys = _searchCache.keys.toList();
      _searchCache.remove(keys.first);
    }

    isSearching.value = true;
    searchResults.assignAll(results);
  }

  Future<void> onCategoryTap(VocabularyCategory category) async {
    final changed = await Get.toNamed(
      Routes.vocabularyTopic,
      arguments: VocabularyTopicArguments(
        topicName: category.name,
        items: category.words,
      ),
    );
    if (changed == true) {
      await loadCategories();
    }
  }

  Future<void> onAddCategory() async {
    final result = await Get.to(
      () => const AddVocabularyCategoryView(),
      binding: AddVocabularyCategoryBinding(),
    );

    if (result is Map<String, dynamic>) {
      final name = (result['name'] as String?)?.trim();
      final icon = result['icon'] as String?;

      if (name == null || name.isEmpty || icon == null || icon.isEmpty) {
        return;
      }

      final realmInstance = RealmService.to.realm;
      if (realmInstance != null) {
        final now = DateTime.now();
        final existing = realmInstance.query<Category>(
          'name == \$0',
          [name],
        );
        final sortOrder = realmInstance.all<Category>().length;
        realmInstance.write(() {
          if (existing.isNotEmpty) {
            final category = existing.first;
            category.iconUrl = icon;
            category.isActive = true;
          } else {
            realmInstance.add(
              Category(
                _generateCategoryId(name, now),
                name,
                sortOrder,
                true,
                now,
                iconUrl: icon,
              ),
            );
          }
        });
      }

      await loadCategories();
    }
  }

  /// Edit an existing category (open add/edit screen pre-filled). After
  /// the user saves, update the Realm Category record and reload categories.
  Future<void> onEditCategory(VocabularyCategory category) async {
    final result = await Get.toNamed(
      Routes.addVocabularyCategory,
      arguments: {
        'name': category.name,
        'icon': category.icon,
      },
    );

    if (result is Map<String, dynamic>) {
      final newName = (result['name'] as String?)?.trim();
      final newIcon = result['icon'] as String?;
      if (newName == null || newName.isEmpty) return;

      final realmInstance = RealmService.to.realm;
      if (realmInstance == null) return;

      realmInstance.write(() {
        final existing = realmInstance.query<Category>('id == \$0', [category.id]).firstOrNull;
        if (existing != null) {
          existing.name = newName;
          existing.iconUrl = newIcon;
          existing.isActive = true;
        }
      });

      await loadCategories();
    }
  }

  /// Delete a category. As a conservative approach, we remove the category
  /// record and move any vocabularies that referenced it to the 'Khác'
  /// category. The UI reloads immediately after.
  Future<void> onDeleteCategory(VocabularyCategory category) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xoá chủ đề'),
        content: Text('Bạn có chắc muốn xoá chủ đề "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back<bool>(result: false), child: const Text('Huỷ')),
          TextButton(onPressed: () => Get.back<bool>(result: true), child: const Text('Xoá')),
        ],
      ),
    );

    if (confirmed != true) return;

    final realmInstance = RealmService.to.realm;
    if (realmInstance == null) return;

    realmInstance.write(() {
      final cat = realmInstance.query<Category>('id == \$0', [category.id]).firstOrNull;
      if (cat != null) {
        // Re-assign vocabularies in this category to 'Khác'
        final others = realmInstance.query<Vocabulary>('category == \$0', [category.name]);
        for (final v in others) {
          v.category = 'Khác';
        }
        // Remove the category record
        realmInstance.delete(cat);
      }
    });

    await loadCategories();
  }

  Future<void> onSearchResultTap(VocabularySearchResult result) async {
    final changed = await Get.toNamed(
      Routes.vocabularyTopic,
      arguments: VocabularyTopicArguments(
        topicName: result.category.name,
        items: result.category.words,
      ),
    );
    if (changed == true) {
      await loadCategories();
    }
  }

  Future<void> seedDefaultTopics() async {
    if (isSeedingDefault.value) return;
    isSeedingDefault.value = true;
    try {
      final messages = <String>[];
      messages.add(await FirestoreService.to.seedPersonalityTopic());
      messages.add(await FirestoreService.to.seedCareerTopic());
      messages.add(await FirestoreService.to.seedWeatherTopic());
      messages.add(await FirestoreService.to.seedColorsTopic());
      messages.add(await FirestoreService.to.seedEmotionsTopic());
      messages.add(await FirestoreService.to.seedSportsTopic());
      messages.add(await FirestoreService.to.seedBodyActionsTopic());
      messages.add(await FirestoreService.to.seedDailyActionsTopic());
      messages.add(await FirestoreService.to.seedNumbersTopic());
      messages.add(await FirestoreService.to.seedHealthTopic());
      Get.snackbar('Thành công', messages.join('\n'));
      await loadRecommendedTopics();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tạo dữ liệu mẫu: $e',
      );
    } finally {
      isSeedingDefault.value = false;
    }
  }

  Future<void> speakWord(String word) async {
    try {
      await _tts.stop();
      await _tts.speak(word);
    } catch (_) {
      // ignore playback errors
    }
  }

  VocabularyLearningStatus _mapLearningStatus(UserVocabulary? userVocab) {
    if (userVocab == null) {
      return VocabularyLearningStatus.notStarted;
    }
    final status = userVocab.status;
    if (userVocab.isMastered ||
        status == VocabularyService.statusLearned ||
        status == 'mastered') {
      return VocabularyLearningStatus.learned;
    }
    if (status == VocabularyService.statusLearning || status == 'reviewing') {
      return VocabularyLearningStatus.learning;
    }
    return VocabularyLearningStatus.notStarted;
  }

  double _calculateProgress(
    List<Vocabulary> vocabularies,
    Map<String, UserVocabulary> userVocabMap,
  ) {
    if (vocabularies.isEmpty) {
      return 0;
    }
    final masteredCount = vocabularies.where((vocab) {
      final userVocab = userVocabMap[vocab.id];
      return userVocab != null &&
          (userVocab.isMastered ||
              userVocab.status == VocabularyService.statusLearned ||
              userVocab.status == 'mastered');
    }).length;

    return masteredCount / vocabularies.length;
  }

  Future<void> _loadCategoriesFromFirestore() async {
    try {
      final firestore = FirestoreService.to;
      final topics = await firestore.getAllTopics();

      if (topics.isEmpty) {
        categories.clear();
        filteredCategories.clear();
        searchResults.clear();
        isSearching.value = false;
        currentQuery.value = '';
        searchController.clear();
        _updateSavedTopicCache();
        recommendedTopics.refresh();
        return;
      }

      final List<VocabularyCategory> builtCategories = [];

      for (final topic in topics) {
        if (topic.dictionaryWordIds.isEmpty) continue;

        final words =
            await firestore.getDictionaryWordsByIds(topic.dictionaryWordIds);
        if (words.isEmpty) continue;

        final items = words
            .map(
              (word) => VocabularyTopicItem(
                word: word.headword,
                ipa: word.ipa ?? '',
                translation: word.meaningVi,
                exampleEn: word.exampleEn ?? '',
                exampleVi: word.exampleVi ?? '',
                status: VocabularyLearningStatus.notStarted,
              ),
            )
            .toList();

        final icon = (topic.icon != null && topic.icon!.isNotEmpty)
            ? topic.icon!
            : (_categoryIcons[topic.name] ?? '📘');

        builtCategories.add(
          VocabularyCategory(
            id: topic.topicId,
            name: topic.name,
            icon: icon,
            progress: 0,
            words: items,
            isSystem: true,
          ),
        );
      }

      builtCategories.sort((a, b) => a.name.compareTo(b.name));

      categories.assignAll(builtCategories);
      filteredCategories.assignAll(builtCategories);
      searchResults.clear();
      isSearching.value = false;
      currentQuery.value = '';
      searchController.clear();
      _updateSavedTopicCache();
      recommendedTopics.refresh();
    } catch (e) {
      Get.log('Load categories from Firestore error: $e');
      categories.clear();
      filteredCategories.clear();
      searchResults.clear();
      isSearching.value = false;
      currentQuery.value = '';
      _updateSavedTopicCache();
    }
  }

  void _updateSavedTopicCache() {
    final ids = <String>{};
    final names = <String>{};
    for (final category in categories) {
      if (category.isSystem) continue;
      if (category.id.isNotEmpty) {
        ids.add(category.id);
      }
      names.add(category.name);
    }
  // Assign to the reactive sets so observers update.
  savedTopicIds.assignAll(ids);
  savedTopicNames.assignAll(names);
  }

  String _generateCategoryId(String name, DateTime timestamp) {
    final normalized = name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '_')
        .replaceAll(RegExp('_+'), '_')
        .trim();
    if (normalized.isEmpty) {
      return 'category_${timestamp.millisecondsSinceEpoch}';
    }
    return 'category_$normalized';
  }

  String _normalize(String value) {
    final lower = value.trim().toLowerCase();
    final buffer = StringBuffer();
    for (final codePoint in lower.runes) {
      buffer.write(_diacriticMap[codePoint] ?? String.fromCharCode(codePoint));
    }
    return buffer.toString();
  }

  static const Map<int, String> _diacriticMap = {
    224: 'a', // à
    225: 'a', // á
    7843: 'a', // ả
    227: 'a', // ã
    7841: 'a', // ạ
    259: 'a', // ă
    7857: 'a', // ằ
    7855: 'a', // ắ
    7859: 'a', // ẳ
    7861: 'a', // ẵ
    7863: 'a', // ặ
    226: 'a', // â
    7847: 'a', // ầ
    7845: 'a', // ấ
    7849: 'a', // ẩ
    7851: 'a', // ẫ
    7853: 'a', // ậ
    232: 'e', // è
    233: 'e', // é
    7867: 'e', // ẻ
    7869: 'e', // ẽ
    7865: 'e', // ẹ
    234: 'e', // ê
    7873: 'e', // ề
    7871: 'e', // ế
    7875: 'e', // ể
    7877: 'e', // ễ
    7879: 'e', // ệ
    236: 'i', // ì
    237: 'i', // í
    7881: 'i', // ỉ
    297: 'i', // ĩ
    7883: 'i', // ị
    242: 'o', // ò
    243: 'o', // ó
    7887: 'o', // ỏ
    245: 'o', // õ
    7885: 'o', // ọ
    244: 'o', // ô
    7891: 'o', // ồ
    7889: 'o', // ố
    7893: 'o', // ổ
    7895: 'o', // ỗ
    7897: 'o', // ộ
    417: 'o', // ơ
    7899: 'o', // ờ
    7901: 'o', // ở
    7903: 'o', // ỡ
    7905: 'o', // ợ
    7907: 'o', // ợ
    249: 'u', // ù
    250: 'u', // ú
    7911: 'u', // ủ
    361: 'u', // ũ
    7909: 'u', // ụ
    432: 'u', // ư
    7913: 'u', // ừ
    7915: 'u', // ứ
    7917: 'u', // ử
    7919: 'u', // ữ
    7921: 'u', // ự
    253: 'y', // ý
    7923: 'y', // ỳ
    7927: 'y', // ỷ
    7929: 'y', // ỹ
    7925: 'y', // ỵ
    273: 'd', // đ
  };
}
