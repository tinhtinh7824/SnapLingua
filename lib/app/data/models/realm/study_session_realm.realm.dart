// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class StudySession extends _StudySession
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  StudySession(
    ObjectId id,
    String userId,
    DateTime startedAt,
    DateTime createdAt, {
    String sessionType = 'review',
    int wordsStudied = 0,
    int correctAnswers = 0,
    int wrongAnswers = 0,
    int durationSeconds = 0,
    int xpEarned = 0,
    DateTime? completedAt,
    DateTime? lastSyncedAt,
    bool needsSync = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<StudySession>({
        'sessionType': 'review',
        'wordsStudied': 0,
        'correctAnswers': 0,
        'wrongAnswers': 0,
        'durationSeconds': 0,
        'xpEarned': 0,
        'needsSync': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'sessionType', sessionType);
    RealmObjectBase.set(this, 'wordsStudied', wordsStudied);
    RealmObjectBase.set(this, 'correctAnswers', correctAnswers);
    RealmObjectBase.set(this, 'wrongAnswers', wrongAnswers);
    RealmObjectBase.set(this, 'durationSeconds', durationSeconds);
    RealmObjectBase.set(this, 'xpEarned', xpEarned);
    RealmObjectBase.set(this, 'startedAt', startedAt);
    RealmObjectBase.set(this, 'completedAt', completedAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastSyncedAt', lastSyncedAt);
    RealmObjectBase.set(this, 'needsSync', needsSync);
  }

  StudySession._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get sessionType =>
      RealmObjectBase.get<String>(this, 'sessionType') as String;
  @override
  set sessionType(String value) =>
      RealmObjectBase.set(this, 'sessionType', value);

  @override
  int get wordsStudied => RealmObjectBase.get<int>(this, 'wordsStudied') as int;
  @override
  set wordsStudied(int value) =>
      RealmObjectBase.set(this, 'wordsStudied', value);

  @override
  int get correctAnswers =>
      RealmObjectBase.get<int>(this, 'correctAnswers') as int;
  @override
  set correctAnswers(int value) =>
      RealmObjectBase.set(this, 'correctAnswers', value);

  @override
  int get wrongAnswers => RealmObjectBase.get<int>(this, 'wrongAnswers') as int;
  @override
  set wrongAnswers(int value) =>
      RealmObjectBase.set(this, 'wrongAnswers', value);

  @override
  int get durationSeconds =>
      RealmObjectBase.get<int>(this, 'durationSeconds') as int;
  @override
  set durationSeconds(int value) =>
      RealmObjectBase.set(this, 'durationSeconds', value);

  @override
  int get xpEarned => RealmObjectBase.get<int>(this, 'xpEarned') as int;
  @override
  set xpEarned(int value) => RealmObjectBase.set(this, 'xpEarned', value);

  @override
  DateTime get startedAt =>
      RealmObjectBase.get<DateTime>(this, 'startedAt') as DateTime;
  @override
  set startedAt(DateTime value) =>
      RealmObjectBase.set(this, 'startedAt', value);

  @override
  DateTime? get completedAt =>
      RealmObjectBase.get<DateTime>(this, 'completedAt') as DateTime?;
  @override
  set completedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'completedAt', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

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
  Stream<RealmObjectChanges<StudySession>> get changes =>
      RealmObjectBase.getChanges<StudySession>(this);

  @override
  Stream<RealmObjectChanges<StudySession>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<StudySession>(this, keyPaths);

  @override
  StudySession freeze() => RealmObjectBase.freezeObject<StudySession>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'userId': userId.toEJson(),
      'sessionType': sessionType.toEJson(),
      'wordsStudied': wordsStudied.toEJson(),
      'correctAnswers': correctAnswers.toEJson(),
      'wrongAnswers': wrongAnswers.toEJson(),
      'durationSeconds': durationSeconds.toEJson(),
      'xpEarned': xpEarned.toEJson(),
      'startedAt': startedAt.toEJson(),
      'completedAt': completedAt.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastSyncedAt': lastSyncedAt.toEJson(),
      'needsSync': needsSync.toEJson(),
    };
  }

  static EJsonValue _toEJson(StudySession value) => value.toEJson();
  static StudySession _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'userId': EJsonValue userId,
        'startedAt': EJsonValue startedAt,
        'createdAt': EJsonValue createdAt,
      } =>
        StudySession(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(startedAt),
          fromEJson(createdAt),
          sessionType: fromEJson(ejson['sessionType'], defaultValue: 'review'),
          wordsStudied: fromEJson(ejson['wordsStudied'], defaultValue: 0),
          correctAnswers: fromEJson(ejson['correctAnswers'], defaultValue: 0),
          wrongAnswers: fromEJson(ejson['wrongAnswers'], defaultValue: 0),
          durationSeconds: fromEJson(ejson['durationSeconds'], defaultValue: 0),
          xpEarned: fromEJson(ejson['xpEarned'], defaultValue: 0),
          completedAt: fromEJson(ejson['completedAt']),
          lastSyncedAt: fromEJson(ejson['lastSyncedAt']),
          needsSync: fromEJson(ejson['needsSync'], defaultValue: false),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(StudySession._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, StudySession, 'StudySession', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('sessionType', RealmPropertyType.string),
      SchemaProperty('wordsStudied', RealmPropertyType.int),
      SchemaProperty('correctAnswers', RealmPropertyType.int),
      SchemaProperty('wrongAnswers', RealmPropertyType.int),
      SchemaProperty('durationSeconds', RealmPropertyType.int),
      SchemaProperty('xpEarned', RealmPropertyType.int),
      SchemaProperty('startedAt', RealmPropertyType.timestamp),
      SchemaProperty('completedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastSyncedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('needsSync', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
