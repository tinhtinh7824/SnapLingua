// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AuthSession extends _AuthSession
    with RealmEntity, RealmObjectBase, RealmObject {
  AuthSession(
    String id,
    String userId,
    String email,
    DateTime createdAt,
    bool isActive, {
    String? refreshToken,
    String? accessToken,
    DateTime? tokenExpiresAt,
    DateTime? lastActiveAt,
    String? deviceId,
    String? deviceName,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'refreshToken', refreshToken);
    RealmObjectBase.set(this, 'accessToken', accessToken);
    RealmObjectBase.set(this, 'tokenExpiresAt', tokenExpiresAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastActiveAt', lastActiveAt);
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'deviceName', deviceName);
    RealmObjectBase.set(this, 'isActive', isActive);
  }

  AuthSession._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get refreshToken =>
      RealmObjectBase.get<String>(this, 'refreshToken') as String?;
  @override
  set refreshToken(String? value) =>
      RealmObjectBase.set(this, 'refreshToken', value);

  @override
  String? get accessToken =>
      RealmObjectBase.get<String>(this, 'accessToken') as String?;
  @override
  set accessToken(String? value) =>
      RealmObjectBase.set(this, 'accessToken', value);

  @override
  DateTime? get tokenExpiresAt =>
      RealmObjectBase.get<DateTime>(this, 'tokenExpiresAt') as DateTime?;
  @override
  set tokenExpiresAt(DateTime? value) =>
      RealmObjectBase.set(this, 'tokenExpiresAt', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get lastActiveAt =>
      RealmObjectBase.get<DateTime>(this, 'lastActiveAt') as DateTime?;
  @override
  set lastActiveAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastActiveAt', value);

  @override
  String? get deviceId =>
      RealmObjectBase.get<String>(this, 'deviceId') as String?;
  @override
  set deviceId(String? value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  String? get deviceName =>
      RealmObjectBase.get<String>(this, 'deviceName') as String?;
  @override
  set deviceName(String? value) =>
      RealmObjectBase.set(this, 'deviceName', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  Stream<RealmObjectChanges<AuthSession>> get changes =>
      RealmObjectBase.getChanges<AuthSession>(this);

  @override
  Stream<RealmObjectChanges<AuthSession>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AuthSession>(this, keyPaths);

  @override
  AuthSession freeze() => RealmObjectBase.freezeObject<AuthSession>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'email': email.toEJson(),
      'refreshToken': refreshToken.toEJson(),
      'accessToken': accessToken.toEJson(),
      'tokenExpiresAt': tokenExpiresAt.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastActiveAt': lastActiveAt.toEJson(),
      'deviceId': deviceId.toEJson(),
      'deviceName': deviceName.toEJson(),
      'isActive': isActive.toEJson(),
    };
  }

  static EJsonValue _toEJson(AuthSession value) => value.toEJson();
  static AuthSession _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'email': EJsonValue email,
        'createdAt': EJsonValue createdAt,
        'isActive': EJsonValue isActive,
      } =>
        AuthSession(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(email),
          fromEJson(createdAt),
          fromEJson(isActive),
          refreshToken: fromEJson(ejson['refreshToken']),
          accessToken: fromEJson(ejson['accessToken']),
          tokenExpiresAt: fromEJson(ejson['tokenExpiresAt']),
          lastActiveAt: fromEJson(ejson['lastActiveAt']),
          deviceId: fromEJson(ejson['deviceId']),
          deviceName: fromEJson(ejson['deviceName']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AuthSession._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AuthSession, 'AuthSession', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('refreshToken', RealmPropertyType.string, optional: true),
      SchemaProperty('accessToken', RealmPropertyType.string, optional: true),
      SchemaProperty('tokenExpiresAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastActiveAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deviceId', RealmPropertyType.string, optional: true),
      SchemaProperty('deviceName', RealmPropertyType.string, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PasswordReset extends _PasswordReset
    with RealmEntity, RealmObjectBase, RealmObject {
  PasswordReset(
    String id,
    String email,
    String resetCode,
    DateTime expiresAt,
    DateTime createdAt,
    bool isUsed,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'resetCode', resetCode);
    RealmObjectBase.set(this, 'expiresAt', expiresAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'isUsed', isUsed);
  }

  PasswordReset._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get resetCode =>
      RealmObjectBase.get<String>(this, 'resetCode') as String;
  @override
  set resetCode(String value) => RealmObjectBase.set(this, 'resetCode', value);

  @override
  DateTime get expiresAt =>
      RealmObjectBase.get<DateTime>(this, 'expiresAt') as DateTime;
  @override
  set expiresAt(DateTime value) =>
      RealmObjectBase.set(this, 'expiresAt', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  bool get isUsed => RealmObjectBase.get<bool>(this, 'isUsed') as bool;
  @override
  set isUsed(bool value) => RealmObjectBase.set(this, 'isUsed', value);

  @override
  Stream<RealmObjectChanges<PasswordReset>> get changes =>
      RealmObjectBase.getChanges<PasswordReset>(this);

  @override
  Stream<RealmObjectChanges<PasswordReset>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PasswordReset>(this, keyPaths);

  @override
  PasswordReset freeze() => RealmObjectBase.freezeObject<PasswordReset>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'email': email.toEJson(),
      'resetCode': resetCode.toEJson(),
      'expiresAt': expiresAt.toEJson(),
      'createdAt': createdAt.toEJson(),
      'isUsed': isUsed.toEJson(),
    };
  }

  static EJsonValue _toEJson(PasswordReset value) => value.toEJson();
  static PasswordReset _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'email': EJsonValue email,
        'resetCode': EJsonValue resetCode,
        'expiresAt': EJsonValue expiresAt,
        'createdAt': EJsonValue createdAt,
        'isUsed': EJsonValue isUsed,
      } =>
        PasswordReset(
          fromEJson(id),
          fromEJson(email),
          fromEJson(resetCode),
          fromEJson(expiresAt),
          fromEJson(createdAt),
          fromEJson(isUsed),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PasswordReset._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PasswordReset, 'PasswordReset', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('resetCode', RealmPropertyType.string),
      SchemaProperty('expiresAt', RealmPropertyType.timestamp),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('isUsed', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
