// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class CameraSession extends _CameraSession
    with RealmEntity, RealmObjectBase, RealmObject {
  CameraSession(
    String id,
    String userId,
    String status,
    DateTime capturedAt, {
    String? imagePath,
    String? processedImagePath,
    DateTime? processedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'imagePath', imagePath);
    RealmObjectBase.set(this, 'processedImagePath', processedImagePath);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'capturedAt', capturedAt);
    RealmObjectBase.set(this, 'processedAt', processedAt);
  }

  CameraSession._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get imagePath =>
      RealmObjectBase.get<String>(this, 'imagePath') as String?;
  @override
  set imagePath(String? value) => RealmObjectBase.set(this, 'imagePath', value);

  @override
  String? get processedImagePath =>
      RealmObjectBase.get<String>(this, 'processedImagePath') as String?;
  @override
  set processedImagePath(String? value) =>
      RealmObjectBase.set(this, 'processedImagePath', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get capturedAt =>
      RealmObjectBase.get<DateTime>(this, 'capturedAt') as DateTime;
  @override
  set capturedAt(DateTime value) =>
      RealmObjectBase.set(this, 'capturedAt', value);

  @override
  DateTime? get processedAt =>
      RealmObjectBase.get<DateTime>(this, 'processedAt') as DateTime?;
  @override
  set processedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'processedAt', value);

  @override
  Stream<RealmObjectChanges<CameraSession>> get changes =>
      RealmObjectBase.getChanges<CameraSession>(this);

  @override
  Stream<RealmObjectChanges<CameraSession>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CameraSession>(this, keyPaths);

  @override
  CameraSession freeze() => RealmObjectBase.freezeObject<CameraSession>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'imagePath': imagePath.toEJson(),
      'processedImagePath': processedImagePath.toEJson(),
      'status': status.toEJson(),
      'capturedAt': capturedAt.toEJson(),
      'processedAt': processedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(CameraSession value) => value.toEJson();
  static CameraSession _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'status': EJsonValue status,
        'capturedAt': EJsonValue capturedAt,
      } =>
        CameraSession(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(status),
          fromEJson(capturedAt),
          imagePath: fromEJson(ejson['imagePath']),
          processedImagePath: fromEJson(ejson['processedImagePath']),
          processedAt: fromEJson(ejson['processedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CameraSession._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, CameraSession, 'CameraSession', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('imagePath', RealmPropertyType.string, optional: true),
      SchemaProperty('processedImagePath', RealmPropertyType.string,
          optional: true),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('capturedAt', RealmPropertyType.timestamp),
      SchemaProperty('processedAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DetectedObject extends _DetectedObject
    with RealmEntity, RealmObjectBase, RealmObject {
  DetectedObject(
    String id,
    String cameraSessionId,
    String objectName,
    double confidence,
    bool isKnownVocabulary,
    DateTime detectedAt, {
    String? vietnameseName,
    String? boundingBox,
    String? vocabularyId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'cameraSessionId', cameraSessionId);
    RealmObjectBase.set(this, 'objectName', objectName);
    RealmObjectBase.set(this, 'vietnameseName', vietnameseName);
    RealmObjectBase.set(this, 'confidence', confidence);
    RealmObjectBase.set(this, 'boundingBox', boundingBox);
    RealmObjectBase.set(this, 'vocabularyId', vocabularyId);
    RealmObjectBase.set(this, 'isKnownVocabulary', isKnownVocabulary);
    RealmObjectBase.set(this, 'detectedAt', detectedAt);
  }

  DetectedObject._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get cameraSessionId =>
      RealmObjectBase.get<String>(this, 'cameraSessionId') as String;
  @override
  set cameraSessionId(String value) =>
      RealmObjectBase.set(this, 'cameraSessionId', value);

  @override
  String get objectName =>
      RealmObjectBase.get<String>(this, 'objectName') as String;
  @override
  set objectName(String value) =>
      RealmObjectBase.set(this, 'objectName', value);

  @override
  String? get vietnameseName =>
      RealmObjectBase.get<String>(this, 'vietnameseName') as String?;
  @override
  set vietnameseName(String? value) =>
      RealmObjectBase.set(this, 'vietnameseName', value);

  @override
  double get confidence =>
      RealmObjectBase.get<double>(this, 'confidence') as double;
  @override
  set confidence(double value) =>
      RealmObjectBase.set(this, 'confidence', value);

  @override
  String? get boundingBox =>
      RealmObjectBase.get<String>(this, 'boundingBox') as String?;
  @override
  set boundingBox(String? value) =>
      RealmObjectBase.set(this, 'boundingBox', value);

  @override
  String? get vocabularyId =>
      RealmObjectBase.get<String>(this, 'vocabularyId') as String?;
  @override
  set vocabularyId(String? value) =>
      RealmObjectBase.set(this, 'vocabularyId', value);

  @override
  bool get isKnownVocabulary =>
      RealmObjectBase.get<bool>(this, 'isKnownVocabulary') as bool;
  @override
  set isKnownVocabulary(bool value) =>
      RealmObjectBase.set(this, 'isKnownVocabulary', value);

  @override
  DateTime get detectedAt =>
      RealmObjectBase.get<DateTime>(this, 'detectedAt') as DateTime;
  @override
  set detectedAt(DateTime value) =>
      RealmObjectBase.set(this, 'detectedAt', value);

  @override
  Stream<RealmObjectChanges<DetectedObject>> get changes =>
      RealmObjectBase.getChanges<DetectedObject>(this);

  @override
  Stream<RealmObjectChanges<DetectedObject>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DetectedObject>(this, keyPaths);

  @override
  DetectedObject freeze() => RealmObjectBase.freezeObject<DetectedObject>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'cameraSessionId': cameraSessionId.toEJson(),
      'objectName': objectName.toEJson(),
      'vietnameseName': vietnameseName.toEJson(),
      'confidence': confidence.toEJson(),
      'boundingBox': boundingBox.toEJson(),
      'vocabularyId': vocabularyId.toEJson(),
      'isKnownVocabulary': isKnownVocabulary.toEJson(),
      'detectedAt': detectedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(DetectedObject value) => value.toEJson();
  static DetectedObject _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'cameraSessionId': EJsonValue cameraSessionId,
        'objectName': EJsonValue objectName,
        'confidence': EJsonValue confidence,
        'isKnownVocabulary': EJsonValue isKnownVocabulary,
        'detectedAt': EJsonValue detectedAt,
      } =>
        DetectedObject(
          fromEJson(id),
          fromEJson(cameraSessionId),
          fromEJson(objectName),
          fromEJson(confidence),
          fromEJson(isKnownVocabulary),
          fromEJson(detectedAt),
          vietnameseName: fromEJson(ejson['vietnameseName']),
          boundingBox: fromEJson(ejson['boundingBox']),
          vocabularyId: fromEJson(ejson['vocabularyId']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DetectedObject._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DetectedObject, 'DetectedObject', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('cameraSessionId', RealmPropertyType.string),
      SchemaProperty('objectName', RealmPropertyType.string),
      SchemaProperty('vietnameseName', RealmPropertyType.string,
          optional: true),
      SchemaProperty('confidence', RealmPropertyType.double),
      SchemaProperty('boundingBox', RealmPropertyType.string, optional: true),
      SchemaProperty('vocabularyId', RealmPropertyType.string, optional: true),
      SchemaProperty('isKnownVocabulary', RealmPropertyType.bool),
      SchemaProperty('detectedAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CameraHistory extends _CameraHistory
    with RealmEntity, RealmObjectBase, RealmObject {
  CameraHistory(
    String id,
    String userId,
    String cameraSessionId,
    int objectsDetected,
    int newWordsLearned,
    int xpEarned,
    DateTime sessionDate,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'cameraSessionId', cameraSessionId);
    RealmObjectBase.set(this, 'objectsDetected', objectsDetected);
    RealmObjectBase.set(this, 'newWordsLearned', newWordsLearned);
    RealmObjectBase.set(this, 'xpEarned', xpEarned);
    RealmObjectBase.set(this, 'sessionDate', sessionDate);
  }

  CameraHistory._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get cameraSessionId =>
      RealmObjectBase.get<String>(this, 'cameraSessionId') as String;
  @override
  set cameraSessionId(String value) =>
      RealmObjectBase.set(this, 'cameraSessionId', value);

  @override
  int get objectsDetected =>
      RealmObjectBase.get<int>(this, 'objectsDetected') as int;
  @override
  set objectsDetected(int value) =>
      RealmObjectBase.set(this, 'objectsDetected', value);

  @override
  int get newWordsLearned =>
      RealmObjectBase.get<int>(this, 'newWordsLearned') as int;
  @override
  set newWordsLearned(int value) =>
      RealmObjectBase.set(this, 'newWordsLearned', value);

  @override
  int get xpEarned => RealmObjectBase.get<int>(this, 'xpEarned') as int;
  @override
  set xpEarned(int value) => RealmObjectBase.set(this, 'xpEarned', value);

  @override
  DateTime get sessionDate =>
      RealmObjectBase.get<DateTime>(this, 'sessionDate') as DateTime;
  @override
  set sessionDate(DateTime value) =>
      RealmObjectBase.set(this, 'sessionDate', value);

  @override
  Stream<RealmObjectChanges<CameraHistory>> get changes =>
      RealmObjectBase.getChanges<CameraHistory>(this);

  @override
  Stream<RealmObjectChanges<CameraHistory>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CameraHistory>(this, keyPaths);

  @override
  CameraHistory freeze() => RealmObjectBase.freezeObject<CameraHistory>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'cameraSessionId': cameraSessionId.toEJson(),
      'objectsDetected': objectsDetected.toEJson(),
      'newWordsLearned': newWordsLearned.toEJson(),
      'xpEarned': xpEarned.toEJson(),
      'sessionDate': sessionDate.toEJson(),
    };
  }

  static EJsonValue _toEJson(CameraHistory value) => value.toEJson();
  static CameraHistory _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'cameraSessionId': EJsonValue cameraSessionId,
        'objectsDetected': EJsonValue objectsDetected,
        'newWordsLearned': EJsonValue newWordsLearned,
        'xpEarned': EJsonValue xpEarned,
        'sessionDate': EJsonValue sessionDate,
      } =>
        CameraHistory(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(cameraSessionId),
          fromEJson(objectsDetected),
          fromEJson(newWordsLearned),
          fromEJson(xpEarned),
          fromEJson(sessionDate),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CameraHistory._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, CameraHistory, 'CameraHistory', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('cameraSessionId', RealmPropertyType.string),
      SchemaProperty('objectsDetected', RealmPropertyType.int),
      SchemaProperty('newWordsLearned', RealmPropertyType.int),
      SchemaProperty('xpEarned', RealmPropertyType.int),
      SchemaProperty('sessionDate', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
