import 'package:realm/realm.dart';

part 'user_model.realm.dart';

@RealmModel()
class _User {
  @PrimaryKey()
  late String id;

  late String email;
  late String? name;
  late String? gender;
  late String? birthDay;
  late String? birthMonth;
  late String? birthYear;
  late DateTime createdAt;
  late DateTime? updatedAt;

  // User preferences and progress
  late String? purpose;
  late String? studyTime;
  late bool surveyCompleted;
  late int level;
  late int xp;
  late int streak;

  // Authentication related
  late bool isVerified;
  late DateTime? lastLoginAt;

  // Profile settings
  late String? avatarUrl;
  late String? deviceId;
  late String? fcmToken;

  // Extended fields from app requirements
  late String? phoneNumber;
  late String? country;
  late String? timezone;
  late String? preferredLanguage;
  late String? nativeLanguage;
  late bool isPremium;
  late DateTime? premiumExpiryDate;
  late int coins;
  late int totalXp;
  late int weeklyXp;
  late int monthlyXp;
  late int dailyGoal;
  late int weeklyGoal;
  late int currentStreak;
  late int longestStreak;
  late DateTime? lastStudyDate;
  late int totalStudyDays;
  late int totalStudyTimeMinutes;
  late bool notificationsEnabled;
  late bool soundEnabled;
  late bool darkModeEnabled;
  late DateTime? lastSyncAt;
  late bool isActive;
  late bool isBlocked;
  late String? blockedReason;
  late DateTime? blockedAt;
  late String? referralCode;
  late String? referredBy;
  late int referralCount;
}