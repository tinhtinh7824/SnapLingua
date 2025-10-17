// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Group extends _Group with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Group(
    ObjectId id,
    String name,
    String ownerId,
    DateTime createdAt, {
    String? description,
    String? avatarUrl,
    String? coverImageUrl,
    Iterable<String> memberIds = const [],
    Iterable<String> adminIds = const [],
    int memberCount = 0,
    String visibility = 'public',
    String joinType = 'open',
    bool allowMemberPosts = true,
    int postCount = 0,
    int activeThisWeek = 0,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    bool needsSync = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Group>({
        'memberCount': 0,
        'visibility': 'public',
        'joinType': 'open',
        'allowMemberPosts': true,
        'postCount': 0,
        'activeThisWeek': 0,
        'needsSync': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'avatarUrl', avatarUrl);
    RealmObjectBase.set(this, 'coverImageUrl', coverImageUrl);
    RealmObjectBase.set(this, 'ownerId', ownerId);
    RealmObjectBase.set<RealmList<String>>(
        this, 'memberIds', RealmList<String>(memberIds));
    RealmObjectBase.set<RealmList<String>>(
        this, 'adminIds', RealmList<String>(adminIds));
    RealmObjectBase.set(this, 'memberCount', memberCount);
    RealmObjectBase.set(this, 'visibility', visibility);
    RealmObjectBase.set(this, 'joinType', joinType);
    RealmObjectBase.set(this, 'allowMemberPosts', allowMemberPosts);
    RealmObjectBase.set(this, 'postCount', postCount);
    RealmObjectBase.set(this, 'activeThisWeek', activeThisWeek);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'lastSyncedAt', lastSyncedAt);
    RealmObjectBase.set(this, 'needsSync', needsSync);
  }

  Group._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

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
  String? get avatarUrl =>
      RealmObjectBase.get<String>(this, 'avatarUrl') as String?;
  @override
  set avatarUrl(String? value) => RealmObjectBase.set(this, 'avatarUrl', value);

  @override
  String? get coverImageUrl =>
      RealmObjectBase.get<String>(this, 'coverImageUrl') as String?;
  @override
  set coverImageUrl(String? value) =>
      RealmObjectBase.set(this, 'coverImageUrl', value);

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'ownerId') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'ownerId', value);

  @override
  RealmList<String> get memberIds =>
      RealmObjectBase.get<String>(this, 'memberIds') as RealmList<String>;
  @override
  set memberIds(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get adminIds =>
      RealmObjectBase.get<String>(this, 'adminIds') as RealmList<String>;
  @override
  set adminIds(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  int get memberCount => RealmObjectBase.get<int>(this, 'memberCount') as int;
  @override
  set memberCount(int value) => RealmObjectBase.set(this, 'memberCount', value);

  @override
  String get visibility =>
      RealmObjectBase.get<String>(this, 'visibility') as String;
  @override
  set visibility(String value) =>
      RealmObjectBase.set(this, 'visibility', value);

  @override
  String get joinType =>
      RealmObjectBase.get<String>(this, 'joinType') as String;
  @override
  set joinType(String value) => RealmObjectBase.set(this, 'joinType', value);

  @override
  bool get allowMemberPosts =>
      RealmObjectBase.get<bool>(this, 'allowMemberPosts') as bool;
  @override
  set allowMemberPosts(bool value) =>
      RealmObjectBase.set(this, 'allowMemberPosts', value);

  @override
  int get postCount => RealmObjectBase.get<int>(this, 'postCount') as int;
  @override
  set postCount(int value) => RealmObjectBase.set(this, 'postCount', value);

  @override
  int get activeThisWeek =>
      RealmObjectBase.get<int>(this, 'activeThisWeek') as int;
  @override
  set activeThisWeek(int value) =>
      RealmObjectBase.set(this, 'activeThisWeek', value);

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
  DateTime? get lastSyncedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastSyncedAt') as DateTime?;
  @override
  set lastSyncedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastSyncedAt', value);

  @override
  bool get needsSync => RealmObjectBase.get<bool>(this, 'needsSync') as bool;
  @override
  set needsSync(bool value) => RealmObjectBase.set(this, 'needsSync', value);

  @override
  Stream<RealmObjectChanges<Group>> get changes =>
      RealmObjectBase.getChanges<Group>(this);

  @override
  Stream<RealmObjectChanges<Group>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Group>(this, keyPaths);

  @override
  Group freeze() => RealmObjectBase.freezeObject<Group>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'avatarUrl': avatarUrl.toEJson(),
      'coverImageUrl': coverImageUrl.toEJson(),
      'ownerId': ownerId.toEJson(),
      'memberIds': memberIds.toEJson(),
      'adminIds': adminIds.toEJson(),
      'memberCount': memberCount.toEJson(),
      'visibility': visibility.toEJson(),
      'joinType': joinType.toEJson(),
      'allowMemberPosts': allowMemberPosts.toEJson(),
      'postCount': postCount.toEJson(),
      'activeThisWeek': activeThisWeek.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'lastSyncedAt': lastSyncedAt.toEJson(),
      'needsSync': needsSync.toEJson(),
    };
  }

  static EJsonValue _toEJson(Group value) => value.toEJson();
  static Group _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'name': EJsonValue name,
        'ownerId': EJsonValue ownerId,
        'createdAt': EJsonValue createdAt,
      } =>
        Group(
          fromEJson(id),
          fromEJson(name),
          fromEJson(ownerId),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
          avatarUrl: fromEJson(ejson['avatarUrl']),
          coverImageUrl: fromEJson(ejson['coverImageUrl']),
          memberIds: fromEJson(ejson['memberIds'], defaultValue: const []),
          adminIds: fromEJson(ejson['adminIds'], defaultValue: const []),
          memberCount: fromEJson(ejson['memberCount'], defaultValue: 0),
          visibility: fromEJson(ejson['visibility'], defaultValue: 'public'),
          joinType: fromEJson(ejson['joinType'], defaultValue: 'open'),
          allowMemberPosts:
              fromEJson(ejson['allowMemberPosts'], defaultValue: true),
          postCount: fromEJson(ejson['postCount'], defaultValue: 0),
          activeThisWeek: fromEJson(ejson['activeThisWeek'], defaultValue: 0),
          updatedAt: fromEJson(ejson['updatedAt']),
          lastSyncedAt: fromEJson(ejson['lastSyncedAt']),
          needsSync: fromEJson(ejson['needsSync'], defaultValue: false),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Group._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Group, 'Group', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('avatarUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('coverImageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('ownerId', RealmPropertyType.string),
      SchemaProperty('memberIds', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('adminIds', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('memberCount', RealmPropertyType.int),
      SchemaProperty('visibility', RealmPropertyType.string),
      SchemaProperty('joinType', RealmPropertyType.string),
      SchemaProperty('allowMemberPosts', RealmPropertyType.bool),
      SchemaProperty('postCount', RealmPropertyType.int),
      SchemaProperty('activeThisWeek', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lastSyncedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('needsSync', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
