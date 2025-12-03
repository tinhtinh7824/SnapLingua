import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/quest_service.dart';
import '../../../routes/app_pages.dart';
import '../../community/controllers/community_controller.dart';
import '../../home/controllers/home_stats_controller.dart';
import '../../home/controllers/learning_tab_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile_notification/controllers/profile_notification_controller.dart';
import '../../review/controllers/review_controller.dart';

class SplashController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;
  bool _isNavigating = false; // Prevent double navigation

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    if (_isNavigating) {
      return;
    }

    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Small delay for splash animation
      await Future.delayed(const Duration(milliseconds: 3000));

      // Check first launch
      final isFirstLaunch = await LocalStorageService.isFirstLaunch();
      if (isFirstLaunch) {
        _isNavigating = true;
        Get.offAllNamed(Routes.onboarding);
        return;
      }

      // Check login status
      final isLoggedIn = await LocalStorageService.isLoggedIn();
      if (isLoggedIn) {
        await _preloadTabs();
        _isNavigating = true;
        Get.offAllNamed(Routes.home);
        return;
      }

      // Not logged in
      _isNavigating = true;
      Get.offAllNamed(Routes.login);
    } catch (e) {
      _errorMessage.value = 'An error occurred during initialization: $e';
      // On error, default to login screen
      if (!_isNavigating) {
        _isNavigating = true;
        Get.offAllNamed(Routes.login);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void retry() {
    _init();
  }

  /// Preloads data/services required by the home screen so it appears instantly.
  Future<void> _preloadTabs() async {
    final homePreload = _preloadHomeTab();

    // Fire off other tabs in the background; don't block navigation.
    Future.wait<void>(
      [
        _preloadReviewTab(),
        _preloadCommunityTab(),
        _preloadProfileTab(),
        _preloadNotificationTab(),
      ],
      eagerError: false,
    ).catchError((e) {
      Get.log('Background preload error: $e');
    });

    await homePreload;
  }

  Future<void> _preloadHomeTab() async {
    // Ensure core services are registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<FirestoreService>()) {
      Get.put<FirestoreService>(FirestoreService(), permanent: true);
    }
    if (!Get.isRegistered<DailyProgressService>()) {
      Get.put<DailyProgressService>(DailyProgressService(), permanent: true);
    }
    if (!Get.isRegistered<QuestService>()) {
      Get.put<QuestService>(QuestService(), permanent: true);
    }

    // Home stats
    final homeStats = Get.isRegistered<HomeStatsController>()
        ? Get.find<HomeStatsController>()
        : Get.put<HomeStatsController>(HomeStatsController(), permanent: true);
    await homeStats.load();

    // Learning tab (new words, review, daily/monthly quests)
    final learning = Get.isRegistered<LearningTabController>()
        ? Get.find<LearningTabController>()
        : Get.put<LearningTabController>(LearningTabController(), permanent: true);
    await learning.refreshProgress();
  }

  Future<void> _preloadReviewTab() async {
    try {
      final review = Get.isRegistered<ReviewController>()
          ? Get.find<ReviewController>()
          : Get.put<ReviewController>(ReviewController(), permanent: true);
      await Future.wait<void>([
        review.loadCategories(),
        review.ensureRecommendedTopicsLoaded(),
      ]);
    } catch (e) {
      Get.log('Review preload error: $e');
    }
  }

  Future<void> _preloadCommunityTab() async {
    try {
      if (!Get.isRegistered<CommunityController>()) {
        Get.put<CommunityController>(CommunityController(), permanent: true);
      }
      // CommunityController sets up its streams in onInit; nothing else to await here.
    } catch (e) {
      Get.log('Community preload error: $e');
    }
  }

  Future<void> _preloadProfileTab() async {
    try {
      final profile = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put<ProfileController>(ProfileController(), permanent: true);
      await profile.loadProfile();
    } catch (e) {
      Get.log('Profile preload error: $e');
    }
  }

  Future<void> _preloadNotificationTab() async {
    try {
      // Ensure shared services exist before controller work.
      if (!Get.isRegistered<AuthService>()) {
        Get.put<AuthService>(AuthService(), permanent: true);
      }
      if (!Get.isRegistered<FirestoreService>()) {
        Get.put<FirestoreService>(FirestoreService(), permanent: true);
      }

      final notificationController = Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>()
          : Get.put<NotificationController>(NotificationController(), permanent: true);
      // Profile notification screen settings
      if (!Get.isRegistered<ProfileNotificationController>()) {
        Get.put<ProfileNotificationController>(
          ProfileNotificationController(),
          permanent: true,
        );
      }

      await notificationController.loadNotifications();
    } catch (e) {
      Get.log('Notification preload error: $e');
    }
  }
}
