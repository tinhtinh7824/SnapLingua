import 'package:get/get.dart';

import '../controllers/community_detail_controller.dart';

class CommunityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<CommunityDetailController>(() => CommunityDetailController());
  }
}
