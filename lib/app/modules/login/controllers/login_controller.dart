import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/google_sign_in_service.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/models/google_login_request.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../data/services/service_binding.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/controllers/home_stats_controller.dart';
import '../../home/controllers/learning_tab_controller.dart';
import '../../review/controllers/review_controller.dart';
import '../../shop/controllers/shop_controller.dart';
import '../../community/controllers/community_controller.dart';
import '../../community_detail/controllers/community_detail_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../notification/controllers/notification_controller.dart';
class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final AuthService _authService = Get.find<AuthService>();
  final _googleSignInService = GoogleSignInService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _emailError = ''.obs;
  final _passwordError = ''.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  String get emailError => _emailError.value;
  String get passwordError => _passwordError.value;

  @override
  void onInit() {
    super.onInit();

    // Listen to text changes to trigger reactive updates
    emailController.addListener(() {
      _emailError.refresh();
    });
    passwordController.addListener(() {
      _passwordError.refresh();
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Make canLogin reactive by depending on observable fields
  bool get canLogin {
    // Access reactive fields to make this getter reactive
    _emailError.value; // Touch reactive field
    _passwordError.value; // Touch reactive field

    return emailController.text.trim().isNotEmpty &&
           passwordController.text.isNotEmpty;
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void forgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _validateEmail() {
    final email = emailController.text.trim();
    if (!_isValidEmail(email)) {
      _emailError.value = 'Email không đúng định dạng';
    } else {
      _emailError.value = '';
    }
  }

  void _validatePassword() {
    final password = passwordController.text;
    if (password.length < 6) {
      _passwordError.value = 'Mật khẩu phải có ít nhất 6 ký tự';
    } else {
      _passwordError.value = '';
    }
  }

  void login() async {
    _validateEmail();
    _validatePassword();

    if (_emailError.value.isNotEmpty || _passwordError.value.isNotEmpty) {
      return;
    }

    _isLoading.value = true;

    try {
      final result = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success'] == true) {
        // AuthService tự lưu trạng thái, nhưng vẫn sync sang LocalStorageService nếu cần
        await LocalStorageService.saveUserData(
          userId: AuthService.to.currentUserId,
          email: AuthService.to.currentUserEmail,
          displayName: AuthService.to.currentUserEmail.split('@').first,
          avatarUrl: null,
        );

        await _resetSessionForNewLogin();
        await Get.offAllNamed(Routes.home);
      } else {
        AppWidgets.showErrorDialog(
          title: 'Thông báo',
          message: (result['message'] as String?)?.trim().isNotEmpty == true
              ? result['message'] as String
              : 'Tài khoản hoặc mật khẩu chưa chính xác.',
        );
      }
    } catch (e) {
      AppWidgets.showErrorDialog(
        title: 'Lỗi kết nối',
        message: 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void loginWithGoogle() async {
    _isLoading.value = true;
    try {
      // B1: Đăng nhập Google
      final googleAccount = await _googleSignInService.signIn();
      if (googleAccount == null) {
        AppWidgets.showInfoDialog(
          title: 'Thông báo',
          message: 'Đăng nhập Google bị hủy',
        );
        _isLoading.value = false;
        return;
      }

      // B2: Lấy email và lưu tạm (demo flow, chưa liên kết Firebase)
      final email = googleAccount.email;

      // Lưu trạng thái đăng nhập giả lập
      await LocalStorageService.saveUserData(
        userId: email,
        email: email,
        displayName: googleAccount.displayName ?? email.split('@').first,
        avatarUrl: googleAccount.photoUrl,
      );
      await _authService.onInit(); // refresh trạng thái

      await _resetSessionForNewLogin();
      await Get.offAllNamed(Routes.home);
    } catch (e) {
      AppWidgets.showErrorDialog(
        title: 'Lỗi kết nối',
        message: 'Không thể kết nối đến Google. Vui lòng thử lại.',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void loginWithFacebook() {
    Get.snackbar(
      'Facebook',
      'Đăng nhập với Facebook',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  Future<void> _resetSessionForNewLogin() async {
    // Clear old controllers to avoid stale state
    await _safeDelete<HomeController>();
    await _safeDelete<HomeStatsController>();
    await _safeDelete<LearningTabController>();
    await _safeDelete<ShopController>();
    await _safeDelete<CommunityController>();
    await _safeDelete<CommunityDetailController>();
    await _safeDelete<ProfileController>();
    await _safeDelete<NotificationController>();
    await _safeDelete<ReviewController>();

    // Rebind services so subsequent screens use fresh data
    ServiceBinding().dependencies();

    // Preload the main tabs/controllers so data is ready when user opens them
    final homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());
    if (!Get.isRegistered<ReviewController>()) {
      Get.put<ReviewController>(ReviewController());
    }
    if (!Get.isRegistered<LearningTabController>()) {
      Get.put<LearningTabController>(LearningTabController());
    }
    // Ensure HomeStats (used by Learning tab/home header) starts loading
    if (!Get.isRegistered<HomeStatsController>()) {
      Get.put<HomeStatsController>(HomeStatsController(), permanent: true);
    } else {
      Get.find<HomeStatsController>().load();
    }
    // Pre-instantiate community and profile controllers so they fetch immediately
    if (!Get.isRegistered<CommunityController>()) {
      Get.put<CommunityController>(CommunityController());
    } else {
      // No explicit load method; onInit already binds streams
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController());
    } else {
      Get.find<ProfileController>().loadProfile();
    }

    // Kick off initial data loads so tabs are hydrated
    final preloadTasks = <Future<void>>[];
    if (Get.isRegistered<HomeStatsController>()) {
      preloadTasks.add(Get.find<HomeStatsController>().load());
    }
    if (Get.isRegistered<LearningTabController>()) {
      preloadTasks.add(Get.find<LearningTabController>().refreshProgress());
    }
    if (Get.isRegistered<ProfileController>()) {
      preloadTasks.add(Get.find<ProfileController>().loadProfile());
    }

    await Future.wait(preloadTasks);

    // Set default tab to home
    homeController.changeTab(0);
  }

  Future<void> _safeDelete<T>() async {
    if (Get.isRegistered<T>()) {
      await Get.delete<T>(force: true);
    }
  }
}
