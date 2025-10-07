import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/services/google_sign_in_service.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/models/login_request.dart';
import '../../../data/models/google_login_request.dart';
import '../../../core/theme/app_widgets.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final _authApiService = AuthApiService();
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

    // Debug: In ra backend URL đang được sử dụng
    AuthApiService.debugPrintUrl();

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
      // Tạo request để gọi API
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Gọi API đăng nhập
      final response = await _authApiService.login(request);

      _isLoading.value = false;

      if (response.success) {
        // Đăng nhập thành công - lưu thông tin user
        if (response.user != null) {
          await LocalStorageService.saveUserData(
            userId: response.user!.userId,
            email: response.user!.email,
            displayName: response.user!.displayName,
            avatarUrl: response.user!.avatarUrl,
          );
        }

        // Chuyển đến trang chủ
        Get.offAllNamed(Routes.home);
      } else {
        // Đăng nhập thất bại - Hiển thị lỗi từ server
        AppWidgets.showErrorDialog(
          title: 'Thông báo',
          message: 'Tài khoản hoặc mật khẩu bạn vừa nhập chưa chính xác. Vui lòng thử lại.',
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
      // Bước 1: Đăng nhập với Google
      final googleAccount = await _googleSignInService.signIn();

      if (googleAccount == null) {
        _isLoading.value = false;
        AppWidgets.showInfoDialog(
          title: 'Thông báo',
          message: 'Đăng nhập Google bị hủy',
        );
        return;
      }

      // Bước 2: Lấy ID token
      final idToken = await _googleSignInService.getIdToken(googleAccount);

      if (idToken == null) {
        _isLoading.value = false;
        AppWidgets.showErrorDialog(
          title: 'Lỗi',
          message: 'Không thể lấy thông tin xác thực từ Google',
        );
        return;
      }

      // Bước 3: Gửi thông tin đến backend
      final request = GoogleLoginRequest(
        idToken: idToken,
        email: googleAccount.email,
        displayName: googleAccount.displayName,
        photoUrl: googleAccount.photoUrl,
      );

      final response = await _authApiService.loginWithGoogle(request);

      _isLoading.value = false;

      if (response.success) {
        // Đăng nhập thành công - lưu thông tin user
        if (response.user != null) {
          await LocalStorageService.saveUserData(
            userId: response.user!.userId,
            email: response.user!.email,
            displayName: response.user!.displayName,
            avatarUrl: response.user!.avatarUrl,
          );
        }

        // Chuyển đến trang chủ
        Get.offAllNamed(Routes.home);
      } else {
        // Đăng nhập thất bại
        AppWidgets.showErrorDialog(
          title: 'Thông báo',
          message: response.message,
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