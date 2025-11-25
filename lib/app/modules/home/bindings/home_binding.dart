import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../review/controllers/review_controller.dart';
import '../controllers/home_stats_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ReviewController>(() => ReviewController());
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<FirestoreService>()) {
      Get.put<FirestoreService>(FirestoreService(), permanent: true);
    }
    Get.put<HomeStatsController>(HomeStatsController(), permanent: true);
  }
}
