import 'package:realm/realm.dart';

part 'auth_model.realm.dart';

@RealmModel()
class _AuthSession {
  @PrimaryKey()
  late String id;

  late String userId;
  late String email;
  late String? refreshToken;
  late String? accessToken;
  late DateTime? tokenExpiresAt;
  late DateTime createdAt;
  late DateTime? lastActiveAt;
  late String? deviceId;
  late String? deviceName;
  late bool isActive;
}

@RealmModel()
class _PasswordReset {
  @PrimaryKey()
  late String id;

  late String email;
  late String resetCode;
  late DateTime expiresAt;
  late DateTime createdAt;
  late bool isUsed;
}