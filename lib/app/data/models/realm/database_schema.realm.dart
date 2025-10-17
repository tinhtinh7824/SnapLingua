// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class DbUser extends _DbUser with RealmEntity, RealmObjectBase, RealmObject {
  DbUser(
    String userId,
    String role,
    String status,
    DateTime createdAt, {
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'display_name', displayName);
    RealmObjectBase.set(this, 'avatar_url', avatarUrl);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'created_at', createdAt);
    RealmObjectBase.set(this, 'updated_at', updatedAt);
  }

  DbUser._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get displayName =>
      RealmObjectBase.get<String>(this, 'display_name') as String?;
  @override
  set displayName(String? value) =>
      RealmObjectBase.set(this, 'display_name', value);

  @override
  String? get avatarUrl =>
      RealmObjectBase.get<String>(this, 'avatar_url') as String?;
  @override
  set avatarUrl(String? value) =>
      RealmObjectBase.set(this, 'avatar_url', value);

  @override
  String get role => RealmObjectBase.get<String>(this, 'role') as String;
  @override
  set role(String value) => RealmObjectBase.set(this, 'role', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updated_at') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updated_at', value);

  @override
  Stream<RealmObjectChanges<DbUser>> get changes =>
      RealmObjectBase.getChanges<DbUser>(this);

  @override
  Stream<RealmObjectChanges<DbUser>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DbUser>(this, keyPaths);

  @override
  DbUser freeze() => RealmObjectBase.freezeObject<DbUser>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'user_id': userId.toEJson(),
      'email': email.toEJson(),
      'display_name': displayName.toEJson(),
      'avatar_url': avatarUrl.toEJson(),
      'role': role.toEJson(),
      'status': status.toEJson(),
      'created_at': createdAt.toEJson(),
      'updated_at': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(DbUser value) => value.toEJson();
  static DbUser _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'user_id': EJsonValue userId,
        'role': EJsonValue role,
        'status': EJsonValue status,
        'created_at': EJsonValue createdAt,
      } =>
        DbUser(
          fromEJson(userId),
          fromEJson(role),
          fromEJson(status),
          fromEJson(createdAt),
          email: fromEJson(ejson['email']),
          displayName: fromEJson(ejson['display_name']),
          avatarUrl: fromEJson(ejson['avatar_url']),
          updatedAt: fromEJson(ejson['updated_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DbUser._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, DbUser, 'DbUser', [
      SchemaProperty('userId', RealmPropertyType.string,
          mapTo: 'user_id', primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('displayName', RealmPropertyType.string,
          mapTo: 'display_name', optional: true),
      SchemaProperty('avatarUrl', RealmPropertyType.string,
          mapTo: 'avatar_url', optional: true),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp,
          mapTo: 'updated_at', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class AuthProviderEntity extends _AuthProviderEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  AuthProviderEntity(
    String providerId,
    String userId,
    String provider,
    String providerUid,
    bool emailVerified,
    DateTime linkedAt,
  ) {
    RealmObjectBase.set(this, 'provider_id', providerId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'provider', provider);
    RealmObjectBase.set(this, 'provider_uid', providerUid);
    RealmObjectBase.set(this, 'email_verified', emailVerified);
    RealmObjectBase.set(this, 'linked_at', linkedAt);
  }

  AuthProviderEntity._();

  @override
  String get providerId =>
      RealmObjectBase.get<String>(this, 'provider_id') as String;
  @override
  set providerId(String value) =>
      RealmObjectBase.set(this, 'provider_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get provider =>
      RealmObjectBase.get<String>(this, 'provider') as String;
  @override
  set provider(String value) => RealmObjectBase.set(this, 'provider', value);

  @override
  String get providerUid =>
      RealmObjectBase.get<String>(this, 'provider_uid') as String;
  @override
  set providerUid(String value) =>
      RealmObjectBase.set(this, 'provider_uid', value);

  @override
  bool get emailVerified =>
      RealmObjectBase.get<bool>(this, 'email_verified') as bool;
  @override
  set emailVerified(bool value) =>
      RealmObjectBase.set(this, 'email_verified', value);

  @override
  DateTime get linkedAt =>
      RealmObjectBase.get<DateTime>(this, 'linked_at') as DateTime;
  @override
  set linkedAt(DateTime value) => RealmObjectBase.set(this, 'linked_at', value);

  @override
  Stream<RealmObjectChanges<AuthProviderEntity>> get changes =>
      RealmObjectBase.getChanges<AuthProviderEntity>(this);

  @override
  Stream<RealmObjectChanges<AuthProviderEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AuthProviderEntity>(this, keyPaths);

  @override
  AuthProviderEntity freeze() =>
      RealmObjectBase.freezeObject<AuthProviderEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'provider_id': providerId.toEJson(),
      'user_id': userId.toEJson(),
      'provider': provider.toEJson(),
      'provider_uid': providerUid.toEJson(),
      'email_verified': emailVerified.toEJson(),
      'linked_at': linkedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(AuthProviderEntity value) => value.toEJson();
  static AuthProviderEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'provider_id': EJsonValue providerId,
        'user_id': EJsonValue userId,
        'provider': EJsonValue provider,
        'provider_uid': EJsonValue providerUid,
        'email_verified': EJsonValue emailVerified,
        'linked_at': EJsonValue linkedAt,
      } =>
        AuthProviderEntity(
          fromEJson(providerId),
          fromEJson(userId),
          fromEJson(provider),
          fromEJson(providerUid),
          fromEJson(emailVerified),
          fromEJson(linkedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AuthProviderEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AuthProviderEntity, 'AuthProviderEntity', [
      SchemaProperty('providerId', RealmPropertyType.string,
          mapTo: 'provider_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('provider', RealmPropertyType.string),
      SchemaProperty('providerUid', RealmPropertyType.string,
          mapTo: 'provider_uid'),
      SchemaProperty('emailVerified', RealmPropertyType.bool,
          mapTo: 'email_verified'),
      SchemaProperty('linkedAt', RealmPropertyType.timestamp,
          mapTo: 'linked_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserSecurityEntity extends _UserSecurityEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  UserSecurityEntity(
    String userId,
    bool twoFactorEnabled, {
    String? passwordHash,
    String? twoFactorMethod,
    String? twoFactorSecret,
    DateTime? lastPasswordChange,
  }) {
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'password_hash', passwordHash);
    RealmObjectBase.set(this, 'two_factor_enabled', twoFactorEnabled);
    RealmObjectBase.set(this, 'two_factor_method', twoFactorMethod);
    RealmObjectBase.set(this, 'two_factor_secret', twoFactorSecret);
    RealmObjectBase.set(this, 'last_password_change', lastPasswordChange);
  }

  UserSecurityEntity._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String? get passwordHash =>
      RealmObjectBase.get<String>(this, 'password_hash') as String?;
  @override
  set passwordHash(String? value) =>
      RealmObjectBase.set(this, 'password_hash', value);

  @override
  bool get twoFactorEnabled =>
      RealmObjectBase.get<bool>(this, 'two_factor_enabled') as bool;
  @override
  set twoFactorEnabled(bool value) =>
      RealmObjectBase.set(this, 'two_factor_enabled', value);

  @override
  String? get twoFactorMethod =>
      RealmObjectBase.get<String>(this, 'two_factor_method') as String?;
  @override
  set twoFactorMethod(String? value) =>
      RealmObjectBase.set(this, 'two_factor_method', value);

  @override
  String? get twoFactorSecret =>
      RealmObjectBase.get<String>(this, 'two_factor_secret') as String?;
  @override
  set twoFactorSecret(String? value) =>
      RealmObjectBase.set(this, 'two_factor_secret', value);

  @override
  DateTime? get lastPasswordChange =>
      RealmObjectBase.get<DateTime>(this, 'last_password_change') as DateTime?;
  @override
  set lastPasswordChange(DateTime? value) =>
      RealmObjectBase.set(this, 'last_password_change', value);

  @override
  Stream<RealmObjectChanges<UserSecurityEntity>> get changes =>
      RealmObjectBase.getChanges<UserSecurityEntity>(this);

  @override
  Stream<RealmObjectChanges<UserSecurityEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserSecurityEntity>(this, keyPaths);

  @override
  UserSecurityEntity freeze() =>
      RealmObjectBase.freezeObject<UserSecurityEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'user_id': userId.toEJson(),
      'password_hash': passwordHash.toEJson(),
      'two_factor_enabled': twoFactorEnabled.toEJson(),
      'two_factor_method': twoFactorMethod.toEJson(),
      'two_factor_secret': twoFactorSecret.toEJson(),
      'last_password_change': lastPasswordChange.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserSecurityEntity value) => value.toEJson();
  static UserSecurityEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'user_id': EJsonValue userId,
        'two_factor_enabled': EJsonValue twoFactorEnabled,
      } =>
        UserSecurityEntity(
          fromEJson(userId),
          fromEJson(twoFactorEnabled),
          passwordHash: fromEJson(ejson['password_hash']),
          twoFactorMethod: fromEJson(ejson['two_factor_method']),
          twoFactorSecret: fromEJson(ejson['two_factor_secret']),
          lastPasswordChange: fromEJson(ejson['last_password_change']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserSecurityEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserSecurityEntity, 'UserSecurityEntity', [
      SchemaProperty('userId', RealmPropertyType.string,
          mapTo: 'user_id', primaryKey: true),
      SchemaProperty('passwordHash', RealmPropertyType.string,
          mapTo: 'password_hash', optional: true),
      SchemaProperty('twoFactorEnabled', RealmPropertyType.bool,
          mapTo: 'two_factor_enabled'),
      SchemaProperty('twoFactorMethod', RealmPropertyType.string,
          mapTo: 'two_factor_method', optional: true),
      SchemaProperty('twoFactorSecret', RealmPropertyType.string,
          mapTo: 'two_factor_secret', optional: true),
      SchemaProperty('lastPasswordChange', RealmPropertyType.timestamp,
          mapTo: 'last_password_change', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DeviceTokenEntity extends _DeviceTokenEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DeviceTokenEntity(
    String tokenId,
    String userId,
    String deviceType,
    String fcmToken,
    DateTime createdAt, {
    String? deviceId,
    DateTime? lastActiveAt,
  }) {
    RealmObjectBase.set(this, 'token_id', tokenId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'device_type', deviceType);
    RealmObjectBase.set(this, 'device_id', deviceId);
    RealmObjectBase.set(this, 'fcm_token', fcmToken);
    RealmObjectBase.set(this, 'last_active_at', lastActiveAt);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  DeviceTokenEntity._();

  @override
  String get tokenId => RealmObjectBase.get<String>(this, 'token_id') as String;
  @override
  set tokenId(String value) => RealmObjectBase.set(this, 'token_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get deviceType =>
      RealmObjectBase.get<String>(this, 'device_type') as String;
  @override
  set deviceType(String value) =>
      RealmObjectBase.set(this, 'device_type', value);

  @override
  String? get deviceId =>
      RealmObjectBase.get<String>(this, 'device_id') as String?;
  @override
  set deviceId(String? value) => RealmObjectBase.set(this, 'device_id', value);

  @override
  String get fcmToken =>
      RealmObjectBase.get<String>(this, 'fcm_token') as String;
  @override
  set fcmToken(String value) => RealmObjectBase.set(this, 'fcm_token', value);

  @override
  DateTime? get lastActiveAt =>
      RealmObjectBase.get<DateTime>(this, 'last_active_at') as DateTime?;
  @override
  set lastActiveAt(DateTime? value) =>
      RealmObjectBase.set(this, 'last_active_at', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<DeviceTokenEntity>> get changes =>
      RealmObjectBase.getChanges<DeviceTokenEntity>(this);

  @override
  Stream<RealmObjectChanges<DeviceTokenEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DeviceTokenEntity>(this, keyPaths);

  @override
  DeviceTokenEntity freeze() =>
      RealmObjectBase.freezeObject<DeviceTokenEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'token_id': tokenId.toEJson(),
      'user_id': userId.toEJson(),
      'device_type': deviceType.toEJson(),
      'device_id': deviceId.toEJson(),
      'fcm_token': fcmToken.toEJson(),
      'last_active_at': lastActiveAt.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(DeviceTokenEntity value) => value.toEJson();
  static DeviceTokenEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'token_id': EJsonValue tokenId,
        'user_id': EJsonValue userId,
        'device_type': EJsonValue deviceType,
        'fcm_token': EJsonValue fcmToken,
        'created_at': EJsonValue createdAt,
      } =>
        DeviceTokenEntity(
          fromEJson(tokenId),
          fromEJson(userId),
          fromEJson(deviceType),
          fromEJson(fcmToken),
          fromEJson(createdAt),
          deviceId: fromEJson(ejson['device_id']),
          lastActiveAt: fromEJson(ejson['last_active_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DeviceTokenEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DeviceTokenEntity, 'DeviceTokenEntity', [
      SchemaProperty('tokenId', RealmPropertyType.string,
          mapTo: 'token_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('deviceType', RealmPropertyType.string,
          mapTo: 'device_type'),
      SchemaProperty('deviceId', RealmPropertyType.string,
          mapTo: 'device_id', optional: true),
      SchemaProperty('fcmToken', RealmPropertyType.string, mapTo: 'fcm_token'),
      SchemaProperty('lastActiveAt', RealmPropertyType.timestamp,
          mapTo: 'last_active_at', optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class BadgeEntity extends _BadgeEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  BadgeEntity(
    String badgeId,
    String code,
    String name,
    String stickerUrl,
    bool stickerAnimated,
    String conditionType,
    int threshold,
    DateTime createdAt, {
    String? iconUrl,
    String? description,
  }) {
    RealmObjectBase.set(this, 'badge_id', badgeId);
    RealmObjectBase.set(this, 'code', code);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'icon_url', iconUrl);
    RealmObjectBase.set(this, 'sticker_url', stickerUrl);
    RealmObjectBase.set(this, 'sticker_animated', stickerAnimated);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'condition_type', conditionType);
    RealmObjectBase.set(this, 'threshold', threshold);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  BadgeEntity._();

  @override
  String get badgeId => RealmObjectBase.get<String>(this, 'badge_id') as String;
  @override
  set badgeId(String value) => RealmObjectBase.set(this, 'badge_id', value);

  @override
  String get code => RealmObjectBase.get<String>(this, 'code') as String;
  @override
  set code(String value) => RealmObjectBase.set(this, 'code', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get iconUrl =>
      RealmObjectBase.get<String>(this, 'icon_url') as String?;
  @override
  set iconUrl(String? value) => RealmObjectBase.set(this, 'icon_url', value);

  @override
  String get stickerUrl =>
      RealmObjectBase.get<String>(this, 'sticker_url') as String;
  @override
  set stickerUrl(String value) =>
      RealmObjectBase.set(this, 'sticker_url', value);

  @override
  bool get stickerAnimated =>
      RealmObjectBase.get<bool>(this, 'sticker_animated') as bool;
  @override
  set stickerAnimated(bool value) =>
      RealmObjectBase.set(this, 'sticker_animated', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get conditionType =>
      RealmObjectBase.get<String>(this, 'condition_type') as String;
  @override
  set conditionType(String value) =>
      RealmObjectBase.set(this, 'condition_type', value);

  @override
  int get threshold => RealmObjectBase.get<int>(this, 'threshold') as int;
  @override
  set threshold(int value) => RealmObjectBase.set(this, 'threshold', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<BadgeEntity>> get changes =>
      RealmObjectBase.getChanges<BadgeEntity>(this);

  @override
  Stream<RealmObjectChanges<BadgeEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<BadgeEntity>(this, keyPaths);

  @override
  BadgeEntity freeze() => RealmObjectBase.freezeObject<BadgeEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'badge_id': badgeId.toEJson(),
      'code': code.toEJson(),
      'name': name.toEJson(),
      'icon_url': iconUrl.toEJson(),
      'sticker_url': stickerUrl.toEJson(),
      'sticker_animated': stickerAnimated.toEJson(),
      'description': description.toEJson(),
      'condition_type': conditionType.toEJson(),
      'threshold': threshold.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(BadgeEntity value) => value.toEJson();
  static BadgeEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'badge_id': EJsonValue badgeId,
        'code': EJsonValue code,
        'name': EJsonValue name,
        'sticker_url': EJsonValue stickerUrl,
        'sticker_animated': EJsonValue stickerAnimated,
        'condition_type': EJsonValue conditionType,
        'threshold': EJsonValue threshold,
        'created_at': EJsonValue createdAt,
      } =>
        BadgeEntity(
          fromEJson(badgeId),
          fromEJson(code),
          fromEJson(name),
          fromEJson(stickerUrl),
          fromEJson(stickerAnimated),
          fromEJson(conditionType),
          fromEJson(threshold),
          fromEJson(createdAt),
          iconUrl: fromEJson(ejson['icon_url']),
          description: fromEJson(ejson['description']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(BadgeEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, BadgeEntity, 'BadgeEntity', [
      SchemaProperty('badgeId', RealmPropertyType.string,
          mapTo: 'badge_id', primaryKey: true),
      SchemaProperty('code', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('iconUrl', RealmPropertyType.string,
          mapTo: 'icon_url', optional: true),
      SchemaProperty('stickerUrl', RealmPropertyType.string,
          mapTo: 'sticker_url'),
      SchemaProperty('stickerAnimated', RealmPropertyType.bool,
          mapTo: 'sticker_animated'),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('conditionType', RealmPropertyType.string,
          mapTo: 'condition_type'),
      SchemaProperty('threshold', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserBadgeEntity extends _UserBadgeEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  UserBadgeEntity(
    String id,
    String userId,
    String badgeId,
    DateTime awardedAt,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'badge_id', badgeId);
    RealmObjectBase.set(this, 'awarded_at', awardedAt);
  }

  UserBadgeEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get badgeId => RealmObjectBase.get<String>(this, 'badge_id') as String;
  @override
  set badgeId(String value) => RealmObjectBase.set(this, 'badge_id', value);

  @override
  DateTime get awardedAt =>
      RealmObjectBase.get<DateTime>(this, 'awarded_at') as DateTime;
  @override
  set awardedAt(DateTime value) =>
      RealmObjectBase.set(this, 'awarded_at', value);

  @override
  Stream<RealmObjectChanges<UserBadgeEntity>> get changes =>
      RealmObjectBase.getChanges<UserBadgeEntity>(this);

  @override
  Stream<RealmObjectChanges<UserBadgeEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserBadgeEntity>(this, keyPaths);

  @override
  UserBadgeEntity freeze() =>
      RealmObjectBase.freezeObject<UserBadgeEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'user_id': userId.toEJson(),
      'badge_id': badgeId.toEJson(),
      'awarded_at': awardedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserBadgeEntity value) => value.toEJson();
  static UserBadgeEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'user_id': EJsonValue userId,
        'badge_id': EJsonValue badgeId,
        'awarded_at': EJsonValue awardedAt,
      } =>
        UserBadgeEntity(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(badgeId),
          fromEJson(awardedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserBadgeEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserBadgeEntity, 'UserBadgeEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('badgeId', RealmPropertyType.string, mapTo: 'badge_id'),
      SchemaProperty('awardedAt', RealmPropertyType.timestamp,
          mapTo: 'awarded_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PhotoEntity extends _PhotoEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PhotoEntity(
    String photoId,
    String imageUrl,
    int width,
    int height,
    String format,
    String source,
    DateTime uploadedAt, {
    String? userId,
    int? sizeBytes,
    DateTime? takenAt,
    String? exif,
    String? checksumSha256,
  }) {
    RealmObjectBase.set(this, 'photo_id', photoId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'image_url', imageUrl);
    RealmObjectBase.set(this, 'width', width);
    RealmObjectBase.set(this, 'height', height);
    RealmObjectBase.set(this, 'format', format);
    RealmObjectBase.set(this, 'size_bytes', sizeBytes);
    RealmObjectBase.set(this, 'source', source);
    RealmObjectBase.set(this, 'taken_at', takenAt);
    RealmObjectBase.set(this, 'uploaded_at', uploadedAt);
    RealmObjectBase.set(this, 'exif', exif);
    RealmObjectBase.set(this, 'checksum_sha256', checksumSha256);
  }

  PhotoEntity._();

  @override
  String get photoId => RealmObjectBase.get<String>(this, 'photo_id') as String;
  @override
  set photoId(String value) => RealmObjectBase.set(this, 'photo_id', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'user_id') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get imageUrl =>
      RealmObjectBase.get<String>(this, 'image_url') as String;
  @override
  set imageUrl(String value) => RealmObjectBase.set(this, 'image_url', value);

  @override
  int get width => RealmObjectBase.get<int>(this, 'width') as int;
  @override
  set width(int value) => RealmObjectBase.set(this, 'width', value);

  @override
  int get height => RealmObjectBase.get<int>(this, 'height') as int;
  @override
  set height(int value) => RealmObjectBase.set(this, 'height', value);

  @override
  String get format => RealmObjectBase.get<String>(this, 'format') as String;
  @override
  set format(String value) => RealmObjectBase.set(this, 'format', value);

  @override
  int? get sizeBytes => RealmObjectBase.get<int>(this, 'size_bytes') as int?;
  @override
  set sizeBytes(int? value) => RealmObjectBase.set(this, 'size_bytes', value);

  @override
  String get source => RealmObjectBase.get<String>(this, 'source') as String;
  @override
  set source(String value) => RealmObjectBase.set(this, 'source', value);

  @override
  DateTime? get takenAt =>
      RealmObjectBase.get<DateTime>(this, 'taken_at') as DateTime?;
  @override
  set takenAt(DateTime? value) => RealmObjectBase.set(this, 'taken_at', value);

  @override
  DateTime get uploadedAt =>
      RealmObjectBase.get<DateTime>(this, 'uploaded_at') as DateTime;
  @override
  set uploadedAt(DateTime value) =>
      RealmObjectBase.set(this, 'uploaded_at', value);

  @override
  String? get exif => RealmObjectBase.get<String>(this, 'exif') as String?;
  @override
  set exif(String? value) => RealmObjectBase.set(this, 'exif', value);

  @override
  String? get checksumSha256 =>
      RealmObjectBase.get<String>(this, 'checksum_sha256') as String?;
  @override
  set checksumSha256(String? value) =>
      RealmObjectBase.set(this, 'checksum_sha256', value);

  @override
  Stream<RealmObjectChanges<PhotoEntity>> get changes =>
      RealmObjectBase.getChanges<PhotoEntity>(this);

  @override
  Stream<RealmObjectChanges<PhotoEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PhotoEntity>(this, keyPaths);

  @override
  PhotoEntity freeze() => RealmObjectBase.freezeObject<PhotoEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'photo_id': photoId.toEJson(),
      'user_id': userId.toEJson(),
      'image_url': imageUrl.toEJson(),
      'width': width.toEJson(),
      'height': height.toEJson(),
      'format': format.toEJson(),
      'size_bytes': sizeBytes.toEJson(),
      'source': source.toEJson(),
      'taken_at': takenAt.toEJson(),
      'uploaded_at': uploadedAt.toEJson(),
      'exif': exif.toEJson(),
      'checksum_sha256': checksumSha256.toEJson(),
    };
  }

  static EJsonValue _toEJson(PhotoEntity value) => value.toEJson();
  static PhotoEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'photo_id': EJsonValue photoId,
        'image_url': EJsonValue imageUrl,
        'width': EJsonValue width,
        'height': EJsonValue height,
        'format': EJsonValue format,
        'source': EJsonValue source,
        'uploaded_at': EJsonValue uploadedAt,
      } =>
        PhotoEntity(
          fromEJson(photoId),
          fromEJson(imageUrl),
          fromEJson(width),
          fromEJson(height),
          fromEJson(format),
          fromEJson(source),
          fromEJson(uploadedAt),
          userId: fromEJson(ejson['user_id']),
          sizeBytes: fromEJson(ejson['size_bytes']),
          takenAt: fromEJson(ejson['taken_at']),
          exif: fromEJson(ejson['exif']),
          checksumSha256: fromEJson(ejson['checksum_sha256']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PhotoEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PhotoEntity, 'PhotoEntity', [
      SchemaProperty('photoId', RealmPropertyType.string,
          mapTo: 'photo_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string,
          mapTo: 'user_id', optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, mapTo: 'image_url'),
      SchemaProperty('width', RealmPropertyType.int),
      SchemaProperty('height', RealmPropertyType.int),
      SchemaProperty('format', RealmPropertyType.string),
      SchemaProperty('sizeBytes', RealmPropertyType.int,
          mapTo: 'size_bytes', optional: true),
      SchemaProperty('source', RealmPropertyType.string),
      SchemaProperty('takenAt', RealmPropertyType.timestamp,
          mapTo: 'taken_at', optional: true),
      SchemaProperty('uploadedAt', RealmPropertyType.timestamp,
          mapTo: 'uploaded_at'),
      SchemaProperty('exif', RealmPropertyType.string, optional: true),
      SchemaProperty('checksumSha256', RealmPropertyType.string,
          mapTo: 'checksum_sha256', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DetectionEntity extends _DetectionEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DetectionEntity(
    String detectionId,
    String photoId,
    String modelVersion,
    String resultJson,
    DateTime createdAt,
  ) {
    RealmObjectBase.set(this, 'detection_id', detectionId);
    RealmObjectBase.set(this, 'photo_id', photoId);
    RealmObjectBase.set(this, 'model_version', modelVersion);
    RealmObjectBase.set(this, 'result_json', resultJson);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  DetectionEntity._();

  @override
  String get detectionId =>
      RealmObjectBase.get<String>(this, 'detection_id') as String;
  @override
  set detectionId(String value) =>
      RealmObjectBase.set(this, 'detection_id', value);

  @override
  String get photoId => RealmObjectBase.get<String>(this, 'photo_id') as String;
  @override
  set photoId(String value) => RealmObjectBase.set(this, 'photo_id', value);

  @override
  String get modelVersion =>
      RealmObjectBase.get<String>(this, 'model_version') as String;
  @override
  set modelVersion(String value) =>
      RealmObjectBase.set(this, 'model_version', value);

  @override
  String get resultJson =>
      RealmObjectBase.get<String>(this, 'result_json') as String;
  @override
  set resultJson(String value) =>
      RealmObjectBase.set(this, 'result_json', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<DetectionEntity>> get changes =>
      RealmObjectBase.getChanges<DetectionEntity>(this);

  @override
  Stream<RealmObjectChanges<DetectionEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DetectionEntity>(this, keyPaths);

  @override
  DetectionEntity freeze() =>
      RealmObjectBase.freezeObject<DetectionEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'detection_id': detectionId.toEJson(),
      'photo_id': photoId.toEJson(),
      'model_version': modelVersion.toEJson(),
      'result_json': resultJson.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(DetectionEntity value) => value.toEJson();
  static DetectionEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'detection_id': EJsonValue detectionId,
        'photo_id': EJsonValue photoId,
        'model_version': EJsonValue modelVersion,
        'result_json': EJsonValue resultJson,
        'created_at': EJsonValue createdAt,
      } =>
        DetectionEntity(
          fromEJson(detectionId),
          fromEJson(photoId),
          fromEJson(modelVersion),
          fromEJson(resultJson),
          fromEJson(createdAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DetectionEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DetectionEntity, 'DetectionEntity', [
      SchemaProperty('detectionId', RealmPropertyType.string,
          mapTo: 'detection_id', primaryKey: true),
      SchemaProperty('photoId', RealmPropertyType.string, mapTo: 'photo_id'),
      SchemaProperty('modelVersion', RealmPropertyType.string,
          mapTo: 'model_version'),
      SchemaProperty('resultJson', RealmPropertyType.string,
          mapTo: 'result_json'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DetectionWordEntity extends _DetectionWordEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DetectionWordEntity(
    String id,
    String detectionId,
    String label,
    int confidence,
    bool selected,
    DateTime createdAt, {
    String? mappedWordId,
    String? bbox,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'detection_id', detectionId);
    RealmObjectBase.set(this, 'label', label);
    RealmObjectBase.set(this, 'confidence', confidence);
    RealmObjectBase.set(this, 'mapped_word_id', mappedWordId);
    RealmObjectBase.set(this, 'bbox', bbox);
    RealmObjectBase.set(this, 'selected', selected);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  DetectionWordEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get detectionId =>
      RealmObjectBase.get<String>(this, 'detection_id') as String;
  @override
  set detectionId(String value) =>
      RealmObjectBase.set(this, 'detection_id', value);

  @override
  String get label => RealmObjectBase.get<String>(this, 'label') as String;
  @override
  set label(String value) => RealmObjectBase.set(this, 'label', value);

  @override
  int get confidence => RealmObjectBase.get<int>(this, 'confidence') as int;
  @override
  set confidence(int value) => RealmObjectBase.set(this, 'confidence', value);

  @override
  String? get mappedWordId =>
      RealmObjectBase.get<String>(this, 'mapped_word_id') as String?;
  @override
  set mappedWordId(String? value) =>
      RealmObjectBase.set(this, 'mapped_word_id', value);

  @override
  String? get bbox => RealmObjectBase.get<String>(this, 'bbox') as String?;
  @override
  set bbox(String? value) => RealmObjectBase.set(this, 'bbox', value);

  @override
  bool get selected => RealmObjectBase.get<bool>(this, 'selected') as bool;
  @override
  set selected(bool value) => RealmObjectBase.set(this, 'selected', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<DetectionWordEntity>> get changes =>
      RealmObjectBase.getChanges<DetectionWordEntity>(this);

  @override
  Stream<RealmObjectChanges<DetectionWordEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DetectionWordEntity>(this, keyPaths);

  @override
  DetectionWordEntity freeze() =>
      RealmObjectBase.freezeObject<DetectionWordEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'detection_id': detectionId.toEJson(),
      'label': label.toEJson(),
      'confidence': confidence.toEJson(),
      'mapped_word_id': mappedWordId.toEJson(),
      'bbox': bbox.toEJson(),
      'selected': selected.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(DetectionWordEntity value) => value.toEJson();
  static DetectionWordEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'detection_id': EJsonValue detectionId,
        'label': EJsonValue label,
        'confidence': EJsonValue confidence,
        'selected': EJsonValue selected,
        'created_at': EJsonValue createdAt,
      } =>
        DetectionWordEntity(
          fromEJson(id),
          fromEJson(detectionId),
          fromEJson(label),
          fromEJson(confidence),
          fromEJson(selected),
          fromEJson(createdAt),
          mappedWordId: fromEJson(ejson['mapped_word_id']),
          bbox: fromEJson(ejson['bbox']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DetectionWordEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DetectionWordEntity, 'DetectionWordEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('detectionId', RealmPropertyType.string,
          mapTo: 'detection_id'),
      SchemaProperty('label', RealmPropertyType.string),
      SchemaProperty('confidence', RealmPropertyType.int),
      SchemaProperty('mappedWordId', RealmPropertyType.string,
          mapTo: 'mapped_word_id', optional: true),
      SchemaProperty('bbox', RealmPropertyType.string, optional: true),
      SchemaProperty('selected', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DictionaryWordEntity extends _DictionaryWordEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DictionaryWordEntity(
    String wordId,
    String headword,
    String normalizedHeadword,
    String meaningVi,
    String createdBy,
    DateTime createdAt, {
    String? ipa,
    String? pos,
    String? exampleEn,
    String? exampleVi,
    String? audioUrl,
    String? imageUrl,
  }) {
    RealmObjectBase.set(this, 'word_id', wordId);
    RealmObjectBase.set(this, 'headword', headword);
    RealmObjectBase.set(this, 'normalized_headword', normalizedHeadword);
    RealmObjectBase.set(this, 'ipa', ipa);
    RealmObjectBase.set(this, 'pos', pos);
    RealmObjectBase.set(this, 'meaning_vi', meaningVi);
    RealmObjectBase.set(this, 'example_en', exampleEn);
    RealmObjectBase.set(this, 'example_vi', exampleVi);
    RealmObjectBase.set(this, 'audio_url', audioUrl);
    RealmObjectBase.set(this, 'image_url', imageUrl);
    RealmObjectBase.set(this, 'created_by', createdBy);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  DictionaryWordEntity._();

  @override
  String get wordId => RealmObjectBase.get<String>(this, 'word_id') as String;
  @override
  set wordId(String value) => RealmObjectBase.set(this, 'word_id', value);

  @override
  String get headword =>
      RealmObjectBase.get<String>(this, 'headword') as String;
  @override
  set headword(String value) => RealmObjectBase.set(this, 'headword', value);

  @override
  String get normalizedHeadword =>
      RealmObjectBase.get<String>(this, 'normalized_headword') as String;
  @override
  set normalizedHeadword(String value) =>
      RealmObjectBase.set(this, 'normalized_headword', value);

  @override
  String? get ipa => RealmObjectBase.get<String>(this, 'ipa') as String?;
  @override
  set ipa(String? value) => RealmObjectBase.set(this, 'ipa', value);

  @override
  String? get pos => RealmObjectBase.get<String>(this, 'pos') as String?;
  @override
  set pos(String? value) => RealmObjectBase.set(this, 'pos', value);

  @override
  String get meaningVi =>
      RealmObjectBase.get<String>(this, 'meaning_vi') as String;
  @override
  set meaningVi(String value) => RealmObjectBase.set(this, 'meaning_vi', value);

  @override
  String? get exampleEn =>
      RealmObjectBase.get<String>(this, 'example_en') as String?;
  @override
  set exampleEn(String? value) =>
      RealmObjectBase.set(this, 'example_en', value);

  @override
  String? get exampleVi =>
      RealmObjectBase.get<String>(this, 'example_vi') as String?;
  @override
  set exampleVi(String? value) =>
      RealmObjectBase.set(this, 'example_vi', value);

  @override
  String? get audioUrl =>
      RealmObjectBase.get<String>(this, 'audio_url') as String?;
  @override
  set audioUrl(String? value) => RealmObjectBase.set(this, 'audio_url', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'image_url') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'image_url', value);

  @override
  String get createdBy =>
      RealmObjectBase.get<String>(this, 'created_by') as String;
  @override
  set createdBy(String value) => RealmObjectBase.set(this, 'created_by', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<DictionaryWordEntity>> get changes =>
      RealmObjectBase.getChanges<DictionaryWordEntity>(this);

  @override
  Stream<RealmObjectChanges<DictionaryWordEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DictionaryWordEntity>(this, keyPaths);

  @override
  DictionaryWordEntity freeze() =>
      RealmObjectBase.freezeObject<DictionaryWordEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'word_id': wordId.toEJson(),
      'headword': headword.toEJson(),
      'normalized_headword': normalizedHeadword.toEJson(),
      'ipa': ipa.toEJson(),
      'pos': pos.toEJson(),
      'meaning_vi': meaningVi.toEJson(),
      'example_en': exampleEn.toEJson(),
      'example_vi': exampleVi.toEJson(),
      'audio_url': audioUrl.toEJson(),
      'image_url': imageUrl.toEJson(),
      'created_by': createdBy.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(DictionaryWordEntity value) => value.toEJson();
  static DictionaryWordEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'word_id': EJsonValue wordId,
        'headword': EJsonValue headword,
        'normalized_headword': EJsonValue normalizedHeadword,
        'meaning_vi': EJsonValue meaningVi,
        'created_by': EJsonValue createdBy,
        'created_at': EJsonValue createdAt,
      } =>
        DictionaryWordEntity(
          fromEJson(wordId),
          fromEJson(headword),
          fromEJson(normalizedHeadword),
          fromEJson(meaningVi),
          fromEJson(createdBy),
          fromEJson(createdAt),
          ipa: fromEJson(ejson['ipa']),
          pos: fromEJson(ejson['pos']),
          exampleEn: fromEJson(ejson['example_en']),
          exampleVi: fromEJson(ejson['example_vi']),
          audioUrl: fromEJson(ejson['audio_url']),
          imageUrl: fromEJson(ejson['image_url']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DictionaryWordEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DictionaryWordEntity, 'DictionaryWordEntity', [
      SchemaProperty('wordId', RealmPropertyType.string,
          mapTo: 'word_id', primaryKey: true),
      SchemaProperty('headword', RealmPropertyType.string),
      SchemaProperty('normalizedHeadword', RealmPropertyType.string,
          mapTo: 'normalized_headword'),
      SchemaProperty('ipa', RealmPropertyType.string, optional: true),
      SchemaProperty('pos', RealmPropertyType.string, optional: true),
      SchemaProperty('meaningVi', RealmPropertyType.string,
          mapTo: 'meaning_vi'),
      SchemaProperty('exampleEn', RealmPropertyType.string,
          mapTo: 'example_en', optional: true),
      SchemaProperty('exampleVi', RealmPropertyType.string,
          mapTo: 'example_vi', optional: true),
      SchemaProperty('audioUrl', RealmPropertyType.string,
          mapTo: 'audio_url', optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string,
          mapTo: 'image_url', optional: true),
      SchemaProperty('createdBy', RealmPropertyType.string,
          mapTo: 'created_by'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PersonalWordEntity extends _PersonalWordEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PersonalWordEntity(
    String personalWordId,
    String userId,
    String status,
    String source,
    int srsStage,
    int srsEase,
    int srsIntervalDays,
    DateTime srsDueAt,
    int repetitions,
    int wrongStreak,
    int forgetCount,
    DateTime createdAt, {
    String? wordId,
    String? customHeadword,
    String? customIpa,
    String? customMeaningVi,
    String? sourcePhotoId,
    DateTime? lastReviewedAt,
  }) {
    RealmObjectBase.set(this, 'personal_word_id', personalWordId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'word_id', wordId);
    RealmObjectBase.set(this, 'custom_headword', customHeadword);
    RealmObjectBase.set(this, 'custom_ipa', customIpa);
    RealmObjectBase.set(this, 'custom_meaning_vi', customMeaningVi);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'source', source);
    RealmObjectBase.set(this, 'source_photo_id', sourcePhotoId);
    RealmObjectBase.set(this, 'srs_stage', srsStage);
    RealmObjectBase.set(this, 'srs_ease', srsEase);
    RealmObjectBase.set(this, 'srs_interval_days', srsIntervalDays);
    RealmObjectBase.set(this, 'srs_due_at', srsDueAt);
    RealmObjectBase.set(this, 'repetitions', repetitions);
    RealmObjectBase.set(this, 'wrong_streak', wrongStreak);
    RealmObjectBase.set(this, 'forget_count', forgetCount);
    RealmObjectBase.set(this, 'last_reviewed_at', lastReviewedAt);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  PersonalWordEntity._();

  @override
  String get personalWordId =>
      RealmObjectBase.get<String>(this, 'personal_word_id') as String;
  @override
  set personalWordId(String value) =>
      RealmObjectBase.set(this, 'personal_word_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String? get wordId => RealmObjectBase.get<String>(this, 'word_id') as String?;
  @override
  set wordId(String? value) => RealmObjectBase.set(this, 'word_id', value);

  @override
  String? get customHeadword =>
      RealmObjectBase.get<String>(this, 'custom_headword') as String?;
  @override
  set customHeadword(String? value) =>
      RealmObjectBase.set(this, 'custom_headword', value);

  @override
  String? get customIpa =>
      RealmObjectBase.get<String>(this, 'custom_ipa') as String?;
  @override
  set customIpa(String? value) =>
      RealmObjectBase.set(this, 'custom_ipa', value);

  @override
  String? get customMeaningVi =>
      RealmObjectBase.get<String>(this, 'custom_meaning_vi') as String?;
  @override
  set customMeaningVi(String? value) =>
      RealmObjectBase.set(this, 'custom_meaning_vi', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  String get source => RealmObjectBase.get<String>(this, 'source') as String;
  @override
  set source(String value) => RealmObjectBase.set(this, 'source', value);

  @override
  String? get sourcePhotoId =>
      RealmObjectBase.get<String>(this, 'source_photo_id') as String?;
  @override
  set sourcePhotoId(String? value) =>
      RealmObjectBase.set(this, 'source_photo_id', value);

  @override
  int get srsStage => RealmObjectBase.get<int>(this, 'srs_stage') as int;
  @override
  set srsStage(int value) => RealmObjectBase.set(this, 'srs_stage', value);

  @override
  int get srsEase => RealmObjectBase.get<int>(this, 'srs_ease') as int;
  @override
  set srsEase(int value) => RealmObjectBase.set(this, 'srs_ease', value);

  @override
  int get srsIntervalDays =>
      RealmObjectBase.get<int>(this, 'srs_interval_days') as int;
  @override
  set srsIntervalDays(int value) =>
      RealmObjectBase.set(this, 'srs_interval_days', value);

  @override
  DateTime get srsDueAt =>
      RealmObjectBase.get<DateTime>(this, 'srs_due_at') as DateTime;
  @override
  set srsDueAt(DateTime value) =>
      RealmObjectBase.set(this, 'srs_due_at', value);

  @override
  int get repetitions => RealmObjectBase.get<int>(this, 'repetitions') as int;
  @override
  set repetitions(int value) => RealmObjectBase.set(this, 'repetitions', value);

  @override
  int get wrongStreak => RealmObjectBase.get<int>(this, 'wrong_streak') as int;
  @override
  set wrongStreak(int value) =>
      RealmObjectBase.set(this, 'wrong_streak', value);

  @override
  int get forgetCount => RealmObjectBase.get<int>(this, 'forget_count') as int;
  @override
  set forgetCount(int value) =>
      RealmObjectBase.set(this, 'forget_count', value);

  @override
  DateTime? get lastReviewedAt =>
      RealmObjectBase.get<DateTime>(this, 'last_reviewed_at') as DateTime?;
  @override
  set lastReviewedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'last_reviewed_at', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<PersonalWordEntity>> get changes =>
      RealmObjectBase.getChanges<PersonalWordEntity>(this);

  @override
  Stream<RealmObjectChanges<PersonalWordEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PersonalWordEntity>(this, keyPaths);

  @override
  PersonalWordEntity freeze() =>
      RealmObjectBase.freezeObject<PersonalWordEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'personal_word_id': personalWordId.toEJson(),
      'user_id': userId.toEJson(),
      'word_id': wordId.toEJson(),
      'custom_headword': customHeadword.toEJson(),
      'custom_ipa': customIpa.toEJson(),
      'custom_meaning_vi': customMeaningVi.toEJson(),
      'status': status.toEJson(),
      'source': source.toEJson(),
      'source_photo_id': sourcePhotoId.toEJson(),
      'srs_stage': srsStage.toEJson(),
      'srs_ease': srsEase.toEJson(),
      'srs_interval_days': srsIntervalDays.toEJson(),
      'srs_due_at': srsDueAt.toEJson(),
      'repetitions': repetitions.toEJson(),
      'wrong_streak': wrongStreak.toEJson(),
      'forget_count': forgetCount.toEJson(),
      'last_reviewed_at': lastReviewedAt.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PersonalWordEntity value) => value.toEJson();
  static PersonalWordEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'personal_word_id': EJsonValue personalWordId,
        'user_id': EJsonValue userId,
        'status': EJsonValue status,
        'source': EJsonValue source,
        'srs_stage': EJsonValue srsStage,
        'srs_ease': EJsonValue srsEase,
        'srs_interval_days': EJsonValue srsIntervalDays,
        'srs_due_at': EJsonValue srsDueAt,
        'repetitions': EJsonValue repetitions,
        'wrong_streak': EJsonValue wrongStreak,
        'forget_count': EJsonValue forgetCount,
        'created_at': EJsonValue createdAt,
      } =>
        PersonalWordEntity(
          fromEJson(personalWordId),
          fromEJson(userId),
          fromEJson(status),
          fromEJson(source),
          fromEJson(srsStage),
          fromEJson(srsEase),
          fromEJson(srsIntervalDays),
          fromEJson(srsDueAt),
          fromEJson(repetitions),
          fromEJson(wrongStreak),
          fromEJson(forgetCount),
          fromEJson(createdAt),
          wordId: fromEJson(ejson['word_id']),
          customHeadword: fromEJson(ejson['custom_headword']),
          customIpa: fromEJson(ejson['custom_ipa']),
          customMeaningVi: fromEJson(ejson['custom_meaning_vi']),
          sourcePhotoId: fromEJson(ejson['source_photo_id']),
          lastReviewedAt: fromEJson(ejson['last_reviewed_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PersonalWordEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PersonalWordEntity, 'PersonalWordEntity', [
      SchemaProperty('personalWordId', RealmPropertyType.string,
          mapTo: 'personal_word_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('wordId', RealmPropertyType.string,
          mapTo: 'word_id', optional: true),
      SchemaProperty('customHeadword', RealmPropertyType.string,
          mapTo: 'custom_headword', optional: true),
      SchemaProperty('customIpa', RealmPropertyType.string,
          mapTo: 'custom_ipa', optional: true),
      SchemaProperty('customMeaningVi', RealmPropertyType.string,
          mapTo: 'custom_meaning_vi', optional: true),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('source', RealmPropertyType.string),
      SchemaProperty('sourcePhotoId', RealmPropertyType.string,
          mapTo: 'source_photo_id', optional: true),
      SchemaProperty('srsStage', RealmPropertyType.int, mapTo: 'srs_stage'),
      SchemaProperty('srsEase', RealmPropertyType.int, mapTo: 'srs_ease'),
      SchemaProperty('srsIntervalDays', RealmPropertyType.int,
          mapTo: 'srs_interval_days'),
      SchemaProperty('srsDueAt', RealmPropertyType.timestamp,
          mapTo: 'srs_due_at'),
      SchemaProperty('repetitions', RealmPropertyType.int),
      SchemaProperty('wrongStreak', RealmPropertyType.int,
          mapTo: 'wrong_streak'),
      SchemaProperty('forgetCount', RealmPropertyType.int,
          mapTo: 'forget_count'),
      SchemaProperty('lastReviewedAt', RealmPropertyType.timestamp,
          mapTo: 'last_reviewed_at', optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class TopicEntity extends _TopicEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  TopicEntity(
    String topicId,
    String name,
    String visibility,
    DateTime createdAt, {
    String? icon,
    String? ownerId,
  }) {
    RealmObjectBase.set(this, 'topic_id', topicId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'icon', icon);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'visibility', visibility);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  TopicEntity._();

  @override
  String get topicId => RealmObjectBase.get<String>(this, 'topic_id') as String;
  @override
  set topicId(String value) => RealmObjectBase.set(this, 'topic_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get icon => RealmObjectBase.get<String>(this, 'icon') as String?;
  @override
  set icon(String? value) => RealmObjectBase.set(this, 'icon', value);

  @override
  String? get ownerId =>
      RealmObjectBase.get<String>(this, 'owner_id') as String?;
  @override
  set ownerId(String? value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  String get visibility =>
      RealmObjectBase.get<String>(this, 'visibility') as String;
  @override
  set visibility(String value) =>
      RealmObjectBase.set(this, 'visibility', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<TopicEntity>> get changes =>
      RealmObjectBase.getChanges<TopicEntity>(this);

  @override
  Stream<RealmObjectChanges<TopicEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TopicEntity>(this, keyPaths);

  @override
  TopicEntity freeze() => RealmObjectBase.freezeObject<TopicEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'topic_id': topicId.toEJson(),
      'name': name.toEJson(),
      'icon': icon.toEJson(),
      'owner_id': ownerId.toEJson(),
      'visibility': visibility.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(TopicEntity value) => value.toEJson();
  static TopicEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'topic_id': EJsonValue topicId,
        'name': EJsonValue name,
        'visibility': EJsonValue visibility,
        'created_at': EJsonValue createdAt,
      } =>
        TopicEntity(
          fromEJson(topicId),
          fromEJson(name),
          fromEJson(visibility),
          fromEJson(createdAt),
          icon: fromEJson(ejson['icon']),
          ownerId: fromEJson(ejson['owner_id']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TopicEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, TopicEntity, 'TopicEntity', [
      SchemaProperty('topicId', RealmPropertyType.string,
          mapTo: 'topic_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('icon', RealmPropertyType.string, optional: true),
      SchemaProperty('ownerId', RealmPropertyType.string,
          mapTo: 'owner_id', optional: true),
      SchemaProperty('visibility', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PersonalWordTopicEntity extends _PersonalWordTopicEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PersonalWordTopicEntity(
    String id,
    String personalWordId,
    String topicId,
    bool isPrimary,
    DateTime createdAt,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'personal_word_id', personalWordId);
    RealmObjectBase.set(this, 'topic_id', topicId);
    RealmObjectBase.set(this, 'is_primary', isPrimary);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  PersonalWordTopicEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get personalWordId =>
      RealmObjectBase.get<String>(this, 'personal_word_id') as String;
  @override
  set personalWordId(String value) =>
      RealmObjectBase.set(this, 'personal_word_id', value);

  @override
  String get topicId => RealmObjectBase.get<String>(this, 'topic_id') as String;
  @override
  set topicId(String value) => RealmObjectBase.set(this, 'topic_id', value);

  @override
  bool get isPrimary => RealmObjectBase.get<bool>(this, 'is_primary') as bool;
  @override
  set isPrimary(bool value) => RealmObjectBase.set(this, 'is_primary', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<PersonalWordTopicEntity>> get changes =>
      RealmObjectBase.getChanges<PersonalWordTopicEntity>(this);

  @override
  Stream<RealmObjectChanges<PersonalWordTopicEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PersonalWordTopicEntity>(this, keyPaths);

  @override
  PersonalWordTopicEntity freeze() =>
      RealmObjectBase.freezeObject<PersonalWordTopicEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'personal_word_id': personalWordId.toEJson(),
      'topic_id': topicId.toEJson(),
      'is_primary': isPrimary.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PersonalWordTopicEntity value) => value.toEJson();
  static PersonalWordTopicEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'personal_word_id': EJsonValue personalWordId,
        'topic_id': EJsonValue topicId,
        'is_primary': EJsonValue isPrimary,
        'created_at': EJsonValue createdAt,
      } =>
        PersonalWordTopicEntity(
          fromEJson(id),
          fromEJson(personalWordId),
          fromEJson(topicId),
          fromEJson(isPrimary),
          fromEJson(createdAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PersonalWordTopicEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, PersonalWordTopicEntity,
        'PersonalWordTopicEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('personalWordId', RealmPropertyType.string,
          mapTo: 'personal_word_id'),
      SchemaProperty('topicId', RealmPropertyType.string, mapTo: 'topic_id'),
      SchemaProperty('isPrimary', RealmPropertyType.bool, mapTo: 'is_primary'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class WordMergeEntity extends _WordMergeEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  WordMergeEntity(
    String mergeId,
    String sourceWordId,
    String targetWordId,
    DateTime mergedAt, {
    String? reason,
  }) {
    RealmObjectBase.set(this, 'merge_id', mergeId);
    RealmObjectBase.set(this, 'source_word_id', sourceWordId);
    RealmObjectBase.set(this, 'target_word_id', targetWordId);
    RealmObjectBase.set(this, 'reason', reason);
    RealmObjectBase.set(this, 'merged_at', mergedAt);
  }

  WordMergeEntity._();

  @override
  String get mergeId => RealmObjectBase.get<String>(this, 'merge_id') as String;
  @override
  set mergeId(String value) => RealmObjectBase.set(this, 'merge_id', value);

  @override
  String get sourceWordId =>
      RealmObjectBase.get<String>(this, 'source_word_id') as String;
  @override
  set sourceWordId(String value) =>
      RealmObjectBase.set(this, 'source_word_id', value);

  @override
  String get targetWordId =>
      RealmObjectBase.get<String>(this, 'target_word_id') as String;
  @override
  set targetWordId(String value) =>
      RealmObjectBase.set(this, 'target_word_id', value);

  @override
  String? get reason => RealmObjectBase.get<String>(this, 'reason') as String?;
  @override
  set reason(String? value) => RealmObjectBase.set(this, 'reason', value);

  @override
  DateTime get mergedAt =>
      RealmObjectBase.get<DateTime>(this, 'merged_at') as DateTime;
  @override
  set mergedAt(DateTime value) => RealmObjectBase.set(this, 'merged_at', value);

  @override
  Stream<RealmObjectChanges<WordMergeEntity>> get changes =>
      RealmObjectBase.getChanges<WordMergeEntity>(this);

  @override
  Stream<RealmObjectChanges<WordMergeEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<WordMergeEntity>(this, keyPaths);

  @override
  WordMergeEntity freeze() =>
      RealmObjectBase.freezeObject<WordMergeEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'merge_id': mergeId.toEJson(),
      'source_word_id': sourceWordId.toEJson(),
      'target_word_id': targetWordId.toEJson(),
      'reason': reason.toEJson(),
      'merged_at': mergedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(WordMergeEntity value) => value.toEJson();
  static WordMergeEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'merge_id': EJsonValue mergeId,
        'source_word_id': EJsonValue sourceWordId,
        'target_word_id': EJsonValue targetWordId,
        'merged_at': EJsonValue mergedAt,
      } =>
        WordMergeEntity(
          fromEJson(mergeId),
          fromEJson(sourceWordId),
          fromEJson(targetWordId),
          fromEJson(mergedAt),
          reason: fromEJson(ejson['reason']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(WordMergeEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, WordMergeEntity, 'WordMergeEntity', [
      SchemaProperty('mergeId', RealmPropertyType.string,
          mapTo: 'merge_id', primaryKey: true),
      SchemaProperty('sourceWordId', RealmPropertyType.string,
          mapTo: 'source_word_id'),
      SchemaProperty('targetWordId', RealmPropertyType.string,
          mapTo: 'target_word_id'),
      SchemaProperty('reason', RealmPropertyType.string, optional: true),
      SchemaProperty('mergedAt', RealmPropertyType.timestamp,
          mapTo: 'merged_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class StudySessionEntity extends _StudySessionEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  StudySessionEntity(
    String sessionId,
    String userId,
    String type,
    int plannedCount,
    int completedCount,
    DateTime startedAt, {
    int? firstTryAccuracy,
    DateTime? endedAt,
  }) {
    RealmObjectBase.set(this, 'session_id', sessionId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'planned_count', plannedCount);
    RealmObjectBase.set(this, 'completed_count', completedCount);
    RealmObjectBase.set(this, 'first_try_accuracy', firstTryAccuracy);
    RealmObjectBase.set(this, 'started_at', startedAt);
    RealmObjectBase.set(this, 'ended_at', endedAt);
  }

  StudySessionEntity._();

  @override
  String get sessionId =>
      RealmObjectBase.get<String>(this, 'session_id') as String;
  @override
  set sessionId(String value) => RealmObjectBase.set(this, 'session_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  int get plannedCount =>
      RealmObjectBase.get<int>(this, 'planned_count') as int;
  @override
  set plannedCount(int value) =>
      RealmObjectBase.set(this, 'planned_count', value);

  @override
  int get completedCount =>
      RealmObjectBase.get<int>(this, 'completed_count') as int;
  @override
  set completedCount(int value) =>
      RealmObjectBase.set(this, 'completed_count', value);

  @override
  int? get firstTryAccuracy =>
      RealmObjectBase.get<int>(this, 'first_try_accuracy') as int?;
  @override
  set firstTryAccuracy(int? value) =>
      RealmObjectBase.set(this, 'first_try_accuracy', value);

  @override
  DateTime get startedAt =>
      RealmObjectBase.get<DateTime>(this, 'started_at') as DateTime;
  @override
  set startedAt(DateTime value) =>
      RealmObjectBase.set(this, 'started_at', value);

  @override
  DateTime? get endedAt =>
      RealmObjectBase.get<DateTime>(this, 'ended_at') as DateTime?;
  @override
  set endedAt(DateTime? value) => RealmObjectBase.set(this, 'ended_at', value);

  @override
  Stream<RealmObjectChanges<StudySessionEntity>> get changes =>
      RealmObjectBase.getChanges<StudySessionEntity>(this);

  @override
  Stream<RealmObjectChanges<StudySessionEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<StudySessionEntity>(this, keyPaths);

  @override
  StudySessionEntity freeze() =>
      RealmObjectBase.freezeObject<StudySessionEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'session_id': sessionId.toEJson(),
      'user_id': userId.toEJson(),
      'type': type.toEJson(),
      'planned_count': plannedCount.toEJson(),
      'completed_count': completedCount.toEJson(),
      'first_try_accuracy': firstTryAccuracy.toEJson(),
      'started_at': startedAt.toEJson(),
      'ended_at': endedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(StudySessionEntity value) => value.toEJson();
  static StudySessionEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'session_id': EJsonValue sessionId,
        'user_id': EJsonValue userId,
        'type': EJsonValue type,
        'planned_count': EJsonValue plannedCount,
        'completed_count': EJsonValue completedCount,
        'started_at': EJsonValue startedAt,
      } =>
        StudySessionEntity(
          fromEJson(sessionId),
          fromEJson(userId),
          fromEJson(type),
          fromEJson(plannedCount),
          fromEJson(completedCount),
          fromEJson(startedAt),
          firstTryAccuracy: fromEJson(ejson['first_try_accuracy']),
          endedAt: fromEJson(ejson['ended_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(StudySessionEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, StudySessionEntity, 'StudySessionEntity', [
      SchemaProperty('sessionId', RealmPropertyType.string,
          mapTo: 'session_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('plannedCount', RealmPropertyType.int,
          mapTo: 'planned_count'),
      SchemaProperty('completedCount', RealmPropertyType.int,
          mapTo: 'completed_count'),
      SchemaProperty('firstTryAccuracy', RealmPropertyType.int,
          mapTo: 'first_try_accuracy', optional: true),
      SchemaProperty('startedAt', RealmPropertyType.timestamp,
          mapTo: 'started_at'),
      SchemaProperty('endedAt', RealmPropertyType.timestamp,
          mapTo: 'ended_at', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class SessionItemEntity extends _SessionItemEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  SessionItemEntity(
    String itemId,
    String sessionId,
    String personalWordId,
    int round,
    String questionType,
    bool firstTryCorrect,
    int attemptsCount,
    DateTime createdAt, {
    int? score,
    String? payload,
  }) {
    RealmObjectBase.set(this, 'item_id', itemId);
    RealmObjectBase.set(this, 'session_id', sessionId);
    RealmObjectBase.set(this, 'personal_word_id', personalWordId);
    RealmObjectBase.set(this, 'round', round);
    RealmObjectBase.set(this, 'question_type', questionType);
    RealmObjectBase.set(this, 'first_try_correct', firstTryCorrect);
    RealmObjectBase.set(this, 'attempts_count', attemptsCount);
    RealmObjectBase.set(this, 'score', score);
    RealmObjectBase.set(this, 'payload', payload);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  SessionItemEntity._();

  @override
  String get itemId => RealmObjectBase.get<String>(this, 'item_id') as String;
  @override
  set itemId(String value) => RealmObjectBase.set(this, 'item_id', value);

  @override
  String get sessionId =>
      RealmObjectBase.get<String>(this, 'session_id') as String;
  @override
  set sessionId(String value) => RealmObjectBase.set(this, 'session_id', value);

  @override
  String get personalWordId =>
      RealmObjectBase.get<String>(this, 'personal_word_id') as String;
  @override
  set personalWordId(String value) =>
      RealmObjectBase.set(this, 'personal_word_id', value);

  @override
  int get round => RealmObjectBase.get<int>(this, 'round') as int;
  @override
  set round(int value) => RealmObjectBase.set(this, 'round', value);

  @override
  String get questionType =>
      RealmObjectBase.get<String>(this, 'question_type') as String;
  @override
  set questionType(String value) =>
      RealmObjectBase.set(this, 'question_type', value);

  @override
  bool get firstTryCorrect =>
      RealmObjectBase.get<bool>(this, 'first_try_correct') as bool;
  @override
  set firstTryCorrect(bool value) =>
      RealmObjectBase.set(this, 'first_try_correct', value);

  @override
  int get attemptsCount =>
      RealmObjectBase.get<int>(this, 'attempts_count') as int;
  @override
  set attemptsCount(int value) =>
      RealmObjectBase.set(this, 'attempts_count', value);

  @override
  int? get score => RealmObjectBase.get<int>(this, 'score') as int?;
  @override
  set score(int? value) => RealmObjectBase.set(this, 'score', value);

  @override
  String? get payload =>
      RealmObjectBase.get<String>(this, 'payload') as String?;
  @override
  set payload(String? value) => RealmObjectBase.set(this, 'payload', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<SessionItemEntity>> get changes =>
      RealmObjectBase.getChanges<SessionItemEntity>(this);

  @override
  Stream<RealmObjectChanges<SessionItemEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SessionItemEntity>(this, keyPaths);

  @override
  SessionItemEntity freeze() =>
      RealmObjectBase.freezeObject<SessionItemEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'item_id': itemId.toEJson(),
      'session_id': sessionId.toEJson(),
      'personal_word_id': personalWordId.toEJson(),
      'round': round.toEJson(),
      'question_type': questionType.toEJson(),
      'first_try_correct': firstTryCorrect.toEJson(),
      'attempts_count': attemptsCount.toEJson(),
      'score': score.toEJson(),
      'payload': payload.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(SessionItemEntity value) => value.toEJson();
  static SessionItemEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'item_id': EJsonValue itemId,
        'session_id': EJsonValue sessionId,
        'personal_word_id': EJsonValue personalWordId,
        'round': EJsonValue round,
        'question_type': EJsonValue questionType,
        'first_try_correct': EJsonValue firstTryCorrect,
        'attempts_count': EJsonValue attemptsCount,
        'created_at': EJsonValue createdAt,
      } =>
        SessionItemEntity(
          fromEJson(itemId),
          fromEJson(sessionId),
          fromEJson(personalWordId),
          fromEJson(round),
          fromEJson(questionType),
          fromEJson(firstTryCorrect),
          fromEJson(attemptsCount),
          fromEJson(createdAt),
          score: fromEJson(ejson['score']),
          payload: fromEJson(ejson['payload']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SessionItemEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, SessionItemEntity, 'SessionItemEntity', [
      SchemaProperty('itemId', RealmPropertyType.string,
          mapTo: 'item_id', primaryKey: true),
      SchemaProperty('sessionId', RealmPropertyType.string,
          mapTo: 'session_id'),
      SchemaProperty('personalWordId', RealmPropertyType.string,
          mapTo: 'personal_word_id'),
      SchemaProperty('round', RealmPropertyType.int),
      SchemaProperty('questionType', RealmPropertyType.string,
          mapTo: 'question_type'),
      SchemaProperty('firstTryCorrect', RealmPropertyType.bool,
          mapTo: 'first_try_correct'),
      SchemaProperty('attemptsCount', RealmPropertyType.int,
          mapTo: 'attempts_count'),
      SchemaProperty('score', RealmPropertyType.int, optional: true),
      SchemaProperty('payload', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DailyProgressEntity extends _DailyProgressEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DailyProgressEntity(
    String progressId,
    String userId,
    DateTime snapshotDate,
    int newTarget,
    int newLearned,
    int reviewDue,
    int reviewDone,
    int streak,
    int xpGained,
  ) {
    RealmObjectBase.set(this, 'progress_id', progressId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'date', snapshotDate);
    RealmObjectBase.set(this, 'new_target', newTarget);
    RealmObjectBase.set(this, 'new_learned', newLearned);
    RealmObjectBase.set(this, 'review_due', reviewDue);
    RealmObjectBase.set(this, 'review_done', reviewDone);
    RealmObjectBase.set(this, 'streak', streak);
    RealmObjectBase.set(this, 'xp_gained', xpGained);
  }

  DailyProgressEntity._();

  @override
  String get progressId =>
      RealmObjectBase.get<String>(this, 'progress_id') as String;
  @override
  set progressId(String value) =>
      RealmObjectBase.set(this, 'progress_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  DateTime get snapshotDate =>
      RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set snapshotDate(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  int get newTarget => RealmObjectBase.get<int>(this, 'new_target') as int;
  @override
  set newTarget(int value) => RealmObjectBase.set(this, 'new_target', value);

  @override
  int get newLearned => RealmObjectBase.get<int>(this, 'new_learned') as int;
  @override
  set newLearned(int value) => RealmObjectBase.set(this, 'new_learned', value);

  @override
  int get reviewDue => RealmObjectBase.get<int>(this, 'review_due') as int;
  @override
  set reviewDue(int value) => RealmObjectBase.set(this, 'review_due', value);

  @override
  int get reviewDone => RealmObjectBase.get<int>(this, 'review_done') as int;
  @override
  set reviewDone(int value) => RealmObjectBase.set(this, 'review_done', value);

  @override
  int get streak => RealmObjectBase.get<int>(this, 'streak') as int;
  @override
  set streak(int value) => RealmObjectBase.set(this, 'streak', value);

  @override
  int get xpGained => RealmObjectBase.get<int>(this, 'xp_gained') as int;
  @override
  set xpGained(int value) => RealmObjectBase.set(this, 'xp_gained', value);

  @override
  Stream<RealmObjectChanges<DailyProgressEntity>> get changes =>
      RealmObjectBase.getChanges<DailyProgressEntity>(this);

  @override
  Stream<RealmObjectChanges<DailyProgressEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DailyProgressEntity>(this, keyPaths);

  @override
  DailyProgressEntity freeze() =>
      RealmObjectBase.freezeObject<DailyProgressEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'progress_id': progressId.toEJson(),
      'user_id': userId.toEJson(),
      'date': snapshotDate.toEJson(),
      'new_target': newTarget.toEJson(),
      'new_learned': newLearned.toEJson(),
      'review_due': reviewDue.toEJson(),
      'review_done': reviewDone.toEJson(),
      'streak': streak.toEJson(),
      'xp_gained': xpGained.toEJson(),
    };
  }

  static EJsonValue _toEJson(DailyProgressEntity value) => value.toEJson();
  static DailyProgressEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'progress_id': EJsonValue progressId,
        'user_id': EJsonValue userId,
        'date': EJsonValue snapshotDate,
        'new_target': EJsonValue newTarget,
        'new_learned': EJsonValue newLearned,
        'review_due': EJsonValue reviewDue,
        'review_done': EJsonValue reviewDone,
        'streak': EJsonValue streak,
        'xp_gained': EJsonValue xpGained,
      } =>
        DailyProgressEntity(
          fromEJson(progressId),
          fromEJson(userId),
          fromEJson(snapshotDate),
          fromEJson(newTarget),
          fromEJson(newLearned),
          fromEJson(reviewDue),
          fromEJson(reviewDone),
          fromEJson(streak),
          fromEJson(xpGained),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DailyProgressEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DailyProgressEntity, 'DailyProgressEntity', [
      SchemaProperty('progressId', RealmPropertyType.string,
          mapTo: 'progress_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('snapshotDate', RealmPropertyType.timestamp,
          mapTo: 'date'),
      SchemaProperty('newTarget', RealmPropertyType.int, mapTo: 'new_target'),
      SchemaProperty('newLearned', RealmPropertyType.int, mapTo: 'new_learned'),
      SchemaProperty('reviewDue', RealmPropertyType.int, mapTo: 'review_due'),
      SchemaProperty('reviewDone', RealmPropertyType.int, mapTo: 'review_done'),
      SchemaProperty('streak', RealmPropertyType.int),
      SchemaProperty('xpGained', RealmPropertyType.int, mapTo: 'xp_gained'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserGoalEntity extends _UserGoalEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  UserGoalEntity(
    String userId,
    int dailyNewTarget,
    String tz,
    bool smartRemind, {
    String? remindMorning,
    String? remindEvening,
  }) {
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'daily_new_target', dailyNewTarget);
    RealmObjectBase.set(this, 'tz', tz);
    RealmObjectBase.set(this, 'remind_morning', remindMorning);
    RealmObjectBase.set(this, 'remind_evening', remindEvening);
    RealmObjectBase.set(this, 'smart_remind', smartRemind);
  }

  UserGoalEntity._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  int get dailyNewTarget =>
      RealmObjectBase.get<int>(this, 'daily_new_target') as int;
  @override
  set dailyNewTarget(int value) =>
      RealmObjectBase.set(this, 'daily_new_target', value);

  @override
  String get tz => RealmObjectBase.get<String>(this, 'tz') as String;
  @override
  set tz(String value) => RealmObjectBase.set(this, 'tz', value);

  @override
  String? get remindMorning =>
      RealmObjectBase.get<String>(this, 'remind_morning') as String?;
  @override
  set remindMorning(String? value) =>
      RealmObjectBase.set(this, 'remind_morning', value);

  @override
  String? get remindEvening =>
      RealmObjectBase.get<String>(this, 'remind_evening') as String?;
  @override
  set remindEvening(String? value) =>
      RealmObjectBase.set(this, 'remind_evening', value);

  @override
  bool get smartRemind =>
      RealmObjectBase.get<bool>(this, 'smart_remind') as bool;
  @override
  set smartRemind(bool value) =>
      RealmObjectBase.set(this, 'smart_remind', value);

  @override
  Stream<RealmObjectChanges<UserGoalEntity>> get changes =>
      RealmObjectBase.getChanges<UserGoalEntity>(this);

  @override
  Stream<RealmObjectChanges<UserGoalEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserGoalEntity>(this, keyPaths);

  @override
  UserGoalEntity freeze() => RealmObjectBase.freezeObject<UserGoalEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'user_id': userId.toEJson(),
      'daily_new_target': dailyNewTarget.toEJson(),
      'tz': tz.toEJson(),
      'remind_morning': remindMorning.toEJson(),
      'remind_evening': remindEvening.toEJson(),
      'smart_remind': smartRemind.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserGoalEntity value) => value.toEJson();
  static UserGoalEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'user_id': EJsonValue userId,
        'daily_new_target': EJsonValue dailyNewTarget,
        'tz': EJsonValue tz,
        'smart_remind': EJsonValue smartRemind,
      } =>
        UserGoalEntity(
          fromEJson(userId),
          fromEJson(dailyNewTarget),
          fromEJson(tz),
          fromEJson(smartRemind),
          remindMorning: fromEJson(ejson['remind_morning']),
          remindEvening: fromEJson(ejson['remind_evening']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserGoalEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserGoalEntity, 'UserGoalEntity', [
      SchemaProperty('userId', RealmPropertyType.string,
          mapTo: 'user_id', primaryKey: true),
      SchemaProperty('dailyNewTarget', RealmPropertyType.int,
          mapTo: 'daily_new_target'),
      SchemaProperty('tz', RealmPropertyType.string),
      SchemaProperty('remindMorning', RealmPropertyType.string,
          mapTo: 'remind_morning', optional: true),
      SchemaProperty('remindEvening', RealmPropertyType.string,
          mapTo: 'remind_evening', optional: true),
      SchemaProperty('smartRemind', RealmPropertyType.bool,
          mapTo: 'smart_remind'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PostEntity extends _PostEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PostEntity(
    String postId,
    String userId,
    String visibility,
    String status,
    DateTime createdAt, {
    String? photoUrl,
    String? caption,
  }) {
    RealmObjectBase.set(this, 'post_id', postId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'photo_url', photoUrl);
    RealmObjectBase.set(this, 'caption', caption);
    RealmObjectBase.set(this, 'visibility', visibility);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  PostEntity._();

  @override
  String get postId => RealmObjectBase.get<String>(this, 'post_id') as String;
  @override
  set postId(String value) => RealmObjectBase.set(this, 'post_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String? get photoUrl =>
      RealmObjectBase.get<String>(this, 'photo_url') as String?;
  @override
  set photoUrl(String? value) => RealmObjectBase.set(this, 'photo_url', value);

  @override
  String? get caption =>
      RealmObjectBase.get<String>(this, 'caption') as String?;
  @override
  set caption(String? value) => RealmObjectBase.set(this, 'caption', value);

  @override
  String get visibility =>
      RealmObjectBase.get<String>(this, 'visibility') as String;
  @override
  set visibility(String value) =>
      RealmObjectBase.set(this, 'visibility', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<PostEntity>> get changes =>
      RealmObjectBase.getChanges<PostEntity>(this);

  @override
  Stream<RealmObjectChanges<PostEntity>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PostEntity>(this, keyPaths);

  @override
  PostEntity freeze() => RealmObjectBase.freezeObject<PostEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'post_id': postId.toEJson(),
      'user_id': userId.toEJson(),
      'photo_url': photoUrl.toEJson(),
      'caption': caption.toEJson(),
      'visibility': visibility.toEJson(),
      'status': status.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PostEntity value) => value.toEJson();
  static PostEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'post_id': EJsonValue postId,
        'user_id': EJsonValue userId,
        'visibility': EJsonValue visibility,
        'status': EJsonValue status,
        'created_at': EJsonValue createdAt,
      } =>
        PostEntity(
          fromEJson(postId),
          fromEJson(userId),
          fromEJson(visibility),
          fromEJson(status),
          fromEJson(createdAt),
          photoUrl: fromEJson(ejson['photo_url']),
          caption: fromEJson(ejson['caption']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PostEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PostEntity, 'PostEntity', [
      SchemaProperty('postId', RealmPropertyType.string,
          mapTo: 'post_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('photoUrl', RealmPropertyType.string,
          mapTo: 'photo_url', optional: true),
      SchemaProperty('caption', RealmPropertyType.string, optional: true),
      SchemaProperty('visibility', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PostWordEntity extends _PostWordEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PostWordEntity(
    String id,
    String postId,
    String meaningSnapshot, {
    String? wordId,
    String? exampleSnapshot,
    String? audioUrlSnapshot,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'post_id', postId);
    RealmObjectBase.set(this, 'word_id', wordId);
    RealmObjectBase.set(this, 'meaning_snapshot', meaningSnapshot);
    RealmObjectBase.set(this, 'example_snapshot', exampleSnapshot);
    RealmObjectBase.set(this, 'audio_url_snapshot', audioUrlSnapshot);
  }

  PostWordEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get postId => RealmObjectBase.get<String>(this, 'post_id') as String;
  @override
  set postId(String value) => RealmObjectBase.set(this, 'post_id', value);

  @override
  String? get wordId => RealmObjectBase.get<String>(this, 'word_id') as String?;
  @override
  set wordId(String? value) => RealmObjectBase.set(this, 'word_id', value);

  @override
  String get meaningSnapshot =>
      RealmObjectBase.get<String>(this, 'meaning_snapshot') as String;
  @override
  set meaningSnapshot(String value) =>
      RealmObjectBase.set(this, 'meaning_snapshot', value);

  @override
  String? get exampleSnapshot =>
      RealmObjectBase.get<String>(this, 'example_snapshot') as String?;
  @override
  set exampleSnapshot(String? value) =>
      RealmObjectBase.set(this, 'example_snapshot', value);

  @override
  String? get audioUrlSnapshot =>
      RealmObjectBase.get<String>(this, 'audio_url_snapshot') as String?;
  @override
  set audioUrlSnapshot(String? value) =>
      RealmObjectBase.set(this, 'audio_url_snapshot', value);

  @override
  Stream<RealmObjectChanges<PostWordEntity>> get changes =>
      RealmObjectBase.getChanges<PostWordEntity>(this);

  @override
  Stream<RealmObjectChanges<PostWordEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PostWordEntity>(this, keyPaths);

  @override
  PostWordEntity freeze() => RealmObjectBase.freezeObject<PostWordEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'post_id': postId.toEJson(),
      'word_id': wordId.toEJson(),
      'meaning_snapshot': meaningSnapshot.toEJson(),
      'example_snapshot': exampleSnapshot.toEJson(),
      'audio_url_snapshot': audioUrlSnapshot.toEJson(),
    };
  }

  static EJsonValue _toEJson(PostWordEntity value) => value.toEJson();
  static PostWordEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'post_id': EJsonValue postId,
        'meaning_snapshot': EJsonValue meaningSnapshot,
      } =>
        PostWordEntity(
          fromEJson(id),
          fromEJson(postId),
          fromEJson(meaningSnapshot),
          wordId: fromEJson(ejson['word_id']),
          exampleSnapshot: fromEJson(ejson['example_snapshot']),
          audioUrlSnapshot: fromEJson(ejson['audio_url_snapshot']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PostWordEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PostWordEntity, 'PostWordEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('postId', RealmPropertyType.string, mapTo: 'post_id'),
      SchemaProperty('wordId', RealmPropertyType.string,
          mapTo: 'word_id', optional: true),
      SchemaProperty('meaningSnapshot', RealmPropertyType.string,
          mapTo: 'meaning_snapshot'),
      SchemaProperty('exampleSnapshot', RealmPropertyType.string,
          mapTo: 'example_snapshot', optional: true),
      SchemaProperty('audioUrlSnapshot', RealmPropertyType.string,
          mapTo: 'audio_url_snapshot', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PostLikeEntity extends _PostLikeEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PostLikeEntity(
    String id,
    String postId,
    String userId,
    DateTime createdAt,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'post_id', postId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  PostLikeEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get postId => RealmObjectBase.get<String>(this, 'post_id') as String;
  @override
  set postId(String value) => RealmObjectBase.set(this, 'post_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<PostLikeEntity>> get changes =>
      RealmObjectBase.getChanges<PostLikeEntity>(this);

  @override
  Stream<RealmObjectChanges<PostLikeEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PostLikeEntity>(this, keyPaths);

  @override
  PostLikeEntity freeze() => RealmObjectBase.freezeObject<PostLikeEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'post_id': postId.toEJson(),
      'user_id': userId.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PostLikeEntity value) => value.toEJson();
  static PostLikeEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'post_id': EJsonValue postId,
        'user_id': EJsonValue userId,
        'created_at': EJsonValue createdAt,
      } =>
        PostLikeEntity(
          fromEJson(id),
          fromEJson(postId),
          fromEJson(userId),
          fromEJson(createdAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PostLikeEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PostLikeEntity, 'PostLikeEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('postId', RealmPropertyType.string, mapTo: 'post_id'),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PostCommentEntity extends _PostCommentEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PostCommentEntity(
    String commentId,
    String postId,
    String userId,
    String commentType,
    String status,
    DateTime createdAt, {
    String? content,
    String? badgeId,
  }) {
    RealmObjectBase.set(this, 'comment_id', commentId);
    RealmObjectBase.set(this, 'post_id', postId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'comment_type', commentType);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'badge_id', badgeId);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  PostCommentEntity._();

  @override
  String get commentId =>
      RealmObjectBase.get<String>(this, 'comment_id') as String;
  @override
  set commentId(String value) => RealmObjectBase.set(this, 'comment_id', value);

  @override
  String get postId => RealmObjectBase.get<String>(this, 'post_id') as String;
  @override
  set postId(String value) => RealmObjectBase.set(this, 'post_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get commentType =>
      RealmObjectBase.get<String>(this, 'comment_type') as String;
  @override
  set commentType(String value) =>
      RealmObjectBase.set(this, 'comment_type', value);

  @override
  String? get content =>
      RealmObjectBase.get<String>(this, 'content') as String?;
  @override
  set content(String? value) => RealmObjectBase.set(this, 'content', value);

  @override
  String? get badgeId =>
      RealmObjectBase.get<String>(this, 'badge_id') as String?;
  @override
  set badgeId(String? value) => RealmObjectBase.set(this, 'badge_id', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<PostCommentEntity>> get changes =>
      RealmObjectBase.getChanges<PostCommentEntity>(this);

  @override
  Stream<RealmObjectChanges<PostCommentEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PostCommentEntity>(this, keyPaths);

  @override
  PostCommentEntity freeze() =>
      RealmObjectBase.freezeObject<PostCommentEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'comment_id': commentId.toEJson(),
      'post_id': postId.toEJson(),
      'user_id': userId.toEJson(),
      'comment_type': commentType.toEJson(),
      'content': content.toEJson(),
      'badge_id': badgeId.toEJson(),
      'status': status.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PostCommentEntity value) => value.toEJson();
  static PostCommentEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'comment_id': EJsonValue commentId,
        'post_id': EJsonValue postId,
        'user_id': EJsonValue userId,
        'comment_type': EJsonValue commentType,
        'status': EJsonValue status,
        'created_at': EJsonValue createdAt,
      } =>
        PostCommentEntity(
          fromEJson(commentId),
          fromEJson(postId),
          fromEJson(userId),
          fromEJson(commentType),
          fromEJson(status),
          fromEJson(createdAt),
          content: fromEJson(ejson['content']),
          badgeId: fromEJson(ejson['badge_id']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PostCommentEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PostCommentEntity, 'PostCommentEntity', [
      SchemaProperty('commentId', RealmPropertyType.string,
          mapTo: 'comment_id', primaryKey: true),
      SchemaProperty('postId', RealmPropertyType.string, mapTo: 'post_id'),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('commentType', RealmPropertyType.string,
          mapTo: 'comment_type'),
      SchemaProperty('content', RealmPropertyType.string, optional: true),
      SchemaProperty('badgeId', RealmPropertyType.string,
          mapTo: 'badge_id', optional: true),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PostReportEntity extends _PostReportEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PostReportEntity(
    String reportId,
    String postId,
    String reporterId,
    String reason,
    String status,
    DateTime createdAt, {
    String? details,
    String? handledBy,
    DateTime? handledAt,
  }) {
    RealmObjectBase.set(this, 'report_id', reportId);
    RealmObjectBase.set(this, 'post_id', postId);
    RealmObjectBase.set(this, 'reporter_id', reporterId);
    RealmObjectBase.set(this, 'reason', reason);
    RealmObjectBase.set(this, 'details', details);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'handled_by', handledBy);
    RealmObjectBase.set(this, 'handled_at', handledAt);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  PostReportEntity._();

  @override
  String get reportId =>
      RealmObjectBase.get<String>(this, 'report_id') as String;
  @override
  set reportId(String value) => RealmObjectBase.set(this, 'report_id', value);

  @override
  String get postId => RealmObjectBase.get<String>(this, 'post_id') as String;
  @override
  set postId(String value) => RealmObjectBase.set(this, 'post_id', value);

  @override
  String get reporterId =>
      RealmObjectBase.get<String>(this, 'reporter_id') as String;
  @override
  set reporterId(String value) =>
      RealmObjectBase.set(this, 'reporter_id', value);

  @override
  String get reason => RealmObjectBase.get<String>(this, 'reason') as String;
  @override
  set reason(String value) => RealmObjectBase.set(this, 'reason', value);

  @override
  String? get details =>
      RealmObjectBase.get<String>(this, 'details') as String?;
  @override
  set details(String? value) => RealmObjectBase.set(this, 'details', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  String? get handledBy =>
      RealmObjectBase.get<String>(this, 'handled_by') as String?;
  @override
  set handledBy(String? value) =>
      RealmObjectBase.set(this, 'handled_by', value);

  @override
  DateTime? get handledAt =>
      RealmObjectBase.get<DateTime>(this, 'handled_at') as DateTime?;
  @override
  set handledAt(DateTime? value) =>
      RealmObjectBase.set(this, 'handled_at', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<PostReportEntity>> get changes =>
      RealmObjectBase.getChanges<PostReportEntity>(this);

  @override
  Stream<RealmObjectChanges<PostReportEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PostReportEntity>(this, keyPaths);

  @override
  PostReportEntity freeze() =>
      RealmObjectBase.freezeObject<PostReportEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'report_id': reportId.toEJson(),
      'post_id': postId.toEJson(),
      'reporter_id': reporterId.toEJson(),
      'reason': reason.toEJson(),
      'details': details.toEJson(),
      'status': status.toEJson(),
      'handled_by': handledBy.toEJson(),
      'handled_at': handledAt.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PostReportEntity value) => value.toEJson();
  static PostReportEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'report_id': EJsonValue reportId,
        'post_id': EJsonValue postId,
        'reporter_id': EJsonValue reporterId,
        'reason': EJsonValue reason,
        'status': EJsonValue status,
        'created_at': EJsonValue createdAt,
      } =>
        PostReportEntity(
          fromEJson(reportId),
          fromEJson(postId),
          fromEJson(reporterId),
          fromEJson(reason),
          fromEJson(status),
          fromEJson(createdAt),
          details: fromEJson(ejson['details']),
          handledBy: fromEJson(ejson['handled_by']),
          handledAt: fromEJson(ejson['handled_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PostReportEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PostReportEntity, 'PostReportEntity', [
      SchemaProperty('reportId', RealmPropertyType.string,
          mapTo: 'report_id', primaryKey: true),
      SchemaProperty('postId', RealmPropertyType.string, mapTo: 'post_id'),
      SchemaProperty('reporterId', RealmPropertyType.string,
          mapTo: 'reporter_id'),
      SchemaProperty('reason', RealmPropertyType.string),
      SchemaProperty('details', RealmPropertyType.string, optional: true),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('handledBy', RealmPropertyType.string,
          mapTo: 'handled_by', optional: true),
      SchemaProperty('handledAt', RealmPropertyType.timestamp,
          mapTo: 'handled_at', optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class GroupEntity extends _GroupEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  GroupEntity(
    String groupId,
    String name,
    bool requireApproval,
    String createdBy,
    String status,
    DateTime createdAt, {
    String? description,
  }) {
    RealmObjectBase.set(this, 'group_id', groupId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'require_approval', requireApproval);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'created_by', createdBy);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  GroupEntity._();

  @override
  String get groupId => RealmObjectBase.get<String>(this, 'group_id') as String;
  @override
  set groupId(String value) => RealmObjectBase.set(this, 'group_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  bool get requireApproval =>
      RealmObjectBase.get<bool>(this, 'require_approval') as bool;
  @override
  set requireApproval(bool value) =>
      RealmObjectBase.set(this, 'require_approval', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get createdBy =>
      RealmObjectBase.get<String>(this, 'created_by') as String;
  @override
  set createdBy(String value) => RealmObjectBase.set(this, 'created_by', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<GroupEntity>> get changes =>
      RealmObjectBase.getChanges<GroupEntity>(this);

  @override
  Stream<RealmObjectChanges<GroupEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<GroupEntity>(this, keyPaths);

  @override
  GroupEntity freeze() => RealmObjectBase.freezeObject<GroupEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'group_id': groupId.toEJson(),
      'name': name.toEJson(),
      'require_approval': requireApproval.toEJson(),
      'description': description.toEJson(),
      'created_by': createdBy.toEJson(),
      'status': status.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GroupEntity value) => value.toEJson();
  static GroupEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'group_id': EJsonValue groupId,
        'name': EJsonValue name,
        'require_approval': EJsonValue requireApproval,
        'created_by': EJsonValue createdBy,
        'status': EJsonValue status,
        'created_at': EJsonValue createdAt,
      } =>
        GroupEntity(
          fromEJson(groupId),
          fromEJson(name),
          fromEJson(requireApproval),
          fromEJson(createdBy),
          fromEJson(status),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GroupEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, GroupEntity, 'GroupEntity', [
      SchemaProperty('groupId', RealmPropertyType.string,
          mapTo: 'group_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('requireApproval', RealmPropertyType.bool,
          mapTo: 'require_approval'),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('createdBy', RealmPropertyType.string,
          mapTo: 'created_by'),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class GroupMemberEntity extends _GroupMemberEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  GroupMemberEntity(
    String id,
    String groupId,
    String userId,
    String role,
    String status,
    DateTime joinedAt,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'group_id', groupId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'joined_at', joinedAt);
  }

  GroupMemberEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get groupId => RealmObjectBase.get<String>(this, 'group_id') as String;
  @override
  set groupId(String value) => RealmObjectBase.set(this, 'group_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get role => RealmObjectBase.get<String>(this, 'role') as String;
  @override
  set role(String value) => RealmObjectBase.set(this, 'role', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get joinedAt =>
      RealmObjectBase.get<DateTime>(this, 'joined_at') as DateTime;
  @override
  set joinedAt(DateTime value) => RealmObjectBase.set(this, 'joined_at', value);

  @override
  Stream<RealmObjectChanges<GroupMemberEntity>> get changes =>
      RealmObjectBase.getChanges<GroupMemberEntity>(this);

  @override
  Stream<RealmObjectChanges<GroupMemberEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<GroupMemberEntity>(this, keyPaths);

  @override
  GroupMemberEntity freeze() =>
      RealmObjectBase.freezeObject<GroupMemberEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'group_id': groupId.toEJson(),
      'user_id': userId.toEJson(),
      'role': role.toEJson(),
      'status': status.toEJson(),
      'joined_at': joinedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GroupMemberEntity value) => value.toEJson();
  static GroupMemberEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'group_id': EJsonValue groupId,
        'user_id': EJsonValue userId,
        'role': EJsonValue role,
        'status': EJsonValue status,
        'joined_at': EJsonValue joinedAt,
      } =>
        GroupMemberEntity(
          fromEJson(id),
          fromEJson(groupId),
          fromEJson(userId),
          fromEJson(role),
          fromEJson(status),
          fromEJson(joinedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GroupMemberEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, GroupMemberEntity, 'GroupMemberEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('groupId', RealmPropertyType.string, mapTo: 'group_id'),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('joinedAt', RealmPropertyType.timestamp,
          mapTo: 'joined_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class GroupMessageEntity extends _GroupMessageEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  GroupMessageEntity(
    String messageId,
    String groupId,
    String userId,
    String messageType,
    DateTime createdAt, {
    String? content,
    String? badgeId,
  }) {
    RealmObjectBase.set(this, 'message_id', messageId);
    RealmObjectBase.set(this, 'group_id', groupId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'message_type', messageType);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'badge_id', badgeId);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  GroupMessageEntity._();

  @override
  String get messageId =>
      RealmObjectBase.get<String>(this, 'message_id') as String;
  @override
  set messageId(String value) => RealmObjectBase.set(this, 'message_id', value);

  @override
  String get groupId => RealmObjectBase.get<String>(this, 'group_id') as String;
  @override
  set groupId(String value) => RealmObjectBase.set(this, 'group_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get messageType =>
      RealmObjectBase.get<String>(this, 'message_type') as String;
  @override
  set messageType(String value) =>
      RealmObjectBase.set(this, 'message_type', value);

  @override
  String? get content =>
      RealmObjectBase.get<String>(this, 'content') as String?;
  @override
  set content(String? value) => RealmObjectBase.set(this, 'content', value);

  @override
  String? get badgeId =>
      RealmObjectBase.get<String>(this, 'badge_id') as String?;
  @override
  set badgeId(String? value) => RealmObjectBase.set(this, 'badge_id', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<GroupMessageEntity>> get changes =>
      RealmObjectBase.getChanges<GroupMessageEntity>(this);

  @override
  Stream<RealmObjectChanges<GroupMessageEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<GroupMessageEntity>(this, keyPaths);

  @override
  GroupMessageEntity freeze() =>
      RealmObjectBase.freezeObject<GroupMessageEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'message_id': messageId.toEJson(),
      'group_id': groupId.toEJson(),
      'user_id': userId.toEJson(),
      'message_type': messageType.toEJson(),
      'content': content.toEJson(),
      'badge_id': badgeId.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(GroupMessageEntity value) => value.toEJson();
  static GroupMessageEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'message_id': EJsonValue messageId,
        'group_id': EJsonValue groupId,
        'user_id': EJsonValue userId,
        'message_type': EJsonValue messageType,
        'created_at': EJsonValue createdAt,
      } =>
        GroupMessageEntity(
          fromEJson(messageId),
          fromEJson(groupId),
          fromEJson(userId),
          fromEJson(messageType),
          fromEJson(createdAt),
          content: fromEJson(ejson['content']),
          badgeId: fromEJson(ejson['badge_id']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(GroupMessageEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, GroupMessageEntity, 'GroupMessageEntity', [
      SchemaProperty('messageId', RealmPropertyType.string,
          mapTo: 'message_id', primaryKey: true),
      SchemaProperty('groupId', RealmPropertyType.string, mapTo: 'group_id'),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('messageType', RealmPropertyType.string,
          mapTo: 'message_type'),
      SchemaProperty('content', RealmPropertyType.string, optional: true),
      SchemaProperty('badgeId', RealmPropertyType.string,
          mapTo: 'badge_id', optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class LeagueTierEntity extends _LeagueTierEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  LeagueTierEntity(
    String tierId,
    String name,
    int orderIndex, {
    String? xpCapRule,
  }) {
    RealmObjectBase.set(this, 'tier_id', tierId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'order_index', orderIndex);
    RealmObjectBase.set(this, 'xp_cap_rule', xpCapRule);
  }

  LeagueTierEntity._();

  @override
  String get tierId => RealmObjectBase.get<String>(this, 'tier_id') as String;
  @override
  set tierId(String value) => RealmObjectBase.set(this, 'tier_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get orderIndex => RealmObjectBase.get<int>(this, 'order_index') as int;
  @override
  set orderIndex(int value) => RealmObjectBase.set(this, 'order_index', value);

  @override
  String? get xpCapRule =>
      RealmObjectBase.get<String>(this, 'xp_cap_rule') as String?;
  @override
  set xpCapRule(String? value) =>
      RealmObjectBase.set(this, 'xp_cap_rule', value);

  @override
  Stream<RealmObjectChanges<LeagueTierEntity>> get changes =>
      RealmObjectBase.getChanges<LeagueTierEntity>(this);

  @override
  Stream<RealmObjectChanges<LeagueTierEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LeagueTierEntity>(this, keyPaths);

  @override
  LeagueTierEntity freeze() =>
      RealmObjectBase.freezeObject<LeagueTierEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'tier_id': tierId.toEJson(),
      'name': name.toEJson(),
      'order_index': orderIndex.toEJson(),
      'xp_cap_rule': xpCapRule.toEJson(),
    };
  }

  static EJsonValue _toEJson(LeagueTierEntity value) => value.toEJson();
  static LeagueTierEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'tier_id': EJsonValue tierId,
        'name': EJsonValue name,
        'order_index': EJsonValue orderIndex,
      } =>
        LeagueTierEntity(
          fromEJson(tierId),
          fromEJson(name),
          fromEJson(orderIndex),
          xpCapRule: fromEJson(ejson['xp_cap_rule']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LeagueTierEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, LeagueTierEntity, 'LeagueTierEntity', [
      SchemaProperty('tierId', RealmPropertyType.string,
          mapTo: 'tier_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('orderIndex', RealmPropertyType.int, mapTo: 'order_index'),
      SchemaProperty('xpCapRule', RealmPropertyType.string,
          mapTo: 'xp_cap_rule', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class LeagueCycleEntity extends _LeagueCycleEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  LeagueCycleEntity(
    String cycleId,
    String tierId,
    DateTime startAt,
    DateTime endAt,
    String status,
  ) {
    RealmObjectBase.set(this, 'cycle_id', cycleId);
    RealmObjectBase.set(this, 'tier_id', tierId);
    RealmObjectBase.set(this, 'start_at', startAt);
    RealmObjectBase.set(this, 'end_at', endAt);
    RealmObjectBase.set(this, 'status', status);
  }

  LeagueCycleEntity._();

  @override
  String get cycleId => RealmObjectBase.get<String>(this, 'cycle_id') as String;
  @override
  set cycleId(String value) => RealmObjectBase.set(this, 'cycle_id', value);

  @override
  String get tierId => RealmObjectBase.get<String>(this, 'tier_id') as String;
  @override
  set tierId(String value) => RealmObjectBase.set(this, 'tier_id', value);

  @override
  DateTime get startAt =>
      RealmObjectBase.get<DateTime>(this, 'start_at') as DateTime;
  @override
  set startAt(DateTime value) => RealmObjectBase.set(this, 'start_at', value);

  @override
  DateTime get endAt =>
      RealmObjectBase.get<DateTime>(this, 'end_at') as DateTime;
  @override
  set endAt(DateTime value) => RealmObjectBase.set(this, 'end_at', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  Stream<RealmObjectChanges<LeagueCycleEntity>> get changes =>
      RealmObjectBase.getChanges<LeagueCycleEntity>(this);

  @override
  Stream<RealmObjectChanges<LeagueCycleEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LeagueCycleEntity>(this, keyPaths);

  @override
  LeagueCycleEntity freeze() =>
      RealmObjectBase.freezeObject<LeagueCycleEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'cycle_id': cycleId.toEJson(),
      'tier_id': tierId.toEJson(),
      'start_at': startAt.toEJson(),
      'end_at': endAt.toEJson(),
      'status': status.toEJson(),
    };
  }

  static EJsonValue _toEJson(LeagueCycleEntity value) => value.toEJson();
  static LeagueCycleEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'cycle_id': EJsonValue cycleId,
        'tier_id': EJsonValue tierId,
        'start_at': EJsonValue startAt,
        'end_at': EJsonValue endAt,
        'status': EJsonValue status,
      } =>
        LeagueCycleEntity(
          fromEJson(cycleId),
          fromEJson(tierId),
          fromEJson(startAt),
          fromEJson(endAt),
          fromEJson(status),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LeagueCycleEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, LeagueCycleEntity, 'LeagueCycleEntity', [
      SchemaProperty('cycleId', RealmPropertyType.string,
          mapTo: 'cycle_id', primaryKey: true),
      SchemaProperty('tierId', RealmPropertyType.string, mapTo: 'tier_id'),
      SchemaProperty('startAt', RealmPropertyType.timestamp, mapTo: 'start_at'),
      SchemaProperty('endAt', RealmPropertyType.timestamp, mapTo: 'end_at'),
      SchemaProperty('status', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class LeagueMemberEntity extends _LeagueMemberEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  LeagueMemberEntity(
    String id,
    String cycleId,
    String userId,
    int weeklyXp,
    bool promoted,
    bool demoted, {
    int? rank,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'cycle_id', cycleId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'weekly_xp', weeklyXp);
    RealmObjectBase.set(this, 'rank', rank);
    RealmObjectBase.set(this, 'promoted', promoted);
    RealmObjectBase.set(this, 'demoted', demoted);
  }

  LeagueMemberEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get cycleId => RealmObjectBase.get<String>(this, 'cycle_id') as String;
  @override
  set cycleId(String value) => RealmObjectBase.set(this, 'cycle_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  int get weeklyXp => RealmObjectBase.get<int>(this, 'weekly_xp') as int;
  @override
  set weeklyXp(int value) => RealmObjectBase.set(this, 'weekly_xp', value);

  @override
  int? get rank => RealmObjectBase.get<int>(this, 'rank') as int?;
  @override
  set rank(int? value) => RealmObjectBase.set(this, 'rank', value);

  @override
  bool get promoted => RealmObjectBase.get<bool>(this, 'promoted') as bool;
  @override
  set promoted(bool value) => RealmObjectBase.set(this, 'promoted', value);

  @override
  bool get demoted => RealmObjectBase.get<bool>(this, 'demoted') as bool;
  @override
  set demoted(bool value) => RealmObjectBase.set(this, 'demoted', value);

  @override
  Stream<RealmObjectChanges<LeagueMemberEntity>> get changes =>
      RealmObjectBase.getChanges<LeagueMemberEntity>(this);

  @override
  Stream<RealmObjectChanges<LeagueMemberEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LeagueMemberEntity>(this, keyPaths);

  @override
  LeagueMemberEntity freeze() =>
      RealmObjectBase.freezeObject<LeagueMemberEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'cycle_id': cycleId.toEJson(),
      'user_id': userId.toEJson(),
      'weekly_xp': weeklyXp.toEJson(),
      'rank': rank.toEJson(),
      'promoted': promoted.toEJson(),
      'demoted': demoted.toEJson(),
    };
  }

  static EJsonValue _toEJson(LeagueMemberEntity value) => value.toEJson();
  static LeagueMemberEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'cycle_id': EJsonValue cycleId,
        'user_id': EJsonValue userId,
        'weekly_xp': EJsonValue weeklyXp,
        'promoted': EJsonValue promoted,
        'demoted': EJsonValue demoted,
      } =>
        LeagueMemberEntity(
          fromEJson(id),
          fromEJson(cycleId),
          fromEJson(userId),
          fromEJson(weeklyXp),
          fromEJson(promoted),
          fromEJson(demoted),
          rank: fromEJson(ejson['rank']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LeagueMemberEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, LeagueMemberEntity, 'LeagueMemberEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('cycleId', RealmPropertyType.string, mapTo: 'cycle_id'),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('weeklyXp', RealmPropertyType.int, mapTo: 'weekly_xp'),
      SchemaProperty('rank', RealmPropertyType.int, optional: true),
      SchemaProperty('promoted', RealmPropertyType.bool),
      SchemaProperty('demoted', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class XpTransactionEntity extends _XpTransactionEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  XpTransactionEntity(
    String txId,
    String userId,
    String sourceType,
    int amount,
    DateTime createdAt, {
    String? sourceId,
    String? note,
  }) {
    RealmObjectBase.set(this, 'tx_id', txId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'source_type', sourceType);
    RealmObjectBase.set(this, 'source_id', sourceId);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  XpTransactionEntity._();

  @override
  String get txId => RealmObjectBase.get<String>(this, 'tx_id') as String;
  @override
  set txId(String value) => RealmObjectBase.set(this, 'tx_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get sourceType =>
      RealmObjectBase.get<String>(this, 'source_type') as String;
  @override
  set sourceType(String value) =>
      RealmObjectBase.set(this, 'source_type', value);

  @override
  String? get sourceId =>
      RealmObjectBase.get<String>(this, 'source_id') as String?;
  @override
  set sourceId(String? value) => RealmObjectBase.set(this, 'source_id', value);

  @override
  int get amount => RealmObjectBase.get<int>(this, 'amount') as int;
  @override
  set amount(int value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<XpTransactionEntity>> get changes =>
      RealmObjectBase.getChanges<XpTransactionEntity>(this);

  @override
  Stream<RealmObjectChanges<XpTransactionEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<XpTransactionEntity>(this, keyPaths);

  @override
  XpTransactionEntity freeze() =>
      RealmObjectBase.freezeObject<XpTransactionEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'tx_id': txId.toEJson(),
      'user_id': userId.toEJson(),
      'source_type': sourceType.toEJson(),
      'source_id': sourceId.toEJson(),
      'amount': amount.toEJson(),
      'note': note.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(XpTransactionEntity value) => value.toEJson();
  static XpTransactionEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'tx_id': EJsonValue txId,
        'user_id': EJsonValue userId,
        'source_type': EJsonValue sourceType,
        'amount': EJsonValue amount,
        'created_at': EJsonValue createdAt,
      } =>
        XpTransactionEntity(
          fromEJson(txId),
          fromEJson(userId),
          fromEJson(sourceType),
          fromEJson(amount),
          fromEJson(createdAt),
          sourceId: fromEJson(ejson['source_id']),
          note: fromEJson(ejson['note']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(XpTransactionEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, XpTransactionEntity, 'XpTransactionEntity', [
      SchemaProperty('txId', RealmPropertyType.string,
          mapTo: 'tx_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('sourceType', RealmPropertyType.string,
          mapTo: 'source_type'),
      SchemaProperty('sourceId', RealmPropertyType.string,
          mapTo: 'source_id', optional: true),
      SchemaProperty('amount', RealmPropertyType.int),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ItemEntity extends _ItemEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  ItemEntity(
    String itemId,
    String code,
    String name,
    DateTime createdAt, {
    String? description,
    int? costScales,
    int? costGems,
  }) {
    RealmObjectBase.set(this, 'item_id', itemId);
    RealmObjectBase.set(this, 'code', code);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'cost_scales', costScales);
    RealmObjectBase.set(this, 'cost_gems', costGems);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  ItemEntity._();

  @override
  String get itemId => RealmObjectBase.get<String>(this, 'item_id') as String;
  @override
  set itemId(String value) => RealmObjectBase.set(this, 'item_id', value);

  @override
  String get code => RealmObjectBase.get<String>(this, 'code') as String;
  @override
  set code(String value) => RealmObjectBase.set(this, 'code', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  int? get costScales => RealmObjectBase.get<int>(this, 'cost_scales') as int?;
  @override
  set costScales(int? value) => RealmObjectBase.set(this, 'cost_scales', value);

  @override
  int? get costGems => RealmObjectBase.get<int>(this, 'cost_gems') as int?;
  @override
  set costGems(int? value) => RealmObjectBase.set(this, 'cost_gems', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<ItemEntity>> get changes =>
      RealmObjectBase.getChanges<ItemEntity>(this);

  @override
  Stream<RealmObjectChanges<ItemEntity>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ItemEntity>(this, keyPaths);

  @override
  ItemEntity freeze() => RealmObjectBase.freezeObject<ItemEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'item_id': itemId.toEJson(),
      'code': code.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'cost_scales': costScales.toEJson(),
      'cost_gems': costGems.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(ItemEntity value) => value.toEJson();
  static ItemEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'item_id': EJsonValue itemId,
        'code': EJsonValue code,
        'name': EJsonValue name,
        'created_at': EJsonValue createdAt,
      } =>
        ItemEntity(
          fromEJson(itemId),
          fromEJson(code),
          fromEJson(name),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
          costScales: fromEJson(ejson['cost_scales']),
          costGems: fromEJson(ejson['cost_gems']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ItemEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ItemEntity, 'ItemEntity', [
      SchemaProperty('itemId', RealmPropertyType.string,
          mapTo: 'item_id', primaryKey: true),
      SchemaProperty('code', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('costScales', RealmPropertyType.int,
          mapTo: 'cost_scales', optional: true),
      SchemaProperty('costGems', RealmPropertyType.int,
          mapTo: 'cost_gems', optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserInventoryEntity extends _UserInventoryEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  UserInventoryEntity(
    String id,
    String userId,
    String itemId,
    int quantity, {
    DateTime? expiresAt,
    DateTime? lastUsedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'item_id', itemId);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'expires_at', expiresAt);
    RealmObjectBase.set(this, 'last_used_at', lastUsedAt);
  }

  UserInventoryEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get itemId => RealmObjectBase.get<String>(this, 'item_id') as String;
  @override
  set itemId(String value) => RealmObjectBase.set(this, 'item_id', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  DateTime? get expiresAt =>
      RealmObjectBase.get<DateTime>(this, 'expires_at') as DateTime?;
  @override
  set expiresAt(DateTime? value) =>
      RealmObjectBase.set(this, 'expires_at', value);

  @override
  DateTime? get lastUsedAt =>
      RealmObjectBase.get<DateTime>(this, 'last_used_at') as DateTime?;
  @override
  set lastUsedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'last_used_at', value);

  @override
  Stream<RealmObjectChanges<UserInventoryEntity>> get changes =>
      RealmObjectBase.getChanges<UserInventoryEntity>(this);

  @override
  Stream<RealmObjectChanges<UserInventoryEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserInventoryEntity>(this, keyPaths);

  @override
  UserInventoryEntity freeze() =>
      RealmObjectBase.freezeObject<UserInventoryEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'user_id': userId.toEJson(),
      'item_id': itemId.toEJson(),
      'quantity': quantity.toEJson(),
      'expires_at': expiresAt.toEJson(),
      'last_used_at': lastUsedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserInventoryEntity value) => value.toEJson();
  static UserInventoryEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'user_id': EJsonValue userId,
        'item_id': EJsonValue itemId,
        'quantity': EJsonValue quantity,
      } =>
        UserInventoryEntity(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(itemId),
          fromEJson(quantity),
          expiresAt: fromEJson(ejson['expires_at']),
          lastUsedAt: fromEJson(ejson['last_used_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserInventoryEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserInventoryEntity, 'UserInventoryEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('itemId', RealmPropertyType.string, mapTo: 'item_id'),
      SchemaProperty('quantity', RealmPropertyType.int),
      SchemaProperty('expiresAt', RealmPropertyType.timestamp,
          mapTo: 'expires_at', optional: true),
      SchemaProperty('lastUsedAt', RealmPropertyType.timestamp,
          mapTo: 'last_used_at', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class NotificationSettingEntity extends _NotificationSettingEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  NotificationSettingEntity(
    String userId,
    bool pushEnabled,
    bool contextualAllowed, {
    String? morningTime,
    String? eveningTime,
  }) {
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'push_enabled', pushEnabled);
    RealmObjectBase.set(this, 'morning_time', morningTime);
    RealmObjectBase.set(this, 'evening_time', eveningTime);
    RealmObjectBase.set(this, 'contextual_allowed', contextualAllowed);
  }

  NotificationSettingEntity._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  bool get pushEnabled =>
      RealmObjectBase.get<bool>(this, 'push_enabled') as bool;
  @override
  set pushEnabled(bool value) =>
      RealmObjectBase.set(this, 'push_enabled', value);

  @override
  String? get morningTime =>
      RealmObjectBase.get<String>(this, 'morning_time') as String?;
  @override
  set morningTime(String? value) =>
      RealmObjectBase.set(this, 'morning_time', value);

  @override
  String? get eveningTime =>
      RealmObjectBase.get<String>(this, 'evening_time') as String?;
  @override
  set eveningTime(String? value) =>
      RealmObjectBase.set(this, 'evening_time', value);

  @override
  bool get contextualAllowed =>
      RealmObjectBase.get<bool>(this, 'contextual_allowed') as bool;
  @override
  set contextualAllowed(bool value) =>
      RealmObjectBase.set(this, 'contextual_allowed', value);

  @override
  Stream<RealmObjectChanges<NotificationSettingEntity>> get changes =>
      RealmObjectBase.getChanges<NotificationSettingEntity>(this);

  @override
  Stream<RealmObjectChanges<NotificationSettingEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<NotificationSettingEntity>(this, keyPaths);

  @override
  NotificationSettingEntity freeze() =>
      RealmObjectBase.freezeObject<NotificationSettingEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'user_id': userId.toEJson(),
      'push_enabled': pushEnabled.toEJson(),
      'morning_time': morningTime.toEJson(),
      'evening_time': eveningTime.toEJson(),
      'contextual_allowed': contextualAllowed.toEJson(),
    };
  }

  static EJsonValue _toEJson(NotificationSettingEntity value) =>
      value.toEJson();
  static NotificationSettingEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'user_id': EJsonValue userId,
        'push_enabled': EJsonValue pushEnabled,
        'contextual_allowed': EJsonValue contextualAllowed,
      } =>
        NotificationSettingEntity(
          fromEJson(userId),
          fromEJson(pushEnabled),
          fromEJson(contextualAllowed),
          morningTime: fromEJson(ejson['morning_time']),
          eveningTime: fromEJson(ejson['evening_time']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(NotificationSettingEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, NotificationSettingEntity,
        'NotificationSettingEntity', [
      SchemaProperty('userId', RealmPropertyType.string,
          mapTo: 'user_id', primaryKey: true),
      SchemaProperty('pushEnabled', RealmPropertyType.bool,
          mapTo: 'push_enabled'),
      SchemaProperty('morningTime', RealmPropertyType.string,
          mapTo: 'morning_time', optional: true),
      SchemaProperty('eveningTime', RealmPropertyType.string,
          mapTo: 'evening_time', optional: true),
      SchemaProperty('contextualAllowed', RealmPropertyType.bool,
          mapTo: 'contextual_allowed'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class NotificationEntity extends _NotificationEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  NotificationEntity(
    String notificationId,
    String userId,
    String type, {
    String? payload,
    DateTime? sentAt,
    DateTime? readAt,
  }) {
    RealmObjectBase.set(this, 'notification_id', notificationId);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'payload', payload);
    RealmObjectBase.set(this, 'sent_at', sentAt);
    RealmObjectBase.set(this, 'read_at', readAt);
  }

  NotificationEntity._();

  @override
  String get notificationId =>
      RealmObjectBase.get<String>(this, 'notification_id') as String;
  @override
  set notificationId(String value) =>
      RealmObjectBase.set(this, 'notification_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'user_id') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get payload =>
      RealmObjectBase.get<String>(this, 'payload') as String?;
  @override
  set payload(String? value) => RealmObjectBase.set(this, 'payload', value);

  @override
  DateTime? get sentAt =>
      RealmObjectBase.get<DateTime>(this, 'sent_at') as DateTime?;
  @override
  set sentAt(DateTime? value) => RealmObjectBase.set(this, 'sent_at', value);

  @override
  DateTime? get readAt =>
      RealmObjectBase.get<DateTime>(this, 'read_at') as DateTime?;
  @override
  set readAt(DateTime? value) => RealmObjectBase.set(this, 'read_at', value);

  @override
  Stream<RealmObjectChanges<NotificationEntity>> get changes =>
      RealmObjectBase.getChanges<NotificationEntity>(this);

  @override
  Stream<RealmObjectChanges<NotificationEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<NotificationEntity>(this, keyPaths);

  @override
  NotificationEntity freeze() =>
      RealmObjectBase.freezeObject<NotificationEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'notification_id': notificationId.toEJson(),
      'user_id': userId.toEJson(),
      'type': type.toEJson(),
      'payload': payload.toEJson(),
      'sent_at': sentAt.toEJson(),
      'read_at': readAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(NotificationEntity value) => value.toEJson();
  static NotificationEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'notification_id': EJsonValue notificationId,
        'user_id': EJsonValue userId,
        'type': EJsonValue type,
      } =>
        NotificationEntity(
          fromEJson(notificationId),
          fromEJson(userId),
          fromEJson(type),
          payload: fromEJson(ejson['payload']),
          sentAt: fromEJson(ejson['sent_at']),
          readAt: fromEJson(ejson['read_at']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(NotificationEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, NotificationEntity, 'NotificationEntity', [
      SchemaProperty('notificationId', RealmPropertyType.string,
          mapTo: 'notification_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, mapTo: 'user_id'),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('payload', RealmPropertyType.string, optional: true),
      SchemaProperty('sentAt', RealmPropertyType.timestamp,
          mapTo: 'sent_at', optional: true),
      SchemaProperty('readAt', RealmPropertyType.timestamp,
          mapTo: 'read_at', optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class AdminActionEntity extends _AdminActionEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  AdminActionEntity(
    String actionId,
    String adminId,
    String targetType,
    String targetId,
    String action,
    DateTime createdAt, {
    String? reason,
  }) {
    RealmObjectBase.set(this, 'action_id', actionId);
    RealmObjectBase.set(this, 'admin_id', adminId);
    RealmObjectBase.set(this, 'target_type', targetType);
    RealmObjectBase.set(this, 'target_id', targetId);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'reason', reason);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  AdminActionEntity._();

  @override
  String get actionId =>
      RealmObjectBase.get<String>(this, 'action_id') as String;
  @override
  set actionId(String value) => RealmObjectBase.set(this, 'action_id', value);

  @override
  String get adminId => RealmObjectBase.get<String>(this, 'admin_id') as String;
  @override
  set adminId(String value) => RealmObjectBase.set(this, 'admin_id', value);

  @override
  String get targetType =>
      RealmObjectBase.get<String>(this, 'target_type') as String;
  @override
  set targetType(String value) =>
      RealmObjectBase.set(this, 'target_type', value);

  @override
  String get targetId =>
      RealmObjectBase.get<String>(this, 'target_id') as String;
  @override
  set targetId(String value) => RealmObjectBase.set(this, 'target_id', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  String? get reason => RealmObjectBase.get<String>(this, 'reason') as String?;
  @override
  set reason(String? value) => RealmObjectBase.set(this, 'reason', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<AdminActionEntity>> get changes =>
      RealmObjectBase.getChanges<AdminActionEntity>(this);

  @override
  Stream<RealmObjectChanges<AdminActionEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AdminActionEntity>(this, keyPaths);

  @override
  AdminActionEntity freeze() =>
      RealmObjectBase.freezeObject<AdminActionEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'action_id': actionId.toEJson(),
      'admin_id': adminId.toEJson(),
      'target_type': targetType.toEJson(),
      'target_id': targetId.toEJson(),
      'action': action.toEJson(),
      'reason': reason.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(AdminActionEntity value) => value.toEJson();
  static AdminActionEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'action_id': EJsonValue actionId,
        'admin_id': EJsonValue adminId,
        'target_type': EJsonValue targetType,
        'target_id': EJsonValue targetId,
        'action': EJsonValue action,
        'created_at': EJsonValue createdAt,
      } =>
        AdminActionEntity(
          fromEJson(actionId),
          fromEJson(adminId),
          fromEJson(targetType),
          fromEJson(targetId),
          fromEJson(action),
          fromEJson(createdAt),
          reason: fromEJson(ejson['reason']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AdminActionEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AdminActionEntity, 'AdminActionEntity', [
      SchemaProperty('actionId', RealmPropertyType.string,
          mapTo: 'action_id', primaryKey: true),
      SchemaProperty('adminId', RealmPropertyType.string, mapTo: 'admin_id'),
      SchemaProperty('targetType', RealmPropertyType.string,
          mapTo: 'target_type'),
      SchemaProperty('targetId', RealmPropertyType.string, mapTo: 'target_id'),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('reason', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp,
          mapTo: 'created_at'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
