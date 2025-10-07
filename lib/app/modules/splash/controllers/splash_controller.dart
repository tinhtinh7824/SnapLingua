import 'package:get/get.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';

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
      await Future.delayed(const Duration(milliseconds: 1500));

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
}
