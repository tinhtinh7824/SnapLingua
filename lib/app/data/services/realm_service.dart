import 'package:get/get.dart';
import 'package:realm/realm.dart' as realm_db;
import 'package:snaplingua/app/data/models/realm/admin_model.dart';
import 'package:snaplingua/app/data/models/realm/auth_model.dart';
import 'package:snaplingua/app/data/models/realm/camera_model.dart';
import 'package:snaplingua/app/data/models/realm/community_model.dart';
import 'package:snaplingua/app/data/models/realm/database_schema.dart';
import 'package:snaplingua/app/data/models/realm/gamification_model.dart';
import 'package:snaplingua/app/data/models/realm/lesson_model.dart';
import 'package:snaplingua/app/data/models/realm/notification_model.dart';
import 'package:snaplingua/app/data/models/realm/survey_model.dart';
import 'package:snaplingua/app/data/models/realm/user_model.dart';
import 'package:snaplingua/app/data/models/realm/vocabulary_model.dart';

class RealmService extends GetxService {
  static RealmService get to => Get.find();

  late realm_db.Realm _realm;
  // realm_db.App? _app; // TODO: Uncomment when Atlas is configured
  // realm_db.User? _currentUser; // TODO: Uncomment when Atlas is configured

  // MongoDB Atlas App configuration
  static const String appId = 'your-mongodb-atlas-app-id'; // Replace with your Atlas App ID

  // Schema configuration
  late realm_db.Configuration _config;

  // Getter for realm instance
  realm_db.Realm? get realm => _realm;

  /// Static factory method for initialization
  static Future<RealmService> init() async {
    final service = RealmService();
    await service._initializeRealm();
    return service;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeRealm();
  }

  Future<void> _initializeRealm() async {
    try {
      // TODO: Initialize the Realm App when Atlas App ID is configured
      // _app = realm_db.App(realm_db.AppConfiguration(appId));

      // Define schema
      _config = realm_db.Configuration.local([
        User.schema,
        SurveyResponse.schema,
        AuthSession.schema,
        PasswordReset.schema,
        // Vocabulary models
        Vocabulary.schema,
        UserVocabulary.schema,
        VocabularyReview.schema,
        Category.schema,
        UserProgress.schema,
        // Lesson models
        Lesson.schema,
        LessonContent.schema,
        UserLesson.schema,
        Exercise.schema,
        UserExercise.schema,
        // Gamification models
        Achievement.schema,
        UserAchievement.schema,
        Badge.schema,
        UserBadge.schema,
        Leaderboard.schema,
        UserStreak.schema,
        DailyChallenge.schema,
        UserDailyChallenge.schema,
        // Community models
        StudyGroup.schema,
        StudyGroupMember.schema,
        StudyGroupMessage.schema,
        Friend.schema,
        UserSession.schema,
        Competition.schema,
        CompetitionParticipant.schema,
        // Camera models
        CameraSession.schema,
        DetectedObject.schema,
        CameraHistory.schema,
        // Notification models
        Notification.schema,
        NotificationPreference.schema,
        PushToken.schema,
        // Admin models
        AdminUser.schema,
        SystemConfig.schema,
        UserReport.schema,
        ContentModerationLog.schema,
        SystemLog.schema,
        AppVersion.schema,
        // Database schema derived from PDF specification
        DbUser.schema,
        AuthProviderEntity.schema,
        UserSecurityEntity.schema,
        DeviceTokenEntity.schema,
        BadgeEntity.schema,
        UserBadgeEntity.schema,
        PhotoEntity.schema,
        DetectionEntity.schema,
        DetectionWordEntity.schema,
        DictionaryWordEntity.schema,
        PersonalWordEntity.schema,
        TopicEntity.schema,
        PersonalWordTopicEntity.schema,
        WordMergeEntity.schema,
        StudySessionEntity.schema,
        SessionItemEntity.schema,
        DailyProgressEntity.schema,
        UserGoalEntity.schema,
        PostEntity.schema,
        PostWordEntity.schema,
        PostLikeEntity.schema,
        PostCommentEntity.schema,
        PostReportEntity.schema,
        GroupEntity.schema,
        GroupMemberEntity.schema,
        GroupMessageEntity.schema,
        LeagueTierEntity.schema,
        LeagueCycleEntity.schema,
        LeagueMemberEntity.schema,
        XpTransactionEntity.schema,
        ItemEntity.schema,
        UserInventoryEntity.schema,
        NotificationSettingEntity.schema,
        NotificationEntity.schema,
        AdminActionEntity.schema,
      ]);

      // Open the local Realm
      _realm = realm_db.Realm(_config);

      print('Realm initialized successfully');
    } catch (e) {
      print('Error initializing Realm: $e');
      rethrow;
    }
  }

  // Authentication methods (simplified for local development)
  Future<bool> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement actual Atlas authentication when App ID is configured
      // For now, simulate successful login for local development
      print('Login simulation for: $email');
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement actual Atlas registration when App ID is configured
      // For now, simulate successful registration for local development
      print('Registration simulation for: $email');
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // TODO: Implement actual logout when Atlas is configured
      print('Logout simulation');
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  // TODO: Uncomment when implementing Atlas sync
  // Future<void> _configureSyncedRealm() async {
  //   try {
  //     // Configure sync when Atlas App is properly set up
  //     print('Sync configuration skipped - using local realm');
  //   } catch (e) {
  //     print('Sync configuration error: $e');
  //     rethrow;
  //   }
  // }

  // User data methods
  Future<User> createUser({
    required String email,
    String? displayName,
    String? avatarUrl,
    String role = 'user',
    String status = 'active',
  }) async {
    try {
      final userId = realm_db.Uuid.v4().toString();

      final user = User(
        userId,
        role,
        status,
        DateTime.now(),
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
        updatedAt: DateTime.now(),
      );

      _realm.write(() {
        _realm.add(user);
      });

      return user;
    } catch (e) {
      print('Create user error: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      final user = _realm.find<User>(userId);
      if (user == null) throw Exception('User not found');

      _realm.write(() {
        if (updates.containsKey('email')) {
          user.email = updates['email'] as String?;
        }
        if (updates.containsKey('displayName')) {
          user.displayName = updates['displayName'] as String?;
        }
        if (updates.containsKey('avatarUrl')) {
          user.avatarUrl = updates['avatarUrl'] as String?;
        }
        if (updates.containsKey('role')) {
          user.role = updates['role'] as String;
        }
        if (updates.containsKey('status')) {
          user.status = updates['status'] as String;
        }
        if (updates.containsKey('updatedAt')) {
          user.updatedAt = updates['updatedAt'] as DateTime?;
        } else {
          user.updatedAt = DateTime.now();
        }
      });
    } catch (e) {
      print('Update user error: $e');
      rethrow;
    }
  }

  User? getUserById(String userId) {
    try {
      return _realm.find<User>(userId);
    } catch (e) {
      print('Get user by id error: $e');
      return null;
    }
  }

  User? getUserByEmail({required String email}) {
    try {
      final results = _realm.query<User>('email == \$0', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print('Get user by email error: $e');
      return null;
    }
  }

  // Survey methods
  Future<void> saveSurveyResponse({
    required String userId,
    required String name,
    required String gender,
    required String birthDay,
    required String birthMonth,
    required String birthYear,
    required String purpose,
    required String studyTime,
  }) async {
    try {
      final surveyId = DateTime.now().millisecondsSinceEpoch.toString();

      final survey = SurveyResponse(
        surveyId,
        userId,
        DateTime.now(),
        DateTime.now(),
        name: name,
        gender: gender,
        birthDay: birthDay,
        birthMonth: birthMonth,
        birthYear: birthYear,
        purpose: purpose,
        studyTime: studyTime,
      );

      _realm.write(() {
        _realm.add(survey);
      });

    } catch (e) {
      print('Save survey error: $e');
      rethrow;
    }
  }

  // Password reset methods
  Future<void> createPasswordReset({
    required String email,
    required String resetCode,
  }) async {
    try {
      final resetId = DateTime.now().millisecondsSinceEpoch.toString();

      final passwordReset = PasswordReset(
        resetId,
        email,
        resetCode,
        DateTime.now().add(const Duration(hours: 1)), // Expires in 1 hour
        DateTime.now(),
        false,
      );

      _realm.write(() {
        _realm.add(passwordReset);
      });
    } catch (e) {
      print('Create password reset error: $e');
      rethrow;
    }
  }

  PasswordReset? getValidPasswordReset({
    required String email,
    required String resetCode,
  }) {
    final results = _realm.query<PasswordReset>(
      'email == \$0 AND resetCode == \$1 AND isUsed == false AND expiresAt > \$2',
      [email, resetCode, DateTime.now()],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> markPasswordResetAsUsed({required String resetId}) async {
    try {
      final reset = _realm.find<PasswordReset>(resetId);
      if (reset == null) throw Exception('Password reset not found');

      _realm.write(() {
        reset.isUsed = true;
      });
    } catch (e) {
      print('Mark password reset used error: $e');
      rethrow;
    }
  }

  @override
  void onClose() {
    _realm.close();
    super.onClose();
  }
}
