// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends _User with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  User(
    ObjectId id,
    DateTime createdAt, {
    String? email,
    String? displayName,
    String? avatarUrl,
    String role = 'user',
    String status = 'active',
    DateTime? updatedAt,
    String? realmUserId,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<User>({
        'role': 'user',
        'status': 'active',
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'displayName', displayName);
    RealmObjectBase.set(this, 'avatarUrl', avatarUrl);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'realmUserId', realmUserId);
  }

  User._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get displayName =>
      RealmObjectBase.get<String>(this, 'displayName') as String?;
  @override
  set displayName(String? value) =>
      RealmObjectBase.set(this, 'displayName', value);

  @override
  String? get avatarUrl =>
      RealmObjectBase.get<String>(this, 'avatarUrl') as String?;
  @override
  set avatarUrl(String? value) => RealmObjectBase.set(this, 'avatarUrl', value);

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
  String? get realmUserId =>
      RealmObjectBase.get<String>(this, 'realmUserId') as String?;
  @override
  set realmUserId(String? value) =>
      RealmObjectBase.set(this, 'realmUserId', value);

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  Stream<RealmObjectChanges<User>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<User>(this, keyPaths);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'email': email.toEJson(),
      'displayName': displayName.toEJson(),
      'avatarUrl': avatarUrl.toEJson(),
      'role': role.toEJson(),
      'status': status.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'realmUserId': realmUserId.toEJson(),
    };
  }

  static EJsonValue _toEJson(User value) => value.toEJson();
  static User _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'createdAt': EJsonValue createdAt,
      } =>
        User(
          fromEJson(id),
          fromEJson(createdAt),
          email: fromEJson(ejson['email']),
          displayName: fromEJson(ejson['displayName']),
          avatarUrl: fromEJson(ejson['avatarUrl']),
          role: fromEJson(ejson['role'], defaultValue: 'user'),
          status: fromEJson(ejson['status'], defaultValue: 'active'),
          updatedAt: fromEJson(ejson['updatedAt']),
          realmUserId: fromEJson(ejson['realmUserId']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(User._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, User, 'User', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('displayName', RealmPropertyType.string, optional: true),
      SchemaProperty('avatarUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('realmUserId', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
