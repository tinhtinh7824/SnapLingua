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
    if (!_authService.isLoggedIn) return;
    isLoading.value = true;
    try {
      final uid = _authService.currentUserId;
      var doc = await _firestoreService.getUserById(uid);
      if (doc == null) {
        await _firestoreService.createUser(
          userId: uid,
          email: _authService.currentUserEmail,
          displayName: _authService.currentUserEmail.split('@').first,
          avatarUrl: null,
        );
        doc = await _firestoreService.getUserById(uid);
      }
      user.value = doc;
    } finally {
      isLoading.value = false;
    }
  }
}
