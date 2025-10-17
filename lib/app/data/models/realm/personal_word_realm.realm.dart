// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_word_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class PersonalWord extends _PersonalWord
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  PersonalWord(
    ObjectId id,
    String userId,
    DateTime srsDueAt,
    DateTime createdAt, {
    String? wordId,
    String? customHeadword,
    String? customIpa,
    String? customMeaningVi,
    String status = 'learning',
    String source = 'camera',
    String? sourcePhotoUrl,
    int srsStage = 0,
    double srsEase = 2.5,
    int srsInterval = 1,
    int repetitions = 0,
    int wrongStreak = 0,
    int forgetCount = 0,
    DateTime? lastReviewedAt,
    Iterable<String> topicIds = const [],
    DateTime? lastSyncedAt,
    bool needsSync = false,
    String? conflictResolution,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<PersonalWord>({
        'status': 'learning',
        'source': 'camera',
        'srsStage': 0,
        'srsEase': 2.5,
        'srsInterval': 1,
        'repetitions': 0,
        'wrongStreak': 0,
        'forgetCount': 0,
        'needsSync': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'wordId', wordId);
    RealmObjectBase.set(this, 'customHeadword', customHeadword);
    RealmObjectBase.set(this, 'customIpa', customIpa);
    RealmObjectBase.set(this, 'customMeaningVi', customMeaningVi);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'source', source);
    RealmObjectBase.set(this, 'sourcePhotoUrl', sourcePhotoUrl);
    RealmObjectBase.set(this, 'srsStage', srsStage);
    RealmObjectBase.set(this, 'srsEase', srsEase);
    RealmObjectBase.set(this, 'srsInterval', srsInterval);
    RealmObjectBase.set(this, 'srsDueAt', srsDueAt);
    RealmObjectBase.set(this, 'repetitions', repetitions);
    RealmObjectBase.set(this, 'wrongStreak', wrongStreak);
    RealmObjectBase.set(this, 'forgetCount', forgetCount);
    RealmObjectBase.set(this, 'lastReviewedAt', lastReviewedAt);
    RealmObjectBase.set<RealmList<String>>(
        this, 'topicIds', RealmList<String>(topicIds));
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastSyncedAt', lastSyncedAt);
    RealmObjectBase.set(this, 'needsSync', needsSync);
    RealmObjectBase.set(this, 'conflictResolution', conflictResolution);
  }

  PersonalWord._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get wordId => RealmObjectBase.get<String>(this, 'wordId') as String?;
  @override
  set wordId(String? value) => RealmObjectBase.set(this, 'wordId', value);

  @override
  String? get customHeadword =>
      RealmObjectBase.get<String>(this, 'customHeadword') as String?;
  @override
  set customHeadword(String? value) =>
      RealmObjectBase.set(this, 'customHeadword', value);

  @override
  String? get customIpa =>
      RealmObjectBase.get<String>(this, 'customIpa') as String?;
  @override
  set customIpa(String? value) => RealmObjectBase.set(this, 'customIpa', value);

  @override
  String? get customMeaningVi =>
      RealmObjectBase.get<String>(this, 'customMeaningVi') as String?;
  @override
  set customMeaningVi(String? value) =>
      RealmObjectBase.set(this, 'customMeaningVi', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  String get source => RealmObjectBase.get<String>(this, 'source') as String;
  @override
  set source(String value) => RealmObjectBase.set(this, 'source', value);

  @override
  String? get sourcePhotoUrl =>
      RealmObjectBase.get<String>(this, 'sourcePhotoUrl') as String?;
  @override
  set sourcePhotoUrl(String? value) =>
      RealmObjectBase.set(this, 'sourcePhotoUrl', value);

  @override
  int get srsStage => RealmObjectBase.get<int>(this, 'srsStage') as int;
  @override
  set srsStage(int value) => RealmObjectBase.set(this, 'srsStage', value);

  @override
  double get srsEase => RealmObjectBase.get<double>(this, 'srsEase') as double;
  @override
  set srsEase(double value) => RealmObjectBase.set(this, 'srsEase', value);

  @override
  int get srsInterval => RealmObjectBase.get<int>(this, 'srsInterval') as int;
  @override
  set srsInterval(int value) => RealmObjectBase.set(this, 'srsInterval', value);

  @override
  DateTime get srsDueAt =>
      RealmObjectBase.get<DateTime>(this, 'srsDueAt') as DateTime;
  @override
  set srsDueAt(DateTime value) => RealmObjectBase.set(this, 'srsDueAt', value);

  @override
  int get repetitions => RealmObjectBase.get<int>(this, 'repetitions') as int;
  @override
  set repetitions(int value) => RealmObjectBase.set(this, 'repetitions', value);

  @override
  int get wrongStreak => RealmObjectBase.get<int>(this, 'wrongStreak') as int;
  @override
  set wrongStreak(int value) => RealmObjectBase.set(this, 'wrongStreak', value);

  @override
  int get forgetCount => RealmObjectBase.get<int>(this, 'forgetCount') as int;
  @override
  set forgetCount(int value) => RealmObjectBase.set(this, 'forgetCount', value);

  @override
  DateTime? get lastReviewedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastReviewedAt') as DateTime?;
  @override
  set lastReviewedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastReviewedAt', value);

  @override
  RealmList<String> get topicIds =>
      RealmObjectBase.get<String>(this, 'topicIds') as RealmList<String>;
  @override
  set topicIds(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

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
  String? get conflictResolution =>
      RealmObjectBase.get<String>(this, 'conflictResolution') as String?;
  @override
  set conflictResolution(String? value) =>
      RealmObjectBase.set(this, 'conflictResolution', value);

  @override
  Stream<RealmObjectChanges<PersonalWord>> get changes =>
      RealmObjectBase.getChanges<PersonalWord>(this);

  @override
  Stream<RealmObjectChanges<PersonalWord>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PersonalWord>(this, keyPaths);

  @override
  PersonalWord freeze() => RealmObjectBase.freezeObject<PersonalWord>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'userId': userId.toEJson(),
      'wordId': wordId.toEJson(),
      'customHeadword': customHeadword.toEJson(),
      'customIpa': customIpa.toEJson(),
      'customMeaningVi': customMeaningVi.toEJson(),
      'status': status.toEJson(),
      'source': source.toEJson(),
      'sourcePhotoUrl': sourcePhotoUrl.toEJson(),
      'srsStage': srsStage.toEJson(),
      'srsEase': srsEase.toEJson(),
      'srsInterval': srsInterval.toEJson(),
      'srsDueAt': srsDueAt.toEJson(),
      'repetitions': repetitions.toEJson(),
      'wrongStreak': wrongStreak.toEJson(),
      'forgetCount': forgetCount.toEJson(),
      'lastReviewedAt': lastReviewedAt.toEJson(),
      'topicIds': topicIds.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastSyncedAt': lastSyncedAt.toEJson(),
      'needsSync': needsSync.toEJson(),
      'conflictResolution': conflictResolution.toEJson(),
    };
  }

  static EJsonValue _toEJson(PersonalWord value) => value.toEJson();
  static PersonalWord _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'userId': EJsonValue userId,
        'srsDueAt': EJsonValue srsDueAt,
        'createdAt': EJsonValue createdAt,
      } =>
        PersonalWord(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(srsDueAt),
          fromEJson(createdAt),
          wordId: fromEJson(ejson['wordId']),
          customHeadword: fromEJson(ejson['customHeadword']),
          customIpa: fromEJson(ejson['customIpa']),
          customMeaningVi: fromEJson(ejson['customMeaningVi']),
          status: fromEJson(ejson['status'], defaultValue: 'learning'),
          source: fromEJson(ejson['source'], defaultValue: 'camera'),
          sourcePhotoUrl: fromEJson(ejson['sourcePhotoUrl']),
          srsStage: fromEJson(ejson['srsStage'], defaultValue: 0),
          srsEase: fromEJson(ejson['srsEase'], defaultValue: 2.5),
          srsInterval: fromEJson(ejson['srsInterval'], defaultValue: 1),
          repetitions: fromEJson(ejson['repetitions'], defaultValue: 0),
          wrongStreak: fromEJson(ejson['wrongStreak'], defaultValue: 0),
          forgetCount: fromEJson(ejson['forgetCount'], defaultValue: 0),
          lastReviewedAt: fromEJson(ejson['lastReviewedAt']),
          topicIds: fromEJson(ejson['topicIds'], defaultValue: const []),
          lastSyncedAt: fromEJson(ejson['lastSyncedAt']),
          needsSync: fromEJson(ejson['needsSync'], defaultValue: false),
          conflictResolution: fromEJson(ejson['conflictResolution']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PersonalWord._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PersonalWord, 'PersonalWord', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('wordId', RealmPropertyType.string, optional: true),
      SchemaProperty('customHeadword', RealmPropertyType.string,
          optional: true),
      SchemaProperty('customIpa', RealmPropertyType.string, optional: true),
      SchemaProperty('customMeaningVi', RealmPropertyType.string,
          optional: true),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('source', RealmPropertyType.string),
      SchemaProperty('sourcePhotoUrl', RealmPropertyType.string,
          optional: true),
      SchemaProperty('srsStage', RealmPropertyType.int),
      SchemaProperty('srsEase', RealmPropertyType.double),
      SchemaProperty('srsInterval', RealmPropertyType.int),
      SchemaProperty('srsDueAt', RealmPropertyType.timestamp),
      SchemaProperty('repetitions', RealmPropertyType.int),
      SchemaProperty('wrongStreak', RealmPropertyType.int),
      SchemaProperty('forgetCount', RealmPropertyType.int),
      SchemaProperty('lastReviewedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('topicIds', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastSyncedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('needsSync', RealmPropertyType.bool),
      SchemaProperty('conflictResolution', RealmPropertyType.string,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
