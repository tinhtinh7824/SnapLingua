// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Achievement extends _Achievement
    with RealmEntity, RealmObjectBase, RealmObject {
  Achievement(
    String id,
    String name,
    String description,
    String type,
    String condition,
    int xpReward,
    int coinReward,
    bool isActive,
    DateTime createdAt, {
    String? iconUrl,
    String? badgeUrl,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'iconUrl', iconUrl);
    RealmObjectBase.set(this, 'condition', condition);
    RealmObjectBase.set(this, 'xpReward', xpReward);
    RealmObjectBase.set(this, 'coinReward', coinReward);
    RealmObjectBase.set(this, 'badgeUrl', badgeUrl);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Achievement._();

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
  String? get iconUrl =>
      RealmObjectBase.get<String>(this, 'iconUrl') as String?;
  @override
  set iconUrl(String? value) => RealmObjectBase.set(this, 'iconUrl', value);

  @override
  String get condition =>
      RealmObjectBase.get<String>(this, 'condition') as String;
  @override
  set condition(String value) => RealmObjectBase.set(this, 'condition', value);

  @override
  int get xpReward => RealmObjectBase.get<int>(this, 'xpReward') as int;
  @override
  set xpReward(int value) => RealmObjectBase.set(this, 'xpReward', value);

  @override
  int get coinReward => RealmObjectBase.get<int>(this, 'coinReward') as int;
  @override
  set coinReward(int value) => RealmObjectBase.set(this, 'coinReward', value);

  @override
  String? get badgeUrl =>
      RealmObjectBase.get<String>(this, 'badgeUrl') as String?;
  @override
  set badgeUrl(String? value) => RealmObjectBase.set(this, 'badgeUrl', value);

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
  Stream<RealmObjectChanges<Achievement>> get changes =>
      RealmObjectBase.getChanges<Achievement>(this);

  @override
  Stream<RealmObjectChanges<Achievement>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Achievement>(this, keyPaths);

  @override
  Achievement freeze() => RealmObjectBase.freezeObject<Achievement>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'type': type.toEJson(),
      'iconUrl': iconUrl.toEJson(),
      'condition': condition.toEJson(),
      'xpReward': xpReward.toEJson(),
      'coinReward': coinReward.toEJson(),
      'badgeUrl': badgeUrl.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Achievement value) => value.toEJson();
  static Achievement _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'type': EJsonValue type,
        'condition': EJsonValue condition,
        'xpReward': EJsonValue xpReward,
        'coinReward': EJsonValue coinReward,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        Achievement(
          fromEJson(id),
          fromEJson(name),
          fromEJson(description),
          fromEJson(type),
          fromEJson(condition),
          fromEJson(xpReward),
          fromEJson(coinReward),
          fromEJson(isActive),
          fromEJson(createdAt),
          iconUrl: fromEJson(ejson['iconUrl']),
          badgeUrl: fromEJson(ejson['badgeUrl']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Achievement._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, Achievement, 'Achievement', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('iconUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('condition', RealmPropertyType.string),
      SchemaProperty('xpReward', RealmPropertyType.int),
      SchemaProperty('coinReward', RealmPropertyType.int),
      SchemaProperty('badgeUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserAchievement extends _UserAchievement
    with RealmEntity, RealmObjectBase, RealmObject {
  UserAchievement(
    String id,
    String userId,
    String achievementId,
    DateTime earnedAt,
    bool isNotified,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'achievementId', achievementId);
    RealmObjectBase.set(this, 'earnedAt', earnedAt);
    RealmObjectBase.set(this, 'isNotified', isNotified);
  }

  UserAchievement._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get achievementId =>
      RealmObjectBase.get<String>(this, 'achievementId') as String;
  @override
  set achievementId(String value) =>
      RealmObjectBase.set(this, 'achievementId', value);

  @override
  DateTime get earnedAt =>
      RealmObjectBase.get<DateTime>(this, 'earnedAt') as DateTime;
  @override
  set earnedAt(DateTime value) => RealmObjectBase.set(this, 'earnedAt', value);

  @override
  bool get isNotified => RealmObjectBase.get<bool>(this, 'isNotified') as bool;
  @override
  set isNotified(bool value) => RealmObjectBase.set(this, 'isNotified', value);

  @override
  Stream<RealmObjectChanges<UserAchievement>> get changes =>
      RealmObjectBase.getChanges<UserAchievement>(this);

  @override
  Stream<RealmObjectChanges<UserAchievement>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserAchievement>(this, keyPaths);

  @override
  UserAchievement freeze() =>
      RealmObjectBase.freezeObject<UserAchievement>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'achievementId': achievementId.toEJson(),
      'earnedAt': earnedAt.toEJson(),
      'isNotified': isNotified.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserAchievement value) => value.toEJson();
  static UserAchievement _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'achievementId': EJsonValue achievementId,
        'earnedAt': EJsonValue earnedAt,
        'isNotified': EJsonValue isNotified,
      } =>
        UserAchievement(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(achievementId),
          fromEJson(earnedAt),
          fromEJson(isNotified),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserAchievement._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserAchievement, 'UserAchievement', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('achievementId', RealmPropertyType.string),
      SchemaProperty('earnedAt', RealmPropertyType.timestamp),
      SchemaProperty('isNotified', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Badge extends _Badge with RealmEntity, RealmObjectBase, RealmObject {
  Badge(
    String id,
    String name,
    String description,
    String rarity,
    String category,
    DateTime createdAt, {
    String? imageUrl,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'rarity', rarity);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Badge._();

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
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  String get rarity => RealmObjectBase.get<String>(this, 'rarity') as String;
  @override
  set rarity(String value) => RealmObjectBase.set(this, 'rarity', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Badge>> get changes =>
      RealmObjectBase.getChanges<Badge>(this);

  @override
  Stream<RealmObjectChanges<Badge>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Badge>(this, keyPaths);

  @override
  Badge freeze() => RealmObjectBase.freezeObject<Badge>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'rarity': rarity.toEJson(),
      'category': category.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Badge value) => value.toEJson();
  static Badge _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'rarity': EJsonValue rarity,
        'category': EJsonValue category,
        'createdAt': EJsonValue createdAt,
      } =>
        Badge(
          fromEJson(id),
          fromEJson(name),
          fromEJson(description),
          fromEJson(rarity),
          fromEJson(category),
          fromEJson(createdAt),
          imageUrl: fromEJson(ejson['imageUrl']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Badge._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Badge, 'Badge', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('rarity', RealmPropertyType.string),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserBadge extends _UserBadge
    with RealmEntity, RealmObjectBase, RealmObject {
  UserBadge(
    String id,
    String userId,
    String badgeId,
    DateTime earnedAt,
    bool isDisplayed,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'badgeId', badgeId);
    RealmObjectBase.set(this, 'earnedAt', earnedAt);
    RealmObjectBase.set(this, 'isDisplayed', isDisplayed);
  }

  UserBadge._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get badgeId => RealmObjectBase.get<String>(this, 'badgeId') as String;
  @override
  set badgeId(String value) => RealmObjectBase.set(this, 'badgeId', value);

  @override
  DateTime get earnedAt =>
      RealmObjectBase.get<DateTime>(this, 'earnedAt') as DateTime;
  @override
  set earnedAt(DateTime value) => RealmObjectBase.set(this, 'earnedAt', value);

  @override
  bool get isDisplayed =>
      RealmObjectBase.get<bool>(this, 'isDisplayed') as bool;
  @override
  set isDisplayed(bool value) =>
      RealmObjectBase.set(this, 'isDisplayed', value);

  @override
  Stream<RealmObjectChanges<UserBadge>> get changes =>
      RealmObjectBase.getChanges<UserBadge>(this);

  @override
  Stream<RealmObjectChanges<UserBadge>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserBadge>(this, keyPaths);

  @override
  UserBadge freeze() => RealmObjectBase.freezeObject<UserBadge>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'badgeId': badgeId.toEJson(),
      'earnedAt': earnedAt.toEJson(),
      'isDisplayed': isDisplayed.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserBadge value) => value.toEJson();
  static UserBadge _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'badgeId': EJsonValue badgeId,
        'earnedAt': EJsonValue earnedAt,
        'isDisplayed': EJsonValue isDisplayed,
      } =>
        UserBadge(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(badgeId),
          fromEJson(earnedAt),
          fromEJson(isDisplayed),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserBadge._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, UserBadge, 'UserBadge', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('badgeId', RealmPropertyType.string),
      SchemaProperty('earnedAt', RealmPropertyType.timestamp),
      SchemaProperty('isDisplayed', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Leaderboard extends _Leaderboard
    with RealmEntity, RealmObjectBase, RealmObject {
  Leaderboard(
    String id,
    String userId,
    String type,
    int xp,
    int rank,
    DateTime periodStart,
    DateTime periodEnd, {
    DateTime? lastUpdatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'xp', xp);
    RealmObjectBase.set(this, 'rank', rank);
    RealmObjectBase.set(this, 'periodStart', periodStart);
    RealmObjectBase.set(this, 'periodEnd', periodEnd);
    RealmObjectBase.set(this, 'lastUpdatedAt', lastUpdatedAt);
  }

  Leaderboard._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  int get xp => RealmObjectBase.get<int>(this, 'xp') as int;
  @override
  set xp(int value) => RealmObjectBase.set(this, 'xp', value);

  @override
  int get rank => RealmObjectBase.get<int>(this, 'rank') as int;
  @override
  set rank(int value) => RealmObjectBase.set(this, 'rank', value);

  @override
  DateTime get periodStart =>
      RealmObjectBase.get<DateTime>(this, 'periodStart') as DateTime;
  @override
  set periodStart(DateTime value) =>
      RealmObjectBase.set(this, 'periodStart', value);

  @override
  DateTime get periodEnd =>
      RealmObjectBase.get<DateTime>(this, 'periodEnd') as DateTime;
  @override
  set periodEnd(DateTime value) =>
      RealmObjectBase.set(this, 'periodEnd', value);

  @override
  DateTime? get lastUpdatedAt =>
      RealmObjectBase.get<DateTime>(this, 'lastUpdatedAt') as DateTime?;
  @override
  set lastUpdatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastUpdatedAt', value);

  @override
  Stream<RealmObjectChanges<Leaderboard>> get changes =>
      RealmObjectBase.getChanges<Leaderboard>(this);

  @override
  Stream<RealmObjectChanges<Leaderboard>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Leaderboard>(this, keyPaths);

  @override
  Leaderboard freeze() => RealmObjectBase.freezeObject<Leaderboard>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'type': type.toEJson(),
      'xp': xp.toEJson(),
      'rank': rank.toEJson(),
      'periodStart': periodStart.toEJson(),
      'periodEnd': periodEnd.toEJson(),
      'lastUpdatedAt': lastUpdatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Leaderboard value) => value.toEJson();
  static Leaderboard _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'type': EJsonValue type,
        'xp': EJsonValue xp,
        'rank': EJsonValue rank,
        'periodStart': EJsonValue periodStart,
        'periodEnd': EJsonValue periodEnd,
      } =>
        Leaderboard(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(type),
          fromEJson(xp),
          fromEJson(rank),
          fromEJson(periodStart),
          fromEJson(periodEnd),
          lastUpdatedAt: fromEJson(ejson['lastUpdatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Leaderboard._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, Leaderboard, 'Leaderboard', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('xp', RealmPropertyType.int),
      SchemaProperty('rank', RealmPropertyType.int),
      SchemaProperty('periodStart', RealmPropertyType.timestamp),
      SchemaProperty('periodEnd', RealmPropertyType.timestamp),
      SchemaProperty('lastUpdatedAt', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserStreak extends _UserStreak
    with RealmEntity, RealmObjectBase, RealmObject {
  UserStreak(
    String id,
    String userId,
    int currentStreak,
    int longestStreak,
    bool isActive,
    DateTime createdAt, {
    DateTime? lastStudyDate,
    DateTime? streakStartDate,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'currentStreak', currentStreak);
    RealmObjectBase.set(this, 'longestStreak', longestStreak);
    RealmObjectBase.set(this, 'lastStudyDate', lastStudyDate);
    RealmObjectBase.set(this, 'streakStartDate', streakStartDate);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  UserStreak._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  int get currentStreak =>
      RealmObjectBase.get<int>(this, 'currentStreak') as int;
  @override
  set currentStreak(int value) =>
      RealmObjectBase.set(this, 'currentStreak', value);

  @override
  int get longestStreak =>
      RealmObjectBase.get<int>(this, 'longestStreak') as int;
  @override
  set longestStreak(int value) =>
      RealmObjectBase.set(this, 'longestStreak', value);

  @override
  DateTime? get lastStudyDate =>
      RealmObjectBase.get<DateTime>(this, 'lastStudyDate') as DateTime?;
  @override
  set lastStudyDate(DateTime? value) =>
      RealmObjectBase.set(this, 'lastStudyDate', value);

  @override
  DateTime? get streakStartDate =>
      RealmObjectBase.get<DateTime>(this, 'streakStartDate') as DateTime?;
  @override
  set streakStartDate(DateTime? value) =>
      RealmObjectBase.set(this, 'streakStartDate', value);

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
  Stream<RealmObjectChanges<UserStreak>> get changes =>
      RealmObjectBase.getChanges<UserStreak>(this);

  @override
  Stream<RealmObjectChanges<UserStreak>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserStreak>(this, keyPaths);

  @override
  UserStreak freeze() => RealmObjectBase.freezeObject<UserStreak>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'currentStreak': currentStreak.toEJson(),
      'longestStreak': longestStreak.toEJson(),
      'lastStudyDate': lastStudyDate.toEJson(),
      'streakStartDate': streakStartDate.toEJson(),
      'isActive': isActive.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserStreak value) => value.toEJson();
  static UserStreak _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'currentStreak': EJsonValue currentStreak,
        'longestStreak': EJsonValue longestStreak,
        'isActive': EJsonValue isActive,
        'createdAt': EJsonValue createdAt,
      } =>
        UserStreak(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(currentStreak),
          fromEJson(longestStreak),
          fromEJson(isActive),
          fromEJson(createdAt),
          lastStudyDate: fromEJson(ejson['lastStudyDate']),
          streakStartDate: fromEJson(ejson['streakStartDate']),
          updatedAt: fromEJson(ejson['updatedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserStreak._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserStreak, 'UserStreak', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('currentStreak', RealmPropertyType.int),
      SchemaProperty('longestStreak', RealmPropertyType.int),
      SchemaProperty('lastStudyDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('streakStartDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DailyChallenge extends _DailyChallenge
    with RealmEntity, RealmObjectBase, RealmObject {
  DailyChallenge(
    String id,
    String name,
    String description,
    String type,
    String goal,
    int xpReward,
    int coinReward,
    DateTime challengeDate,
    bool isActive,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'goal', goal);
    RealmObjectBase.set(this, 'xpReward', xpReward);
    RealmObjectBase.set(this, 'coinReward', coinReward);
    RealmObjectBase.set(this, 'challengeDate', challengeDate);
    RealmObjectBase.set(this, 'isActive', isActive);
  }

  DailyChallenge._();

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
  String get goal => RealmObjectBase.get<String>(this, 'goal') as String;
  @override
  set goal(String value) => RealmObjectBase.set(this, 'goal', value);

  @override
  int get xpReward => RealmObjectBase.get<int>(this, 'xpReward') as int;
  @override
  set xpReward(int value) => RealmObjectBase.set(this, 'xpReward', value);

  @override
  int get coinReward => RealmObjectBase.get<int>(this, 'coinReward') as int;
  @override
  set coinReward(int value) => RealmObjectBase.set(this, 'coinReward', value);

  @override
  DateTime get challengeDate =>
      RealmObjectBase.get<DateTime>(this, 'challengeDate') as DateTime;
  @override
  set challengeDate(DateTime value) =>
      RealmObjectBase.set(this, 'challengeDate', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  Stream<RealmObjectChanges<DailyChallenge>> get changes =>
      RealmObjectBase.getChanges<DailyChallenge>(this);

  @override
  Stream<RealmObjectChanges<DailyChallenge>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DailyChallenge>(this, keyPaths);

  @override
  DailyChallenge freeze() => RealmObjectBase.freezeObject<DailyChallenge>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'type': type.toEJson(),
      'goal': goal.toEJson(),
      'xpReward': xpReward.toEJson(),
      'coinReward': coinReward.toEJson(),
      'challengeDate': challengeDate.toEJson(),
      'isActive': isActive.toEJson(),
    };
  }

  static EJsonValue _toEJson(DailyChallenge value) => value.toEJson();
  static DailyChallenge _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'type': EJsonValue type,
        'goal': EJsonValue goal,
        'xpReward': EJsonValue xpReward,
        'coinReward': EJsonValue coinReward,
        'challengeDate': EJsonValue challengeDate,
        'isActive': EJsonValue isActive,
      } =>
        DailyChallenge(
          fromEJson(id),
          fromEJson(name),
          fromEJson(description),
          fromEJson(type),
          fromEJson(goal),
          fromEJson(xpReward),
          fromEJson(coinReward),
          fromEJson(challengeDate),
          fromEJson(isActive),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DailyChallenge._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DailyChallenge, 'DailyChallenge', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('goal', RealmPropertyType.string),
      SchemaProperty('xpReward', RealmPropertyType.int),
      SchemaProperty('coinReward', RealmPropertyType.int),
      SchemaProperty('challengeDate', RealmPropertyType.timestamp),
      SchemaProperty('isActive', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserDailyChallenge extends _UserDailyChallenge
    with RealmEntity, RealmObjectBase, RealmObject {
  UserDailyChallenge(
    String id,
    String userId,
    String dailyChallengeId,
    double progress,
    bool isCompleted,
    int xpEarned,
    int coinsEarned,
    DateTime createdAt, {
    DateTime? completedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'dailyChallengeId', dailyChallengeId);
    RealmObjectBase.set(this, 'progress', progress);
    RealmObjectBase.set(this, 'isCompleted', isCompleted);
    RealmObjectBase.set(this, 'completedAt', completedAt);
    RealmObjectBase.set(this, 'xpEarned', xpEarned);
    RealmObjectBase.set(this, 'coinsEarned', coinsEarned);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  UserDailyChallenge._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get dailyChallengeId =>
      RealmObjectBase.get<String>(this, 'dailyChallengeId') as String;
  @override
  set dailyChallengeId(String value) =>
      RealmObjectBase.set(this, 'dailyChallengeId', value);

  @override
  double get progress =>
      RealmObjectBase.get<double>(this, 'progress') as double;
  @override
  set progress(double value) => RealmObjectBase.set(this, 'progress', value);

  @override
  bool get isCompleted =>
      RealmObjectBase.get<bool>(this, 'isCompleted') as bool;
  @override
  set isCompleted(bool value) =>
      RealmObjectBase.set(this, 'isCompleted', value);

  @override
  DateTime? get completedAt =>
      RealmObjectBase.get<DateTime>(this, 'completedAt') as DateTime?;
  @override
  set completedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'completedAt', value);

  @override
  int get xpEarned => RealmObjectBase.get<int>(this, 'xpEarned') as int;
  @override
  set xpEarned(int value) => RealmObjectBase.set(this, 'xpEarned', value);

  @override
  int get coinsEarned => RealmObjectBase.get<int>(this, 'coinsEarned') as int;
  @override
  set coinsEarned(int value) => RealmObjectBase.set(this, 'coinsEarned', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<UserDailyChallenge>> get changes =>
      RealmObjectBase.getChanges<UserDailyChallenge>(this);

  @override
  Stream<RealmObjectChanges<UserDailyChallenge>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserDailyChallenge>(this, keyPaths);

  @override
  UserDailyChallenge freeze() =>
      RealmObjectBase.freezeObject<UserDailyChallenge>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'userId': userId.toEJson(),
      'dailyChallengeId': dailyChallengeId.toEJson(),
      'progress': progress.toEJson(),
      'isCompleted': isCompleted.toEJson(),
      'completedAt': completedAt.toEJson(),
      'xpEarned': xpEarned.toEJson(),
      'coinsEarned': coinsEarned.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserDailyChallenge value) => value.toEJson();
  static UserDailyChallenge _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'userId': EJsonValue userId,
        'dailyChallengeId': EJsonValue dailyChallengeId,
        'progress': EJsonValue progress,
        'isCompleted': EJsonValue isCompleted,
        'xpEarned': EJsonValue xpEarned,
        'coinsEarned': EJsonValue coinsEarned,
        'createdAt': EJsonValue createdAt,
      } =>
        UserDailyChallenge(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(dailyChallengeId),
          fromEJson(progress),
          fromEJson(isCompleted),
          fromEJson(xpEarned),
          fromEJson(coinsEarned),
          fromEJson(createdAt),
          completedAt: fromEJson(ejson['completedAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserDailyChallenge._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserDailyChallenge, 'UserDailyChallenge', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('dailyChallengeId', RealmPropertyType.string),
      SchemaProperty('progress', RealmPropertyType.double),
      SchemaProperty('isCompleted', RealmPropertyType.bool),
      SchemaProperty('completedAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('xpEarned', RealmPropertyType.int),
      SchemaProperty('coinsEarned', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
