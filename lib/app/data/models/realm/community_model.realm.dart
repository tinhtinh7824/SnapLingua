// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class StudyGroup extends _StudyGroup
    with RealmEntity, RealmObjectBase, RealmObject {
  StudyGroup(
    String id,
    String name,
    String creatorId,
    int memberLimit,
    int currentMembers,
    String joinType,
    bool isActive,
    DateTime createdAt, {
    String? description,
    String? imageUrl,
    String? joinCode,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'creatorId', creatorId);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'memberLimit', memberLimit);
    RealmObjectBase.set(this, 'currentMembers', currentMembers);
    RealmObjectBase.set(this, 'joinType', joinType);
    RealmObjectBase.set(this, 'joinCode', joinCode);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  StudyGroup._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

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
  String get creatorId =>
      RealmObjectBase.get<String>(this, 'creatorId') as String;
  @override
  set creatorId(String value) => RealmObjectBase.set(this, 'creatorId', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  int get memberLimit => RealmObjectBase.get<int>(this, 'memberLimit') as int;
  @override
  set memberLimit(int value) => RealmObjectBase.set(this, 'memberLimit', value);

  @override
  int get currentMembers =>
      RealmObjectBase.get<int>(this, 'currentMembers') as int;
  @override
  set currentMembers(int value) =>
      RealmObjectBase.set(this, 'currentMembers', value);

  @override
  String get joinType =>
      RealmObjectBase.get<String>(this, 'joinType') as String;
  @override
  set joinType(String value) => RealmObjectBase.set(this, 'joinType', value);

  @override
  String? get joinCode =>
      RealmObjectBase.get<String>(this, 'joinCode') as String?;
  @override
  set joinCode(String? value) => RealmObjectBase.set(this, 'joinCode', value);

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
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<StudyGroup>> get changes =>
      RealmObjectBase.getChanges<StudyGroup>(this);

  @override
  Stream<RealmObjectChanges<StudyGroup>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<StudyGroup>(this, keyPaths);

  @override
  StudyGroup freeze() => RealmObjectBase.freezeObject<StudyGroup>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'creatorId': creatorId.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'memberLimit': memberLimit.toEJson(),
      'currentMembers': currentMembers.toEJson(),
      'joinType': joinType.toEJson(),
      'joinCode': joinCode.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(StudyGroup value) => value.toEJson();
  static StudyGroup _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'creatorId': EJsonValue creatorId,
        'memberLimit': EJsonValue memberLimit,
        'currentMembers': EJsonValue currentMembers,
        'joinType': EJsonValue joinType,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        StudyGroup(
          fromEJson(id),
          fromEJson(name),
          fromEJson(creatorId),
          fromEJson(memberLimit),
          fromEJson(currentMembers),
          fromEJson(joinType),
          fromEJson(isActive),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
          imageUrl: fromEJson(ejson['imageUrl']),
          joinCode: fromEJson(ejson['joinCode']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(StudyGroup._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, StudyGroup, 'StudyGroup', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('creatorId', RealmPropertyType.string),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('memberLimit', RealmPropertyType.int),
      SchemaProperty('currentMembers', RealmPropertyType.int),
      SchemaProperty('joinType', RealmPropertyType.string),
      SchemaProperty('joinCode', RealmPropertyType.string, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class StudyGroupMember extends _StudyGroupMember
    with RealmEntity, RealmObjectBase, RealmObject {
  StudyGroupMember(
    String id,
    String studyGroupId,
    String userId,
    String role,
    DateTime joinedAt,
    bool isActive, {
    DateTime? lastActiveAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'studyGroupId', studyGroupId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'joinedAt', joinedAt);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'lastActiveAt', lastActiveAt);
  }

  StudyGroupMember._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get studyGroupId =>
      RealmObjectBase.get<String>(this, 'studyGroupId') as String;
  @override
  set studyGroupId(String value) =>
      RealmObjectBase.set(this, 'studyGroupId', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get role => RealmObjectBase.get<String>(this, 'role') as String;
  @override
  set role(String value) => RealmObjectBase.set(this, 'role', value);

  @override
  DateTime get joinedAt =>
      RealmObjectBase.get<DateTime>(this, 'joinedAt') as DateTime;
  @override
  set joinedAt(DateTime value) => RealmObjectBase.set(this, 'joinedAt', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  DateTime? get lastActiveAt =>
      RealmObjectBase.get<DateTime>(this, 'lastActiveAt') as DateTime?;
  @override
  set lastActiveAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastActiveAt', value);

  @override
  Stream<RealmObjectChanges<StudyGroupMember>> get changes =>
      RealmObjectBase.getChanges<StudyGroupMember>(this);

  @override
  Stream<RealmObjectChanges<StudyGroupMember>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<StudyGroupMember>(this, keyPaths);

  @override
  StudyGroupMember freeze() =>
      RealmObjectBase.freezeObject<StudyGroupMember>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'studyGroupId': studyGroupId.toEJson(),
      'userId': userId.toEJson(),
      'role': role.toEJson(),
      'joinedAt': joinedAt.toEJson(),
      'isActive': isActive.toEJson(),
      'lastActiveAt': lastActiveAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(StudyGroupMember value) => value.toEJson();
  static StudyGroupMember _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'studyGroupId': EJsonValue studyGroupId,
        'userId': EJsonValue userId,
        'role': EJsonValue role,
        'joinedAt': EJsonValue joinedAt,
        'isActive': EJsonValue isActive,
      } =>
        StudyGroupMember(
          fromEJson(id),
          fromEJson(studyGroupId),
          fromEJson(userId),
          fromEJson(role),
          fromEJson(joinedAt),
          fromEJson(isActive),
          lastActiveAt: fromEJson(ejson['lastActiveAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(StudyGroupMember._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, StudyGroupMember, 'StudyGroupMember', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('studyGroupId', RealmPropertyType.string),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('joinedAt', RealmPropertyType.timestamp),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('lastActiveAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class StudyGroupMessage extends _StudyGroupMessage
    with RealmEntity, RealmObjectBase, RealmObject {
  StudyGroupMessage(
    String id,
    String studyGroupId,
    String senderId,
    String messageType,
    String content,
    DateTime sentAt,
    bool isEdited,
    bool isDeleted, {
    String? metadata,
    DateTime? editedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'studyGroupId', studyGroupId);
    RealmObjectBase.set(this, 'senderId', senderId);
    RealmObjectBase.set(this, 'messageType', messageType);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'metadata', metadata);
    RealmObjectBase.set(this, 'sentAt', sentAt);
    RealmObjectBase.set(this, 'isEdited', isEdited);
    RealmObjectBase.set(this, 'editedAt', editedAt);
    RealmObjectBase.set(this, 'isDeleted', isDeleted);
  }

  StudyGroupMessage._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get studyGroupId =>
      RealmObjectBase.get<String>(this, 'studyGroupId') as String;
  @override
  set studyGroupId(String value) =>
      RealmObjectBase.set(this, 'studyGroupId', value);

  @override
  String get senderId =>
      RealmObjectBase.get<String>(this, 'senderId') as String;
  @override
  set senderId(String value) => RealmObjectBase.set(this, 'senderId', value);

  @override
  String get messageType =>
      RealmObjectBase.get<String>(this, 'messageType') as String;
  @override
  set messageType(String value) =>
      RealmObjectBase.set(this, 'messageType', value);

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  String? get metadata =>
      RealmObjectBase.get<String>(this, 'metadata') as String?;
  @override
  set metadata(String? value) => RealmObjectBase.set(this, 'metadata', value);

  @override
  DateTime get sentAt =>
      RealmObjectBase.get<DateTime>(this, 'sentAt') as DateTime;
  @override
  set sentAt(DateTime value) => RealmObjectBase.set(this, 'sentAt', value);

  @override
  bool get isEdited => RealmObjectBase.get<bool>(this, 'isEdited') as bool;
  @override
  set isEdited(bool value) => RealmObjectBase.set(this, 'isEdited', value);

  @override
  DateTime? get editedAt =>
      RealmObjectBase.get<DateTime>(this, 'editedAt') as DateTime?;
  @override
  set editedAt(DateTime? value) => RealmObjectBase.set(this, 'editedAt', value);

  @override
  bool get isDeleted => RealmObjectBase.get<bool>(this, 'isDeleted') as bool;
  @override
  set isDeleted(bool value) => RealmObjectBase.set(this, 'isDeleted', value);

  @override
  Stream<RealmObjectChanges<StudyGroupMessage>> get changes =>
      RealmObjectBase.getChanges<StudyGroupMessage>(this);

  @override
  Stream<RealmObjectChanges<StudyGroupMessage>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<StudyGroupMessage>(this, keyPaths);

  @override
  StudyGroupMessage freeze() =>
      RealmObjectBase.freezeObject<StudyGroupMessage>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'studyGroupId': studyGroupId.toEJson(),
      'senderId': senderId.toEJson(),
      'messageType': messageType.toEJson(),
      'content': content.toEJson(),
      'metadata': metadata.toEJson(),
      'sentAt': sentAt.toEJson(),
      'isEdited': isEdited.toEJson(),
      'editedAt': editedAt.toEJson(),
      'isDeleted': isDeleted.toEJson(),
    };
  }

  static EJsonValue _toEJson(StudyGroupMessage value) => value.toEJson();
  static StudyGroupMessage _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'studyGroupId': EJsonValue studyGroupId,
        'senderId': EJsonValue senderId,
        'messageType': EJsonValue messageType,
        'content': EJsonValue content,
        'sentAt': EJsonValue sentAt,
        'isEdited': EJsonValue isEdited,
        'isDeleted': EJsonValue isDeleted,
      } =>
        StudyGroupMessage(
          fromEJson(id),
          fromEJson(studyGroupId),
          fromEJson(senderId),
          fromEJson(messageType),
          fromEJson(content),
          fromEJson(sentAt),
          fromEJson(isEdited),
          fromEJson(isDeleted),
          metadata: fromEJson(ejson['metadata']),
          editedAt: fromEJson(ejson['editedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(StudyGroupMessage._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, StudyGroupMessage, 'StudyGroupMessage', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('studyGroupId', RealmPropertyType.string),
      SchemaProperty('senderId', RealmPropertyType.string),
      SchemaProperty('messageType', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('metadata', RealmPropertyType.string, optional: true),
      SchemaProperty('sentAt', RealmPropertyType.timestamp),
      SchemaProperty('isEdited', RealmPropertyType.bool),
      SchemaProperty('editedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('isDeleted', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Friend extends _Friend with RealmEntity, RealmObjectBase, RealmObject {
  Friend(
    String id,
    String userId,
    String friendId,
    String status,
    DateTime requestedAt, {
    DateTime? acceptedAt,
    DateTime? lastInteractionAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'friendId', friendId);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'requestedAt', requestedAt);
    RealmObjectBase.set(this, 'acceptedAt', acceptedAt);
    RealmObjectBase.set(this, 'lastInteractionAt', lastInteractionAt);
  }

  Friend._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get friendId =>
      RealmObjectBase.get<String>(this, 'friendId') as String;
  @override
  set friendId(String value) => RealmObjectBase.set(this, 'friendId', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get requestedAt =>
      RealmObjectBase.get<DateTime>(this, 'requestedAt') as DateTime;
  @override
  set requestedAt(DateTime value) =>
      RealmObjectBase.set(this, 'requestedAt', value);

  @override
  DateTime? get acceptedAt =>
      RealmObjectBase.get<DateTime>(this, 'acceptedAt') as DateTime?;
  @override
  set acceptedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'acceptedAt', value);

  @override
  DateTime? get lastInteractionAt =>
      RealmObjectBase.get<DateTime>(this, 'lastInteractionAt') as DateTime?;
  @override
  set lastInteractionAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastInteractionAt', value);

  @override
  Stream<RealmObjectChanges<Friend>> get changes =>
      RealmObjectBase.getChanges<Friend>(this);

  @override
  Stream<RealmObjectChanges<Friend>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Friend>(this, keyPaths);

  @override
  Friend freeze() => RealmObjectBase.freezeObject<Friend>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'friendId': friendId.toEJson(),
      'status': status.toEJson(),
      'requestedAt': requestedAt.toEJson(),
      'acceptedAt': acceptedAt.toEJson(),
      'lastInteractionAt': lastInteractionAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Friend value) => value.toEJson();
  static Friend _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'friendId': EJsonValue friendId,
        'status': EJsonValue status,
        'requestedAt': EJsonValue requestedAt,
      } =>
        Friend(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(friendId),
          fromEJson(status),
          fromEJson(requestedAt),
          acceptedAt: fromEJson(ejson['acceptedAt']),
          lastInteractionAt: fromEJson(ejson['lastInteractionAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Friend._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Friend, 'Friend', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('friendId', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('requestedAt', RealmPropertyType.timestamp),
      SchemaProperty('acceptedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lastInteractionAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserSession extends _UserSession
    with RealmEntity, RealmObjectBase, RealmObject {
  UserSession(
    String id,
    String userId,
    DateTime startTime,
    int xpEarned,
    int wordsLearned,
    int lessonsCompleted,
    int timeSpentMinutes, {
    DateTime? endTime,
    String? activityType,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'startTime', startTime);
    RealmObjectBase.set(this, 'endTime', endTime);
    RealmObjectBase.set(this, 'xpEarned', xpEarned);
    RealmObjectBase.set(this, 'wordsLearned', wordsLearned);
    RealmObjectBase.set(this, 'lessonsCompleted', lessonsCompleted);
    RealmObjectBase.set(this, 'timeSpentMinutes', timeSpentMinutes);
    RealmObjectBase.set(this, 'activityType', activityType);
  }

  UserSession._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  DateTime get startTime =>
      RealmObjectBase.get<DateTime>(this, 'startTime') as DateTime;
  @override
  set startTime(DateTime value) =>
      RealmObjectBase.set(this, 'startTime', value);

  @override
  DateTime? get endTime =>
      RealmObjectBase.get<DateTime>(this, 'endTime') as DateTime?;
  @override
  set endTime(DateTime? value) => RealmObjectBase.set(this, 'endTime', value);

  @override
  int get xpEarned => RealmObjectBase.get<int>(this, 'xpEarned') as int;
  @override
  set xpEarned(int value) => RealmObjectBase.set(this, 'xpEarned', value);

  @override
  int get wordsLearned => RealmObjectBase.get<int>(this, 'wordsLearned') as int;
  @override
  set wordsLearned(int value) =>
      RealmObjectBase.set(this, 'wordsLearned', value);

  @override
  int get lessonsCompleted =>
      RealmObjectBase.get<int>(this, 'lessonsCompleted') as int;
  @override
  set lessonsCompleted(int value) =>
      RealmObjectBase.set(this, 'lessonsCompleted', value);

  @override
  int get timeSpentMinutes =>
      RealmObjectBase.get<int>(this, 'timeSpentMinutes') as int;
  @override
  set timeSpentMinutes(int value) =>
      RealmObjectBase.set(this, 'timeSpentMinutes', value);

  @override
  String? get activityType =>
      RealmObjectBase.get<String>(this, 'activityType') as String?;
  @override
  set activityType(String? value) =>
      RealmObjectBase.set(this, 'activityType', value);

  @override
  Stream<RealmObjectChanges<UserSession>> get changes =>
      RealmObjectBase.getChanges<UserSession>(this);

  @override
  Stream<RealmObjectChanges<UserSession>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserSession>(this, keyPaths);

  @override
  UserSession freeze() => RealmObjectBase.freezeObject<UserSession>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'startTime': startTime.toEJson(),
      'endTime': endTime.toEJson(),
      'xpEarned': xpEarned.toEJson(),
      'wordsLearned': wordsLearned.toEJson(),
      'lessonsCompleted': lessonsCompleted.toEJson(),
      'timeSpentMinutes': timeSpentMinutes.toEJson(),
      'activityType': activityType.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserSession value) => value.toEJson();
  static UserSession _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'startTime': EJsonValue startTime,
        'xpEarned': EJsonValue xpEarned,
        'wordsLearned': EJsonValue wordsLearned,
        'lessonsCompleted': EJsonValue lessonsCompleted,
        'timeSpentMinutes': EJsonValue timeSpentMinutes,
      } =>
        UserSession(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(startTime),
          fromEJson(xpEarned),
          fromEJson(wordsLearned),
          fromEJson(lessonsCompleted),
          fromEJson(timeSpentMinutes),
          endTime: fromEJson(ejson['endTime']),
          activityType: fromEJson(ejson['activityType']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserSession._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserSession, 'UserSession', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('startTime', RealmPropertyType.timestamp),
      SchemaProperty('endTime', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('xpEarned', RealmPropertyType.int),
      SchemaProperty('wordsLearned', RealmPropertyType.int),
      SchemaProperty('lessonsCompleted', RealmPropertyType.int),
      SchemaProperty('timeSpentMinutes', RealmPropertyType.int),
      SchemaProperty('activityType', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Competition extends _Competition
    with RealmEntity, RealmObjectBase, RealmObject {
  Competition(
    String id,
    String name,
    String description,
    String type,
    DateTime startDate,
    DateTime endDate,
    bool isActive,
    DateTime createdAt, {
    String? rules,
    String? rewards,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'startDate', startDate);
    RealmObjectBase.set(this, 'endDate', endDate);
    RealmObjectBase.set(this, 'rules', rules);
    RealmObjectBase.set(this, 'rewards', rewards);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Competition._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  DateTime get startDate =>
      RealmObjectBase.get<DateTime>(this, 'startDate') as DateTime;
  @override
  set startDate(DateTime value) =>
      RealmObjectBase.set(this, 'startDate', value);

  @override
  DateTime get endDate =>
      RealmObjectBase.get<DateTime>(this, 'endDate') as DateTime;
  @override
  set endDate(DateTime value) => RealmObjectBase.set(this, 'endDate', value);

  @override
  String? get rules => RealmObjectBase.get<String>(this, 'rules') as String?;
  @override
  set rules(String? value) => RealmObjectBase.set(this, 'rules', value);

  @override
  String? get rewards =>
      RealmObjectBase.get<String>(this, 'rewards') as String?;
  @override
  set rewards(String? value) => RealmObjectBase.set(this, 'rewards', value);

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
  Stream<RealmObjectChanges<Competition>> get changes =>
      RealmObjectBase.getChanges<Competition>(this);

  @override
  Stream<RealmObjectChanges<Competition>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Competition>(this, keyPaths);

  @override
  Competition freeze() => RealmObjectBase.freezeObject<Competition>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'type': type.toEJson(),
      'startDate': startDate.toEJson(),
      'endDate': endDate.toEJson(),
      'rules': rules.toEJson(),
      'rewards': rewards.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Competition value) => value.toEJson();
  static Competition _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'type': EJsonValue type,
        'startDate': EJsonValue startDate,
        'endDate': EJsonValue endDate,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        Competition(
          fromEJson(id),
          fromEJson(name),
          fromEJson(description),
          fromEJson(type),
          fromEJson(startDate),
          fromEJson(endDate),
          fromEJson(isActive),
          fromEJson(createdAt),
          rules: fromEJson(ejson['rules']),
          rewards: fromEJson(ejson['rewards']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Competition._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, Competition, 'Competition', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('startDate', RealmPropertyType.timestamp),
      SchemaProperty('endDate', RealmPropertyType.timestamp),
      SchemaProperty('rules', RealmPropertyType.string, optional: true),
      SchemaProperty('rewards', RealmPropertyType.string, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CompetitionParticipant extends _CompetitionParticipant
    with RealmEntity, RealmObjectBase, RealmObject {
  CompetitionParticipant(
    String id,
    String competitionId,
    String userId,
    int score,
    int rank,
    DateTime joinedAt, {
    DateTime? lastUpdateAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'competitionId', competitionId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'score', score);
    RealmObjectBase.set(this, 'rank', rank);
    RealmObjectBase.set(this, 'joinedAt', joinedAt);
    RealmObjectBase.set(this, 'lastUpdateAt', lastUpdateAt);
  }

  CompetitionParticipant._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get competitionId =>
      RealmObjectBase.get<String>(this, 'competitionId') as String;
  @override
  set competitionId(String value) =>
      RealmObjectBase.set(this, 'competitionId', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  int get score => RealmObjectBase.get<int>(this, 'score') as int;
  @override
  set score(int value) => RealmObjectBase.set(this, 'score', value);

  @override
  int get rank => RealmObjectBase.get<int>(this, 'rank') as int;
  @override
  set rank(int value) => RealmObjectBase.set(this, 'rank', value);

  @override
  DateTime get joinedAt =>
      RealmObjectBase.get<DateTime>(this, 'joinedAt') as DateTime;
  @override
  set joinedAt(DateTime value) => RealmObjectBase.set(this, 'joinedAt', value);

  @override
  DateTime? get lastUpdateAt =>
      RealmObjectBase.get<DateTime>(this, 'lastUpdateAt') as DateTime?;
  @override
  set lastUpdateAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastUpdateAt', value);

  @override
  Stream<RealmObjectChanges<CompetitionParticipant>> get changes =>
      RealmObjectBase.getChanges<CompetitionParticipant>(this);

  @override
  Stream<RealmObjectChanges<CompetitionParticipant>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CompetitionParticipant>(this, keyPaths);

  @override
  CompetitionParticipant freeze() =>
      RealmObjectBase.freezeObject<CompetitionParticipant>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'competitionId': competitionId.toEJson(),
      'userId': userId.toEJson(),
      'score': score.toEJson(),
      'rank': rank.toEJson(),
      'joinedAt': joinedAt.toEJson(),
      'lastUpdateAt': lastUpdateAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(CompetitionParticipant value) => value.toEJson();
  static CompetitionParticipant _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'competitionId': EJsonValue competitionId,
        'userId': EJsonValue userId,
        'score': EJsonValue score,
        'rank': EJsonValue rank,
        'joinedAt': EJsonValue joinedAt,
      } =>
        CompetitionParticipant(
          fromEJson(id),
          fromEJson(competitionId),
          fromEJson(userId),
          fromEJson(score),
          fromEJson(rank),
          fromEJson(joinedAt),
          lastUpdateAt: fromEJson(ejson['lastUpdateAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CompetitionParticipant._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, CompetitionParticipant,
        'CompetitionParticipant', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('competitionId', RealmPropertyType.string),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('score', RealmPropertyType.int),
      SchemaProperty('rank', RealmPropertyType.int),
      SchemaProperty('joinedAt', RealmPropertyType.timestamp),
      SchemaProperty('lastUpdateAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
