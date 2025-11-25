import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/daily_progress_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure all required services are available
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<UserService>()) {
      Get.put<UserService>(UserService(), permanent: true);
    }
    if (!Get.isRegistered<FirestoreService>()) {
      Get.put<FirestoreService>(FirestoreService(), permanent: true);
    }
    if (!Get.isRegistered<DailyProgressService>()) {
      Get.put<DailyProgressService>(DailyProgressService(), permanent: true);
    }

    // Create the ProfileController
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
