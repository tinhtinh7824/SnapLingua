import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/routes/app_pages.dart';

import '../models/firestore_daily_progress.dart';
import 'firestore_service.dart';
import 'quest_service.dart';

const int _kDailyXpCap = 500;

enum DailyActivityType {
  learning,
  review,
  camera,
  flashcard,
  other,
}

class DailyProgressService extends GetxService {
  static DailyProgressService get to => Get.find<DailyProgressService>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, Map<String, List<FirestoreDailyProgress>>> _monthlyCache =
      {};
  final Map<String, int> _cachedLifetimeXp = {};
  final Map<String, Set<int>> _streakMilestonesSent = {};

  static const List<int> _streakMilestones = [3, 5, 7, 10, 14, 21, 30, 50, 100];
  static const List<int> _xpMilestones = [500, 1000, 2000, 5000, 10000, 20000];

  CollectionReference<Map<String, dynamic>> get _dailyProgressCollection =>
      _firestore.collection('daily_progress');

  Future<int> awardXp({
    required String userId,
    required int amount,
    required DailyActivityType activity,
    required String sourceType,
    required String action,
    int wordsCount = 0,
    Map<String, dynamic>? metadata,
    String? sourceId,
    DateTime? occurredAt,
  }) async {
    final update = await _recordDailyProgress(
      userId: userId,
      activity: activity,
      xpDelta: amount,
      occurredAt: occurredAt,
    );

    await _persistXpTransaction(
      userId: userId,
      amount: update.appliedXp,
      wordsCount: wordsCount,
      sourceType: sourceType,
      action: action,
      metadata: metadata,
      sourceId: sourceId,
      occurredAt: occurredAt,
    );

    await _ensureStreakUpdated(
      userId: userId,
      progressId: update.progressId,
      hadActivityBefore: update.hadActivityBefore,
      hasActivityAfter: update.hasActivityAfter,
    );

    if (Get.isRegistered<QuestService>()) {
      await QuestService.to.handleDailyProgressUpdate(
        userId: userId,
        activity: activity,
        before: update.before,
        after: update.after,
      );
    }

    return update.appliedXp;
  }

  Future<void> markActivity({
    required String userId,
    required DailyActivityType activity,
    DateTime? occurredAt,
  }) async {
    final update = await _recordDailyProgress(
      userId: userId,
      activity: activity,
      xpDelta: 0,
      occurredAt: occurredAt,
    );

    await _ensureStreakUpdated(
      userId: userId,
      progressId: update.progressId,
      hadActivityBefore: update.hadActivityBefore,
      hasActivityAfter: update.hasActivityAfter,
    );

    if (Get.isRegistered<QuestService>()) {
      await QuestService.to.handleDailyProgressUpdate(
        userId: userId,
        activity: activity,
        before: update.before,
        after: update.after,
      );
    }
  }

  Future<List<FirestoreDailyProgress>> getMonthlyProgress({
    required String userId,
    required DateTime month,
  }) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final docIds = <String>[];

    for (var day = start;
        day.isBefore(end);
        day = day.add(const Duration(days: 1))) {
      docIds.add(_composeProgressId(userId, day));
    }

    final List<FirestoreDailyProgress> results = [];
    const int chunkSize = 10;
    for (var i = 0; i < docIds.length; i += chunkSize) {
      final chunk = docIds.sublist(
        i,
        i + chunkSize > docIds.length ? docIds.length : i + chunkSize,
      );
      final snapshot = await _dailyProgressCollection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(
        snapshot.docs
            .map(FirestoreDailyProgress.fromSnapshot)
            .toList(growable: false),
      );
    }

    results.sort((a, b) => a.date.compareTo(b.date));
    _cacheMonthlyProgress(userId: userId, month: month, progress: results);
    return results;
  }

  List<FirestoreDailyProgress>? getCachedMonthlyProgress({
    required String userId,
    required DateTime month,
  }) {
    if (userId.isEmpty) return null;
    final monthKey = _monthCacheKey(month);
    final userCache = _monthlyCache[userId];
    if (userCache == null) return null;
    final cached = userCache[monthKey];
    if (cached == null) return null;
    return List<FirestoreDailyProgress>.from(cached);
  }

  void _cacheMonthlyProgress({
    required String userId,
    required DateTime month,
    required List<FirestoreDailyProgress> progress,
  }) {
    if (userId.isEmpty) {
      return;
    }
    final normalizedMonth = DateTime(month.year, month.month);
    final monthKey = _monthCacheKey(normalizedMonth);
    final userCache =
        _monthlyCache.putIfAbsent(userId, () => <String, List<FirestoreDailyProgress>>{});
    userCache[monthKey] = List<FirestoreDailyProgress>.from(progress);
  }

  String _monthCacheKey(DateTime month) {
    final normalizedMonth = DateTime(month.year, month.month);
    final monthValue = normalizedMonth.month.toString().padLeft(2, '0');
    return '${normalizedMonth.year}-$monthValue';
  }

  Future<void> _maybeNotifyStreakMilestone({
    required String userId,
    required int previousStreak,
    required int newStreak,
  }) async {
    if (userId.isEmpty) return;
    if (newStreak <= previousStreak) return;
    final milestone = _streakMilestones.firstWhere(
      (value) => previousStreak < value && newStreak >= value,
      orElse: () => -1,
    );
    if (milestone == -1) {
      return;
    }
    final sent = _streakMilestonesSent.putIfAbsent(userId, () => <int>{});
    if (sent.contains(milestone)) {
      return;
    }
    sent.add(milestone);
    await _sendMilestoneNotification(
      userId: userId,
      type: 'streak_milestone',
      payload: {
        'title': 'Chuỗi streak $milestone ngày!',
        'subtitle': 'Đừng bỏ cuộc, tiếp tục giữ streak nhé!',
        'imagePath': 'assets/images/streak/streakbang.png',
        'hasAction': true,
        'actionRoute': Routes.streak,
        'actionText': 'Xem streak',
      },
    );
  }

  Future<void> _maybeNotifyXpMilestone({
    required String userId,
    required int delta,
  }) async {
    if (userId.isEmpty || delta <= 0) return;
    final previousTotal = await _resolveLifetimeXp(userId);
    final newTotal = previousTotal + delta;
    _cachedLifetimeXp[userId] = newTotal;
    final milestone = _xpMilestones.firstWhere(
      (value) => previousTotal < value && newTotal >= value,
      orElse: () => -1,
    );
    if (milestone == -1) {
      return;
    }
    await _sendMilestoneNotification(
      userId: userId,
      type: 'xp_milestone',
      payload: {
        'title': 'Bạn đã đạt $milestone XP!',
        'subtitle': 'Tổng kinh nghiệm hiện tại: $newTotal XP.',
        'imagePath': 'assets/images/XP.png',
        'hasAction': true,
        'actionRoute': Routes.profile,
        'actionText': 'Xem hồ sơ',
      },
    );
  }

  Future<int> _resolveLifetimeXp(String userId) async {
    if (userId.isEmpty) return 0;
    final cached = _cachedLifetimeXp[userId];
    if (cached != null) return cached;
    try {
      final total = await FirestoreService.to.getLifetimeXp(userId);
      _cachedLifetimeXp[userId] = total;
      return total;
    } catch (e) {
      debugPrint('Không thể lấy XP tích lũy của $userId: $e');
      return 0;
    }
  }

  Future<void> _sendMilestoneNotification({
    required String userId,
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    if (!Get.isRegistered<FirestoreService>()) {
      return;
    }
    try {
      await FirestoreService.to.createNotification(
        userId: userId,
        type: type,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Không thể tạo thông báo $type cho $userId: $e');
    }
  }

  Future<int> getDayXp(String userId, DateTime date) async {
    final progressId = _composeProgressId(userId, _dateOnly(date));
    final doc = await _dailyProgressCollection.doc(progressId).get();
    if (!doc.exists || doc.data() == null) return 0;
    return FirestoreDailyProgress.fromSnapshot(doc).xpGained;
  }

  Future<int> getCurrentStreak(String userId) async {
    if (userId.isEmpty) return 0;
    final today = _dateOnly(DateTime.now());
    final hasTodayActivity = await hasActivityOnDate(userId: userId, date: today);

    if (hasTodayActivity) {
      return _calculateStreakEndingOn(userId, today);
    }

    final lastActiveDate = await _findMostRecentActiveDate(
      userId: userId,
      before: today,
    );

    if (lastActiveDate == null) {
      return 0;
    }

    final gap = today.difference(lastActiveDate).inDays;
    if (gap == 1) {
      return _calculateStreakEndingOn(userId, lastActiveDate);
    }

    return 0;
  }

  Future<FirestoreDailyProgress?> getProgressForDate({
    required String userId,
    DateTime? date,
  }) async {
    if (userId.isEmpty) return null;
    final targetDate = _dateOnly(date ?? DateTime.now());
    final progressId = _composeProgressId(userId, targetDate);
    final doc = await _dailyProgressCollection.doc(progressId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FirestoreDailyProgress.fromSnapshot(doc);
  }

  Future<bool> hasActivityOnDate({
    required String userId,
    DateTime? date,
  }) async {
    final progress = await getProgressForDate(userId: userId, date: date);
    if (progress == null) {
      return false;
    }
    return _hasActivity(progress);
  }

  Future<_ProgressUpdateResult> _recordDailyProgress({
    required String userId,
    required DailyActivityType activity,
    required int xpDelta,
    DateTime? occurredAt,
  }) async {
    final activityDate = _dateOnly(occurredAt ?? DateTime.now());
    final progressId = _composeProgressId(userId, activityDate);
    final docRef = _dailyProgressCollection.doc(progressId);

    return _firestore.runTransaction<_ProgressUpdateResult>((transaction) async {
      final snapshot = await transaction.get(docRef);

      FirestoreDailyProgress progress;
      bool hadActivityBefore = false;

      if (snapshot.exists && snapshot.data() != null) {
        progress = FirestoreDailyProgress.fromSnapshot(snapshot);
        hadActivityBefore = _hasActivity(progress);
      } else {
        progress = FirestoreDailyProgress(
          progressId: progressId,
          userId: userId,
          date: activityDate,
          newTarget: 0,
          newLearned: 0,
          reviewDue: 0,
          reviewDone: 0,
          streak: 0,
          xpGained: 0,
        );
      }

      final beforeProgress = progress;

      final currentXp = progress.xpGained;
      final xpRemaining = math.max(0, _kDailyXpCap - currentXp);
      final xpToApply = xpDelta > 0 ? math.min(xpDelta, xpRemaining) : 0;

      var updatedProgress = progress;
      if (xpToApply > 0) {
        updatedProgress =
            updatedProgress.copyWith(xpGained: currentXp + xpToApply);
      }

      updatedProgress = updatedProgress.copyWith(date: activityDate);
      updatedProgress = _incrementCounters(updatedProgress, activity);
      final hasActivityAfter = _hasActivity(updatedProgress);

      transaction.set(docRef, updatedProgress.toMap());

      return _ProgressUpdateResult(
        appliedXp: xpToApply,
        progressId: progressId,
        hadActivityBefore: hadActivityBefore,
        hasActivityAfter: hasActivityAfter,
        before: beforeProgress,
        after: updatedProgress,
      );
    });
  }

  Future<void> _persistXpTransaction({
    required String userId,
    required int amount,
    required int wordsCount,
    required String sourceType,
    required String action,
    Map<String, dynamic>? metadata,
    String? sourceId,
    DateTime? occurredAt,
  }) async {
    if (amount <= 0 || userId == 'guest') return;
    if (!Get.isRegistered<FirestoreService>()) return;

    try {
      await FirestoreService.to.addXpTransaction(
        userId: userId,
        sourceType: sourceType,
        action: action,
        sourceId: sourceId,
        amount: amount,
        metadata: metadata,
        wordsCount: wordsCount,
        occurredAt: occurredAt ?? DateTime.now(),
      );
      await _maybeNotifyXpMilestone(userId: userId, delta: amount);
    } catch (_) {}
  }

  Future<void> _ensureStreakUpdated({
    required String userId,
    required String progressId,
    required bool hadActivityBefore,
    required bool hasActivityAfter,
  }) async {
    if (!hasActivityAfter) return;

    final snapshot = await _dailyProgressCollection.doc(progressId).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return;
    }

    final progress = FirestoreDailyProgress.fromSnapshot(snapshot);
    final previousStreak = progress.streak;
    final newStreak = await _calculateStreakEndingOn(userId, progress.date);

    try {
      await _dailyProgressCollection.doc(progressId).set(
            progress.copyWith(streak: newStreak).toMap(),
            SetOptions(merge: true),
          );
    } catch (_) {}

    await _maybeNotifyStreakMilestone(
      userId: userId,
      previousStreak: previousStreak,
      newStreak: newStreak,
    );
  }

  FirestoreDailyProgress _incrementCounters(
    FirestoreDailyProgress progress,
    DailyActivityType activity,
  ) {
    switch (activity) {
      case DailyActivityType.learning:
        return progress.copyWith(newLearned: progress.newLearned + 1);
      case DailyActivityType.review:
        return progress.copyWith(reviewDone: progress.reviewDone + 1);
      case DailyActivityType.camera:
        return progress.copyWith(reviewDue: progress.reviewDue + 1);
      case DailyActivityType.flashcard:
        return progress.copyWith(newTarget: progress.newTarget + 1);
      case DailyActivityType.other:
        return progress;
    }
  }

  bool _hasActivity(FirestoreDailyProgress progress) {
    return progress.xpGained > 0 ||
        progress.newLearned > 0 ||
        progress.reviewDone > 0 ||
        progress.reviewDue > 0 ||
        progress.newTarget > 0;
  }

  Future<int> _calculateStreakEndingOn(String userId, DateTime date) async {
    var streak = 0;
    var current = _dateOnly(date);

    while (true) {
      final progress = await getProgressForDate(
        userId: userId,
        date: current,
      );

      if (progress == null || !_hasActivity(progress)) {
        break;
      }

      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<DateTime?> _findMostRecentActiveDate({
    required String userId,
    required DateTime before,
    int maxDays = 365,
  }) async {
    var current = before.subtract(const Duration(days: 1));
    var scanned = 0;

    while (scanned < maxDays) {
      final progress = await getProgressForDate(userId: userId, date: current);
      if (progress == null) {
        return null;
      }
      if (_hasActivity(progress)) {
        return current;
      }
      scanned++;
      current = current.subtract(const Duration(days: 1));
    }

    return null;
  }

  String _composeProgressId(String userId, DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${userId}_$y$m$d';
  }

  DateTime _dateOnly(DateTime input) =>
      DateTime(input.year, input.month, input.day);
}

class _ProgressUpdateResult {
  _ProgressUpdateResult({
    required this.appliedXp,
    required this.progressId,
    required this.hadActivityBefore,
    required this.hasActivityAfter,
    required this.before,
    required this.after,
  });

  final int appliedXp;
  final String progressId;
  final bool hadActivityBefore;
  final bool hasActivityAfter;
  final FirestoreDailyProgress before;
  final FirestoreDailyProgress after;
}
