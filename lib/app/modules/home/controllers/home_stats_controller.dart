import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/models/firestore_user.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class HomeStatsController extends GetxController {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  HomeStatsController({
    AuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? Get.find<AuthService>(),
        _firestoreService = firestoreService ?? Get.find<FirestoreService>();

  final Rx<FirestoreUser?> user = Rx<FirestoreUser?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final fbUser = FirebaseAuth.instance.currentUser;
      // Ưu tiên lấy userId/email trực tiếp từ Firebase để luôn đúng tài khoản đang đăng nhập
      final uid = fbUser?.uid ?? _authService.currentUserId;
      final email = fbUser?.email ?? _authService.currentUserEmail;

      if (uid.isEmpty) return;

      var doc = await _firestoreService.getUserById(uid);
      if (doc == null) {
        await _firestoreService.createUser(
          userId: uid,
          email: email,
          displayName: (fbUser?.displayName?.isNotEmpty == true)
              ? fbUser!.displayName!
              : (email.isNotEmpty ? email.split('@').first : 'Snaplingua user'),
          avatarUrl: fbUser?.photoURL,
        );
        doc = await _firestoreService.getUserById(uid);
      }
      user.value = doc;
    } finally {
      isLoading.value = false;
    }
  }
}
