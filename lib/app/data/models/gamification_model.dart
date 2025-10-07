import 'package:realm/realm.dart';

part 'gamification_model.realm.dart';

@RealmModel()
class _Achievement {
  @PrimaryKey()
  late String id;
  late String name;
  late String description;
  late String type; // streak, xp, vocabulary, lesson
  late String? iconUrl;
  late String condition; // JSON string for achievement conditions
  late int xpReward;
  late int coinReward;
  late String? badgeUrl;
  late bool isActive;
  late DateTime createdAt;
}

@RealmModel()
class _UserAchievement {
  @PrimaryKey()
  late String id;
  late String userId;
  late String achievementId;
  late DateTime earnedAt;
  late bool isNotified;
}

@RealmModel()
class _Badge {
  @PrimaryKey()
  late String id;
  late String name;
  late String description;
  late String? imageUrl;
  late String rarity; // common, rare, epic, legendary
  late String category;
  late DateTime createdAt;
}

@RealmModel()
class _UserBadge {
  @PrimaryKey()
  late String id;
  late String userId;
  late String badgeId;
  late DateTime earnedAt;
  late bool isDisplayed;
}

@RealmModel()
class _Leaderboard {
  @PrimaryKey()
  late String id;
  late String userId;
  late String type; // daily, weekly, monthly, all_time
  late int xp;
  late int rank;
  late DateTime periodStart;
  late DateTime periodEnd;
  late DateTime? lastUpdatedAt;
}

@RealmModel()
class _UserStreak {
  @PrimaryKey()
  late String id;
  late String userId;
  late int currentStreak;
  late int longestStreak;
  late DateTime? lastStudyDate;
  late DateTime? streakStartDate;
  late bool isActive;
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _DailyChallenge {
  @PrimaryKey()
  late String id;
  late String name;
  late String description;
  late String type; // vocabulary, lesson, time_based
  late String goal; // JSON string for challenge goal
  late int xpReward;
  late int coinReward;
  late DateTime challengeDate;
  late bool isActive;
}

@RealmModel()
class _UserDailyChallenge {
  @PrimaryKey()
  late String id;
  late String userId;
  late String dailyChallengeId;
  late double progress; // 0.0 to 1.0
  late bool isCompleted;
  late DateTime? completedAt;
  late int xpEarned;
  late int coinsEarned;
  late DateTime createdAt;
}