// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends _User with RealmEntity, RealmObjectBase, RealmObject {
  User(
    String id,
    String email,
    DateTime createdAt,
    bool surveyCompleted,
    int level,
    int xp,
    int streak,
    bool isVerified,
    bool isPremium,
    int coins,
    int totalXp,
    int weeklyXp,
    int monthlyXp,
    int dailyGoal,
    int weeklyGoal,
    int currentStreak,
    int longestStreak,
    int totalStudyDays,
    int totalStudyTimeMinutes,
    bool notificationsEnabled,
    bool soundEnabled,
    bool darkModeEnabled,
    bool isActive,
    bool isBlocked,
    int referralCount, {
    String? name,
    String? gender,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
    DateTime? updatedAt,
    String? purpose,
    String? studyTime,
    DateTime? lastLoginAt,
    String? avatarUrl,
    String? deviceId,
    String? fcmToken,
    String? phoneNumber,
    String? country,
    String? timezone,
    String? preferredLanguage,
    String? nativeLanguage,
    DateTime? premiumExpiryDate,
    DateTime? lastStudyDate,
    DateTime? lastSyncAt,
    String? blockedReason,
    DateTime? blockedAt,
    String? referralCode,
    String? referredBy,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'birthDay', birthDay);
    RealmObjectBase.set(this, 'birthMonth', birthMonth);
    RealmObjectBase.set(this, 'birthYear', birthYear);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'purpose', purpose);
    RealmObjectBase.set(this, 'studyTime', studyTime);
    RealmObjectBase.set(this, 'surveyCompleted', surveyCompleted);
    RealmObjectBase.set(this, 'level', level);
    RealmObjectBase.set(this, 'xp', xp);
    RealmObjectBase.set(this, 'streak', streak);
    RealmObjectBase.set(this, 'isVerified', isVerified);
    RealmObjectBase.set(this, 'lastLoginAt', lastLoginAt);
    RealmObjectBase.set(this, 'avatarUrl', avatarUrl);
    RealmObjectBase.set(this, 'deviceId', deviceId);
    RealmObjectBase.set(this, 'fcmToken', fcmToken);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'country', country);
    RealmObjectBase.set(this, 'timezone', timezone);
    RealmObjectBase.set(this, 'preferredLanguage', preferredLanguage);
    RealmObjectBase.set(this, 'nativeLanguage', nativeLanguage);
    RealmObjectBase.set(this, 'isPremium', isPremium);
    RealmObjectBase.set(this, 'premiumExpiryDate', premiumExpiryDate);
    RealmObjectBase.set(this, 'coins', coins);
    RealmObjectBase.set(this, 'totalXp', totalXp);
    RealmObjectBase.set(this, 'weeklyXp', weeklyXp);
    RealmObjectBase.set(this, 'monthlyXp', monthlyXp);
    RealmObjectBase.set(this, 'dailyGoal', dailyGoal);
    RealmObjectBase.set(this, 'weeklyGoal', weeklyGoal);
    RealmObjectBase.set(this, 'currentStreak', currentStreak);
    RealmObjectBase.set(this, 'longestStreak', longestStreak);
    RealmObjectBase.set(this, 'lastStudyDate', lastStudyDate);
    RealmObjectBase.set(this, 'totalStudyDays', totalStudyDays);
    RealmObjectBase.set(this, 'totalStudyTimeMinutes', totalStudyTimeMinutes);
    RealmObjectBase.set(this, 'notificationsEnabled', notificationsEnabled);
    RealmObjectBase.set(this, 'soundEnabled', soundEnabled);
    RealmObjectBase.set(this, 'darkModeEnabled', darkModeEnabled);
    RealmObjectBase.set(this, 'lastSyncAt', lastSyncAt);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'isBlocked', isBlocked);
    RealmObjectBase.set(this, 'blockedReason', blockedReason);
    RealmObjectBase.set(this, 'blockedAt', blockedAt);
    RealmObjectBase.set(this, 'referralCode', referralCode);
    RealmObjectBase.set(this, 'referredBy', referredBy);
    RealmObjectBase.set(this, 'referralCount', referralCount);
  }

  User._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

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
  bool get surveyCompleted =>
      RealmObjectBase.get<bool>(this, 'surveyCompleted') as bool;
  @override
  set surveyCompleted(bool value) =>
      RealmObjectBase.set(this, 'surveyCompleted', value);

  @override
  int get level => RealmObjectBase.get<int>(this, 'level') as int;
  @override
  set level(int value) => RealmObjectBase.set(this, 'level', value);

  @override
  int get xp => RealmObjectBase.get<int>(this, 'xp') as int;
  @override
  set xp(int value) => RealmObjectBase.set(this, 'xp', value);

  @override
  int get streak => RealmObjectBase.get<int>(this, 'streak') as int;
  @override
  set streak(int value) => RealmObjectBase.set(this, 'streak', value);

  @override
  bool get isVerified => RealmObjectBase.get<bool>(this, 'isVerified') as bool;
  @override
  set isVerified(bool value) => RealmObjectBase.set(this, 'isVerified', value);

  @override
  DateTime? get lastLoginAt =>
      RealmObjectBase.get<DateTime>(this, 'lastLoginAt') as DateTime?;
  @override
  set lastLoginAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastLoginAt', value);

  @override
  String? get avatarUrl =>
      RealmObjectBase.get<String>(this, 'avatarUrl') as String?;
  @override
  set avatarUrl(String? value) => RealmObjectBase.set(this, 'avatarUrl', value);

  @override
  String? get deviceId =>
      RealmObjectBase.get<String>(this, 'deviceId') as String?;
  @override
  set deviceId(String? value) => RealmObjectBase.set(this, 'deviceId', value);

  @override
  String? get fcmToken =>
      RealmObjectBase.get<String>(this, 'fcmToken') as String?;
  @override
  set fcmToken(String? value) => RealmObjectBase.set(this, 'fcmToken', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  String? get country =>
      RealmObjectBase.get<String>(this, 'country') as String?;
  @override
  set country(String? value) => RealmObjectBase.set(this, 'country', value);

  @override
  String? get timezone =>
      RealmObjectBase.get<String>(this, 'timezone') as String?;
  @override
  set timezone(String? value) => RealmObjectBase.set(this, 'timezone', value);

  @override
  String? get preferredLanguage =>
      RealmObjectBase.get<String>(this, 'preferredLanguage') as String?;
  @override
  set preferredLanguage(String? value) =>
      RealmObjectBase.set(this, 'preferredLanguage', value);

  @override
  String? get nativeLanguage =>
      RealmObjectBase.get<String>(this, 'nativeLanguage') as String?;
  @override
  set nativeLanguage(String? value) =>
      RealmObjectBase.set(this, 'nativeLanguage', value);

  @override
  bool get isPremium => RealmObjectBase.get<bool>(this, 'isPremium') as bool;
  @override
  set isPremium(bool value) => RealmObjectBase.set(this, 'isPremium', value);

  @override
  DateTime? get premiumExpiryDate =>
      RealmObjectBase.get<DateTime>(this, 'premiumExpiryDate') as DateTime?;
  @override
  set premiumExpiryDate(DateTime? value) =>
      RealmObjectBase.set(this, 'premiumExpiryDate', value);

  @override
  int get coins => RealmObjectBase.get<int>(this, 'coins') as int;
  @override
  set coins(int value) => RealmObjectBase.set(this, 'coins', value);

  @override
  int get totalXp => RealmObjectBase.get<int>(this, 'totalXp') as int;
  @override
  set totalXp(int value) => RealmObjectBase.set(this, 'totalXp', value);

  @override
  int get weeklyXp => RealmObjectBase.get<int>(this, 'weeklyXp') as int;
  @override
  set weeklyXp(int value) => RealmObjectBase.set(this, 'weeklyXp', value);

  @override
  int get monthlyXp => RealmObjectBase.get<int>(this, 'monthlyXp') as int;
  @override
  set monthlyXp(int value) => RealmObjectBase.set(this, 'monthlyXp', value);

  @override
  int get dailyGoal => RealmObjectBase.get<int>(this, 'dailyGoal') as int;
  @override
  set dailyGoal(int value) => RealmObjectBase.set(this, 'dailyGoal', value);

  @override
  int get weeklyGoal => RealmObjectBase.get<int>(this, 'weeklyGoal') as int;
  @override
  set weeklyGoal(int value) => RealmObjectBase.set(this, 'weeklyGoal', value);

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
  int get totalStudyDays =>
      RealmObjectBase.get<int>(this, 'totalStudyDays') as int;
  @override
  set totalStudyDays(int value) =>
      RealmObjectBase.set(this, 'totalStudyDays', value);

  @override
  int get totalStudyTimeMinutes =>
      RealmObjectBase.get<int>(this, 'totalStudyTimeMinutes') as int;
  @override
  set totalStudyTimeMinutes(int value) =>
      RealmObjectBase.set(this, 'totalStudyTimeMinutes', value);

  @override
  bool get notificationsEnabled =>
      RealmObjectBase.get<bool>(this, 'notificationsEnabled') as bool;
  @override
  set notificationsEnabled(bool value) =>
      RealmObjectBase.set(this, 'notificationsEnabled', value);

  @override
  bool get soundEnabled =>
      RealmObjectBase.get<bool>(this, 'soundEnabled') as bool;
  @override
  set soundEnabled(bool value) =>
      RealmObjectBase.set(this, 'soundEnabled', value);

  @override
  bool get darkModeEnabled =>
      RealmObjectBase.get<bool>(this, 'darkModeEnabled') as bool;
  @override
  set darkModeEnabled(bool value) =>
      RealmObjectBase.set(this, 'darkModeEnabled', value);

  @override
  DateTime? get lastSyncAt =>
      RealmObjectBase.get<DateTime>(this, 'lastSyncAt') as DateTime?;
  @override
  set lastSyncAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastSyncAt', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  bool get isBlocked => RealmObjectBase.get<bool>(this, 'isBlocked') as bool;
  @override
  set isBlocked(bool value) => RealmObjectBase.set(this, 'isBlocked', value);

  @override
  String? get blockedReason =>
      RealmObjectBase.get<String>(this, 'blockedReason') as String?;
  @override
  set blockedReason(String? value) =>
      RealmObjectBase.set(this, 'blockedReason', value);

  @override
  DateTime? get blockedAt =>
      RealmObjectBase.get<DateTime>(this, 'blockedAt') as DateTime?;
  @override
  set blockedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'blockedAt', value);

  @override
  String? get referralCode =>
      RealmObjectBase.get<String>(this, 'referralCode') as String?;
  @override
  set referralCode(String? value) =>
      RealmObjectBase.set(this, 'referralCode', value);

  @override
  String? get referredBy =>
      RealmObjectBase.get<String>(this, 'referredBy') as String?;
  @override
  set referredBy(String? value) =>
      RealmObjectBase.set(this, 'referredBy', value);

  @override
  int get referralCount =>
      RealmObjectBase.get<int>(this, 'referralCount') as int;
  @override
  set referralCount(int value) =>
      RealmObjectBase.set(this, 'referralCount', value);

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  Stream<RealmObjectChanges<User>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<User>(this, keyPaths);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'email': email.toEJson(),
      'name': name.toEJson(),
      'gender': gender.toEJson(),
      'birthDay': birthDay.toEJson(),
      'birthMonth': birthMonth.toEJson(),
      'birthYear': birthYear.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'purpose': purpose.toEJson(),
      'studyTime': studyTime.toEJson(),
      'surveyCompleted': surveyCompleted.toEJson(),
      'level': level.toEJson(),
      'xp': xp.toEJson(),
      'streak': streak.toEJson(),
      'isVerified': isVerified.toEJson(),
      'lastLoginAt': lastLoginAt.toEJson(),
      'avatarUrl': avatarUrl.toEJson(),
      'deviceId': deviceId.toEJson(),
      'fcmToken': fcmToken.toEJson(),
      'phoneNumber': phoneNumber.toEJson(),
      'country': country.toEJson(),
      'timezone': timezone.toEJson(),
      'preferredLanguage': preferredLanguage.toEJson(),
      'nativeLanguage': nativeLanguage.toEJson(),
      'isPremium': isPremium.toEJson(),
      'premiumExpiryDate': premiumExpiryDate.toEJson(),
      'coins': coins.toEJson(),
      'totalXp': totalXp.toEJson(),
      'weeklyXp': weeklyXp.toEJson(),
      'monthlyXp': monthlyXp.toEJson(),
      'dailyGoal': dailyGoal.toEJson(),
      'weeklyGoal': weeklyGoal.toEJson(),
      'currentStreak': currentStreak.toEJson(),
      'longestStreak': longestStreak.toEJson(),
      'lastStudyDate': lastStudyDate.toEJson(),
      'totalStudyDays': totalStudyDays.toEJson(),
      'totalStudyTimeMinutes': totalStudyTimeMinutes.toEJson(),
      'notificationsEnabled': notificationsEnabled.toEJson(),
      'soundEnabled': soundEnabled.toEJson(),
      'darkModeEnabled': darkModeEnabled.toEJson(),
      'lastSyncAt': lastSyncAt.toEJson(),
      'isActive': isActive.toEJson(),
      'isBlocked': isBlocked.toEJson(),
      'blockedReason': blockedReason.toEJson(),
      'blockedAt': blockedAt.toEJson(),
      'referralCode': referralCode.toEJson(),
      'referredBy': referredBy.toEJson(),
      'referralCount': referralCount.toEJson(),
    };
  }

  static EJsonValue _toEJson(User value) => value.toEJson();
  static User _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'email': EJsonValue email,
        'createdAt': EJsonValue createdAt,
        'surveyCompleted': EJsonValue surveyCompleted,
        'level': EJsonValue level,
        'xp': EJsonValue xp,
        'streak': EJsonValue streak,
        'isVerified': EJsonValue isVerified,
        'isPremium': EJsonValue isPremium,
        'coins': EJsonValue coins,
        'totalXp': EJsonValue totalXp,
        'weeklyXp': EJsonValue weeklyXp,
        'monthlyXp': EJsonValue monthlyXp,
        'dailyGoal': EJsonValue dailyGoal,
        'weeklyGoal': EJsonValue weeklyGoal,
        'currentStreak': EJsonValue currentStreak,
        'longestStreak': EJsonValue longestStreak,
        'totalStudyDays': EJsonValue totalStudyDays,
        'totalStudyTimeMinutes': EJsonValue totalStudyTimeMinutes,
        'notificationsEnabled': EJsonValue notificationsEnabled,
        'soundEnabled': EJsonValue soundEnabled,
        'darkModeEnabled': EJsonValue darkModeEnabled,
        'isActive': EJsonValue isActive,
        'isBlocked': EJsonValue isBlocked,
        'referralCount': EJsonValue referralCount,
      } =>
        User(
          fromEJson(id),
          fromEJson(email),
          fromEJson(createdAt),
          fromEJson(surveyCompleted),
          fromEJson(level),
          fromEJson(xp),
          fromEJson(streak),
          fromEJson(isVerified),
          fromEJson(isPremium),
          fromEJson(coins),
          fromEJson(totalXp),
          fromEJson(weeklyXp),
          fromEJson(monthlyXp),
          fromEJson(dailyGoal),
          fromEJson(weeklyGoal),
          fromEJson(currentStreak),
          fromEJson(longestStreak),
          fromEJson(totalStudyDays),
          fromEJson(totalStudyTimeMinutes),
          fromEJson(notificationsEnabled),
          fromEJson(soundEnabled),
          fromEJson(darkModeEnabled),
          fromEJson(isActive),
          fromEJson(isBlocked),
          fromEJson(referralCount),
          name: fromEJson(ejson['name']),
          gender: fromEJson(ejson['gender']),
          birthDay: fromEJson(ejson['birthDay']),
          birthMonth: fromEJson(ejson['birthMonth']),
          birthYear: fromEJson(ejson['birthYear']),
          updatedAt: fromEJson(ejson['updatedAt']),
          purpose: fromEJson(ejson['purpose']),
          studyTime: fromEJson(ejson['studyTime']),
          lastLoginAt: fromEJson(ejson['lastLoginAt']),
          avatarUrl: fromEJson(ejson['avatarUrl']),
          deviceId: fromEJson(ejson['deviceId']),
          fcmToken: fromEJson(ejson['fcmToken']),
          phoneNumber: fromEJson(ejson['phoneNumber']),
          country: fromEJson(ejson['country']),
          timezone: fromEJson(ejson['timezone']),
          preferredLanguage: fromEJson(ejson['preferredLanguage']),
          nativeLanguage: fromEJson(ejson['nativeLanguage']),
          premiumExpiryDate: fromEJson(ejson['premiumExpiryDate']),
          lastStudyDate: fromEJson(ejson['lastStudyDate']),
          lastSyncAt: fromEJson(ejson['lastSyncAt']),
          blockedReason: fromEJson(ejson['blockedReason']),
          blockedAt: fromEJson(ejson['blockedAt']),
          referralCode: fromEJson(ejson['referralCode']),
          referredBy: fromEJson(ejson['referredBy']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(User._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, User, 'User', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('gender', RealmPropertyType.string, optional: true),
      SchemaProperty('birthDay', RealmPropertyType.string, optional: true),
      SchemaProperty('birthMonth', RealmPropertyType.string, optional: true),
      SchemaProperty('birthYear', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('purpose', RealmPropertyType.string, optional: true),
      SchemaProperty('studyTime', RealmPropertyType.string, optional: true),
      SchemaProperty('surveyCompleted', RealmPropertyType.bool),
      SchemaProperty('level', RealmPropertyType.int),
      SchemaProperty('xp', RealmPropertyType.int),
      SchemaProperty('streak', RealmPropertyType.int),
      SchemaProperty('isVerified', RealmPropertyType.bool),
      SchemaProperty('lastLoginAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('avatarUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('deviceId', RealmPropertyType.string, optional: true),
      SchemaProperty('fcmToken', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('country', RealmPropertyType.string, optional: true),
      SchemaProperty('timezone', RealmPropertyType.string, optional: true),
      SchemaProperty('preferredLanguage', RealmPropertyType.string,
          optional: true),
      SchemaProperty('nativeLanguage', RealmPropertyType.string,
          optional: true),
      SchemaProperty('isPremium', RealmPropertyType.bool),
      SchemaProperty('premiumExpiryDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('coins', RealmPropertyType.int),
      SchemaProperty('totalXp', RealmPropertyType.int),
      SchemaProperty('weeklyXp', RealmPropertyType.int),
      SchemaProperty('monthlyXp', RealmPropertyType.int),
      SchemaProperty('dailyGoal', RealmPropertyType.int),
      SchemaProperty('weeklyGoal', RealmPropertyType.int),
      SchemaProperty('currentStreak', RealmPropertyType.int),
      SchemaProperty('longestStreak', RealmPropertyType.int),
      SchemaProperty('lastStudyDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('totalStudyDays', RealmPropertyType.int),
      SchemaProperty('totalStudyTimeMinutes', RealmPropertyType.int),
      SchemaProperty('notificationsEnabled', RealmPropertyType.bool),
      SchemaProperty('soundEnabled', RealmPropertyType.bool),
      SchemaProperty('darkModeEnabled', RealmPropertyType.bool),
      SchemaProperty('lastSyncAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('isBlocked', RealmPropertyType.bool),
      SchemaProperty('blockedReason', RealmPropertyType.string, optional: true),
      SchemaProperty('blockedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('referralCode', RealmPropertyType.string, optional: true),
      SchemaProperty('referredBy', RealmPropertyType.string, optional: true),
      SchemaProperty('referralCount', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
