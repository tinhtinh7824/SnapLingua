import 'package:get/get.dart';
import 'package:snaplingua/app/data/models/realm/gamification_model.dart';

import 'realm_service.dart';

class GamificationService extends GetxService {
  static GamificationService get to => Get.find<GamificationService>();

  final RealmService _realmService = RealmService.to;

  // Get user achievements
  Future<List<UserAchievement>> getUserAchievements(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<UserAchievement>()
          .where((ua) => ua.userId == userId);
      return results.toList();
    } catch (e) {
      print('Error getting user achievements: $e');
      return [];
    }
  }

  // Award achievement to user
  Future<bool> awardAchievement(String userId, String achievementId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if already earned
      final existing = realm.all<UserAchievement>()
          .where((ua) => ua.userId == userId && ua.achievementId == achievementId)
          .firstOrNull;

      if (existing != null) {
        print('Achievement already earned');
        return false;
      }

      final userAchievement = UserAchievement(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        achievementId,
        DateTime.now(),
        false, // isNotified
      );

      realm.write(() => realm.add(userAchievement));
      return true;
    } catch (e) {
      print('Error awarding achievement: $e');
      return false;
    }
  }

  // Get user badges
  Future<List<UserBadge>> getUserBadges(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<UserBadge>()
          .where((ub) => ub.userId == userId);
      return results.toList();
    } catch (e) {
      print('Error getting user badges: $e');
      return [];
    }
  }

  // Award badge to user
  Future<bool> awardBadge(String userId, String badgeId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if already earned
      final existing = realm.all<UserBadge>()
          .where((ub) => ub.userId == userId && ub.badgeId == badgeId)
          .firstOrNull;

      if (existing != null) {
        print('Badge already earned');
        return false;
      }

      final userBadge = UserBadge(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        badgeId,
        DateTime.now(),
        false, // isDisplayed
      );

      realm.write(() => realm.add(userBadge));
      return true;
    } catch (e) {
      print('Error awarding badge: $e');
      return false;
    }
  }

  // Get leaderboard
  Future<List<Leaderboard>> getLeaderboard(String type, {int limit = 50}) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Leaderboard>()
          .where((l) => l.type == type)
          .toList()
        ..sort((a, b) => a.rank.compareTo(b.rank));

      return results.take(limit).toList();
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  // Update user streak
  Future<bool> updateStreak(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final userStreak = realm.all<UserStreak>()
          .where((us) => us.userId == userId)
          .firstOrNull;

      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);

      if (userStreak == null) {
        // Create new streak
        final newStreak = UserStreak(
          DateTime.now().millisecondsSinceEpoch.toString(),
          userId,
          1,
          1,
          true,
          DateTime.now(),
          lastStudyDate: todayDateOnly,
          streakStartDate: todayDateOnly,
          updatedAt: DateTime.now(),
        );

        realm.write(() => realm.add(newStreak));
        return true;
      }

      final lastStudyDate = userStreak.lastStudyDate;
      if (lastStudyDate == null) {
        // First study session
        realm.write(() {
          userStreak.currentStreak = 1;
          userStreak.longestStreak = 1;
          userStreak.lastStudyDate = todayDateOnly;
          userStreak.streakStartDate = todayDateOnly;
          userStreak.isActive = true;
          userStreak.updatedAt = DateTime.now();
        });
        return true;
      }

      final lastStudyDateOnly = DateTime(lastStudyDate.year, lastStudyDate.month, lastStudyDate.day);
      final daysDifference = todayDateOnly.difference(lastStudyDateOnly).inDays;

      realm.write(() {
        if (daysDifference == 0) {
          // Same day, no change needed
          return;
        } else if (daysDifference == 1) {
          // Consecutive day, increment streak
          userStreak.currentStreak++;
          if (userStreak.currentStreak > userStreak.longestStreak) {
            userStreak.longestStreak = userStreak.currentStreak;
          }
        } else {
          // Streak broken, reset
          userStreak.currentStreak = 1;
          userStreak.streakStartDate = todayDateOnly;
        }

        userStreak.lastStudyDate = todayDateOnly;
        userStreak.isActive = true;
        userStreak.updatedAt = DateTime.now();
      });

      return true;
    } catch (e) {
      print('Error updating streak: $e');
      return false;
    }
  }

  // Get daily challenges
  Future<List<DailyChallenge>> getTodaysChallenges() async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);

      final results = realm.all<DailyChallenge>()
          .where((dc) => dc.isActive &&
                        dc.challengeDate.year == todayDateOnly.year &&
                        dc.challengeDate.month == todayDateOnly.month &&
                        dc.challengeDate.day == todayDateOnly.day);

      return results.toList();
    } catch (e) {
      print('Error getting daily challenges: $e');
      return [];
    }
  }

  // Get user's daily challenge progress
  Future<List<UserDailyChallenge>> getUserDailyChallenges(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      final results = realm.all<UserDailyChallenge>()
          .where((udc) => udc.userId == userId &&
                         udc.createdAt.isAfter(todayStart));

      return results.toList();
    } catch (e) {
      print('Error getting user daily challenges: $e');
      return [];
    }
  }

  // Update daily challenge progress
  Future<bool> updateChallengeProgress(String userId, String challengeId, double progress) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final userChallenge = realm.all<UserDailyChallenge>()
          .where((udc) => udc.userId == userId && udc.dailyChallengeId == challengeId)
          .firstOrNull;

      if (userChallenge == null) {
        // Create new user challenge
        final newUserChallenge = UserDailyChallenge(
          DateTime.now().millisecondsSinceEpoch.toString(),
          userId,
          challengeId,
          progress,
          progress >= 1.0,
          0, // xpEarned
          0, // coinsEarned
          DateTime.now(),
          completedAt: progress >= 1.0 ? DateTime.now() : null,
        );

        realm.write(() => realm.add(newUserChallenge));
      } else {
        realm.write(() {
          userChallenge.progress = progress;
          if (progress >= 1.0 && !userChallenge.isCompleted) {
            userChallenge.isCompleted = true;
            userChallenge.completedAt = DateTime.now();

            // Award XP and coins
            final challenge = realm.find<DailyChallenge>(challengeId);
            if (challenge != null) {
              userChallenge.xpEarned = challenge.xpReward;
              userChallenge.coinsEarned = challenge.coinReward;
            }
          }
        });
      }

      return true;
    } catch (e) {
      print('Error updating challenge progress: $e');
      return false;
    }
  }

  // Get user's current streak
  Future<UserStreak?> getUserStreak(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final userStreak = realm.all<UserStreak>()
          .where((us) => us.userId == userId)
          .firstOrNull;

      return userStreak;
    } catch (e) {
      print('Error getting user streak: $e');
      return null;
    }
  }

  // Calculate total XP for leaderboard ranking
  Future<void> updateLeaderboardRanking(String userId, int xp, String type) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Define period based on type
      DateTime periodStart, periodEnd;
      final now = DateTime.now();

      switch (type) {
        case 'daily':
          periodStart = DateTime(now.year, now.month, now.day);
          periodEnd = periodStart.add(const Duration(days: 1));
          break;
        case 'weekly':
          final weekday = now.weekday;
          periodStart = now.subtract(Duration(days: weekday - 1));
          periodStart = DateTime(periodStart.year, periodStart.month, periodStart.day);
          periodEnd = periodStart.add(const Duration(days: 7));
          break;
        case 'monthly':
          periodStart = DateTime(now.year, now.month, 1);
          periodEnd = DateTime(now.year, now.month + 1, 1);
          break;
        default: // all_time
          periodStart = DateTime(2000);
          periodEnd = DateTime(2100);
      }

      // Find or create leaderboard entry
      final leaderboard = realm.all<Leaderboard>()
          .where((l) => l.userId == userId &&
                       l.type == type &&
                       l.periodStart == periodStart)
          .firstOrNull;

      if (leaderboard == null) {
        final newLeaderboard = Leaderboard(
          DateTime.now().millisecondsSinceEpoch.toString(),
          userId,
          type,
          xp,
          0, // rank will be calculated separately
          periodStart,
          periodEnd,
          lastUpdatedAt: DateTime.now(),
        );

        realm.write(() => realm.add(newLeaderboard));
      } else {
        realm.write(() {
          leaderboard.xp = xp;
          leaderboard.lastUpdatedAt = DateTime.now();
        });
      }

      // Recalculate ranks for this period
      await _recalculateRanks(type, periodStart);
    } catch (e) {
      print('Error updating leaderboard ranking: $e');
    }
  }

  Future<void> _recalculateRanks(String type, DateTime periodStart) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) return;

      final leaderboards = realm.all<Leaderboard>()
          .where((l) => l.type == type && l.periodStart == periodStart)
          .toList()
        ..sort((a, b) => b.xp.compareTo(a.xp));

      realm.write(() {
        for (int i = 0; i < leaderboards.length; i++) {
          leaderboards[i].rank = i + 1;
        }
      });
    } catch (e) {
      print('Error recalculating ranks: $e');
    }
  }
}
