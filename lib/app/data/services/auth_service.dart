import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'realm_service.dart';
import 'firestore_service.dart';
import 'service_binding.dart';
import 'survey_service.dart';
import 'user_service.dart';
import 'vocabulary_service.dart';
import 'lesson_service.dart';
import 'gamification_service.dart';
import 'community_service.dart';
import 'camera_service.dart';
import 'daily_progress_service.dart';
import 'goal_service.dart';
import 'notification_settings_service.dart';
import 'push_notification_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _storage = GetStorage();
  final RealmService _realmService = Get.find<RealmService>();
  final FirestoreService _firestoreService =
      Get.isRegistered<FirestoreService>()
          ? FirestoreService.to
          : Get.put(FirestoreService());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RxBool _isLoggedIn = false.obs;
  final RxString _currentUserId = ''.obs;
  final RxString _currentUserEmail = ''.obs;
  bool _isPersistingState = false;

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

      // Prefer persisted state if available
      if (userId != null && email != null) {
        _currentUserId.value = userId;
        _currentUserEmail.value = email;
        _isLoggedIn.value = true;
        return;
      }

      // Fallback to Firebase current user
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser != null) {
        _currentUserId.value = fbUser.uid;
        _currentUserEmail.value = fbUser.email ?? '';
        _isLoggedIn.value = true;
        // Chỉ cập nhật vào memory; tránh ghi file lặp trong onInit
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

      // Register with Firebase Auth
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (name != null && name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
      }

      final userId = cred.user?.uid ?? email;

      // Ensure user profile exists in Firestore (for profile screen)
      await _ensureFirestoreUser(
        userId: userId,
        email: email,
        displayName: name ?? cred.user?.displayName ?? email.split('@').first,
        avatarUrl: null,
      );

      // Create user profile in Realm (local) to keep compatibility
      await _realmService.createUser(
        email: email,
        displayName: name ?? cred.user?.displayName,
      );

      await _saveAuthState(userId, email);
      await _reinitializeUserScopedServices();

      return {'success': true, 'message': 'Đăng ký thành công'};
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'message': _friendlyFirebaseError(e)};
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

      // Login with Firebase Auth
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = cred.user?.uid ?? email;

      // Ensure user profile exists in Firestore (for profile screen)
      await _ensureFirestoreUser(
        userId: userId,
        email: email,
        displayName: cred.user?.displayName ?? email.split('@').first,
        avatarUrl: cred.user?.photoURL,
      );

      // Sync user to Realm/local if missing
      var user = _realmService.getUserByEmail(email: email);
      if (user == null) {
        user = await _realmService.createUser(
          email: email,
          displayName: cred.user?.displayName,
        );
      }

      await _saveAuthState(userId, email);
      await _reinitializeUserScopedServices();

      return {'success': true, 'message': 'Đăng nhập thành công'};
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': _friendlyFirebaseError(e)};
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _realmService.logout();
      await _clearAuthState();
      await _resetUserScopedServices();
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
      await _realmService.createPasswordReset(
        email: email,
        resetCode: resetCode,
      );

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
      final passwordReset = _realmService.getValidPasswordReset(
        email: email,
        resetCode: resetCode,
      );

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

      final passwordReset = _realmService.getValidPasswordReset(
        email: email,
        resetCode: resetCode,
      );

      if (passwordReset != null) {
        // Mark reset code as used
        await _realmService.markPasswordResetAsUsed(resetId: passwordReset.id);

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

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        return {'success': false, 'message': 'Vui lòng nhập đầy đủ thông tin'};
      }
      if (newPassword.length < 6) {
        return {
          'success': false,
          'message': 'Mật khẩu mới phải có ít nhất 6 ký tự',
        };
      }
      if (newPassword != confirmPassword) {
        return {
          'success': false,
          'message': 'Xác nhận mật khẩu không khớp',
        };
      }

      // TODO: Integrate with actual auth backend. For now, we accept the change locally.
      return {'success': true, 'message': 'Đổi mật khẩu thành công'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Không thể đổi mật khẩu: ${e.toString()}',
      };
    }
  }

  Future<void> _saveAuthState(String userId, String email) async {
    if (_isPersistingState) return; // tránh ghi chồng chéo gây lỗi lock file
    _isPersistingState = true;
    _currentUserId.value = userId;
    _currentUserEmail.value = email;
    _isLoggedIn.value = true;

    try {
      await _storage.write('user_id', userId);
      await _storage.write('user_email', email);
      await _storage.write('is_logged_in', true);
    } finally {
      _isPersistingState = false;
    }
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

  Future<void> _reinitializeUserScopedServices() async {
    await _resetUserScopedServices();
    // Re-register services so controllers pick up a fresh instance for the current user.
    ServiceBinding().dependencies();
  }

  Future<void> _resetUserScopedServices() async {
    await _safeDelete<UserService>();
    await _safeDelete<SurveyService>();
    await _safeDelete<VocabularyService>();
    await _safeDelete<LessonService>();
    await _safeDelete<GamificationService>();
    await _safeDelete<CommunityService>();
    await _safeDelete<CameraService>();
    await _safeDelete<DailyProgressService>();
    await _safeDelete<GoalService>();
    await _safeDelete<NotificationSettingsService>();
    await _safeDelete<PushNotificationService>();
  }

  Future<void> _safeDelete<T>() async {
    if (Get.isRegistered<T>()) {
      await Get.delete<T>(force: true);
    }
  }

  String _friendlyFirebaseError(Object e) {
    final msg = e.toString();
    if (msg.contains('invalid-credential') ||
        msg.contains('wrong-password')) {
      return 'Email hoặc mật khẩu không đúng';
    }
    if (msg.contains('user-not-found')) {
      return 'Tài khoản không tồn tại';
    }
    if (msg.contains('email-already-in-use')) {
      return 'Email đã được sử dụng';
    }
    if (msg.contains('network-request-failed')) {
      return 'Không thể kết nối mạng';
    }
    return 'Có lỗi xảy ra: $msg';
  }

  Future<void> _ensureFirestoreUser({
    required String userId,
    required String email,
    required String displayName,
    String? avatarUrl,
  }) async {
    try {
      final existing = await _firestoreService.getUserById(userId);
      if (existing != null) return;

      await _firestoreService.createUser(
        userId: userId,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
    } catch (e) {
      print('Ensure Firestore user error: $e');
    }
  }
}
