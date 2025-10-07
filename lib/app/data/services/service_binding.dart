import 'package:get/get.dart';
import 'realm_service.dart';
import 'auth_service.dart';
import 'survey_service.dart';
import 'user_service.dart';
import 'vocabulary_service.dart';
import 'lesson_service.dart';
import 'gamification_service.dart';
import 'community_service.dart';
import 'camera_service.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize core services in order
    Get.put<RealmService>(RealmService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<SurveyService>(SurveyService(), permanent: true);
    Get.put<UserService>(UserService(), permanent: true);

    // Initialize new feature services
    Get.put<VocabularyService>(VocabularyService(), permanent: true);
    Get.put<LessonService>(LessonService(), permanent: true);
    Get.put<GamificationService>(GamificationService(), permanent: true);
    Get.put<CommunityService>(CommunityService(), permanent: true);
    Get.put<CameraService>(CameraService(), permanent: true);
  }
}

class DatabaseInitializer {
  static Future<void> initialize() async {
    try {
      // Initialize service binding
      ServiceBinding().dependencies();

      // Wait for services to initialize
      await Get.find<RealmService>().onInit();
      await Get.find<AuthService>().onInit();

      print('Database services initialized successfully');
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }
}