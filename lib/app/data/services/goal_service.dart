import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GoalService extends GetxService {
  GoalService({GetStorage? storage}) : _storage = storage ?? GetStorage();

  static GoalService get to => Get.find();

  static const _learnKey = 'daily_learn_goal';
  static const _reviewKey = 'daily_review_goal';

  final GetStorage _storage;

  final RxInt dailyLearnGoal = 15.obs;
  final RxInt dailyReviewGoal = 30.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _loadGoals();
  }

  void _loadGoals() {
    final learn = _storage.read(_learnKey);
    final review = _storage.read(_reviewKey);

    if (learn is int && learn > 0) {
      dailyLearnGoal.value = learn;
    } else if (learn is String) {
      final parsed = int.tryParse(learn);
      if (parsed != null && parsed > 0) {
        dailyLearnGoal.value = parsed;
      }
    }

    if (review is int && review > 0) {
      dailyReviewGoal.value = review;
    } else if (review is String) {
      final parsed = int.tryParse(review);
      if (parsed != null && parsed > 0) {
        dailyReviewGoal.value = parsed;
      }
    }
  }

  Future<void> updateGoals({
    required int learnGoal,
    required int reviewGoal,
  }) async {
    dailyLearnGoal.value = learnGoal;
    dailyReviewGoal.value = reviewGoal;
    await _storage.write(_learnKey, learnGoal);
    await _storage.write(_reviewKey, reviewGoal);
  }
}
