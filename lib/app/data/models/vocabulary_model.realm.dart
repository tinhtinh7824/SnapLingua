// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Vocabulary extends _Vocabulary
    with RealmEntity, RealmObjectBase, RealmObject {
  Vocabulary(
    String id,
    String word,
    String definition,
    String difficulty,
    String category,
    int frequency,
    bool isActive,
    DateTime createdAt, {
    String? pronunciation,
    String? phonetic,
    String? example,
    String? translation,
    String? imageUrl,
    String? audioUrl,
    String? tags,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'word', word);
    RealmObjectBase.set(this, 'pronunciation', pronunciation);
    RealmObjectBase.set(this, 'phonetic', phonetic);
    RealmObjectBase.set(this, 'definition', definition);
    RealmObjectBase.set(this, 'example', example);
    RealmObjectBase.set(this, 'translation', translation);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'audioUrl', audioUrl);
    RealmObjectBase.set(this, 'difficulty', difficulty);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'tags', tags);
    RealmObjectBase.set(this, 'frequency', frequency);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  Vocabulary._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get word => RealmObjectBase.get<String>(this, 'word') as String;
  @override
  set word(String value) => RealmObjectBase.set(this, 'word', value);

  @override
  String? get pronunciation =>
      RealmObjectBase.get<String>(this, 'pronunciation') as String?;
  @override
  set pronunciation(String? value) =>
      RealmObjectBase.set(this, 'pronunciation', value);

  @override
  String? get phonetic =>
      RealmObjectBase.get<String>(this, 'phonetic') as String?;
  @override
  set phonetic(String? value) => RealmObjectBase.set(this, 'phonetic', value);

  @override
  String get definition =>
      RealmObjectBase.get<String>(this, 'definition') as String;
  @override
  set definition(String value) =>
      RealmObjectBase.set(this, 'definition', value);

  @override
  String? get example =>
      RealmObjectBase.get<String>(this, 'example') as String?;
  @override
  set example(String? value) => RealmObjectBase.set(this, 'example', value);

  @override
  String? get translation =>
      RealmObjectBase.get<String>(this, 'translation') as String?;
  @override
  set translation(String? value) =>
      RealmObjectBase.set(this, 'translation', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  String? get audioUrl =>
      RealmObjectBase.get<String>(this, 'audioUrl') as String?;
  @override
  set audioUrl(String? value) => RealmObjectBase.set(this, 'audioUrl', value);

  @override
  String get difficulty =>
      RealmObjectBase.get<String>(this, 'difficulty') as String;
  @override
  set difficulty(String value) =>
      RealmObjectBase.set(this, 'difficulty', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String? get tags => RealmObjectBase.get<String>(this, 'tags') as String?;
  @override
  set tags(String? value) => RealmObjectBase.set(this, 'tags', value);

  @override
  int get frequency => RealmObjectBase.get<int>(this, 'frequency') as int;
  @override
  set frequency(int value) => RealmObjectBase.set(this, 'frequency', value);

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
  Stream<RealmObjectChanges<Vocabulary>> get changes =>
      RealmObjectBase.getChanges<Vocabulary>(this);

  @override
  Stream<RealmObjectChanges<Vocabulary>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Vocabulary>(this, keyPaths);

  @override
  Vocabulary freeze() => RealmObjectBase.freezeObject<Vocabulary>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'word': word.toEJson(),
      'pronunciation': pronunciation.toEJson(),
      'phonetic': phonetic.toEJson(),
      'definition': definition.toEJson(),
      'example': example.toEJson(),
      'translation': translation.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'audioUrl': audioUrl.toEJson(),
      'difficulty': difficulty.toEJson(),
      'category': category.toEJson(),
      'tags': tags.toEJson(),
      'frequency': frequency.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Vocabulary value) => value.toEJson();
  static Vocabulary _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'word': EJsonValue word,
        'definition': EJsonValue definition,
        'difficulty': EJsonValue difficulty,
        'category': EJsonValue category,
        'frequency': EJsonValue frequency,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        Vocabulary(
          fromEJson(id),
          fromEJson(word),
          fromEJson(definition),
          fromEJson(difficulty),
          fromEJson(category),
          fromEJson(frequency),
          fromEJson(isActive),
          fromEJson(createdAt),
          pronunciation: fromEJson(ejson['pronunciation']),
          phonetic: fromEJson(ejson['phonetic']),
          example: fromEJson(ejson['example']),
          translation: fromEJson(ejson['translation']),
          imageUrl: fromEJson(ejson['imageUrl']),
          audioUrl: fromEJson(ejson['audioUrl']),
          tags: fromEJson(ejson['tags']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Vocabulary._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, Vocabulary, 'Vocabulary', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('word', RealmPropertyType.string),
      SchemaProperty('pronunciation', RealmPropertyType.string, optional: true),
      SchemaProperty('phonetic', RealmPropertyType.string, optional: true),
      SchemaProperty('definition', RealmPropertyType.string),
      SchemaProperty('example', RealmPropertyType.string, optional: true),
      SchemaProperty('translation', RealmPropertyType.string, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('audioUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('difficulty', RealmPropertyType.string),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('tags', RealmPropertyType.string, optional: true),
      SchemaProperty('frequency', RealmPropertyType.int),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserVocabulary extends _UserVocabulary
    with RealmEntity, RealmObjectBase, RealmObject {
  UserVocabulary(
    String id,
    String userId,
    String vocabularyId,
    int level,
    int repetitions,
    double easeFactor,
    int interval,
    int correctCount,
    int incorrectCount,
    bool isMastered,
    bool isFavorite,
    String status,
    DateTime createdAt, {
    DateTime? nextReviewDate,
    DateTime? lastReviewedAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'vocabularyId', vocabularyId);
    RealmObjectBase.set(this, 'level', level);
    RealmObjectBase.set(this, 'repetitions', repetitions);
    RealmObjectBase.set(this, 'easeFactor', easeFactor);
    RealmObjectBase.set(this, 'interval', interval);
    RealmObjectBase.set(this, 'nextReviewDate', nextReviewDate);
    RealmObjectBase.set(this, 'lastReviewedAt', lastReviewedAt);
    RealmObjectBase.set(this, 'correctCount', correctCount);
    RealmObjectBase.set(this, 'incorrectCount', incorrectCount);
    RealmObjectBase.set(this, 'isMastered', isMastered);
    RealmObjectBase.set(this, 'isFavorite', isFavorite);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  UserVocabulary._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get vocabularyId =>
      RealmObjectBase.get<String>(this, 'vocabularyId') as String;
  @override
  set vocabularyId(String value) =>
      RealmObjectBase.set(this, 'vocabularyId', value);

  @override
  int get level => RealmObjectBase.get<int>(this, 'level') as int;
  @override
  set level(int value) => RealmObjectBase.set(this, 'level', value);

  @override
  int get repetitions => RealmObjectBase.get<int>(this, 'repetitions') as int;
  @override
  set repetitions(int value) => RealmObjectBase.set(this, 'repetitions', value);

  @override
  double get easeFactor =>
      RealmObjectBase.get<double>(this, 'easeFactor') as double;
  @override
  set easeFactor(double value) =>
      RealmObjectBase.set(this, 'easeFactor', value);

  @override
  int get interval => RealmObjectBase.get<int>(this, 'interval') as int;
  @override
  set interval(int value) => RealmObjectBase.set(this, 'interval', value);

  @override
  DateTime? get nextReviewDate =>
      RealmObjectBase.get<DateTime>(this, 'nextReviewDate') as DateTime?;
  @override
  set nextReviewDate(DateTime? value) =>
      RealmObjectBase.set(this, 'nextReviewDate', value);

  @override
  DateTime? get lastReviewedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastReviewedAt') as DateTime?;
  @override
  set lastReviewedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastReviewedAt', value);

  @override
  int get correctCount => RealmObjectBase.get<int>(this, 'correctCount') as int;
  @override
  set correctCount(int value) =>
      RealmObjectBase.set(this, 'correctCount', value);

  @override
  int get incorrectCount =>
      RealmObjectBase.get<int>(this, 'incorrectCount') as int;
  @override
  set incorrectCount(int value) =>
      RealmObjectBase.set(this, 'incorrectCount', value);

  @override
  bool get isMastered => RealmObjectBase.get<bool>(this, 'isMastered') as bool;
  @override
  set isMastered(bool value) => RealmObjectBase.set(this, 'isMastered', value);

  @override
  bool get isFavorite => RealmObjectBase.get<bool>(this, 'isFavorite') as bool;
  @override
  set isFavorite(bool value) => RealmObjectBase.set(this, 'isFavorite', value);

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
  Stream<RealmObjectChanges<UserVocabulary>> get changes =>
      RealmObjectBase.getChanges<UserVocabulary>(this);

  @override
  Stream<RealmObjectChanges<UserVocabulary>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserVocabulary>(this, keyPaths);

  @override
  UserVocabulary freeze() => RealmObjectBase.freezeObject<UserVocabulary>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'vocabularyId': vocabularyId.toEJson(),
      'level': level.toEJson(),
      'repetitions': repetitions.toEJson(),
      'easeFactor': easeFactor.toEJson(),
      'interval': interval.toEJson(),
      'nextReviewDate': nextReviewDate.toEJson(),
      'lastReviewedAt': lastReviewedAt.toEJson(),
      'correctCount': correctCount.toEJson(),
      'incorrectCount': incorrectCount.toEJson(),
      'isMastered': isMastered.toEJson(),
      'isFavorite': isFavorite.toEJson(),
      'status': status.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserVocabulary value) => value.toEJson();
  static UserVocabulary _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'vocabularyId': EJsonValue vocabularyId,
        'level': EJsonValue level,
        'repetitions': EJsonValue repetitions,
        'easeFactor': EJsonValue easeFactor,
        'interval': EJsonValue interval,
        'correctCount': EJsonValue correctCount,
        'incorrectCount': EJsonValue incorrectCount,
        'isMastered': EJsonValue isMastered,
        'isFavorite': EJsonValue isFavorite,
        'status': EJsonValue status,
        'createdAt': EJsonValue createdAt,
      } =>
        UserVocabulary(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(vocabularyId),
          fromEJson(level),
          fromEJson(repetitions),
          fromEJson(easeFactor),
          fromEJson(interval),
          fromEJson(correctCount),
          fromEJson(incorrectCount),
          fromEJson(isMastered),
          fromEJson(isFavorite),
          fromEJson(status),
          fromEJson(createdAt),
          nextReviewDate: fromEJson(ejson['nextReviewDate']),
          lastReviewedAt: fromEJson(ejson['lastReviewedAt']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserVocabulary._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserVocabulary, 'UserVocabulary', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('vocabularyId', RealmPropertyType.string),
      SchemaProperty('level', RealmPropertyType.int),
      SchemaProperty('repetitions', RealmPropertyType.int),
      SchemaProperty('easeFactor', RealmPropertyType.double),
      SchemaProperty('interval', RealmPropertyType.int),
      SchemaProperty('nextReviewDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('lastReviewedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('correctCount', RealmPropertyType.int),
      SchemaProperty('incorrectCount', RealmPropertyType.int),
      SchemaProperty('isMastered', RealmPropertyType.bool),
      SchemaProperty('isFavorite', RealmPropertyType.bool),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class VocabularyReview extends _VocabularyReview
    with RealmEntity, RealmObjectBase, RealmObject {
  VocabularyReview(
    String id,
    String userId,
    String vocabularyId,
    String userVocabularyId,
    bool isCorrect,
    int responseTime,
    String reviewType,
    int difficulty,
    DateTime reviewedAt, {
    String? feedback,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'vocabularyId', vocabularyId);
    RealmObjectBase.set(this, 'userVocabularyId', userVocabularyId);
    RealmObjectBase.set(this, 'isCorrect', isCorrect);
    RealmObjectBase.set(this, 'responseTime', responseTime);
    RealmObjectBase.set(this, 'reviewType', reviewType);
    RealmObjectBase.set(this, 'difficulty', difficulty);
    RealmObjectBase.set(this, 'feedback', feedback);
    RealmObjectBase.set(this, 'reviewedAt', reviewedAt);
  }

  VocabularyReview._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get vocabularyId =>
      RealmObjectBase.get<String>(this, 'vocabularyId') as String;
  @override
  set vocabularyId(String value) =>
      RealmObjectBase.set(this, 'vocabularyId', value);

  @override
  String get userVocabularyId =>
      RealmObjectBase.get<String>(this, 'userVocabularyId') as String;
  @override
  set userVocabularyId(String value) =>
      RealmObjectBase.set(this, 'userVocabularyId', value);

  @override
  bool get isCorrect => RealmObjectBase.get<bool>(this, 'isCorrect') as bool;
  @override
  set isCorrect(bool value) => RealmObjectBase.set(this, 'isCorrect', value);

  @override
  int get responseTime => RealmObjectBase.get<int>(this, 'responseTime') as int;
  @override
  set responseTime(int value) =>
      RealmObjectBase.set(this, 'responseTime', value);

  @override
  String get reviewType =>
      RealmObjectBase.get<String>(this, 'reviewType') as String;
  @override
  set reviewType(String value) =>
      RealmObjectBase.set(this, 'reviewType', value);

  @override
  int get difficulty => RealmObjectBase.get<int>(this, 'difficulty') as int;
  @override
  set difficulty(int value) => RealmObjectBase.set(this, 'difficulty', value);

  @override
  String? get feedback =>
      RealmObjectBase.get<String>(this, 'feedback') as String?;
  @override
  set feedback(String? value) => RealmObjectBase.set(this, 'feedback', value);

  @override
  DateTime get reviewedAt =>
      RealmObjectBase.get<DateTime>(this, 'reviewedAt') as DateTime;
  @override
  set reviewedAt(DateTime value) =>
      RealmObjectBase.set(this, 'reviewedAt', value);

  @override
  Stream<RealmObjectChanges<VocabularyReview>> get changes =>
      RealmObjectBase.getChanges<VocabularyReview>(this);

  @override
  Stream<RealmObjectChanges<VocabularyReview>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<VocabularyReview>(this, keyPaths);

  @override
  VocabularyReview freeze() =>
      RealmObjectBase.freezeObject<VocabularyReview>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'vocabularyId': vocabularyId.toEJson(),
      'userVocabularyId': userVocabularyId.toEJson(),
      'isCorrect': isCorrect.toEJson(),
      'responseTime': responseTime.toEJson(),
      'reviewType': reviewType.toEJson(),
      'difficulty': difficulty.toEJson(),
      'feedback': feedback.toEJson(),
      'reviewedAt': reviewedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(VocabularyReview value) => value.toEJson();
  static VocabularyReview _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'vocabularyId': EJsonValue vocabularyId,
        'userVocabularyId': EJsonValue userVocabularyId,
        'isCorrect': EJsonValue isCorrect,
        'responseTime': EJsonValue responseTime,
        'reviewType': EJsonValue reviewType,
        'difficulty': EJsonValue difficulty,
        'reviewedAt': EJsonValue reviewedAt,
      } =>
        VocabularyReview(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(vocabularyId),
          fromEJson(userVocabularyId),
          fromEJson(isCorrect),
          fromEJson(responseTime),
          fromEJson(reviewType),
          fromEJson(difficulty),
          fromEJson(reviewedAt),
          feedback: fromEJson(ejson['feedback']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(VocabularyReview._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, VocabularyReview, 'VocabularyReview', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('vocabularyId', RealmPropertyType.string),
      SchemaProperty('userVocabularyId', RealmPropertyType.string),
      SchemaProperty('isCorrect', RealmPropertyType.bool),
      SchemaProperty('responseTime', RealmPropertyType.int),
      SchemaProperty('reviewType', RealmPropertyType.string),
      SchemaProperty('difficulty', RealmPropertyType.int),
      SchemaProperty('feedback', RealmPropertyType.string, optional: true),
      SchemaProperty('reviewedAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Category extends _Category
    with RealmEntity, RealmObjectBase, RealmObject {
  Category(
    String id,
    String name,
    int sortOrder,
    bool isActive,
    DateTime createdAt, {
    String? description,
    String? iconUrl,
    String? color,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'iconUrl', iconUrl);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'sortOrder', sortOrder);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Category._();

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
  String? get iconUrl =>
      RealmObjectBase.get<String>(this, 'iconUrl') as String?;
  @override
  set iconUrl(String? value) => RealmObjectBase.set(this, 'iconUrl', value);

  @override
  String? get color => RealmObjectBase.get<String>(this, 'color') as String?;
  @override
  set color(String? value) => RealmObjectBase.set(this, 'color', value);

  @override
  int get sortOrder => RealmObjectBase.get<int>(this, 'sortOrder') as int;
  @override
  set sortOrder(int value) => RealmObjectBase.set(this, 'sortOrder', value);

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
  Stream<RealmObjectChanges<Category>> get changes =>
      RealmObjectBase.getChanges<Category>(this);

  @override
  Stream<RealmObjectChanges<Category>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Category>(this, keyPaths);

  @override
  Category freeze() => RealmObjectBase.freezeObject<Category>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'iconUrl': iconUrl.toEJson(),
      'color': color.toEJson(),
      'sortOrder': sortOrder.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Category value) => value.toEJson();
  static Category _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'sortOrder': EJsonValue sortOrder,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        Category(
          fromEJson(id),
          fromEJson(name),
          fromEJson(sortOrder),
          fromEJson(isActive),
          fromEJson(createdAt),
          description: fromEJson(ejson['description']),
          iconUrl: fromEJson(ejson['iconUrl']),
          color: fromEJson(ejson['color']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Category._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Category, 'Category', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('iconUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('color', RealmPropertyType.string, optional: true),
      SchemaProperty('sortOrder', RealmPropertyType.int),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserProgress extends _UserProgress
    with RealmEntity, RealmObjectBase, RealmObject {
  UserProgress(
    String id,
    String userId,
    String categoryId,
    int totalWords,
    int learnedWords,
    int masteredWords,
    double accuracy,
    int totalReviews,
    DateTime createdAt, {
    DateTime? lastStudiedAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'totalWords', totalWords);
    RealmObjectBase.set(this, 'learnedWords', learnedWords);
    RealmObjectBase.set(this, 'masteredWords', masteredWords);
    RealmObjectBase.set(this, 'accuracy', accuracy);
    RealmObjectBase.set(this, 'totalReviews', totalReviews);
    RealmObjectBase.set(this, 'lastStudiedAt', lastStudiedAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  UserProgress._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get categoryId =>
      RealmObjectBase.get<String>(this, 'categoryId') as String;
  @override
  set categoryId(String value) =>
      RealmObjectBase.set(this, 'categoryId', value);

  @override
  int get totalWords => RealmObjectBase.get<int>(this, 'totalWords') as int;
  @override
  set totalWords(int value) => RealmObjectBase.set(this, 'totalWords', value);

  @override
  int get learnedWords => RealmObjectBase.get<int>(this, 'learnedWords') as int;
  @override
  set learnedWords(int value) =>
      RealmObjectBase.set(this, 'learnedWords', value);

  @override
  int get masteredWords =>
      RealmObjectBase.get<int>(this, 'masteredWords') as int;
  @override
  set masteredWords(int value) =>
      RealmObjectBase.set(this, 'masteredWords', value);

  @override
  double get accuracy =>
      RealmObjectBase.get<double>(this, 'accuracy') as double;
  @override
  set accuracy(double value) => RealmObjectBase.set(this, 'accuracy', value);

  @override
  int get totalReviews => RealmObjectBase.get<int>(this, 'totalReviews') as int;
  @override
  set totalReviews(int value) =>
      RealmObjectBase.set(this, 'totalReviews', value);

  @override
  DateTime? get lastStudiedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastStudiedAt') as DateTime?;
  @override
  set lastStudiedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastStudiedAt', value);

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
  Stream<RealmObjectChanges<UserProgress>> get changes =>
      RealmObjectBase.getChanges<UserProgress>(this);

  @override
  Stream<RealmObjectChanges<UserProgress>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserProgress>(this, keyPaths);

  @override
  UserProgress freeze() => RealmObjectBase.freezeObject<UserProgress>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'categoryId': categoryId.toEJson(),
      'totalWords': totalWords.toEJson(),
      'learnedWords': learnedWords.toEJson(),
      'masteredWords': masteredWords.toEJson(),
      'accuracy': accuracy.toEJson(),
      'totalReviews': totalReviews.toEJson(),
      'lastStudiedAt': lastStudiedAt.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserProgress value) => value.toEJson();
  static UserProgress _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'categoryId': EJsonValue categoryId,
        'totalWords': EJsonValue totalWords,
        'learnedWords': EJsonValue learnedWords,
        'masteredWords': EJsonValue masteredWords,
        'accuracy': EJsonValue accuracy,
        'totalReviews': EJsonValue totalReviews,
        'createdAt': EJsonValue createdAt,
      } =>
        UserProgress(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(categoryId),
          fromEJson(totalWords),
          fromEJson(learnedWords),
          fromEJson(masteredWords),
          fromEJson(accuracy),
          fromEJson(totalReviews),
          fromEJson(createdAt),
          lastStudiedAt: fromEJson(ejson['lastStudiedAt']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserProgress._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserProgress, 'UserProgress', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('categoryId', RealmPropertyType.string),
      SchemaProperty('totalWords', RealmPropertyType.int),
      SchemaProperty('learnedWords', RealmPropertyType.int),
      SchemaProperty('masteredWords', RealmPropertyType.int),
      SchemaProperty('accuracy', RealmPropertyType.double),
      SchemaProperty('totalReviews', RealmPropertyType.int),
      SchemaProperty('lastStudiedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
