import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/quest_service.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_stats_controller.dart';
import '../../home/controllers/learning_tab_controller.dart';

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
        await _preloadHomeData();
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
  Future<void> _preloadHomeData() async {
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
}
