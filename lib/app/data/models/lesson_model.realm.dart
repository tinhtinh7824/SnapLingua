// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Lesson extends _Lesson with RealmEntity, RealmObjectBase, RealmObject {
  Lesson(
    String id,
    String title,
    String categoryId,
    int level,
    int sortOrder,
    String difficulty,
    String type,
    int estimatedTime,
    int xpReward,
    bool isPremium,
    bool isActive,
    DateTime createdAt, {
    String? description,
    String? imageUrl,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'level', level);
    RealmObjectBase.set(this, 'sortOrder', sortOrder);
    RealmObjectBase.set(this, 'difficulty', difficulty);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'estimatedTime', estimatedTime);
    RealmObjectBase.set(this, 'xpReward', xpReward);
    RealmObjectBase.set(this, 'isPremium', isPremium);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  Lesson._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get categoryId =>
      RealmObjectBase.get<String>(this, 'categoryId') as String;
  @override
  set categoryId(String value) =>
      RealmObjectBase.set(this, 'categoryId', value);

  @override
  int get level => RealmObjectBase.get<int>(this, 'level') as int;
  @override
  set level(int value) => RealmObjectBase.set(this, 'level', value);

  @override
  int get sortOrder => RealmObjectBase.get<int>(this, 'sortOrder') as int;
  @override
  set sortOrder(int value) => RealmObjectBase.set(this, 'sortOrder', value);

  @override
  String get difficulty =>
      RealmObjectBase.get<String>(this, 'difficulty') as String;
  @override
  set difficulty(String value) =>
      RealmObjectBase.set(this, 'difficulty', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  int get estimatedTime =>
      RealmObjectBase.get<int>(this, 'estimatedTime') as int;
  @override
  set estimatedTime(int value) =>
      RealmObjectBase.set(this, 'estimatedTime', value);

  @override
  int get xpReward => RealmObjectBase.get<int>(this, 'xpReward') as int;
  @override
  set xpReward(int value) => RealmObjectBase.set(this, 'xpReward', value);

  @override
  bool get isPremium => RealmObjectBase.get<bool>(this, 'isPremium') as bool;
  @override
  set isPremium(bool value) => RealmObjectBase.set(this, 'isPremium', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

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
  Stream<RealmObjectChanges<Lesson>> get changes =>
      RealmObjectBase.getChanges<Lesson>(this);

  @override
  Stream<RealmObjectChanges<Lesson>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Lesson>(this, keyPaths);

  @override
  Lesson freeze() => RealmObjectBase.freezeObject<Lesson>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'categoryId': categoryId.toEJson(),
      'level': level.toEJson(),
      'sortOrder': sortOrder.toEJson(),
      'difficulty': difficulty.toEJson(),
      'type': type.toEJson(),
      'estimatedTime': estimatedTime.toEJson(),
      'xpReward': xpReward.toEJson(),
      'isPremium': isPremium.toEJson(),
      'isActive': isActive.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Lesson value) => value.toEJson();
  static Lesson _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'categoryId': EJsonValue categoryId,
        'level': EJsonValue level,
        'sortOrder': EJsonValue sortOrder,
        'difficulty': EJsonValue difficulty,
        'type': EJsonValue type,
        'estimatedTime': EJsonValue estimatedTime,
        'xpReward': EJsonValue xpReward,
        'isPremium': EJsonValue isPremium,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        Lesson(
          fromEJson(id),
          fromEJson(title),
          fromEJson(categoryId),
          fromEJson(level),
          fromEJson(sortOrder),
          fromEJson(difficulty),
          fromEJson(type),
          fromEJson(estimatedTime),
          fromEJson(xpReward),
          fromEJson(isPremium),
          fromEJson(isActive),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
          imageUrl: fromEJson(ejson['imageUrl']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Lesson._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Lesson, 'Lesson', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('categoryId', RealmPropertyType.string),
      SchemaProperty('level', RealmPropertyType.int),
      SchemaProperty('sortOrder', RealmPropertyType.int),
      SchemaProperty('difficulty', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('estimatedTime', RealmPropertyType.int),
      SchemaProperty('xpReward', RealmPropertyType.int),
      SchemaProperty('isPremium', RealmPropertyType.bool),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class LessonContent extends _LessonContent
    with RealmEntity, RealmObjectBase, RealmObject {
  LessonContent(
    String id,
    String lessonId,
    String contentType,
    String content,
    int sortOrder,
    DateTime createdAt, {
    String? metadata,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'lessonId', lessonId);
    RealmObjectBase.set(this, 'contentType', contentType);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'metadata', metadata);
    RealmObjectBase.set(this, 'sortOrder', sortOrder);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  LessonContent._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get lessonId =>
      RealmObjectBase.get<String>(this, 'lessonId') as String;
  @override
  set lessonId(String value) => RealmObjectBase.set(this, 'lessonId', value);

  @override
  String get contentType =>
      RealmObjectBase.get<String>(this, 'contentType') as String;
  @override
  set contentType(String value) =>
      RealmObjectBase.set(this, 'contentType', value);

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
  int get sortOrder => RealmObjectBase.get<int>(this, 'sortOrder') as int;
  @override
  set sortOrder(int value) => RealmObjectBase.set(this, 'sortOrder', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<LessonContent>> get changes =>
      RealmObjectBase.getChanges<LessonContent>(this);

  @override
  Stream<RealmObjectChanges<LessonContent>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LessonContent>(this, keyPaths);

  @override
  LessonContent freeze() => RealmObjectBase.freezeObject<LessonContent>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'lessonId': lessonId.toEJson(),
      'contentType': contentType.toEJson(),
      'content': content.toEJson(),
      'metadata': metadata.toEJson(),
      'sortOrder': sortOrder.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(LessonContent value) => value.toEJson();
  static LessonContent _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'lessonId': EJsonValue lessonId,
        'contentType': EJsonValue contentType,
        'content': EJsonValue content,
        'sortOrder': EJsonValue sortOrder,
        'createdAt': EJsonValue createdAt,
      } =>
        LessonContent(
          fromEJson(id),
          fromEJson(lessonId),
          fromEJson(contentType),
          fromEJson(content),
          fromEJson(sortOrder),
          fromEJson(createdAt),
          metadata: fromEJson(ejson['metadata']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LessonContent._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, LessonContent, 'LessonContent', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('lessonId', RealmPropertyType.string),
      SchemaProperty('contentType', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('metadata', RealmPropertyType.string, optional: true),
      SchemaProperty('sortOrder', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserLesson extends _UserLesson
    with RealmEntity, RealmObjectBase, RealmObject {
  UserLesson(
    String id,
    String userId,
    String lessonId,
    String status,
    double progress,
    int xpEarned,
    DateTime createdAt, {
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastAccessedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'lessonId', lessonId);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'progress', progress);
    RealmObjectBase.set(this, 'xpEarned', xpEarned);
    RealmObjectBase.set(this, 'startedAt', startedAt);
    RealmObjectBase.set(this, 'completedAt', completedAt);
    RealmObjectBase.set(this, 'lastAccessedAt', lastAccessedAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  UserLesson._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get lessonId =>
      RealmObjectBase.get<String>(this, 'lessonId') as String;
  @override
  set lessonId(String value) => RealmObjectBase.set(this, 'lessonId', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  double get progress =>
      RealmObjectBase.get<double>(this, 'progress') as double;
  @override
  set progress(double value) => RealmObjectBase.set(this, 'progress', value);

  @override
  int get xpEarned => RealmObjectBase.get<int>(this, 'xpEarned') as int;
  @override
  set xpEarned(int value) => RealmObjectBase.set(this, 'xpEarned', value);

  @override
  DateTime? get startedAt =>
      RealmObjectBase.get<DateTime>(this, 'startedAt') as DateTime?;
  @override
  set startedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'startedAt', value);

  @override
  DateTime? get completedAt =>
      RealmObjectBase.get<DateTime>(this, 'completedAt') as DateTime?;
  @override
  set completedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'completedAt', value);

  @override
  DateTime? get lastAccessedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastAccessedAt') as DateTime?;
  @override
  set lastAccessedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastAccessedAt', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<UserLesson>> get changes =>
      RealmObjectBase.getChanges<UserLesson>(this);

  @override
  Stream<RealmObjectChanges<UserLesson>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserLesson>(this, keyPaths);

  @override
  UserLesson freeze() => RealmObjectBase.freezeObject<UserLesson>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'lessonId': lessonId.toEJson(),
      'status': status.toEJson(),
      'progress': progress.toEJson(),
      'xpEarned': xpEarned.toEJson(),
      'startedAt': startedAt.toEJson(),
      'completedAt': completedAt.toEJson(),
      'lastAccessedAt': lastAccessedAt.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserLesson value) => value.toEJson();
  static UserLesson _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'lessonId': EJsonValue lessonId,
        'status': EJsonValue status,
        'progress': EJsonValue progress,
        'xpEarned': EJsonValue xpEarned,
        'createdAt': EJsonValue createdAt,
      } =>
        UserLesson(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(lessonId),
          fromEJson(status),
          fromEJson(progress),
          fromEJson(xpEarned),
          fromEJson(createdAt),
          startedAt: fromEJson(ejson['startedAt']),
          completedAt: fromEJson(ejson['completedAt']),
          lastAccessedAt: fromEJson(ejson['lastAccessedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserLesson._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserLesson, 'UserLesson', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('lessonId', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('progress', RealmPropertyType.double),
      SchemaProperty('xpEarned', RealmPropertyType.int),
      SchemaProperty('startedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('completedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('lastAccessedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Exercise extends _Exercise
    with RealmEntity, RealmObjectBase, RealmObject {
  Exercise(
    String id,
    String lessonId,
    String type,
    String question,
    String correctAnswer,
    int points,
    int sortOrder,
    DateTime createdAt, {
    String? options,
    String? explanation,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'lessonId', lessonId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'question', question);
    RealmObjectBase.set(this, 'correctAnswer', correctAnswer);
    RealmObjectBase.set(this, 'options', options);
    RealmObjectBase.set(this, 'explanation', explanation);
    RealmObjectBase.set(this, 'points', points);
    RealmObjectBase.set(this, 'sortOrder', sortOrder);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Exercise._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get lessonId =>
      RealmObjectBase.get<String>(this, 'lessonId') as String;
  @override
  set lessonId(String value) => RealmObjectBase.set(this, 'lessonId', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String get question =>
      RealmObjectBase.get<String>(this, 'question') as String;
  @override
  set question(String value) => RealmObjectBase.set(this, 'question', value);

  @override
  String get correctAnswer =>
      RealmObjectBase.get<String>(this, 'correctAnswer') as String;
  @override
  set correctAnswer(String value) =>
      RealmObjectBase.set(this, 'correctAnswer', value);

  @override
  String? get options =>
      RealmObjectBase.get<String>(this, 'options') as String?;
  @override
  set options(String? value) => RealmObjectBase.set(this, 'options', value);

  @override
  String? get explanation =>
      RealmObjectBase.get<String>(this, 'explanation') as String?;
  @override
  set explanation(String? value) =>
      RealmObjectBase.set(this, 'explanation', value);

  @override
  int get points => RealmObjectBase.get<int>(this, 'points') as int;
  @override
  set points(int value) => RealmObjectBase.set(this, 'points', value);

  @override
  int get sortOrder => RealmObjectBase.get<int>(this, 'sortOrder') as int;
  @override
  set sortOrder(int value) => RealmObjectBase.set(this, 'sortOrder', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Exercise>> get changes =>
      RealmObjectBase.getChanges<Exercise>(this);

  @override
  Stream<RealmObjectChanges<Exercise>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Exercise>(this, keyPaths);

  @override
  Exercise freeze() => RealmObjectBase.freezeObject<Exercise>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'lessonId': lessonId.toEJson(),
      'type': type.toEJson(),
      'question': question.toEJson(),
      'correctAnswer': correctAnswer.toEJson(),
      'options': options.toEJson(),
      'explanation': explanation.toEJson(),
      'points': points.toEJson(),
      'sortOrder': sortOrder.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Exercise value) => value.toEJson();
  static Exercise _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'lessonId': EJsonValue lessonId,
        'type': EJsonValue type,
        'question': EJsonValue question,
        'correctAnswer': EJsonValue correctAnswer,
        'points': EJsonValue points,
        'sortOrder': EJsonValue sortOrder,
        'createdAt': EJsonValue createdAt,
      } =>
        Exercise(
          fromEJson(id),
          fromEJson(lessonId),
          fromEJson(type),
          fromEJson(question),
          fromEJson(correctAnswer),
          fromEJson(points),
          fromEJson(sortOrder),
          fromEJson(createdAt),
          options: fromEJson(ejson['options']),
          explanation: fromEJson(ejson['explanation']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Exercise._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Exercise, 'Exercise', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('lessonId', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('question', RealmPropertyType.string),
      SchemaProperty('correctAnswer', RealmPropertyType.string),
      SchemaProperty('options', RealmPropertyType.string, optional: true),
      SchemaProperty('explanation', RealmPropertyType.string, optional: true),
      SchemaProperty('points', RealmPropertyType.int),
      SchemaProperty('sortOrder', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserExercise extends _UserExercise
    with RealmEntity, RealmObjectBase, RealmObject {
  UserExercise(
    String id,
    String userId,
    String exerciseId,
    String userAnswer,
    bool isCorrect,
    int pointsEarned,
    int attempts,
    DateTime submittedAt, {
    String? feedback,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'exerciseId', exerciseId);
    RealmObjectBase.set(this, 'userAnswer', userAnswer);
    RealmObjectBase.set(this, 'isCorrect', isCorrect);
    RealmObjectBase.set(this, 'pointsEarned', pointsEarned);
    RealmObjectBase.set(this, 'attempts', attempts);
    RealmObjectBase.set(this, 'feedback', feedback);
    RealmObjectBase.set(this, 'submittedAt', submittedAt);
  }

  UserExercise._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get exerciseId =>
      RealmObjectBase.get<String>(this, 'exerciseId') as String;
  @override
  set exerciseId(String value) =>
      RealmObjectBase.set(this, 'exerciseId', value);

  @override
  String get userAnswer =>
      RealmObjectBase.get<String>(this, 'userAnswer') as String;
  @override
  set userAnswer(String value) =>
      RealmObjectBase.set(this, 'userAnswer', value);

  @override
  bool get isCorrect => RealmObjectBase.get<bool>(this, 'isCorrect') as bool;
  @override
  set isCorrect(bool value) => RealmObjectBase.set(this, 'isCorrect', value);

  @override
  int get pointsEarned => RealmObjectBase.get<int>(this, 'pointsEarned') as int;
  @override
  set pointsEarned(int value) =>
      RealmObjectBase.set(this, 'pointsEarned', value);

  @override
  int get attempts => RealmObjectBase.get<int>(this, 'attempts') as int;
  @override
  set attempts(int value) => RealmObjectBase.set(this, 'attempts', value);

  @override
  String? get feedback =>
      RealmObjectBase.get<String>(this, 'feedback') as String?;
  @override
  set feedback(String? value) => RealmObjectBase.set(this, 'feedback', value);

  @override
  DateTime get submittedAt =>
      RealmObjectBase.get<DateTime>(this, 'submittedAt') as DateTime;
  @override
  set submittedAt(DateTime value) =>
      RealmObjectBase.set(this, 'submittedAt', value);

  @override
  Stream<RealmObjectChanges<UserExercise>> get changes =>
      RealmObjectBase.getChanges<UserExercise>(this);

  @override
  Stream<RealmObjectChanges<UserExercise>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserExercise>(this, keyPaths);

  @override
  UserExercise freeze() => RealmObjectBase.freezeObject<UserExercise>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'exerciseId': exerciseId.toEJson(),
      'userAnswer': userAnswer.toEJson(),
      'isCorrect': isCorrect.toEJson(),
      'pointsEarned': pointsEarned.toEJson(),
      'attempts': attempts.toEJson(),
      'feedback': feedback.toEJson(),
      'submittedAt': submittedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserExercise value) => value.toEJson();
  static UserExercise _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'exerciseId': EJsonValue exerciseId,
        'userAnswer': EJsonValue userAnswer,
        'isCorrect': EJsonValue isCorrect,
        'pointsEarned': EJsonValue pointsEarned,
        'attempts': EJsonValue attempts,
        'submittedAt': EJsonValue submittedAt,
      } =>
        UserExercise(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(exerciseId),
          fromEJson(userAnswer),
          fromEJson(isCorrect),
          fromEJson(pointsEarned),
          fromEJson(attempts),
          fromEJson(submittedAt),
          feedback: fromEJson(ejson['feedback']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserExercise._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserExercise, 'UserExercise', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('exerciseId', RealmPropertyType.string),
      SchemaProperty('userAnswer', RealmPropertyType.string),
      SchemaProperty('isCorrect', RealmPropertyType.bool),
      SchemaProperty('pointsEarned', RealmPropertyType.int),
      SchemaProperty('attempts', RealmPropertyType.int),
      SchemaProperty('feedback', RealmPropertyType.string, optional: true),
      SchemaProperty('submittedAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
