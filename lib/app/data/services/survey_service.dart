import 'package:get/get.dart';
import 'realm_service.dart';
import 'auth_service.dart';

class SurveyService extends GetxService {
  static SurveyService get to => Get.find();

  final RealmService _realmService = Get.find<RealmService>();
  final AuthService _authService = Get.find<AuthService>();

  Future<Map<String, dynamic>> submitSurvey({
    required String name,
    required String gender,
    required String birthDay,
    required String birthMonth,
    required String birthYear,
    required String purpose,
    required String studyTime,
  }) async {
    try {
      if (!_authService.isLoggedIn) {
        return {'success': false, 'message': 'Bạn cần đăng nhập để tiếp tục'};
      }

      final userId = _authService.currentUserId;

      await _realmService.saveSurveyResponse(
        userId: userId,
        name: name,
        gender: gender,
        birthDay: birthDay,
        birthMonth: birthMonth,
        birthYear: birthYear,
        purpose: purpose,
        studyTime: studyTime,
      );

      await _realmService.updateUser(userId, {
        'displayName': name,
      });

      return {'success': true, 'message': 'Khảo sát đã được lưu thành công'};
    } catch (e) {
      print('Submit survey error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi lưu khảo sát'};
    }
  }

  Future<Map<String, dynamic>?> getUserSurveyData() async {
    return null;
  }

  bool isSurveyCompleted() => false;

  Future<void> resetSurvey() async {}
}
