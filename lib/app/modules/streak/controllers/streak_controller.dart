import 'package:get/get.dart';

import '../../../data/models/firestore_daily_progress.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';

class StreakController extends GetxController {
  StreakController({
    AuthService? authService,
    DailyProgressService? dailyProgressService,
  })  : _authService = authService ?? _resolveAuthService(),
        _dailyProgressService =
            dailyProgressService ?? _resolveDailyProgressService();

  final AuthService _authService;
  final DailyProgressService _dailyProgressService;

  final currentStreak = 0.obs;
  final studyDaysInMonth = 0.obs;
  final freezeItemsUsed = 0.obs;
  final currentMonth = DateTime.now().obs;
  final studiedDays = <DateTime>[].obs;
  final isLoading = false.obs;
  final todayHasActivity = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshStreakData();
  }

  Future<void> refreshStreakData() async {
    await _loadDataForMonth(currentMonth.value, refreshStreak: true);
  }

  Future<void> previousMonth() async {
    final prev = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
    await _loadDataForMonth(prev);
  }

  Future<void> nextMonth() async {
    final next = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    await _loadDataForMonth(next);
  }

  bool isDayStudied(DateTime day) {
    return studiedDays.any(
      (studiedDay) =>
          studiedDay.year == day.year &&
          studiedDay.month == day.month &&
          studiedDay.day == day.day,
    );
  }

  bool isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year &&
        day.month == now.month &&
        day.day == now.day;
  }

  bool isCurrentMonth(DateTime day) {
    return day.month == currentMonth.value.month &&
        day.year == currentMonth.value.year;
  }

  String getMotivationalMessage() {
    final streak = currentStreak.value;

    if (streak == 0) {
      return 'Hãy bắt đầu streak của bạn hôm nay!';
    } else if (streak < 7) {
      return 'Tuyệt vời! Tiếp tục duy trì streak!';
    } else if (streak < 30) {
      return 'Streak ấn tượng! Bạn đang làm rất tốt!';
    } else if (streak < 100) {
      return 'Wow! Streak tháng rồi! Bạn thật kiên trì!';
    } else {
      return 'Huyền thoại! Streak 100+ ngày là điều tuyệt vời!';
    }
  }

  String getStreakMessage() {
    final streak = currentStreak.value;

    if (streak == 0) {
      return 'Bắt đầu hành trình học tập của bạn!';
    } else if (streak < 7) {
      return 'Đang trên đường xây dựng thói quen tốt!';
    } else if (streak < 30) {
      return 'Thói quen học tập đã được hình thành!';
    } else {
      return 'Bạn là người học tập kiên trì!';
    }
  }

  Future<void> _loadDataForMonth(
    DateTime month, {
    bool refreshStreak = false,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = _resolveUserId();
      if (userId.isEmpty || userId == 'guest') {
        errorMessage.value = 'Bạn cần đăng nhập để xem streak.';
        _resetData();
        return;
      }

      final normalizedMonth = DateTime(month.year, month.month);
      currentMonth.value = normalizedMonth;

      List<FirestoreDailyProgress> monthly;
      final cached = _dailyProgressService.getCachedMonthlyProgress(
        userId: userId,
        month: normalizedMonth,
      );

      if (cached != null) {
        monthly = cached;
      } else {
        monthly = await _dailyProgressService.getMonthlyProgress(
          userId: userId,
          month: normalizedMonth,
        );
      }

      final activeDays = monthly
          .where(_hasActivity)
          .map(
            (p) => DateTime(p.date.year, p.date.month, p.date.day),
          )
          .toList();
      activeDays.sort((a, b) => a.compareTo(b));
      studiedDays.assignAll(activeDays);
      studyDaysInMonth.value = activeDays.length;

      todayHasActivity.value = await _dailyProgressService.hasActivityOnDate(
        userId: userId,
        date: DateTime.now(),
      );

      if (refreshStreak) {
        currentStreak.value =
            await _dailyProgressService.calculateStreak(userId: userId);
      }

      freezeItemsUsed.value = 0;
    } catch (e) {
      errorMessage.value = 'Không thể tải dữ liệu streak: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _resetData() {
    currentStreak.value = 0;
    studyDaysInMonth.value = 0;
    studiedDays.clear();
    todayHasActivity.value = false;
    freezeItemsUsed.value = 0;
  }

  String _resolveUserId() {
    try {
      return _authService.currentUserId;
    } catch (_) {
      return '';
    }
  }

  static bool _hasActivity(FirestoreDailyProgress progress) {
    return progress.xpGained > 0 ||
        progress.newLearned > 0 ||
        progress.reviewDone > 0 ||
        progress.reviewDue > 0 ||
        progress.newTarget > 0;
  }

  static AuthService _resolveAuthService() {
    if (Get.isRegistered<AuthService>()) {
      return AuthService.to;
    }
    return Get.put(AuthService());
  }

  static DailyProgressService _resolveDailyProgressService() {
    if (Get.isRegistered<DailyProgressService>()) {
      return DailyProgressService.to;
    }
    return Get.put(DailyProgressService());
  }
}
