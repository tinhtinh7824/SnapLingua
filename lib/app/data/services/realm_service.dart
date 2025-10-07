import 'package:get/get.dart';
import 'package:realm/realm.dart' as realm_db;
import '../models/user_model.dart';
import '../models/survey_model.dart';
import '../models/auth_model.dart';
import '../models/vocabulary_model.dart';
import '../models/lesson_model.dart';
import '../models/gamification_model.dart';
import '../models/community_model.dart';
import '../models/camera_model.dart';
import '../models/notification_model.dart';
import '../models/admin_model.dart';

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
  Future<bool> loginWithEmailPassword(String email, String password) async {
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

  Future<bool> registerWithEmailPassword(String email, String password) async {
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
  Future<void> createUser({
    required String email,
    String? name,
    String? gender,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
  }) async {
    try {
      final userId = DateTime.now().millisecondsSinceEpoch.toString(); // TODO: Use actual user ID when Atlas is configured

      final user = User(
        userId,
        email,
        DateTime.now(),
        false, // surveyCompleted
        1, // level
        0, // xp
        0, // streak
        false, // isVerified
        false, // isPremium
        0, // coins
        0, // totalXp
        0, // weeklyXp
        0, // monthlyXp
        10, // dailyGoal
        70, // weeklyGoal
        0, // currentStreak
        0, // longestStreak
        0, // totalStudyDays
        0, // totalStudyTimeMinutes
        true, // notificationsEnabled
        true, // soundEnabled
        false, // darkModeEnabled
        true, // isActive
        false, // isBlocked
        0, // referralCount
        name: name,
        gender: gender,
        birthDay: birthDay,
        birthMonth: birthMonth,
        birthYear: birthYear,
      );

      _realm.write(() {
        _realm.add(user);
      });
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
        if (updates.containsKey('name')) user.name = updates['name'];
        if (updates.containsKey('gender')) user.gender = updates['gender'];
        if (updates.containsKey('birthDay')) user.birthDay = updates['birthDay'];
        if (updates.containsKey('birthMonth')) user.birthMonth = updates['birthMonth'];
        if (updates.containsKey('birthYear')) user.birthYear = updates['birthYear'];
        if (updates.containsKey('purpose')) user.purpose = updates['purpose'];
        if (updates.containsKey('studyTime')) user.studyTime = updates['studyTime'];
        if (updates.containsKey('surveyCompleted')) user.surveyCompleted = updates['surveyCompleted'];
        user.updatedAt = DateTime.now();
      });
    } catch (e) {
      print('Update user error: $e');
      rethrow;
    }
  }

  User? getCurrentUser() {
    // TODO: Implement when Atlas authentication is configured
    // For now, return null since we don't have user sessions
    return null;
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

      // Update user's survey completion status
      await updateUser(userId, {'surveyCompleted': true});
    } catch (e) {
      print('Save survey error: $e');
      rethrow;
    }
  }

  // Password reset methods
  Future<void> createPasswordReset(String email, String resetCode) async {
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

  PasswordReset? getValidPasswordReset(String email, String resetCode) {
    final results = _realm.query<PasswordReset>(
      'email == \$0 AND resetCode == \$1 AND isUsed == false AND expiresAt > \$2',
      [email, resetCode, DateTime.now()],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> markPasswordResetAsUsed(String resetId) async {
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