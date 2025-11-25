import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/google_sign_in_service.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/models/google_login_request.dart';
import '../../../core/theme/app_widgets.dart';

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

      _isLoading.value = false;

      if (result['success'] == true) {
        // AuthService tự lưu trạng thái, nhưng vẫn sync sang LocalStorageService nếu cần
        await LocalStorageService.saveUserData(
          userId: AuthService.to.currentUserId,
          email: AuthService.to.currentUserEmail,
          displayName: AuthService.to.currentUserEmail.split('@').first,
          avatarUrl: null,
        );

        Get.offAllNamed(Routes.home);
      } else {
        AppWidgets.showErrorDialog(
          title: 'Thông báo',
          message: (result['message'] as String?)?.trim().isNotEmpty == true
              ? result['message'] as String
              : 'Tài khoản hoặc mật khẩu chưa chính xác.',
        );
      }
    } catch (e) {
      _isLoading.value = false;
      AppWidgets.showErrorDialog(
        title: 'Lỗi kết nối',
        message: 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.',
      );
    }
  }

  void loginWithGoogle() async {
    _isLoading.value = true;
    try {
      // B1: Đăng nhập Google
      final googleAccount = await _googleSignInService.signIn();
      if (googleAccount == null) {
        _isLoading.value = false;
        AppWidgets.showInfoDialog(
          title: 'Thông báo',
          message: 'Đăng nhập Google bị hủy',
        );
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

      _isLoading.value = false;
      Get.offAllNamed(Routes.home);
    } catch (e) {
      _isLoading.value = false;
      AppWidgets.showErrorDialog(
        title: 'Lỗi kết nối',
        message: 'Không thể kết nối đến Google. Vui lòng thử lại.',
      );
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
}
