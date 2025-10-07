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

  @override
  void onInit() {
    super.onInit();
    _initializeStreakData();
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
  }

  // Navigate to previous month
  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
  }

  // Navigate to next month
  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
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
}
