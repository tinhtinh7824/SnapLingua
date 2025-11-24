import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/data/services/daily_progress_service.dart';

import '../models/firestore_daily_progress.dart';
import '../models/firestore_daily_quest.dart';
import '../models/firestore_monthly_quest.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'goal_service.dart';

const int _kDailyQuestRewardScales = 15;
const int _kMonthlyQuestTarget = 20;
const int _kMonthlyGemReward = 2;

class QuestService extends GetxService {
  QuestService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static QuestService get to => Get.find<QuestService>();

  final FirebaseFirestore _firestore;

  final RxList<FirestoreDailyQuest> dailyQuests =
      <FirestoreDailyQuest>[].obs;
  final Rxn<FirestoreMonthlyQuestProgress> monthlyProgress =
      Rxn<FirestoreMonthlyQuestProgress>();

  CollectionReference<Map<String, dynamic>> get _dailyQuestCollection =>
      _firestore.collection('user_daily_quests');

  CollectionReference<Map<String, dynamic>> get _monthlyQuestCollection =>
      _firestore.collection('user_monthly_quests');

  final Random _random = Random();

  int get dailyQuestReward => _kDailyQuestRewardScales;

  Future<void> refreshQuests() async {
    final userId = _resolveUserId();
    if (userId == null) {
      dailyQuests.clear();
      monthlyProgress.value = null;
      return;
    }

    final todayDoc = await _getOrCreateTodayDoc(userId);
    dailyQuests.assignAll(todayDoc.quests);

    final monthlyDoc = await _getOrCreateMonthlyDoc(userId, DateTime.now());
    monthlyProgress.value = monthlyDoc;
  }

  Future<void> incrementQuestProgress(
    DailyQuestType type, {
    int amount = 1,
    String? userId,
  }) async {
    final targetUserId = userId ?? _resolveUserId();
    if (targetUserId == null || targetUserId.isEmpty || targetUserId == 'guest') {
      return;
    }
    if (amount <= 0) return;

    bool questCompletedNow = false;
    FirestoreDailyQuest? updatedQuest;

    final docRef =
        _dailyQuestCollection.doc(_composeDailyDocId(targetUserId, DateTime.now()));

    await _firestore.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      FirestoreDailyQuestDay day;
      if (!snapshot.exists || snapshot.data() == null) {
        day = await _createTodayDoc(targetUserId);
      } else {
        day = FirestoreDailyQuestDay.fromSnapshot(snapshot);
      }

      final questIndex =
          day.quests.indexWhere((quest) => quest.type == type);
      if (questIndex == -1) {
        return;
      }

      final quest = day.quests[questIndex];
      if (quest.completed) {
        updatedQuest = quest;
        return;
      }

      final nextProgress = (quest.progress + amount).clamp(0, quest.target);
      final bool completedNow = nextProgress >= quest.target;

      final updated = quest.copyWith(
        progress: nextProgress,
        completed: completedNow,
        completedAt: completedNow ? DateTime.now() : quest.completedAt,
      );

      final updatedQuests = List<FirestoreDailyQuest>.from(day.quests);
      updatedQuests[questIndex] = updated;

      final updatedDay = day.copyWith(
        quests: updatedQuests,
        completedCount:
            completedNow ? day.completedCount + 1 : day.completedCount,
      );

      transaction.set(docRef, updatedDay.toMap());
      updatedQuest = updated;
      questCompletedNow = completedNow;
    });

    if (questCompletedNow && updatedQuest != null) {
      // Previously we rewarded automatically when a quest completed.
      // Change: do NOT grant rewards automatically here. Rewards must be claimed by the user
      // by tapping the quest image. We still persist the completed state to Firestore.
    }

    await refreshQuests();
  }

  /// Claim reward for a completed daily quest. This will mark the quest's
  /// `reward_claimed` flag in Firestore and grant the configured reward.
  Future<void> claimDailyQuest(
    DailyQuestType type, {
    String? userId,
  }) async {
    final targetUserId = userId ?? _resolveUserId();
    if (targetUserId == null || targetUserId.isEmpty || targetUserId == 'guest') {
      return;
    }

    final docRef = _dailyQuestCollection.doc(_composeDailyDocId(targetUserId, DateTime.now()));

    bool rewarded = false;
    FirestoreDailyQuest? claimedQuest;

    await _firestore.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;
      final day = FirestoreDailyQuestDay.fromSnapshot(snapshot);

      final questIndex = day.quests.indexWhere((q) => q.type == type);
      if (questIndex == -1) return;
      final quest = day.quests[questIndex];
      if (!quest.completed || quest.rewardClaimed) return;

      final updated = quest.copyWith(rewardClaimed: true);
      final updatedQuests = List<FirestoreDailyQuest>.from(day.quests);
      updatedQuests[questIndex] = updated;

      final updatedDay = day.copyWith(quests: updatedQuests);
      transaction.set(docRef, updatedDay.toMap());

      claimedQuest = updated;
      rewarded = true;
    });

    if (!rewarded || claimedQuest == null) return;

    // Grant balances and update monthly progress after successful transaction
    if (Get.isRegistered<FirestoreService>()) {
      await FirestoreService.to.incrementUserBalances(
        userId: targetUserId,
        scalesDelta: _kDailyQuestRewardScales,
      );
    }

    final monthlyDoc = await _incrementMonthlyProgress(targetUserId);
    if (monthlyDoc != null && monthlyDoc.completedCount >= _kMonthlyQuestTarget) {
      await _maybeRewardMonthlyGoal(monthlyDoc);
    }

    await refreshQuests();
  }

  Future<void> handleDailyProgressUpdate({
    required String userId,
    required DailyActivityType activity,
    required FirestoreDailyProgress before,
    required FirestoreDailyProgress after,
  }) async {
    switch (activity) {
      case DailyActivityType.learning:
        final deltaLearned = after.newLearned - before.newLearned;
        if (deltaLearned > 0) {
          await incrementQuestProgress(
            DailyQuestType.reachLearnGoal,
            amount: deltaLearned,
            userId: userId,
          );
        }
        break;
      case DailyActivityType.review:
        final deltaReview = after.reviewDone - before.reviewDone;
        if (deltaReview > 0) {
          await incrementQuestProgress(
            DailyQuestType.reachReviewGoal,
            amount: deltaReview,
            userId: userId,
          );
        }
        break;
      default:
        break;
    }
  }

  String? _resolveUserId() {
    if (!Get.isRegistered<AuthService>()) return null;
    final auth = AuthService.to;
    if (!auth.isLoggedIn || auth.currentUserId.isEmpty) {
      return null;
    }
    return auth.currentUserId;
  }

  Future<FirestoreDailyQuestDay> _getOrCreateTodayDoc(String userId) async {
    final docRef =
        _dailyQuestCollection.doc(_composeDailyDocId(userId, DateTime.now()));
    final snapshot = await docRef.get();
    if (snapshot.exists && snapshot.data() != null) {
      return FirestoreDailyQuestDay.fromSnapshot(snapshot);
    }
    final created = await _createTodayDoc(userId);
    await docRef.set(created.toMap());
    return created;
  }

  Future<FirestoreDailyQuestDay> _createTodayDoc(String userId) async {
    final today = DateTime.now();
    final selected = _selectRandomQuests();
    final quests = selected
        .map(
          (type) => FirestoreDailyQuest(
            type: type,
            target: _generateQuestTarget(type),
            progress: 0,
            completed: false,
          ),
        )
        .toList(growable: false);

    return FirestoreDailyQuestDay(
      docId: _composeDailyDocId(userId, today),
      userId: userId,
      date: DateTime(today.year, today.month, today.day),
      quests: quests,
      completedCount: 0,
    );
  }


  Future<FirestoreMonthlyQuestProgress?> _incrementMonthlyProgress(
    String userId,
  ) async {
    final now = DateTime.now();
    final monthKey = _composeMonthKey(now);
    final docRef = _monthlyQuestCollection.doc('$userId\_$monthKey');

    FirestoreMonthlyQuestProgress? current;

    await _firestore.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) {
        final created = FirestoreMonthlyQuestProgress(
          docId: docRef.id,
          userId: userId,
          monthKey: monthKey,
          monthStart: DateTime(now.year, now.month, 1),
          completedCount: 1,
          rewardClaimed: false,
        );
        transaction.set(docRef, created.toMap());
        current = created;
        return;
      }

      final progress = FirestoreMonthlyQuestProgress.fromSnapshot(snapshot);
      final updated = progress.copyWith(
        completedCount: progress.completedCount + 1,
      );
      transaction.set(docRef, updated.toMap());
      current = updated;
    });

    return current;
  }

  Future<void> _maybeRewardMonthlyGoal(
    FirestoreMonthlyQuestProgress progress,
  ) async {
    if (progress.rewardClaimed) {
      return;
    }
    if (!Get.isRegistered<FirestoreService>()) return;

    final docRef = _monthlyQuestCollection.doc(progress.docId);
    bool rewardGranted = false;
    await _firestore.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;
      final latest = FirestoreMonthlyQuestProgress.fromSnapshot(snapshot);
      if (latest.completedCount < _kMonthlyQuestTarget ||
          latest.rewardClaimed) {
        return;
      }
      final updated = latest.copyWith(
        rewardClaimed: true,
        rewardClaimedAt: DateTime.now(),
      );
      transaction.set(docRef, updated.toMap());
      rewardGranted = true;
    });

    if (!rewardGranted) return;

    await FirestoreService.to.incrementUserBalances(
      userId: progress.userId,
      gemsDelta: _kMonthlyGemReward,
    );
    // TODO: Grant monthly icon reward (inventory item) once item catalog is defined.
  }

  Future<FirestoreMonthlyQuestProgress> _getOrCreateMonthlyDoc(
    String userId,
    DateTime date,
  ) async {
    final monthKey = _composeMonthKey(date);
    final docRef = _monthlyQuestCollection.doc('$userId\_$monthKey');
    final snapshot = await docRef.get();
    if (snapshot.exists && snapshot.data() != null) {
      return FirestoreMonthlyQuestProgress.fromSnapshot(snapshot);
    }
    final created = FirestoreMonthlyQuestProgress(
      docId: docRef.id,
      userId: userId,
      monthKey: monthKey,
      monthStart: DateTime(date.year, date.month, 1),
      completedCount: 0,
      rewardClaimed: false,
    );
    await docRef.set(created.toMap());
    return created;
  }

List<DailyQuestType> _selectRandomQuests() {
  final available = List<DailyQuestType>.from(_questDefinitions.keys);
  available.shuffle(_random);
  return available.take(3).toList(growable: false);
}

int _generateQuestTarget(DailyQuestType type) {
  final definition = _questDefinitions[type];
  if (definition == null) return 1;
  return definition.resolveTarget(_random);
}
}

class _DailyQuestDefinition {
  const _DailyQuestDefinition({
    required this.title,
    required this.minTarget,
    required this.maxTarget,
  });

  final String title;
  final int minTarget;
  final int maxTarget;

  int resolveTarget(Random random) {
    if (maxTarget <= minTarget) return minTarget;
    final range = maxTarget - minTarget + 1;
    return minTarget + random.nextInt(range);
  }
}

final Map<DailyQuestType, _DailyQuestDefinition> _questDefinitions = {
  DailyQuestType.saveWords: const _DailyQuestDefinition(
    title: 'Lưu 5 từ mới qua hình ảnh',
    minTarget: 5,
    maxTarget: 5,
  ),
  DailyQuestType.reachLearnGoal: const _DailyQuestDefinition(
    title: 'Đạt mục tiêu học từ mới hôm nay',
    minTarget: 10,
    maxTarget: 30,
  ),
  DailyQuestType.reachReviewGoal: const _DailyQuestDefinition(
    title: 'Đạt mục tiêu ôn tập từ hôm nay',
    minTarget: 20,
    maxTarget: 40,
  ),
  DailyQuestType.postCommunityImage: const _DailyQuestDefinition(
    title: 'Đăng 1 hình ảnh lên cộng đồng',
    minTarget: 1,
    maxTarget: 1,
  ),
  DailyQuestType.engageCommunity: const _DailyQuestDefinition(
    title: 'Bình luận hoặc thả tim 5 bài viết',
    minTarget: 5,
    maxTarget: 5,
  ),
};

String questTitleForType(DailyQuestType type) =>
    _questDefinitions[type]?.title ?? '';

int questTargetForType(DailyQuestType type) =>
    _questDefinitions[type]?.maxTarget ?? 0;

int monthlyQuestTarget() => _kMonthlyQuestTarget;

String _composeDailyDocId(String userId, DateTime date) {
  final safe = DateTime(date.year, date.month, date.day);
  final month = safe.month.toString().padLeft(2, '0');
  final day = safe.day.toString().padLeft(2, '0');
  return '${userId}_${safe.year}$month$day';
}

String _composeMonthKey(DateTime date) =>
    '${date.year}${date.month.toString().padLeft(2, '0')}';
