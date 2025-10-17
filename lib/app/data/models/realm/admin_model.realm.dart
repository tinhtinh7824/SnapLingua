// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AdminUser extends _AdminUser
    with RealmEntity, RealmObjectBase, RealmObject {
  AdminUser(
    String id,
    String email,
    String name,
    String role,
    bool isActive,
    DateTime createdAt, {
    String? permissions,
    DateTime? lastLoginAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'permissions', permissions);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastLoginAt', lastLoginAt);
  }

  AdminUser._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get role => RealmObjectBase.get<String>(this, 'role') as String;
  @override
  set role(String value) => RealmObjectBase.set(this, 'role', value);

  @override
  String? get permissions =>
      RealmObjectBase.get<String>(this, 'permissions') as String?;
  @override
  set permissions(String? value) =>
      RealmObjectBase.set(this, 'permissions', value);

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
  DateTime? get lastLoginAt =>
      RealmObjectBase.get<DateTime>(this, 'lastLoginAt') as DateTime?;
  @override
  set lastLoginAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastLoginAt', value);

  @override
  Stream<RealmObjectChanges<AdminUser>> get changes =>
      RealmObjectBase.getChanges<AdminUser>(this);

  @override
  Stream<RealmObjectChanges<AdminUser>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AdminUser>(this, keyPaths);

  @override
  AdminUser freeze() => RealmObjectBase.freezeObject<AdminUser>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'email': email.toEJson(),
      'name': name.toEJson(),
      'role': role.toEJson(),
      'permissions': permissions.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastLoginAt': lastLoginAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(AdminUser value) => value.toEJson();
  static AdminUser _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'email': EJsonValue email,
        'name': EJsonValue name,
        'role': EJsonValue role,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        AdminUser(
          fromEJson(id),
          fromEJson(email),
          fromEJson(name),
          fromEJson(role),
          fromEJson(isActive),
          fromEJson(createdAt),
          permissions: fromEJson(ejson['permissions']),
          lastLoginAt: fromEJson(ejson['lastLoginAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AdminUser._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, AdminUser, 'AdminUser', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('permissions', RealmPropertyType.string, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastLoginAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class SystemConfig extends _SystemConfig
    with RealmEntity, RealmObjectBase, RealmObject {
  SystemConfig(
    String id,
    String key,
    String value,
    String type,
    DateTime createdAt, {
    String? description,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  SystemConfig._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get key => RealmObjectBase.get<String>(this, 'key') as String;
  @override
  set key(String value) => RealmObjectBase.set(this, 'key', value);

  @override
  String get value => RealmObjectBase.get<String>(this, 'value') as String;
  @override
  set value(String value) => RealmObjectBase.set(this, 'value', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

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
  Stream<RealmObjectChanges<SystemConfig>> get changes =>
      RealmObjectBase.getChanges<SystemConfig>(this);

  @override
  Stream<RealmObjectChanges<SystemConfig>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SystemConfig>(this, keyPaths);

  @override
  SystemConfig freeze() => RealmObjectBase.freezeObject<SystemConfig>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'key': key.toEJson(),
      'value': value.toEJson(),
      'type': type.toEJson(),
      'description': description.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(SystemConfig value) => value.toEJson();
  static SystemConfig _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'key': EJsonValue key,
        'value': EJsonValue value,
        'type': EJsonValue type,
        'createdAt': EJsonValue createdAt,
      } =>
        SystemConfig(
          fromEJson(id),
          fromEJson(key),
          fromEJson(value),
          fromEJson(type),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SystemConfig._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, SystemConfig, 'SystemConfig', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('key', RealmPropertyType.string),
      SchemaProperty('value', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserReport extends _UserReport
    with RealmEntity, RealmObjectBase, RealmObject {
  UserReport(
    String id,
    String reporterId,
    String reportedUserId,
    String reason,
    String status,
    DateTime reportedAt, {
    String? details,
    String? adminNotes,
    String? adminId,
    DateTime? reviewedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'reporterId', reporterId);
    RealmObjectBase.set(this, 'reportedUserId', reportedUserId);
    RealmObjectBase.set(this, 'reason', reason);
    RealmObjectBase.set(this, 'details', details);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'adminNotes', adminNotes);
    RealmObjectBase.set(this, 'adminId', adminId);
    RealmObjectBase.set(this, 'reportedAt', reportedAt);
    RealmObjectBase.set(this, 'reviewedAt', reviewedAt);
  }

  UserReport._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get reporterId =>
      RealmObjectBase.get<String>(this, 'reporterId') as String;
  @override
  set reporterId(String value) =>
      RealmObjectBase.set(this, 'reporterId', value);

  @override
  String get reportedUserId =>
      RealmObjectBase.get<String>(this, 'reportedUserId') as String;
  @override
  set reportedUserId(String value) =>
      RealmObjectBase.set(this, 'reportedUserId', value);

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
  String? get adminNotes =>
      RealmObjectBase.get<String>(this, 'adminNotes') as String?;
  @override
  set adminNotes(String? value) =>
      RealmObjectBase.set(this, 'adminNotes', value);

  @override
  String? get adminId =>
      RealmObjectBase.get<String>(this, 'adminId') as String?;
  @override
  set adminId(String? value) => RealmObjectBase.set(this, 'adminId', value);

  @override
  DateTime get reportedAt =>
      RealmObjectBase.get<DateTime>(this, 'reportedAt') as DateTime;
  @override
  set reportedAt(DateTime value) =>
      RealmObjectBase.set(this, 'reportedAt', value);

  @override
  DateTime? get reviewedAt =>
      RealmObjectBase.get<DateTime>(this, 'reviewedAt') as DateTime?;
  @override
  set reviewedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'reviewedAt', value);

  @override
  Stream<RealmObjectChanges<UserReport>> get changes =>
      RealmObjectBase.getChanges<UserReport>(this);

  @override
  Stream<RealmObjectChanges<UserReport>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserReport>(this, keyPaths);

  @override
  UserReport freeze() => RealmObjectBase.freezeObject<UserReport>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'reporterId': reporterId.toEJson(),
      'reportedUserId': reportedUserId.toEJson(),
      'reason': reason.toEJson(),
      'details': details.toEJson(),
      'status': status.toEJson(),
      'adminNotes': adminNotes.toEJson(),
      'adminId': adminId.toEJson(),
      'reportedAt': reportedAt.toEJson(),
      'reviewedAt': reviewedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserReport value) => value.toEJson();
  static UserReport _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'reporterId': EJsonValue reporterId,
        'reportedUserId': EJsonValue reportedUserId,
        'reason': EJsonValue reason,
        'status': EJsonValue status,
        'reportedAt': EJsonValue reportedAt,
      } =>
        UserReport(
          fromEJson(id),
          fromEJson(reporterId),
          fromEJson(reportedUserId),
          fromEJson(reason),
          fromEJson(status),
          fromEJson(reportedAt),
          details: fromEJson(ejson['details']),
          adminNotes: fromEJson(ejson['adminNotes']),
          adminId: fromEJson(ejson['adminId']),
          reviewedAt: fromEJson(ejson['reviewedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserReport._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserReport, 'UserReport', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('reporterId', RealmPropertyType.string),
      SchemaProperty('reportedUserId', RealmPropertyType.string),
      SchemaProperty('reason', RealmPropertyType.string),
      SchemaProperty('details', RealmPropertyType.string, optional: true),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('adminNotes', RealmPropertyType.string, optional: true),
      SchemaProperty('adminId', RealmPropertyType.string, optional: true),
      SchemaProperty('reportedAt', RealmPropertyType.timestamp),
      SchemaProperty('reviewedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ContentModerationLog extends _ContentModerationLog
    with RealmEntity, RealmObjectBase, RealmObject {
  ContentModerationLog(
    String id,
    String contentType,
    String contentId,
    String action,
    String adminId,
    DateTime actionAt, {
    String? reason,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'contentType', contentType);
    RealmObjectBase.set(this, 'contentId', contentId);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'reason', reason);
    RealmObjectBase.set(this, 'adminId', adminId);
    RealmObjectBase.set(this, 'actionAt', actionAt);
  }

  ContentModerationLog._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get contentType =>
      RealmObjectBase.get<String>(this, 'contentType') as String;
  @override
  set contentType(String value) =>
      RealmObjectBase.set(this, 'contentType', value);

  @override
  String get contentId =>
      RealmObjectBase.get<String>(this, 'contentId') as String;
  @override
  set contentId(String value) => RealmObjectBase.set(this, 'contentId', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  String? get reason => RealmObjectBase.get<String>(this, 'reason') as String?;
  @override
  set reason(String? value) => RealmObjectBase.set(this, 'reason', value);

  @override
  String get adminId => RealmObjectBase.get<String>(this, 'adminId') as String;
  @override
  set adminId(String value) => RealmObjectBase.set(this, 'adminId', value);

  @override
  DateTime get actionAt =>
      RealmObjectBase.get<DateTime>(this, 'actionAt') as DateTime;
  @override
  set actionAt(DateTime value) => RealmObjectBase.set(this, 'actionAt', value);

  @override
  Stream<RealmObjectChanges<ContentModerationLog>> get changes =>
      RealmObjectBase.getChanges<ContentModerationLog>(this);

  @override
  Stream<RealmObjectChanges<ContentModerationLog>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ContentModerationLog>(this, keyPaths);

  @override
  ContentModerationLog freeze() =>
      RealmObjectBase.freezeObject<ContentModerationLog>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'contentType': contentType.toEJson(),
      'contentId': contentId.toEJson(),
      'action': action.toEJson(),
      'reason': reason.toEJson(),
      'adminId': adminId.toEJson(),
      'actionAt': actionAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(ContentModerationLog value) => value.toEJson();
  static ContentModerationLog _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'contentType': EJsonValue contentType,
        'contentId': EJsonValue contentId,
        'action': EJsonValue action,
        'adminId': EJsonValue adminId,
        'actionAt': EJsonValue actionAt,
      } =>
        ContentModerationLog(
          fromEJson(id),
          fromEJson(contentType),
          fromEJson(contentId),
          fromEJson(action),
          fromEJson(adminId),
          fromEJson(actionAt),
          reason: fromEJson(ejson['reason']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ContentModerationLog._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ContentModerationLog, 'ContentModerationLog', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('contentType', RealmPropertyType.string),
      SchemaProperty('contentId', RealmPropertyType.string),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('reason', RealmPropertyType.string, optional: true),
      SchemaProperty('adminId', RealmPropertyType.string),
      SchemaProperty('actionAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class SystemLog extends _SystemLog
    with RealmEntity, RealmObjectBase, RealmObject {
  SystemLog(
    String id,
    String level,
    String category,
    String message,
    DateTime createdAt, {
    String? details,
    String? userId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'level', level);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'details', details);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  SystemLog._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get level => RealmObjectBase.get<String>(this, 'level') as String;
  @override
  set level(String value) => RealmObjectBase.set(this, 'level', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String get message => RealmObjectBase.get<String>(this, 'message') as String;
  @override
  set message(String value) => RealmObjectBase.set(this, 'message', value);

  @override
  String? get details =>
      RealmObjectBase.get<String>(this, 'details') as String?;
  @override
  set details(String? value) => RealmObjectBase.set(this, 'details', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<SystemLog>> get changes =>
      RealmObjectBase.getChanges<SystemLog>(this);

  @override
  Stream<RealmObjectChanges<SystemLog>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SystemLog>(this, keyPaths);

  @override
  SystemLog freeze() => RealmObjectBase.freezeObject<SystemLog>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'level': level.toEJson(),
      'category': category.toEJson(),
      'message': message.toEJson(),
      'details': details.toEJson(),
      'userId': userId.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(SystemLog value) => value.toEJson();
  static SystemLog _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'level': EJsonValue level,
        'category': EJsonValue category,
        'message': EJsonValue message,
        'createdAt': EJsonValue createdAt,
      } =>
        SystemLog(
          fromEJson(id),
          fromEJson(level),
          fromEJson(category),
          fromEJson(message),
          fromEJson(createdAt),
          details: fromEJson(ejson['details']),
          userId: fromEJson(ejson['userId']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SystemLog._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, SystemLog, 'SystemLog', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('level', RealmPropertyType.string),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('message', RealmPropertyType.string),
      SchemaProperty('details', RealmPropertyType.string, optional: true),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class AppVersion extends _AppVersion
    with RealmEntity, RealmObjectBase, RealmObject {
  AppVersion(
    String id,
    String platform,
    String version,
    String buildNumber,
    bool isRequired,
    DateTime releasedAt,
    bool isActive, {
    String? downloadUrl,
    String? releaseNotes,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'platform', platform);
    RealmObjectBase.set(this, 'version', version);
    RealmObjectBase.set(this, 'buildNumber', buildNumber);
    RealmObjectBase.set(this, 'isRequired', isRequired);
    RealmObjectBase.set(this, 'downloadUrl', downloadUrl);
    RealmObjectBase.set(this, 'releaseNotes', releaseNotes);
    RealmObjectBase.set(this, 'releasedAt', releasedAt);
    RealmObjectBase.set(this, 'isActive', isActive);
  }

  AppVersion._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get platform =>
      RealmObjectBase.get<String>(this, 'platform') as String;
  @override
  set platform(String value) => RealmObjectBase.set(this, 'platform', value);

  @override
  String get version => RealmObjectBase.get<String>(this, 'version') as String;
  @override
  set version(String value) => RealmObjectBase.set(this, 'version', value);

  @override
  String get buildNumber =>
      RealmObjectBase.get<String>(this, 'buildNumber') as String;
  @override
  set buildNumber(String value) =>
      RealmObjectBase.set(this, 'buildNumber', value);

  @override
  bool get isRequired => RealmObjectBase.get<bool>(this, 'isRequired') as bool;
  @override
  set isRequired(bool value) => RealmObjectBase.set(this, 'isRequired', value);

  @override
  String? get downloadUrl =>
      RealmObjectBase.get<String>(this, 'downloadUrl') as String?;
  @override
  set downloadUrl(String? value) =>
      RealmObjectBase.set(this, 'downloadUrl', value);

  @override
  String? get releaseNotes =>
      RealmObjectBase.get<String>(this, 'releaseNotes') as String?;
  @override
  set releaseNotes(String? value) =>
      RealmObjectBase.set(this, 'releaseNotes', value);

  @override
  DateTime get releasedAt =>
      RealmObjectBase.get<DateTime>(this, 'releasedAt') as DateTime;
  @override
  set releasedAt(DateTime value) =>
      RealmObjectBase.set(this, 'releasedAt', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  Stream<RealmObjectChanges<AppVersion>> get changes =>
      RealmObjectBase.getChanges<AppVersion>(this);

  @override
  Stream<RealmObjectChanges<AppVersion>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AppVersion>(this, keyPaths);

  @override
  AppVersion freeze() => RealmObjectBase.freezeObject<AppVersion>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'platform': platform.toEJson(),
      'version': version.toEJson(),
      'buildNumber': buildNumber.toEJson(),
      'isRequired': isRequired.toEJson(),
      'downloadUrl': downloadUrl.toEJson(),
      'releaseNotes': releaseNotes.toEJson(),
      'releasedAt': releasedAt.toEJson(),
      'isActive': isActive.toEJson(),
    };
  }

  static EJsonValue _toEJson(AppVersion value) => value.toEJson();
  static AppVersion _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'platform': EJsonValue platform,
        'version': EJsonValue version,
        'buildNumber': EJsonValue buildNumber,
        'isRequired': EJsonValue isRequired,
        'releasedAt': EJsonValue releasedAt,
        'isActive': EJsonValue isActive,
      } =>
        AppVersion(
          fromEJson(id),
          fromEJson(platform),
          fromEJson(version),
          fromEJson(buildNumber),
          fromEJson(isRequired),
          fromEJson(releasedAt),
          fromEJson(isActive),
          downloadUrl: fromEJson(ejson['downloadUrl']),
          releaseNotes: fromEJson(ejson['releaseNotes']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AppVersion._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AppVersion, 'AppVersion', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('platform', RealmPropertyType.string),
      SchemaProperty('version', RealmPropertyType.string),
      SchemaProperty('buildNumber', RealmPropertyType.string),
      SchemaProperty('isRequired', RealmPropertyType.bool),
      SchemaProperty('downloadUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('releaseNotes', RealmPropertyType.string, optional: true),
      SchemaProperty('releasedAt', RealmPropertyType.timestamp),
      SchemaProperty('isActive', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
