// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SurveyResponse extends _SurveyResponse
    with RealmEntity, RealmObjectBase, RealmObject {
  SurveyResponse(
    String id,
    String userId,
    DateTime completedAt,
    DateTime createdAt, {
    String? name,
    String? gender,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
    String? purpose,
    String? studyTime,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'birthDay', birthDay);
    RealmObjectBase.set(this, 'birthMonth', birthMonth);
    RealmObjectBase.set(this, 'birthYear', birthYear);
    RealmObjectBase.set(this, 'purpose', purpose);
    RealmObjectBase.set(this, 'studyTime', studyTime);
    RealmObjectBase.set(this, 'completedAt', completedAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  SurveyResponse._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get gender => RealmObjectBase.get<String>(this, 'gender') as String?;
  @override
  set gender(String? value) => RealmObjectBase.set(this, 'gender', value);

  @override
  String? get birthDay =>
      RealmObjectBase.get<String>(this, 'birthDay') as String?;
  @override
  set birthDay(String? value) => RealmObjectBase.set(this, 'birthDay', value);

  @override
  String? get birthMonth =>
      RealmObjectBase.get<String>(this, 'birthMonth') as String?;
  @override
  set birthMonth(String? value) =>
      RealmObjectBase.set(this, 'birthMonth', value);

  @override
  String? get birthYear =>
      RealmObjectBase.get<String>(this, 'birthYear') as String?;
  @override
  set birthYear(String? value) => RealmObjectBase.set(this, 'birthYear', value);

  @override
  String? get purpose =>
      RealmObjectBase.get<String>(this, 'purpose') as String?;
  @override
  set purpose(String? value) => RealmObjectBase.set(this, 'purpose', value);

  @override
  String? get studyTime =>
      RealmObjectBase.get<String>(this, 'studyTime') as String?;
  @override
  set studyTime(String? value) => RealmObjectBase.set(this, 'studyTime', value);

  @override
  DateTime get completedAt =>
      RealmObjectBase.get<DateTime>(this, 'completedAt') as DateTime;
  @override
  set completedAt(DateTime value) =>
      RealmObjectBase.set(this, 'completedAt', value);

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
  Stream<RealmObjectChanges<SurveyResponse>> get changes =>
      RealmObjectBase.getChanges<SurveyResponse>(this);

  @override
  Stream<RealmObjectChanges<SurveyResponse>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SurveyResponse>(this, keyPaths);

  @override
  SurveyResponse freeze() => RealmObjectBase.freezeObject<SurveyResponse>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'name': name.toEJson(),
      'gender': gender.toEJson(),
      'birthDay': birthDay.toEJson(),
      'birthMonth': birthMonth.toEJson(),
      'birthYear': birthYear.toEJson(),
      'purpose': purpose.toEJson(),
      'studyTime': studyTime.toEJson(),
      'completedAt': completedAt.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(SurveyResponse value) => value.toEJson();
  static SurveyResponse _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'completedAt': EJsonValue completedAt,
        'createdAt': EJsonValue createdAt,
      } =>
        SurveyResponse(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(completedAt),
          fromEJson(createdAt),
          name: fromEJson(ejson['name']),
          gender: fromEJson(ejson['gender']),
          birthDay: fromEJson(ejson['birthDay']),
          birthMonth: fromEJson(ejson['birthMonth']),
          birthYear: fromEJson(ejson['birthYear']),
          purpose: fromEJson(ejson['purpose']),
          studyTime: fromEJson(ejson['studyTime']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SurveyResponse._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, SurveyResponse, 'SurveyResponse', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('gender', RealmPropertyType.string, optional: true),
      SchemaProperty('birthDay', RealmPropertyType.string, optional: true),
      SchemaProperty('birthMonth', RealmPropertyType.string, optional: true),
      SchemaProperty('birthYear', RealmPropertyType.string, optional: true),
      SchemaProperty('purpose', RealmPropertyType.string, optional: true),
      SchemaProperty('studyTime', RealmPropertyType.string, optional: true),
      SchemaProperty('completedAt', RealmPropertyType.timestamp),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
