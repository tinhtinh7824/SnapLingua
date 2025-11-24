import 'package:get/get.dart';
import 'firestore_service.dart';
import 'auth_service.dart';

class SurveyService extends GetxService {
  static SurveyService get to => Get.find();

  final FirestoreService _firestoreService =
      Get.isRegistered<FirestoreService>()
          ? FirestoreService.to
          : Get.put(FirestoreService());
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

      // Save survey response to Firestore
      await _firestoreService.createNotification(
        userId: userId,
        type: 'survey',
        payload: {
          'name': name,
          'gender': gender,
          'birthDay': birthDay,
          'birthMonth': birthMonth,
          'birthYear': birthYear,
          'purpose': purpose,
          'studyTime': studyTime,
        },
      );

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
