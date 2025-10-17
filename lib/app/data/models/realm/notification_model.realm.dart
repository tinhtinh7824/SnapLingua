// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Notification extends _Notification
    with RealmEntity, RealmObjectBase, RealmObject {
  Notification(
    String id,
    String userId,
    String type,
    String title,
    String message,
    bool isRead,
    bool isPush,
    bool isEmail,
    DateTime createdAt, {
    String? data,
    DateTime? scheduledAt,
    DateTime? sentAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'data', data);
    RealmObjectBase.set(this, 'isRead', isRead);
    RealmObjectBase.set(this, 'isPush', isPush);
    RealmObjectBase.set(this, 'isEmail', isEmail);
    RealmObjectBase.set(this, 'scheduledAt', scheduledAt);
    RealmObjectBase.set(this, 'sentAt', sentAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Notification._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get message => RealmObjectBase.get<String>(this, 'message') as String;
  @override
  set message(String value) => RealmObjectBase.set(this, 'message', value);

  @override
  String? get data => RealmObjectBase.get<String>(this, 'data') as String?;
  @override
  set data(String? value) => RealmObjectBase.set(this, 'data', value);

  @override
  bool get isRead => RealmObjectBase.get<bool>(this, 'isRead') as bool;
  @override
  set isRead(bool value) => RealmObjectBase.set(this, 'isRead', value);

  @override
  bool get isPush => RealmObjectBase.get<bool>(this, 'isPush') as bool;
  @override
  set isPush(bool value) => RealmObjectBase.set(this, 'isPush', value);

  @override
  bool get isEmail => RealmObjectBase.get<bool>(this, 'isEmail') as bool;
  @override
  set isEmail(bool value) => RealmObjectBase.set(this, 'isEmail', value);

  @override
  DateTime? get scheduledAt =>
      RealmObjectBase.get<DateTime>(this, 'scheduledAt') as DateTime?;
  @override
  set scheduledAt(DateTime? value) =>
      RealmObjectBase.set(this, 'scheduledAt', value);

  @override
  DateTime? get sentAt =>
      RealmObjectBase.get<DateTime>(this, 'sentAt') as DateTime?;
  @override
  set sentAt(DateTime? value) => RealmObjectBase.set(this, 'sentAt', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Notification>> get changes =>
      RealmObjectBase.getChanges<Notification>(this);

  @override
  Stream<RealmObjectChanges<Notification>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Notification>(this, keyPaths);

  @override
  Notification freeze() => RealmObjectBase.freezeObject<Notification>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'type': type.toEJson(),
      'title': title.toEJson(),
      'message': message.toEJson(),
      'data': data.toEJson(),
      'isRead': isRead.toEJson(),
      'isPush': isPush.toEJson(),
      'isEmail': isEmail.toEJson(),
      'scheduledAt': scheduledAt.toEJson(),
      'sentAt': sentAt.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Notification value) => value.toEJson();
  static Notification _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'type': EJsonValue type,
        'title': EJsonValue title,
        'message': EJsonValue message,
        'isRead': EJsonValue isRead,
        'isPush': EJsonValue isPush,
        'isEmail': EJsonValue isEmail,
        'createdAt': EJsonValue createdAt,
      } =>
        Notification(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(type),
          fromEJson(title),
          fromEJson(message),
          fromEJson(isRead),
          fromEJson(isPush),
          fromEJson(isEmail),
          fromEJson(createdAt),
          data: fromEJson(ejson['data']),
          scheduledAt: fromEJson(ejson['scheduledAt']),
          sentAt: fromEJson(ejson['sentAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Notification._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, Notification, 'Notification', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('message', RealmPropertyType.string),
      SchemaProperty('data', RealmPropertyType.string, optional: true),
      SchemaProperty('isRead', RealmPropertyType.bool),
      SchemaProperty('isPush', RealmPropertyType.bool),
      SchemaProperty('isEmail', RealmPropertyType.bool),
      SchemaProperty('scheduledAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('sentAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class NotificationPreference extends _NotificationPreference
    with RealmEntity, RealmObjectBase, RealmObject {
  NotificationPreference(
    String id,
    String userId,
    String type,
    bool pushEnabled,
    bool emailEnabled,
    bool inAppEnabled,
    DateTime createdAt, {
    String? schedule,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'pushEnabled', pushEnabled);
    RealmObjectBase.set(this, 'emailEnabled', emailEnabled);
    RealmObjectBase.set(this, 'inAppEnabled', inAppEnabled);
    RealmObjectBase.set(this, 'schedule', schedule);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  NotificationPreference._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  bool get pushEnabled =>
      RealmObjectBase.get<bool>(this, 'pushEnabled') as bool;
  @override
  set pushEnabled(bool value) =>
      RealmObjectBase.set(this, 'pushEnabled', value);

  @override
  bool get emailEnabled =>
      RealmObjectBase.get<bool>(this, 'emailEnabled') as bool;
  @override
  set emailEnabled(bool value) =>
      RealmObjectBase.set(this, 'emailEnabled', value);

  @override
  bool get inAppEnabled =>
      RealmObjectBase.get<bool>(this, 'inAppEnabled') as bool;
  @override
  set inAppEnabled(bool value) =>
      RealmObjectBase.set(this, 'inAppEnabled', value);

  @override
  String? get schedule =>
      RealmObjectBase.get<String>(this, 'schedule') as String?;
  @override
  set schedule(String? value) => RealmObjectBase.set(this, 'schedule', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<NotificationPreference>> get changes =>
      RealmObjectBase.getChanges<NotificationPreference>(this);

  @override
  Stream<RealmObjectChanges<NotificationPreference>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<NotificationPreference>(this, keyPaths);

  @override
  NotificationPreference freeze() =>
      RealmObjectBase.freezeObject<NotificationPreference>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'type': type.toEJson(),
      'pushEnabled': pushEnabled.toEJson(),
      'emailEnabled': emailEnabled.toEJson(),
      'inAppEnabled': inAppEnabled.toEJson(),
      'schedule': schedule.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(NotificationPreference value) => value.toEJson();
  static NotificationPreference _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'type': EJsonValue type,
        'pushEnabled': EJsonValue pushEnabled,
        'emailEnabled': EJsonValue emailEnabled,
        'inAppEnabled': EJsonValue inAppEnabled,
        'createdAt': EJsonValue createdAt,
      } =>
        NotificationPreference(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(type),
          fromEJson(pushEnabled),
          fromEJson(emailEnabled),
          fromEJson(inAppEnabled),
          fromEJson(createdAt),
          schedule: fromEJson(ejson['schedule']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(NotificationPreference._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, NotificationPreference,
        'NotificationPreference', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('pushEnabled', RealmPropertyType.bool),
      SchemaProperty('emailEnabled', RealmPropertyType.bool),
      SchemaProperty('inAppEnabled', RealmPropertyType.bool),
      SchemaProperty('schedule', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PushToken extends _PushToken
    with RealmEntity, RealmObjectBase, RealmObject {
  PushToken(
    String id,
    String userId,
    String token,
    String platform,
    bool isActive,
    DateTime createdAt, {
    String? deviceId,
    DateTime? lastUsedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'token', token);
    RealmObjectBase.set(this, 'platform', platform);
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastUsedAt', lastUsedAt);
  }

  PushToken._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get token => RealmObjectBase.get<String>(this, 'token') as String;
  @override
  set token(String value) => RealmObjectBase.set(this, 'token', value);

  @override
  String get platform =>
      RealmObjectBase.get<String>(this, 'platform') as String;
  @override
  set platform(String value) => RealmObjectBase.set(this, 'platform', value);

  @override
  String? get deviceId =>
      RealmObjectBase.get<String>(this, 'deviceId') as String?;
  @override
  set deviceId(String? value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get lastUsedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastUsedAt') as DateTime?;
  @override
  set lastUsedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastUsedAt', value);

  @override
  Stream<RealmObjectChanges<PushToken>> get changes =>
      RealmObjectBase.getChanges<PushToken>(this);

  @override
  Stream<RealmObjectChanges<PushToken>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PushToken>(this, keyPaths);

  @override
  PushToken freeze() => RealmObjectBase.freezeObject<PushToken>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'token': token.toEJson(),
      'platform': platform.toEJson(),
      'deviceId': deviceId.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastUsedAt': lastUsedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PushToken value) => value.toEJson();
  static PushToken _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'token': EJsonValue token,
        'platform': EJsonValue platform,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        PushToken(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(token),
          fromEJson(platform),
          fromEJson(isActive),
          fromEJson(createdAt),
          deviceId: fromEJson(ejson['deviceId']),
          lastUsedAt: fromEJson(ejson['lastUsedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PushToken._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, PushToken, 'PushToken', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('token', RealmPropertyType.string),
      SchemaProperty('platform', RealmPropertyType.string),
      SchemaProperty('deviceId', RealmPropertyType.string, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastUsedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
