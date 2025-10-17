// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Word extends _Word with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Word(
    ObjectId id,
    String headword,
    String normalizedHeadword,
    String meaningVi,
    DateTime createdAt, {
    String? ipa,
    String? pos,
    String? exampleEn,
    String? exampleVi,
    String? audioUrl,
    String? imageUrl,
    String createdBy = 'system',
    DateTime? lastSyncedAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Word>({
        'createdBy': 'system',
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'headword', headword);
    RealmObjectBase.set(this, 'normalizedHeadword', normalizedHeadword);
    RealmObjectBase.set(this, 'ipa', ipa);
    RealmObjectBase.set(this, 'pos', pos);
    RealmObjectBase.set(this, 'meaningVi', meaningVi);
    RealmObjectBase.set(this, 'exampleEn', exampleEn);
    RealmObjectBase.set(this, 'exampleVi', exampleVi);
    RealmObjectBase.set(this, 'audioUrl', audioUrl);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'createdBy', createdBy);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastSyncedAt', lastSyncedAt);
  }

  Word._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get headword =>
      RealmObjectBase.get<String>(this, 'headword') as String;
  @override
  set headword(String value) => RealmObjectBase.set(this, 'headword', value);

  @override
  String get normalizedHeadword =>
      RealmObjectBase.get<String>(this, 'normalizedHeadword') as String;
  @override
  set normalizedHeadword(String value) =>
      RealmObjectBase.set(this, 'normalizedHeadword', value);

  @override
  String? get ipa => RealmObjectBase.get<String>(this, 'ipa') as String?;
  @override
  set ipa(String? value) => RealmObjectBase.set(this, 'ipa', value);

  @override
  String? get pos => RealmObjectBase.get<String>(this, 'pos') as String?;
  @override
  set pos(String? value) => RealmObjectBase.set(this, 'pos', value);

  @override
  String get meaningVi =>
      RealmObjectBase.get<String>(this, 'meaningVi') as String;
  @override
  set meaningVi(String value) => RealmObjectBase.set(this, 'meaningVi', value);

  @override
  String? get exampleEn =>
      RealmObjectBase.get<String>(this, 'exampleEn') as String?;
  @override
  set exampleEn(String? value) => RealmObjectBase.set(this, 'exampleEn', value);

  @override
  String? get exampleVi =>
      RealmObjectBase.get<String>(this, 'exampleVi') as String?;
  @override
  set exampleVi(String? value) => RealmObjectBase.set(this, 'exampleVi', value);

  @override
  String? get audioUrl =>
      RealmObjectBase.get<String>(this, 'audioUrl') as String?;
  @override
  set audioUrl(String? value) => RealmObjectBase.set(this, 'audioUrl', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  String get createdBy =>
      RealmObjectBase.get<String>(this, 'createdBy') as String;
  @override
  set createdBy(String value) => RealmObjectBase.set(this, 'createdBy', value);

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
  Stream<RealmObjectChanges<Word>> get changes =>
      RealmObjectBase.getChanges<Word>(this);

  @override
  Stream<RealmObjectChanges<Word>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Word>(this, keyPaths);

  @override
  Word freeze() => RealmObjectBase.freezeObject<Word>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'headword': headword.toEJson(),
      'normalizedHeadword': normalizedHeadword.toEJson(),
      'ipa': ipa.toEJson(),
      'pos': pos.toEJson(),
      'meaningVi': meaningVi.toEJson(),
      'exampleEn': exampleEn.toEJson(),
      'exampleVi': exampleVi.toEJson(),
      'audioUrl': audioUrl.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'createdBy': createdBy.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastSyncedAt': lastSyncedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Word value) => value.toEJson();
  static Word _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'headword': EJsonValue headword,
        'normalizedHeadword': EJsonValue normalizedHeadword,
        'meaningVi': EJsonValue meaningVi,
        'createdAt': EJsonValue createdAt,
      } =>
        Word(
          fromEJson(id),
          fromEJson(headword),
          fromEJson(normalizedHeadword),
          fromEJson(meaningVi),
          fromEJson(createdAt),
          ipa: fromEJson(ejson['ipa']),
          pos: fromEJson(ejson['pos']),
          exampleEn: fromEJson(ejson['exampleEn']),
          exampleVi: fromEJson(ejson['exampleVi']),
          audioUrl: fromEJson(ejson['audioUrl']),
          imageUrl: fromEJson(ejson['imageUrl']),
          createdBy: fromEJson(ejson['createdBy'], defaultValue: 'system'),
          lastSyncedAt: fromEJson(ejson['lastSyncedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Word._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Word, 'Word', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('headword', RealmPropertyType.string),
      SchemaProperty('normalizedHeadword', RealmPropertyType.string),
      SchemaProperty('ipa', RealmPropertyType.string, optional: true),
      SchemaProperty('pos', RealmPropertyType.string, optional: true),
      SchemaProperty('meaningVi', RealmPropertyType.string),
      SchemaProperty('exampleEn', RealmPropertyType.string, optional: true),
      SchemaProperty('exampleVi', RealmPropertyType.string, optional: true),
      SchemaProperty('audioUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('createdBy', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastSyncedAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
