import 'package:realm/realm.dart';

part 'admin_model.realm.dart';

@RealmModel()
class _AdminUser {
  @PrimaryKey()
  late String id;
  late String email;
  late String name;
  late String role; // super_admin, admin, moderator
  late String? permissions; // JSON array of permissions
  late bool isActive;
  late DateTime createdAt;
  late DateTime? lastLoginAt;
}

@RealmModel()
class _SystemConfig {
  @PrimaryKey()
  late String id;
  late String key;
  late String value;
  late String type; // string, number, boolean, json
  late String? description;
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _UserReport {
  @PrimaryKey()
  late String id;
  late String reporterId;
  late String reportedUserId;
  late String reason;
  late String? details;
  late String status; // pending, reviewed, resolved, dismissed
  late String? adminNotes;
  late String? adminId;
  late DateTime reportedAt;
  late DateTime? reviewedAt;
}

@RealmModel()
class _ContentModerationLog {
  @PrimaryKey()
  late String id;
  late String contentType; // message, profile, vocabulary
  late String contentId;
  late String action; // approved, rejected, edited, deleted
  late String? reason;
  late String adminId;
  late DateTime actionAt;
}

@RealmModel()
class _SystemLog {
  @PrimaryKey()
  late String id;
  late String level; // info, warning, error, critical
  late String category; // auth, sync, payment, general
  late String message;
  late String? details; // JSON string
  late String? userId;
  late DateTime createdAt;
}

@RealmModel()
class _AppVersion {
  @PrimaryKey()
  late String id;
  late String platform; // ios, android
  late String version;
  late String buildNumber;
  late bool isRequired;
  late String? downloadUrl;
  late String? releaseNotes;
  late DateTime releasedAt;
  late bool isActive;
}