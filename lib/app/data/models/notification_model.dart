import 'package:realm/realm.dart';

part 'notification_model.realm.dart';

@RealmModel()
class _Notification {
  @PrimaryKey()
  late String id;
  late String userId;
  late String type; // reminder, achievement, social, system
  late String title;
  late String message;
  late String? data; // JSON string for additional data
  late bool isRead;
  late bool isPush;
  late bool isEmail;
  late DateTime? scheduledAt;
  late DateTime? sentAt;
  late DateTime createdAt;
}

@RealmModel()
class _NotificationPreference {
  @PrimaryKey()
  late String id;
  late String userId;
  late String type; // reminder, achievement, social, system
  late bool pushEnabled;
  late bool emailEnabled;
  late bool inAppEnabled;
  late String? schedule; // JSON for schedule settings
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _PushToken {
  @PrimaryKey()
  late String id;
  late String userId;
  late String token;
  late String platform; // ios, android, web
  late String? deviceId;
  late bool isActive;
  late DateTime createdAt;
  late DateTime? lastUsedAt;
}