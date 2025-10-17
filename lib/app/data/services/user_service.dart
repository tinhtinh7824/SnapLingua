import 'package:get/get.dart';
import 'realm_service.dart';
import 'auth_service.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  final RealmService _realmService = Get.find<RealmService>();
  final AuthService _authService = Get.find<AuthService>();

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!_authService.isLoggedIn) return null;

      final user = _realmService.getUserById(_authService.currentUserId);
      if (user == null) return null;

      return {
        'id': user.userId,
        'email': user.email,
        'displayName': user.displayName,
        'avatarUrl': user.avatarUrl,
        'role': user.role,
        'status': user.status,
        'createdAt': user.createdAt,
        'updatedAt': user.updatedAt,
      };
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? avatarUrl,
    String? status,
  }) async {
    try {
      if (!_authService.isLoggedIn) {
        return {'success': false, 'message': 'Bạn cần đăng nhập để tiếp tục'};
      }

      final userId = _authService.currentUserId;
      final updates = <String, dynamic>{};

      if (displayName != null) updates['displayName'] = displayName;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      if (status != null) updates['status'] = status;

      if (updates.isEmpty) {
        return {'success': true, 'message': 'Không có thay đổi nào được áp dụng'};
      }

      await _realmService.updateUser(userId, updates);

      return {'success': true, 'message': 'Cập nhật thông tin thành công'};
    } catch (e) {
      print('Update profile error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi cập nhật thông tin'};
    }
  }

  Future<void> updateXP(int xpGained) async {}

  Future<void> updateStreak(int newStreak) async {}

  Future<void> updateLastLogin() async {}

  int getUserLevel() => 1;

  int getUserXP() => 0;

  int getUserStreak() => 0;

  int getXPForNextLevel() => 1000;

  int getXPProgress() => 0;

  double getLevelProgress() => 0;
}
