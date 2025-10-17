// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends _User with RealmEntity, RealmObjectBase, RealmObject {
  User(
    String userId,
    String role,
    String status,
    DateTime createdAt, {
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'displayName', displayName);
    RealmObjectBase.set(this, 'avatarUrl', avatarUrl);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  User._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

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
  set avatarUrl(String? value) =>
      RealmObjectBase.set(this, 'avatarUrl', value);

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
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(User._);
    return const SchemaObject(
        ObjectType.realmObject, User, 'User', [
      SchemaProperty('userId', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('displayName', RealmPropertyType.string, optional: true),
      SchemaProperty('avatarUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}
