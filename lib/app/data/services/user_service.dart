import 'package:get/get.dart';
import 'realm_service.dart';
import 'auth_service.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  final RealmService _realmService = Get.find<RealmService>();
  final AuthService _authService = Get.find<AuthService>();

  // User profile methods
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!_authService.isLoggedIn) return null;

      final user = _realmService.getCurrentUser();
      if (user == null) return null;

      return {
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'gender': user.gender,
        'birthDay': user.birthDay,
        'birthMonth': user.birthMonth,
        'birthYear': user.birthYear,
        'purpose': user.purpose,
        'studyTime': user.studyTime,
        'level': user.level,
        'xp': user.xp,
        'streak': user.streak,
        'surveyCompleted': user.surveyCompleted,
        'isVerified': user.isVerified,
        'avatarUrl': user.avatarUrl,
        'createdAt': user.createdAt,
        'lastLoginAt': user.lastLoginAt,
      };
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? gender,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
    String? avatarUrl,
  }) async {
    try {
      if (!_authService.isLoggedIn) {
        return {'success': false, 'message': 'Bạn cần đăng nhập để tiếp tục'};
      }

      final userId = _authService.currentUserId;
      final updates = <String, dynamic>{};

      if (name != null) updates['name'] = name;
      if (gender != null) updates['gender'] = gender;
      if (birthDay != null) updates['birthDay'] = birthDay;
      if (birthMonth != null) updates['birthMonth'] = birthMonth;
      if (birthYear != null) updates['birthYear'] = birthYear;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

      await _realmService.updateUser(userId, updates);

      return {'success': true, 'message': 'Cập nhật thông tin thành công'};
    } catch (e) {
      print('Update profile error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi cập nhật thông tin'};
    }
  }

  // Learning progress methods
  Future<void> updateXP(int xpGained) async {
    try {
      if (!_authService.isLoggedIn) return;

      final user = _realmService.getCurrentUser();
      if (user == null) return;

      final newXP = user.xp + xpGained;
      final newLevel = _calculateLevel(newXP);

      await _realmService.updateUser(user.id, {
        'xp': newXP,
        'level': newLevel,
      });
    } catch (e) {
      print('Update XP error: $e');
    }
  }

  Future<void> updateStreak(int newStreak) async {
    try {
      if (!_authService.isLoggedIn) return;

      final userId = _authService.currentUserId;
      await _realmService.updateUser(userId, {'streak': newStreak});
    } catch (e) {
      print('Update streak error: $e');
    }
  }

  Future<void> updateLastLogin() async {
    try {
      if (!_authService.isLoggedIn) return;

      final userId = _authService.currentUserId;
      await _realmService.updateUser(userId, {'lastLoginAt': DateTime.now()});
    } catch (e) {
      print('Update last login error: $e');
    }
  }

  // Achievement methods
  int getUserLevel() {
    try {
      final user = _realmService.getCurrentUser();
      return user?.level ?? 1;
    } catch (e) {
      return 1;
    }
  }

  int getUserXP() {
    try {
      final user = _realmService.getCurrentUser();
      return user?.xp ?? 0;
    } catch (e) {
      return 0;
    }
  }

  int getUserStreak() {
    try {
      final user = _realmService.getCurrentUser();
      return user?.streak ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Utility methods
  int _calculateLevel(int xp) {
    // Simple level calculation: 1000 XP per level
    return (xp / 1000).floor() + 1;
  }

  int getXPForNextLevel() {
    final currentLevel = getUserLevel();
    return currentLevel * 1000;
  }

  int getXPProgress() {
    final currentXP = getUserXP();
    final currentLevel = getUserLevel();
    final xpForCurrentLevel = (currentLevel - 1) * 1000;
    return currentXP - xpForCurrentLevel;
  }

  double getLevelProgress() {
    final progress = getXPProgress();
    return progress / 1000.0;
  }

  // Validation methods
  String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Tên không được để trống';
    }
    if (name.trim().length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    if (name.trim().length > 50) {
      return 'Tên không được quá 50 ký tự';
    }
    return null;
  }

  String? validateBirthDate(String? day, String? month, String? year) {
    if (day == null || month == null || year == null) {
      return 'Vui lòng chọn ngày sinh đầy đủ';
    }

    try {
      final birthDate = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
      );

      final now = DateTime.now();
      final age = now.year - birthDate.year;

      if (age < 10) {
        return 'Bạn phải từ 10 tuổi trở lên để sử dụng ứng dụng';
      }

      if (age > 120) {
        return 'Ngày sinh không hợp lệ';
      }

      return null;
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }
  }
}