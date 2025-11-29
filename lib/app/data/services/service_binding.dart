import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'realm_service.dart';
import 'auth_service.dart';
import 'survey_service.dart';
import 'user_service.dart';
import 'vocabulary_service.dart';
import 'lesson_service.dart';
import 'gamification_service.dart';
import 'community_service.dart';
import 'camera_service.dart';
import 'firestore_service.dart';
import 'daily_progress_service.dart';
import 'goal_service.dart';
import 'notification_settings_service.dart';
import 'push_notification_service.dart';
import 'yolo_tflite_detector_service.dart';
import 'notification_scheduler_service.dart';
import '../../../firebase_options.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize core services in order
    if (!Get.isRegistered<RealmService>()) {
      Get.put<RealmService>(RealmService(), permanent: true);
    }
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<SurveyService>()) {
      Get.put<SurveyService>(SurveyService(), permanent: true);
    }
    if (!Get.isRegistered<UserService>()) {
      Get.put<UserService>(UserService(), permanent: true);
    }

    // Initialize new feature services
    if (!Get.isRegistered<VocabularyService>()) {
      Get.put<VocabularyService>(VocabularyService(), permanent: true);
    }
    if (!Get.isRegistered<LessonService>()) {
      Get.put<LessonService>(LessonService(), permanent: true);
    }
    if (!Get.isRegistered<GamificationService>()) {
      Get.put<GamificationService>(GamificationService(), permanent: true);
    }
    if (!Get.isRegistered<CommunityService>()) {
      Get.put<CommunityService>(CommunityService(), permanent: true);
    }
    if (!Get.isRegistered<CameraService>()) {
      Get.put<CameraService>(CameraService(), permanent: true);
    }
    if (!Get.isRegistered<FirestoreService>()) {
      Get.put<FirestoreService>(FirestoreService(), permanent: true);
    }
    if (!Get.isRegistered<DailyProgressService>()) {
      Get.put<DailyProgressService>(DailyProgressService(), permanent: true);
    }
    if (!Get.isRegistered<GoalService>()) {
      Get.put<GoalService>(GoalService(), permanent: true);
    }
    if (!Get.isRegistered<PushNotificationService>()) {
      Get.put<PushNotificationService>(PushNotificationService(), permanent: true);
    }
    if (!Get.isRegistered<NotificationSchedulerService>()) {
      Get.put<NotificationSchedulerService>(NotificationSchedulerService(),
          permanent: true);
    }
    if (!Get.isRegistered<NotificationSettingsService>()) {
      Get.put<NotificationSettingsService>(NotificationSettingsService(), permanent: true);
    }
    if (!Get.isRegistered<YoloTfliteDetectorService>()) {
      Get.put<YoloTfliteDetectorService>(YoloTfliteDetectorService(), permanent: true);
    }
  }
}

class DatabaseInitializer {
  static Future<void> initialize() async {
    try {
      // Initialize Firebase first - this is critical for other services
      await _initializeFirebase();

      // Initialize service binding after Firebase is ready
      ServiceBinding().dependencies();

      // Initialize push notifications and load notification settings so the
      // notification screen can immediately register the device and show
      // current state.
      if (Get.isRegistered<PushNotificationService>()) {
        await Get.find<PushNotificationService>().init();
      }
      if (Get.isRegistered<NotificationSettingsService>()) {
        await Get.find<NotificationSettingsService>().ensureLoaded();
      }

      // Wait for core services to initialize
      await Get.find<RealmService>().onInit();
      await Get.find<AuthService>().onInit();

      print('Database services initialized successfully');
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  static Future<void> _initializeFirebase() async {
    if (Firebase.apps.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('[Firebase] Already initialized (${Firebase.apps.length} apps)');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('[Firebase] Starting initialization with multiple strategies...');
    }

    // Strategy 1: Try firebase_options.dart (most reliable for cross-platform)
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        debugPrint('[Firebase] ✅ Strategy 1 SUCCESS: firebase_options.dart');
        debugPrint('[Firebase] Project ID: ${Firebase.app().options.projectId}');
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Firebase] ❌ Strategy 1 FAILED: firebase_options.dart - $e');
      }
    }

    // Strategy 2: Direct manual configuration (bypassing platform resources)
    try {
      // Use platform-specific configurations
      FirebaseOptions options;
      if (defaultTargetPlatform == TargetPlatform.android) {
        options = const FirebaseOptions(
          apiKey: 'AIzaSyAB0h6-Y-8RaRQiKjzorjFsffiGY__Dt-g',
          appId: '1:567458286537:android:b9bbc23f5b4532cd597618',
          messagingSenderId: '567458286537',
          projectId: 'snaplingua-cfceb',
          storageBucket: 'snaplingua-cfceb.firebasestorage.app',
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        options = const FirebaseOptions(
          apiKey: 'AIzaSyBoJyEhkhx1b47QOwiUGb_hz-xdfgptCoQ',
          appId: '1:567458286537:ios:30b14190721c25b0597618',
          messagingSenderId: '567458286537',
          projectId: 'snaplingua-cfceb',
          storageBucket: 'snaplingua-cfceb.firebasestorage.app',
          iosClientId: '567458286537-bdog3p68irjnpgdqkv4ugk1ethps5rv7.apps.googleusercontent.com',
          iosBundleId: 'com.snaplingua.app',
        );
      } else {
        // Fallback for other platforms
        options = const FirebaseOptions(
          apiKey: 'AIzaSyAB0h6-Y-8RaRQiKjzorjFsffiGY__Dt-g',
          appId: '1:567458286537:android:b9bbc23f5b4532cd597618',
          messagingSenderId: '567458286537',
          projectId: 'snaplingua-cfceb',
          storageBucket: 'snaplingua-cfceb.firebasestorage.app',
        );
      }

      await Firebase.initializeApp(options: options);
      if (kDebugMode) {
        debugPrint('[Firebase] ✅ Strategy 2 SUCCESS: Direct manual config for $defaultTargetPlatform');
        debugPrint('[Firebase] Project ID: ${Firebase.app().options.projectId}');
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Firebase] ❌ Strategy 2 FAILED: Direct manual config - $e');
      }
    }

    // Strategy 3: Try platform-specific config files (google-services.json/GoogleService-Info.plist)
    try {
      await Firebase.initializeApp();
      if (kDebugMode) {
        debugPrint('[Firebase] ✅ Strategy 3 SUCCESS: Platform-specific config files');
        debugPrint('[Firebase] Project ID: ${Firebase.app().options.projectId}');
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Firebase] ❌ Strategy 3 FAILED: Platform config files - $e');
      }
    }

    // If all strategies fail, provide detailed error information
    if (kDebugMode) {
      debugPrint('[Firebase] ❌ ALL STRATEGIES FAILED');
      debugPrint('[Firebase] Platform: $defaultTargetPlatform');
      debugPrint('[Firebase] This might be due to:');
      debugPrint('[Firebase] 1. Missing google-services.json or GoogleService-Info.plist');
      debugPrint('[Firebase] 2. Missing Firebase Android/iOS configuration');
      debugPrint('[Firebase] 3. Gradle plugin not properly applied');
    }

    throw Exception('Firebase initialization failed on $defaultTargetPlatform. Please check Firebase configuration files and Android/iOS setup.');
  }
}
