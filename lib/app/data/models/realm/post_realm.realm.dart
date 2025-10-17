// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Post extends _Post with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Post(
    ObjectId id,
    String authorId,
    String content,
    DateTime createdAt, {
    String? authorName,
    String? authorAvatarUrl,
    String? groupId,
    String? imageUrl,
    Iterable<String> likedByUserIds = const [],
    int likeCount = 0,
    int commentCount = 0,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    bool needsSync = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Post>({
        'likeCount': 0,
        'commentCount': 0,
        'needsSync': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'authorId', authorId);
    RealmObjectBase.set(this, 'authorName', authorName);
    RealmObjectBase.set(this, 'authorAvatarUrl', authorAvatarUrl);
    RealmObjectBase.set(this, 'groupId', groupId);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set<RealmList<String>>(
        this, 'likedByUserIds', RealmList<String>(likedByUserIds));
    RealmObjectBase.set(this, 'likeCount', likeCount);
    RealmObjectBase.set(this, 'commentCount', commentCount);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'lastSyncedAt', lastSyncedAt);
    RealmObjectBase.set(this, 'needsSync', needsSync);
  }

  Post._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get authorId =>
      RealmObjectBase.get<String>(this, 'authorId') as String;
  @override
  set authorId(String value) => RealmObjectBase.set(this, 'authorId', value);

  @override
  String? get authorName =>
      RealmObjectBase.get<String>(this, 'authorName') as String?;
  @override
  set authorName(String? value) =>
      RealmObjectBase.set(this, 'authorName', value);

  @override
  String? get authorAvatarUrl =>
      RealmObjectBase.get<String>(this, 'authorAvatarUrl') as String?;
  @override
  set authorAvatarUrl(String? value) =>
      RealmObjectBase.set(this, 'authorAvatarUrl', value);

  @override
  String? get groupId =>
      RealmObjectBase.get<String>(this, 'groupId') as String?;
  @override
  set groupId(String? value) => RealmObjectBase.set(this, 'groupId', value);

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  RealmList<String> get likedByUserIds =>
      RealmObjectBase.get<String>(this, 'likedByUserIds') as RealmList<String>;
  @override
  set likedByUserIds(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  int get likeCount => RealmObjectBase.get<int>(this, 'likeCount') as int;
  @override
  set likeCount(int value) => RealmObjectBase.set(this, 'likeCount', value);

  @override
  int get commentCount => RealmObjectBase.get<int>(this, 'commentCount') as int;
  @override
  set commentCount(int value) =>
      RealmObjectBase.set(this, 'commentCount', value);

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
  Stream<RealmObjectChanges<Post>> get changes =>
      RealmObjectBase.getChanges<Post>(this);

  @override
  Stream<RealmObjectChanges<Post>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Post>(this, keyPaths);

  @override
  Post freeze() => RealmObjectBase.freezeObject<Post>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'authorId': authorId.toEJson(),
      'authorName': authorName.toEJson(),
      'authorAvatarUrl': authorAvatarUrl.toEJson(),
      'groupId': groupId.toEJson(),
      'content': content.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'likedByUserIds': likedByUserIds.toEJson(),
      'likeCount': likeCount.toEJson(),
      'commentCount': commentCount.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'lastSyncedAt': lastSyncedAt.toEJson(),
      'needsSync': needsSync.toEJson(),
    };
  }

  static EJsonValue _toEJson(Post value) => value.toEJson();
  static Post _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'authorId': EJsonValue authorId,
        'content': EJsonValue content,
        'createdAt': EJsonValue createdAt,
      } =>
        Post(
          fromEJson(id),
          fromEJson(authorId),
          fromEJson(content),
          fromEJson(createdAt),
          authorName: fromEJson(ejson['authorName']),
          authorAvatarUrl: fromEJson(ejson['authorAvatarUrl']),
          groupId: fromEJson(ejson['groupId']),
          imageUrl: fromEJson(ejson['imageUrl']),
          likedByUserIds:
              fromEJson(ejson['likedByUserIds'], defaultValue: const []),
          likeCount: fromEJson(ejson['likeCount'], defaultValue: 0),
          commentCount: fromEJson(ejson['commentCount'], defaultValue: 0),
          updatedAt: fromEJson(ejson['updatedAt']),
          lastSyncedAt: fromEJson(ejson['lastSyncedAt']),
          needsSync: fromEJson(ejson['needsSync'], defaultValue: false),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Post._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Post, 'Post', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('authorId', RealmPropertyType.string),
      SchemaProperty('authorName', RealmPropertyType.string, optional: true),
      SchemaProperty('authorAvatarUrl', RealmPropertyType.string,
          optional: true),
      SchemaProperty('groupId', RealmPropertyType.string, optional: true),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('likedByUserIds', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('likeCount', RealmPropertyType.int),
      SchemaProperty('commentCount', RealmPropertyType.int),
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
