import 'package:get/get.dart';

class StreakController extends GetxController {
  // Current streak count
  final currentStreak = 15.obs;

  // Total study days in current month
  final studyDaysInMonth = 15.obs;

  // Freeze items used
  final freezeItemsUsed = 5.obs;

  // Current selected month/year
  final currentMonth = DateTime.now().obs;

  // Days that user has studied (sample data)
  final studiedDays = <DateTime>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Today's activity status
  final todayHasActivity = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStreakData();
    _updateTodayActivity();
  }

  void _initializeStreakData() {
    // Sample data: User studied on these days in August 2025
    const year = 2025;
    const month = 8;

    // Days with streak (orange)
    final studyDaysList = [
      1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 14, 16, 18, 19, 20, 21, 22, 23, 25, 26
    ];

    studiedDays.value = studyDaysList
        .map((day) => DateTime(year, month, day))
        .toList();
    _updateTodayActivity();
  }

  // Update today's activity status
  void _updateTodayActivity() {
    final today = DateTime.now();
    todayHasActivity.value = isDayStudied(today);
  }

  // Navigate to previous month
  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
    _updateMonthlyStatistics();
  }

  // Navigate to next month
  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    _updateMonthlyStatistics();
  }

  // Check if a day has been studied
  bool isDayStudied(DateTime day) {
    return studiedDays.any((studiedDay) =>
        studiedDay.year == day.year &&
        studiedDay.month == day.month &&
        studiedDay.day == day.day);
  }

  // Check if it's today
  bool isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year &&
        day.month == now.month &&
        day.day == now.day;
  }

  // Check if it's current month
  bool isCurrentMonth(DateTime day) {
    return day.month == currentMonth.value.month &&
        day.year == currentMonth.value.year;
  }

  // Refresh streak data
  Future<void> refreshStreakData() async {
    try {
      isLoading.value = true;

      // Simulate data loading
      await Future.delayed(const Duration(seconds: 1));

      // Recalculate statistics for current month
      _updateMonthlyStatistics();
      _updateTodayActivity();

      Get.log('Streak data refreshed successfully');
    } catch (e) {
      Get.log('Error refreshing streak data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get motivational message based on current streak
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

  // Get streak status message
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

  // Update monthly statistics when month changes
  void _updateMonthlyStatistics() {
    final month = currentMonth.value;

    // Count study days in current month
    int studyDaysCount = 0;
    for (final studiedDay in studiedDays) {
      if (studiedDay.year == month.year && studiedDay.month == month.month) {
        studyDaysCount++;
      }
    }

    studyDaysInMonth.value = studyDaysCount;

    // Update freeze items used (placeholder logic)
    freezeItemsUsed.value = (studyDaysCount * 0.2).round();
  }


  // Add a study day (for future enhancement)
  void addStudyDay(DateTime date) {
    if (!isDayStudied(date)) {
      studiedDays.add(date);
      studiedDays.refresh();
      _updateMonthlyStatistics();
      _updateTodayActivity();

      // Update current streak if it's today
      if (isToday(date)) {
        currentStreak.value += 1;
      }
    }
  }

  // Remove a study day (for future enhancement)
  void removeStudyDay(DateTime date) {
    studiedDays.removeWhere((day) =>
      day.year == date.year &&
      day.month == date.month &&
      day.day == date.day
    );
    studiedDays.refresh();
    _updateMonthlyStatistics();
    _updateTodayActivity();
  }
}
