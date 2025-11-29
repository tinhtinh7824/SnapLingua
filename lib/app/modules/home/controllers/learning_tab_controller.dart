import 'package:get/get.dart';
import '../../../data/models/firestore_daily_progress.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/models/firestore_daily_quest.dart';
import '../../../data/models/firestore_monthly_quest.dart';
import '../../../data/services/quest_service.dart';
import '../../../data/services/goal_service.dart';

class LearningTabController extends GetxController {
  static LearningTabController get to => Get.find<LearningTabController>();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt newLearned = 0.obs;
  final RxInt newTarget = 15.obs;
  final RxInt reviewDone = 0.obs;
  final RxInt reviewDue = 30.obs;
  final RxList<FirestoreDailyQuest> dailyQuests = <FirestoreDailyQuest>[].obs;
  final Rxn<FirestoreMonthlyQuestProgress> monthlyQuest =
      Rxn<FirestoreMonthlyQuestProgress>();

  int get monthlyTarget => monthlyQuestTarget();

  @override
  void onInit() {
    super.onInit();
    // Ensure QuestService is available before we start refreshing.
    if (!Get.isRegistered<QuestService>()) {
      Get.put(QuestService());
    }
    refreshProgress();
  }

  Future<void> refreshProgress() async {
    try {
      isLoading.value = true;
      error.value = '';

      if (!Get.isRegistered<AuthService>()) {
        error.value = 'AuthService chưa sẵn sàng';
        return;
      }

      final auth = AuthService.to;
      if (!auth.isLoggedIn || auth.currentUserId.isEmpty) {
        final goalService = Get.isRegistered<GoalService>()
            ? GoalService.to
            : Get.put(GoalService());
        newLearned.value = 0;
        reviewDone.value = 0;
        newTarget.value = goalService.dailyLearnGoal.value;
        reviewDue.value = goalService.dailyReviewGoal.value;
        error.value = 'Bạn cần đăng nhập để xem tiến độ';
        return;
      }

      final goalService = Get.isRegistered<GoalService>()
          ? GoalService.to
          : Get.put(GoalService());
      final progressService = DailyProgressService.to;
      final today = DateTime.now();
      List<FirestoreDailyProgress> monthly;
      try {
        monthly = await progressService.getMonthlyProgress(
          userId: auth.currentUserId,
          month: today,
        );
      } catch (e) {
        error.value = 'Không tải được tiến độ: $e';
        return;
      }

      final todayProgress = monthly.firstWhere(
        (p) => p.date.year == today.year && p.date.month == today.month && p.date.day == today.day,
        orElse: () => FirestoreDailyProgress(
          progressId: '',
          userId: auth.currentUserId,
          date: DateTime(today.year, today.month, today.day),
          newTarget: 15,
          newLearned: 0,
          reviewDue: 30,
          reviewDone: 0,
          streak: 0,
          xpGained: 0,
        ),
      );

      newLearned.value = todayProgress.newLearned;
      final learnGoal = goalService.dailyLearnGoal.value;
      final normalizedLearnTarget =
          todayProgress.newTarget > 0 ? todayProgress.newTarget : learnGoal;
      newTarget.value =
          [normalizedLearnTarget, learnGoal, newLearned.value].reduce((a, b) => a > b ? a : b);

      reviewDone.value = todayProgress.reviewDone;
      final reviewGoal = goalService.dailyReviewGoal.value;
      final normalizedReviewDue =
          todayProgress.reviewDue > 0 ? todayProgress.reviewDue : reviewGoal;
      reviewDue.value =
          [normalizedReviewDue, reviewGoal, reviewDone.value].reduce((a, b) => a > b ? a : b);

      // Quests
      await QuestService.to.refreshQuests();
      dailyQuests.assignAll(QuestService.to.dailyQuests);
      monthlyQuest.value = QuestService.to.monthlyProgress.value;

    } catch (e) {
      error.value = 'Không thể làm mới tiến độ: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
