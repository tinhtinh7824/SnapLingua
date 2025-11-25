import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'firestore_service.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService =
      Get.isRegistered<FirestoreService>()
          ? FirestoreService.to
          : Get.put(FirestoreService());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!_authService.isLoggedIn) return null;

      final userId = _authService.currentUserId;
      final email = _authService.currentUserEmail;

      // Try to fetch Firestore user; auto-create minimal doc if missing.
      var user = await _firestoreService.getUserById(userId);
      if (user == null) {
        await _firestoreService.createUser(
          userId: userId,
          email: email,
          displayName: email.split('@').first,
          avatarUrl: null,
        );
        user = await _firestoreService.getUserById(userId);
      }
      if (user == null) return null;

      return {
        'id': user.id,
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

      await _firestore.collection('users').doc(userId).set(
            updates,
            SetOptions(merge: true),
          );

      return {'success': true, 'message': 'Cập nhật thông tin thành công'};
    } catch (e) {
      print('Update profile error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi cập nhật thông tin'};
    }
  }

  /// Upload avatar to storage. Placeholder: returns the provided local path or empty string on failure.
  Future<String> uploadAvatar(String filePath) async {
    // TODO: Integrate with Firebase Storage; for now, just return the existing path.
    return filePath;
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
