import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/models/register_request.dart';
import '../../../core/theme/app_widgets.dart';

class RegisterController extends GetxController {
  static RegisterController get to => Get.find();

  final _authApiService = AuthApiService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final displayNameController = TextEditingController();

  // Reactive text values to trigger UI updates
  final _emailText = ''.obs;
  final _passwordText = ''.obs;
  final _confirmPasswordText = ''.obs;

  final _isPasswordVisible = false.obs;
  final _isConfirmPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _emailError = ''.obs;
  final _passwordError = ''.obs;
  final _confirmPasswordError = ''.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  String get emailError => _emailError.value;
  String get passwordError => _passwordError.value;
  String get confirmPasswordError => _confirmPasswordError.value;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      _emailText.value = emailController.text;
      _validateEmail();
    });
    passwordController.addListener(() {
      _passwordText.value = passwordController.text;
      _validatePassword();
      _validateConfirmPassword();
    });
    confirmPasswordController.addListener(() {
      _confirmPasswordText.value = confirmPasswordController.text;
      _validateConfirmPassword();
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    super.onClose();
  }

  bool get canRegister {
    // Access reactive values to make this getter reactive
    final emailText = _emailText.value.trim();
    final passwordText = _passwordText.value;
    final confirmPasswordText = _confirmPasswordText.value;
    final emailError = _emailError.value;
    final passwordError = _passwordError.value;
    final confirmPasswordError = _confirmPasswordError.value;

    return emailText.isNotEmpty &&
           passwordText.isNotEmpty &&
           confirmPasswordText.isNotEmpty &&
           emailError.isEmpty &&
           passwordError.isEmpty &&
           confirmPasswordError.isEmpty;
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _emailError.value = 'Email không được để trống';
    } else if (!_isValidEmail(email)) {
      _emailError.value = 'Email không đúng định dạng';
    } else {
      _emailError.value = '';
    }
  }

  void _validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      _passwordError.value = 'Mật khẩu không được để trống';
    } else if (password.length < 6) {
      _passwordError.value = 'Mật khẩu phải có ít nhất 6 ký tự';
    } else {
      _passwordError.value = '';
    }
  }

  void _validateConfirmPassword() {
    final confirmPassword = confirmPasswordController.text;
    final password = passwordController.text;

    if (confirmPassword.isEmpty) {
      _confirmPasswordError.value = 'Xác nhận mật khẩu không được để trống';
    } else if (confirmPassword != password) {
      _confirmPasswordError.value = 'Mật khẩu không khớp';
    } else {
      _confirmPasswordError.value = '';
    }
  }

  void register() async {
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();

    if (_emailError.value.isNotEmpty ||
        _passwordError.value.isNotEmpty ||
        _confirmPasswordError.value.isNotEmpty) {
      return;
    }

    _isLoading.value = true;

    try {
      // Tạo request với dữ liệu từ form
      final request = RegisterRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: displayNameController.text.trim().isEmpty
            ? null
            : displayNameController.text.trim(),
      );

      // Gọi API đăng ký
      final response = await _authApiService.register(request);

      _isLoading.value = false;

      if (response.success) {
        // Đăng ký thành công
        AppWidgets.showSuccessDialog(
          title: 'Thành công',
          message: response.message,
          onConfirm: () {
            // Chuyển đến màn hình survey
            Get.offNamed(Routes.survey);
          },
        );
      } else {
        // Đăng ký thất bại
        AppWidgets.showErrorDialog(
          title: 'Lỗi đăng ký',
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

  void registerWithGoogle() {
    Get.snackbar(
      'Google',
      'Đăng ký với Google',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void registerWithFacebook() {
    Get.snackbar(
      'Facebook',
      'Đăng ký với Facebook',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToLogin() {
    Get.offNamed(Routes.login);
  }
}