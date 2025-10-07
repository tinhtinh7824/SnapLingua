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

      // Save survey response
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

      // Update user profile with survey data
      await _realmService.updateUser(userId, {
        'name': name,
        'gender': gender,
        'birthDay': birthDay,
        'birthMonth': birthMonth,
        'birthYear': birthYear,
        'purpose': purpose,
        'studyTime': studyTime,
        'surveyCompleted': true,
      });

      return {'success': true, 'message': 'Khảo sát đã được lưu thành công'};
    } catch (e) {
      print('Submit survey error: $e');
      return {'success': false, 'message': 'Có lỗi xảy ra khi lưu khảo sát'};
    }
  }

  Future<Map<String, dynamic>?> getUserSurveyData() async {
    try {
      if (!_authService.isLoggedIn) return null;

      final user = _realmService.getCurrentUser();
      if (user == null) return null;

      return {
        'name': user.name,
        'gender': user.gender,
        'birthDay': user.birthDay,
        'birthMonth': user.birthMonth,
        'birthYear': user.birthYear,
        'purpose': user.purpose,
        'studyTime': user.studyTime,
        'surveyCompleted': user.surveyCompleted,
      };
    } catch (e) {
      print('Get survey data error: $e');
      return null;
    }
  }

  bool isSurveyCompleted() {
    try {
      if (!_authService.isLoggedIn) return false;

      final user = _realmService.getCurrentUser();
      return user?.surveyCompleted ?? false;
    } catch (e) {
      print('Check survey completion error: $e');
      return false;
    }
  }

  Future<void> resetSurvey() async {
    try {
      if (!_authService.isLoggedIn) return;

      final userId = _authService.currentUserId;
      await _realmService.updateUser(userId, {
        'name': null,
        'gender': null,
        'birthDay': null,
        'birthMonth': null,
        'birthYear': null,
        'purpose': null,
        'studyTime': null,
        'surveyCompleted': false,
      });
    } catch (e) {
      print('Reset survey error: $e');
      rethrow;
    }
  }
}