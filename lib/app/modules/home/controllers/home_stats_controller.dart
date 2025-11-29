import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/models/firestore_user.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/services/firestore_service.dart';

class HomeStatsController extends GetxController {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  final DailyProgressService _dailyProgressService;

  HomeStatsController({
    AuthService? authService,
    FirestoreService? firestoreService,
    DailyProgressService? dailyProgressService,
  })  : _authService = authService ?? Get.find<AuthService>(),
        _firestoreService = firestoreService ?? Get.find<FirestoreService>(),
        _dailyProgressService =
            dailyProgressService ?? Get.find<DailyProgressService>();

  final Rx<FirestoreUser?> user = Rx<FirestoreUser?>(null);
  final RxBool isLoading = false.obs;
  final RxInt unreadNotifications = 0.obs;
  final RxInt streak = 0.obs;
  StreamSubscription<FirestoreUser?>? _userSub;
  StreamSubscription<int>? _notificationSub;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<DailyProgressService>()) {
      Get.put(DailyProgressService());
    }
    Get.log('HomeStatsController.onInit');
    load();
  }

  Future<void> load() async {
    Get.log('HomeStatsController.load start');
    isLoading.value = true;
    try {
      final fbUser = FirebaseAuth.instance.currentUser;
      // Ưu tiên lấy userId/email trực tiếp từ Firebase để luôn đúng tài khoản đang đăng nhập
      final uid = fbUser?.uid ?? _authService.currentUserId;
      final email = fbUser?.email ?? _authService.currentUserEmail;

      if (uid.isEmpty) {
        Get.log('HomeStatsController.load: empty uid');
        return;
      }

      await _ensureUserExists(uid, email, fbUser);
      _userSub?.cancel();
      _userSub = _firestoreService.watchUserById(uid).listen((doc) {
        user.value = doc;
      });

      _notificationSub?.cancel();
      _notificationSub =
          _firestoreService.watchUnreadNotifications(uid).listen((count) {
        unreadNotifications.value = count;
      });

      streak.value = await _dailyProgressService.calculateStreak(
        userId: uid,
      );
      Get.log('HomeStatsController.load done');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _ensureUserExists(
    String uid,
    String email,
    User? fbUser,
  ) async {
    var doc = await _firestoreService.getUserById(uid);
    if (doc != null) {
      return;
    }
    await _firestoreService.createUser(
      userId: uid,
      email: email,
      displayName: (fbUser?.displayName?.isNotEmpty == true)
          ? fbUser!.displayName!
          : (email.isNotEmpty ? email.split('@').first : 'Snaplingua user'),
      avatarUrl: fbUser?.photoURL,
    );
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _notificationSub?.cancel();
    super.onClose();
  }
}
