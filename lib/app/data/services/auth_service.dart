import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'realm_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _storage = GetStorage();
  final RealmService _realmService = Get.find<RealmService>();

  final RxBool _isLoggedIn = false.obs;
  final RxString _currentUserId = ''.obs;
  final RxString _currentUserEmail = ''.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  String get currentUserId => _currentUserId.value;
  String get currentUserEmail => _currentUserEmail.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final userId = _storage.read('user_id');
      final email = _storage.read('user_email');

      if (userId != null && email != null) {
        _currentUserId.value = userId;
        _currentUserEmail.value = email;
        _isLoggedIn.value = true;
      }
    } catch (e) {
      print('Check auth status error: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Validate input
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email không đúng định dạng'};
      }

      if (password.length < 6) {
        return {'success': false, 'message': 'Mật khẩu phải có ít nhất 6 ký tự'};
      }

      // Register with Realm
      final success = await _realmService.registerWithEmailPassword(email, password);

      if (success) {
        // Create user profile
        await _realmService.createUser(
          email: email,
          name: name,
        );

        // Save auth state with generated user ID
        final userId = DateTime.now().millisecondsSinceEpoch.toString();
        await _saveAuthState(userId, email);

        return {'success': true, 'message': 'Đăng ký thành công'};
      } else {
        return {'success': false, 'message': 'Đăng ký không thành công'};
      }
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email không đúng định dạng'};
      }

      if (password.isEmpty) {
        return {'success': false, 'message': 'Mật khẩu không được để trống'};
      }

      // Login with Realm
      final success = await _realmService.loginWithEmailPassword(email, password);

      if (success) {
        // Save auth state with generated user ID
        final userId = DateTime.now().millisecondsSinceEpoch.toString();
        await _saveAuthState(userId, email);

        return {'success': true, 'message': 'Đăng nhập thành công'};
      } else {
        return {'success': false, 'message': 'Email hoặc mật khẩu không đúng'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Email hoặc mật khẩu không đúng'};
    }
  }

  Future<void> logout() async {
    try {
      await _realmService.logout();
      await _clearAuthState();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<Map<String, dynamic>> sendPasswordResetCode(String email) async {
    try {
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email không đúng định dạng'};
      }

      // Generate 6-digit reset code
      final resetCode = _generateResetCode();

      // Save reset code to database
      await _realmService.createPasswordReset(email, resetCode);

      // In a real app, you would send the code via email
      // For demo purposes, we'll just return the code
      print('Password reset code for $email: $resetCode');

      return {
        'success': true,
        'message': 'Mã xác thực đã được gửi đến email của bạn',
        'resetCode': resetCode, // Remove this in production
      };
    } catch (e) {
      print('Send reset code error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi gửi mã xác thực'};
    }
  }

  Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String resetCode,
  }) async {
    try {
      final passwordReset = _realmService.getValidPasswordReset(email, resetCode);

      if (passwordReset != null) {
        return {'success': true, 'message': 'Mã xác thực đúng'};
      } else {
        return {'success': false, 'message': 'Mã xác thực không đúng hoặc đã hết hạn'};
      }
    } catch (e) {
      print('Verify reset code error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi xác thực'};
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String resetCode,
    required String newPassword,
  }) async {
    try {
      if (newPassword.length < 6) {
        return {'success': false, 'message': 'Mật khẩu phải có ít nhất 6 ký tự'};
      }

      final passwordReset = _realmService.getValidPasswordReset(email, resetCode);

      if (passwordReset != null) {
        // Mark reset code as used
        await _realmService.markPasswordResetAsUsed(passwordReset.id);

        // In a real implementation, you would update the password in Atlas
        // For now, we'll just return success
        return {'success': true, 'message': 'Mật khẩu đã được đặt lại thành công'};
      } else {
        return {'success': false, 'message': 'Mã xác thực không đúng hoặc đã hết hạn'};
      }
    } catch (e) {
      print('Reset password error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi đặt lại mật khẩu'};
    }
  }

  Future<void> _saveAuthState(String userId, String email) async {
    _currentUserId.value = userId;
    _currentUserEmail.value = email;
    _isLoggedIn.value = true;

    await _storage.write('user_id', userId);
    await _storage.write('user_email', email);
    await _storage.write('is_logged_in', true);
  }

  Future<void> _clearAuthState() async {
    _currentUserId.value = '';
    _currentUserEmail.value = '';
    _isLoggedIn.value = false;

    await _storage.remove('user_id');
    await _storage.remove('user_email');
    await _storage.remove('is_logged_in');
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  String _generateResetCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}