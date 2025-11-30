import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/modules/community/controllers/community_controller.dart';
import 'package:snaplingua/app/modules/home/controllers/home_stats_controller.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/firestore_personal_word.dart';
import '../../../data/models/firestore_session_item.dart';
import '../../../data/models/firestore_study_session.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../home/controllers/learning_tab_controller.dart';
import '../../review/controllers/review_controller.dart';
import '../../vocabulary_topic/controllers/vocabulary_topic_controller.dart';

class LearningWord {
  LearningWord({
    required this.vocabularyId,
    required this.word,
    required this.translation,
    this.personalWordId,
    this.phonetic,
    this.status,
    this.exampleEn,
    this.exampleVi,
    this.srsStage = 0,
    this.repetitions = 0,
    this.wrongStreak = 0,
    this.lapses = 0,
    this.srsEase = 250,
    this.srsIntervalDays = 0,
    this.srsDueAt,
    this.isLeech = false,
  });

  final String vocabularyId;
  final String word;
  final String translation;
  final String? personalWordId;
  final String? phonetic;
  final String? status;
  final String? exampleEn;
  final String? exampleVi;
  final int srsStage;
  final int repetitions;
  final int wrongStreak;
  final int lapses;
  final int srsEase;
  final int srsIntervalDays;
  final DateTime? srsDueAt;
  final bool isLeech;
}

class LearningSessionArguments {
  const LearningSessionArguments({
    required this.words,
    this.round = 1,
    this.sessionType = 'new_learning',
  });

  final List<LearningWord> words;
  final int round;
  final String sessionType;
}

class PersonalWordSrsUpdate {
  PersonalWordSrsUpdate({
    required this.personalWordId,
    required this.status,
    required this.srsStage,
    required this.srsEase,
    required this.srsIntervalDays,
    required this.srsDueAt,
    required this.repetitions,
    required this.wrongStreak,
    required this.forgetCount,
    required this.lastReviewedAt,
  });

  final String personalWordId;
  final String status;
  final int srsStage;
  final int srsEase;
  final int srsIntervalDays;
  final DateTime srsDueAt;
  final int repetitions;
  final int wrongStreak;
  final int forgetCount;
  final DateTime lastReviewedAt;

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'srs_stage': srsStage,
      'srs_ease': srsEase,
      'srs_interval_days': srsIntervalDays,
      'srs_due_at': srsDueAt,
      'repetitions': repetitions,
      'wrong_streak': wrongStreak,
      'forget_count': forgetCount,
      'last_reviewed_at': lastReviewedAt,
    };
  }
}

class RoundThreeResult {
  RoundThreeResult(this.word);

  final LearningWord word;
  int attempts = 0;
  bool? firstTryCorrect;
  final List<String> questionTypes = <String>[];

  void recordAttempt({
    required String questionType,
    required bool isFirstAttempt,
    required bool isCorrect,
  }) {
    attempts += 1;
    questionTypes.add(questionType);
    if (isFirstAttempt) {
      firstTryCorrect = isCorrect;
    }
  }
}

class RoundThreeSummary {
  RoundThreeSummary({
    required this.total,
    required this.firstTryCorrect,
    required this.results,
    this.xpEarned = 0,
    this.scalesEarned = 0,
  });

  final int total;
  final int firstTryCorrect;
  final List<RoundThreeResult> results;
  final int xpEarned;
  final int scalesEarned;

  int get firstTryAccuracyPercent =>
      total == 0 ? 0 : ((firstTryCorrect * 100) / total).round();

  List<RoundThreeResult> get difficultResults => results
      .where((result) =>
          result.firstTryCorrect == false || result.firstTryCorrect == null)
      .toList();

  RoundThreeSummary copyWith({int? xpEarned, int? scalesEarned}) {
    return RoundThreeSummary(
      total: total,
      firstTryCorrect: firstTryCorrect,
      results: results,
      xpEarned: xpEarned ?? this.xpEarned,
      scalesEarned: scalesEarned ?? this.scalesEarned,
    );
  }
}

class LearningSessionController extends GetxController {
  static const int roundLearning = 1;
  static const int roundFlashcard = 2;
  static const int roundFinalCheck = 3;

  late final List<LearningWord> words;
  late final String sessionType;
  late final PageController pageController;
  late final FlutterTts _tts;
  bool _ttsReady = false;

  final RxInt _currentIndex = 0.obs;
  final RxInt _round = RxInt(roundLearning);
  final RxList<LearningWord> _flashcardQueue = <LearningWord>[].obs;
  final RxInt _flashcardTotal = 0.obs;
  final RxBool _flashcardBackVisible = false.obs;
  final RxInt _flashcardVersion = 0.obs;
  final RxBool _awaitingRoundThree = false.obs;
  final Map<String, bool> _firstFlashcardAction = <String, bool>{};
  final Map<String, RoundThreeResult> _roundThreeResults =
      <String, RoundThreeResult>{};
  DateTime? _roundThreeStartedAt;
  final Uuid _uuid = const Uuid();
  int _xpEarned = 0;
  int _scalesEarned = 0;

  // Cached values for performance optimization
  String? _cachedUserId;
  int? _cachedDisplayPosition;
  int _lastFlashcardQueueLength = -1;

  int get currentIndex => _currentIndex.value;
  int get total => words.length;
  int get round => _round.value;
  bool get isFlashcardRound => round == roundFlashcard;
  bool get canPrevious => !isFlashcardRound && currentIndex > 0;
  bool get canNext => !isFlashcardRound && currentIndex < total - 1;
  bool get isOnLastCard => !isFlashcardRound && currentIndex >= total - 1;
  String get currentSessionType => sessionType;
  int get totalXpEarned => _xpEarned;
  int get totalScalesEarned => _scalesEarned;

  bool get hasFlashcards => _flashcardQueue.isNotEmpty;
  int get displayTotal => isFlashcardRound ? _flashcardTotal.value : total;
  int get displayPosition {
    if (!isFlashcardRound) return currentIndex + 1;

    // Use cached value if flashcard queue length hasn't changed
    final currentQueueLength = _flashcardQueue.length;
    if (_cachedDisplayPosition != null && _lastFlashcardQueueLength == currentQueueLength) {
      return _cachedDisplayPosition!;
    }

    final totalCards = _flashcardTotal.value;
    if (totalCards == 0) return 0;
    final seen = totalCards - currentQueueLength;
    final position = seen + 1;
    final result = position > totalCards ? totalCards : position;

    // Cache the result
    _cachedDisplayPosition = result;
    _lastFlashcardQueueLength = currentQueueLength;

    return result;
  }

  bool get isFlashcardBackVisible => _flashcardBackVisible.value;
  int get flashcardVersion => _flashcardVersion.value;
  bool get isAwaitingRoundThree => _awaitingRoundThree.value;
  Map<String, RoundThreeResult> get roundThreeResults => _roundThreeResults;

  LearningWord get currentWord {
    if (isFlashcardRound) {
      return _flashcardQueue.isNotEmpty ? _flashcardQueue.first : words.first;
    }

    // Ensure currentIndex is within bounds
    final index = currentIndex.clamp(0, words.length - 1);
    return words[index];
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is LearningSessionArguments) {
      words = args.words.toList(growable: false);
      // Validate round number is within expected range
      _round.value = args.round.clamp(roundLearning, roundFinalCheck);
      sessionType = args.sessionType;
    } else {
      words = const [];
      _round.value = roundLearning;
      sessionType = 'new_learning';
    }

    // Enhanced empty validation
    if (words.isEmpty) {
      Get.log('LearningSession: No words provided, returning to previous screen');
      Future.microtask(Get.back<void>);
      return;
    }

    // Validate words have required data
    final validWords = words.where((word) =>
        word.word.trim().isNotEmpty &&
        word.translation.trim().isNotEmpty
    ).toList();

    if (validWords.length != words.length) {
      Get.log('LearningSession: ${words.length - validWords.length} invalid words removed');
      words = validWords;
      if (words.isEmpty) {
        Future.microtask(Get.back<void>);
        return;
      }
    }

    pageController = PageController();
    _xpEarned = 0;
    _scalesEarned = 0;

    if (isFlashcardRound) {
      _flashcardQueue.assignAll(words);
      _flashcardTotal.value = words.length;
      _flashcardBackVisible.value = false;
      _currentIndex.value = 0;
      _flashcardVersion.value = 0;
      _awaitingRoundThree.value = false;
    }

    _tts = FlutterTts();
    _initTts();

    _roundThreeResults.clear();
  }

  @override
  void onClose() {
    // Stop TTS and dispose resources
    _tts.stop();
    pageController.dispose();

    // Clear cache and maps for memory optimization
    _firstFlashcardAction.clear();
    _roundThreeResults.clear();
    _cachedUserId = null;
    _cachedDisplayPosition = null;
    _lastFlashcardQueueLength = -1;

    super.onClose();
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
      _ttsReady = true;
    } catch (_) {
      _ttsReady = false;
    }
  }

  void onPageChanged(int index) {
    if (isFlashcardRound) return;
    _currentIndex.value = index;
  }

  void nextWord() {
    if (!canNext) return;
    pageController.nextPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void previousWord() {
    if (!canPrevious) return;
    pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void startFlashcardRound() {
    if (words.isEmpty) return;
    _round.value = roundFlashcard;
    _flashcardQueue.assignAll(words);
    _flashcardTotal.value = words.length;
    _flashcardBackVisible.value = false;
    _currentIndex.value = 0;
    _flashcardVersion.value = 0;
    _awaitingRoundThree.value = false;
  }

  void markRemembered() {
    if (!isFlashcardRound || _flashcardQueue.isEmpty) return;
    final entry = _flashcardQueue.removeAt(0);
    _firstFlashcardAction[entry.vocabularyId] = true;
    _flashcardBackVisible.value = false;
    _flashcardVersion.value++;

    // Clear cache when queue is modified
    _cachedDisplayPosition = null;

    if (_flashcardQueue.isEmpty) {
      _awaitingRoundThree.value = true;
    }
  }

  void markForgotten() {
    if (!isFlashcardRound || _flashcardQueue.isEmpty) return;
    final entry = _flashcardQueue.removeAt(0);
    _flashcardQueue.add(entry);
    _firstFlashcardAction[entry.vocabularyId] = false;
    _flashcardBackVisible.value = false;
    _flashcardVersion.value++;

    // Clear cache when queue is modified
    _cachedDisplayPosition = null;
  }

  void proceedToRoundThree() {
    _awaitingRoundThree.value = false;
    _round.value = roundFinalCheck;
    _roundThreeStartedAt = DateTime.now();
  }

  void toggleFlashcardSide() {
    if (!isFlashcardRound || _flashcardQueue.isEmpty) return;
    _flashcardBackVisible.toggle();
  }

  Future<void> speakWord(LearningWord word) async {
    // Early return if word is empty to avoid unnecessary TTS operations
    if (word.word.trim().isEmpty) return;

    if (!_ttsReady) {
      await _initTts();
      // If TTS is still not ready after init, don't proceed
      if (!_ttsReady) {
        _showTtsError();
        return;
      }
    }

    try {
      await _tts.stop();
      await _tts.speak(word.word);
    } catch (_) {
      _showTtsError();
    }
  }

  void _showTtsError() {
    Get.snackbar(
      'Không phát được âm',
      'Tính năng phát âm đang được cập nhật.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void recordRoundThreeResult({
    required LearningWord word,
    required String questionType,
    required bool isFirstAttempt,
    required bool isCorrect,
  }) {
    final key = word.personalWordId ?? word.vocabularyId;
    final result = _roundThreeResults.putIfAbsent(
        key, () => RoundThreeResult(word));
    result.recordAttempt(
      questionType: questionType,
      isFirstAttempt: isFirstAttempt,
      isCorrect: isCorrect,
    );
  }

  RoundThreeSummary buildRoundThreeSummary() {
    // Ensure all words have results, but avoid recreating existing entries
    for (final word in words) {
      final key = word.personalWordId ?? word.vocabularyId;
      if (!_roundThreeResults.containsKey(key)) {
        _roundThreeResults[key] = RoundThreeResult(word);
      }
    }

    final entries = _roundThreeResults.values.toList(growable: false);
    final total = entries.length;

    // Use efficient counting instead of creating intermediate lists
    int firstTryCorrect = 0;
    for (final result in entries) {
      if (result.firstTryCorrect == true) {
        firstTryCorrect++;
      }
    }

    return RoundThreeSummary(
      total: total,
      firstTryCorrect: firstTryCorrect,
      results: entries,
    );
  }

  Future<void> awardXp({
    required int amount,
    required String sourceType,
    required String action,
    int wordsCount = 1,
    Map<String, dynamic>? metadata,
    String? sourceId,
  }) async {
    // Enhanced validation for business logic
    if (amount <= 0 || sourceType.trim().isEmpty || action.trim().isEmpty) {
      Get.log('AwardXP: Invalid parameters - amount: $amount, sourceType: "$sourceType", action: "$action"');
      return;
    }

    // Prevent excessive XP awards per operation
    final maxXpPerOperation = 1000;
    final clampedAmount = amount.clamp(1, maxXpPerOperation);
    if (clampedAmount != amount) {
      Get.log('AwardXP: XP amount clamped from $amount to $clampedAmount');
    }

    try {
      final auth = Get.isRegistered<AuthService>() ? AuthService.to : null;
      final userId = (auth != null &&
              auth.isLoggedIn &&
              auth.currentUserId.isNotEmpty)
          ? auth.currentUserId
          : 'guest';

      int appliedXp = clampedAmount;
      if (Get.isRegistered<DailyProgressService>()) {
        appliedXp = await DailyProgressService.to.awardXp(
          userId: userId,
          amount: clampedAmount,
          activity: _mapActivityType(sourceType),
          sourceType: sourceType,
          action: action,
          wordsCount: wordsCount,
          metadata: metadata,
          sourceId: sourceId,
        );
      } else if (clampedAmount > 0 &&
          userId != 'guest' &&
          Get.isRegistered<FirestoreService>()) {
        // Fire-and-forget fallback to avoid blocking UI when DailyProgressService is unavailable.
        unawaited(FirestoreService.to.applyXp(
          userId: userId,
          amount: clampedAmount,
          sourceType: sourceType,
          action: action,
          sourceId: sourceId,
          metadata: metadata,
          wordsCount: wordsCount,
        ));
      }

      if (appliedXp > 0) {
        _xpEarned += appliedXp;
        // Notify other controllers to refresh XP-dependent UI immediately.
        if (Get.isRegistered<HomeStatsController>()) {
          try {
            await Get.find<HomeStatsController>().load();
          } catch (_) {}
        }
        if (Get.isRegistered<LearningTabController>()) {
          try {
            await Get.find<LearningTabController>().refreshProgress();
          } catch (_) {}
        }
        if (Get.isRegistered<CommunityController>()) {
          try {
            await Get.find<CommunityController>().refreshLeaderboard();
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  Future<RoundThreeSummary> finalizeRoundThree() async {
    final summary = buildRoundThreeSummary();
    final userId = _resolveUserId();

    // Early return for guest users or when user is not authenticated
    if (userId == null || userId == 'guest') {
      Get.log('FinalizeRoundThree: Skipping persistence for guest user');
      return summary.copyWith(
        xpEarned: _xpEarned,
        scalesEarned: _scalesEarned,
      );
    }

    // Validate we have results to process
    if (summary.results.isEmpty) {
      Get.log('FinalizeRoundThree: No results to finalize');
      return summary.copyWith(
        xpEarned: _xpEarned,
        scalesEarned: _scalesEarned,
      );
    }

    final now = DateTime.now();
    final updates = <PersonalWordSrsUpdate>[];
    final sessionItems = <FirestoreSessionItem>[];
    const intervals = [1, 3, 7, 14, 30, 60, 120];
    final sessionId = 'study_${now.millisecondsSinceEpoch}_${_uuid.v4()}';

    for (final result in summary.results) {
      final word = result.word;
      final personalId = word.personalWordId;
      final sessionWordId = (personalId == null || personalId.isEmpty)
          ? word.vocabularyId
          : personalId;

      final isFirstCorrect = result.firstTryCorrect == true;
      final baseStage = word.srsStage.clamp(0, 6); // Ensure stage is valid
      final baseRepetitions = word.repetitions.clamp(0, 999); // Prevent overflow
      final baseWrong = word.wrongStreak.clamp(0, 999); // Prevent overflow
      final baseLapses = word.lapses.clamp(0, 999); // Prevent overflow
      final baseEase = word.srsEase > 0 ? word.srsEase.clamp(130, 400) : 250; // Reasonable ease range

      int newStage;
      int newWrong;
      int newLapses;
      int intervalDays;
      String newStatus;

      if (isFirstCorrect) {
        _scalesEarned += 1;
        newStage = (baseStage + 1).clamp(0, intervals.length - 1);
        intervalDays = intervals[newStage];
        newWrong = 0;
        newLapses = baseLapses;
        newStatus = newStage >= 2
            ? FirestorePersonalWordStatus.mastered
            : FirestorePersonalWordStatus.learning;
      } else {
        newStage = 0;
        intervalDays = intervals.first;
        newWrong = (baseWrong + 1).clamp(0, 999);
        newLapses = (baseLapses + 1).clamp(0, 999);
        newStatus = FirestorePersonalWordStatus.learning;
      }

      final dueAt = now.add(Duration(days: intervalDays));

      if (personalId != null && personalId.isNotEmpty) {
        updates.add(
          PersonalWordSrsUpdate(
            personalWordId: personalId,
            status: newStatus,
            srsStage: newStage,
            srsEase: baseEase,
            srsIntervalDays: intervalDays,
            srsDueAt: dueAt,
            repetitions: baseRepetitions + 1,
            wrongStreak: newWrong,
            forgetCount: newLapses,
            lastReviewedAt: now,
          ),
        );
      }

      sessionItems.add(
        FirestoreSessionItem(
          itemId: _uuid.v4(),
          sessionId: sessionId,
          personalWordId: sessionWordId,
          round: LearningSessionController.roundFinalCheck,
          questionType: result.questionTypes.isNotEmpty
              ? result.questionTypes.first
              : 'unknown',
          firstTryCorrect: isFirstCorrect,
          attemptsCount: result.attempts,
          score: isFirstCorrect ? 1 : 0,
          payload: {
            'question_types': result.questionTypes,
            'word': word.word,
            'translation': word.translation,
          },
          createdAt: now,
        ),
      );
    }

    if (Get.isRegistered<DailyProgressService>()) {
      try {
        final activity = sessionType == 'review'
            ? DailyActivityType.review
            : DailyActivityType.learning;
        await DailyProgressService.to.markActivity(
          userId: userId,
          activity: activity,
          count: summary.results.length,
        );
      } catch (_) {}
    }

    final studySession = FirestoreStudySession(
      sessionId: sessionId,
      userId: userId,
      type: sessionType,
      plannedCount: words.length,
      completedCount: summary.results.length,
      firstTryAccuracy: summary.firstTryAccuracyPercent,
      startedAt: _roundThreeStartedAt ?? now,
      endedAt: now,
    );

    try {
      if (updates.isNotEmpty && Get.isRegistered<FirestoreService>()) {
        await FirestoreService.to.updatePersonalWordsSrs(updates: updates);
      }

      if (Get.isRegistered<FirestoreService>()) {
        await FirestoreService.to.saveStudySession(
          session: studySession,
          items: sessionItems,
        );
        if (_scalesEarned > 0 && userId != 'guest') {
          await FirestoreService.to.incrementUserBalances(
            userId: userId,
            scalesDelta: _scalesEarned,
          );
        }
      }
    } catch (error) {
      Get.log('Persist round three data error: $error');
    }

    if (Get.isRegistered<ReviewController>()) {
      try {
        await Get.find<ReviewController>().loadCategories();
      } catch (error) {
        Get.log('Refresh review categories error: $error');
      }
    }

    if (Get.isRegistered<VocabularyTopicController>()) {
      final topicController = Get.find<VocabularyTopicController>();
      for (final result in summary.results) {
        final targetStatus = result.firstTryCorrect == true
            ? VocabularyLearningStatus.learned
            : VocabularyLearningStatus.learning;
        topicController.updateWordStatus(result.word.word, targetStatus);
      }
    }

    if (Get.isRegistered<LearningTabController>()) {
      try {
        await Get.find<LearningTabController>().refreshProgress();
      } catch (error) {
        Get.log('Refresh learning tab progress error: $error');
      }
    }

    return summary.copyWith(
      xpEarned: _xpEarned,
      scalesEarned: _scalesEarned,
    );
  }

  String? _resolveUserId() {
    // Use cached value if available
    if (_cachedUserId != null) {
      return _cachedUserId;
    }

    if (!Get.isRegistered<AuthService>()) {
      return null;
    }
    final auth = AuthService.to;
    if (!auth.isLoggedIn || auth.currentUserId.isEmpty) {
      return null;
    }

    // Cache the result for subsequent calls
    _cachedUserId = auth.currentUserId;
    return _cachedUserId;
  }
}

DailyActivityType _mapActivityType(String sourceType) {
  switch (sourceType) {
    case 'learning':
    case 'lesson':
      return DailyActivityType.learning;
    case 'review':
      return DailyActivityType.review;
    case 'camera':
      return DailyActivityType.camera;
    case 'flashcard':
      return DailyActivityType.flashcard;
    default:
      return DailyActivityType.other;
  }
}
