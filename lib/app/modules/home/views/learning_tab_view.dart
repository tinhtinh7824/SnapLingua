import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../routes/app_pages.dart';
import '../../camera_detection/controllers/camera_detection_controller.dart';
import '../../review/controllers/review_controller.dart';
import '../controllers/home_stats_controller.dart';
import '../../../data/models/firestore_user.dart';
import '../../../data/models/firestore_daily_quest.dart';
import '../../../data/models/firestore_monthly_quest.dart';
import '../../learning_session/controllers/learning_session_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/vocabulary_service.dart';
import '../../../data/models/realm/vocabulary_model.dart';
import '../controllers/learning_tab_controller.dart';
import '../../../data/services/quest_service.dart';

class LearningTabView extends GetView<HomeStatsController> {
  const LearningTabView({super.key});

  // Widget vòng tròn progress dùng chung
  Widget _buildProgressCircle({
    required int current,
    required int total,
    required Color color,
  }) {
    final safeTotal = total <= 0 ? 1 : total;
    final safeCurrent = current.clamp(0, safeTotal).toInt();
    return SizedBox(
      width: 65.w,
      height: 65.h,
      child: Stack(
        children: [
          // Vòng tròn nền
          Center(
            child: SizedBox(
              width: 80.w,
              height: 80.h,
              child: CircularProgressIndicator(
                value: safeCurrent / safeTotal,
                strokeWidth: 8.w,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          // Text ở giữa
          Center(
            child: Text(
              '$safeCurrent/$safeTotal',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget progress bar dùng chung cho nhiệm vụ
  Widget _buildQuestProgressBar({
    required int current,
    required int total,
    String? title,
    String? imagePath,
    double? devicePixelRatio,
  }) {
    final safeTotal = total <= 0 ? 1 : total;
    final safeCurrent = current.clamp(0, safeTotal);
    final percentage = ((safeCurrent / safeTotal) * 100).round();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
                SizedBox(height: 8.h),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: safeCurrent / safeTotal,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF1CB0F6)),
                  minHeight: 10.h,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$safeCurrent/$safeTotal',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1CB0F6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (imagePath != null) ...[
          SizedBox(width: 12.w),
          Builder(
            builder: (context) {
              final ratio = devicePixelRatio ?? MediaQuery.of(context).devicePixelRatio;
              return _buildOptimizedAsset(
                imagePath: imagePath,
                width: 60.w,
                height: 60.h,
                devicePixelRatio: ratio,
                fallback: SizedBox(width: 60.w, height: 60.h),
              );
            },
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final progressController = Get.put(LearningTabController());

    return Scaffold(
      backgroundColor: const Color(0xFFE5FFFD),
      body: Obx(() {
        final loading = controller.isLoading.value;
        final statsUser = controller.user.value;
        final streak = controller.streak.value;
        final unread = controller.unreadNotifications.value;
        return Column(
          children: [
            // AppBar với màu BBFFEE
            Container(
              color: const Color(0xFFBBFFEE),
              child: SafeArea(
                child: _buildHeader(
                  devicePixelRatio,
                  user: statsUser,
                  streak: streak,
                  unreadNotifications: unread,
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card học với ảnh - flush with app bar
                          _buildLearningCard(devicePixelRatio),

                          // Content with padding
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Học từ mới
                                Obx(() => _buildVocabularyCard(
                                      devicePixelRatio,
                                      progressController.newLearned.value,
                                      progressController.newTarget.value,
                                    )),
                                SizedBox(height: 20.h),

                                // Ôn tập ngay
                                Obx(() => _buildReviewCard(
                                      devicePixelRatio,
                                      progressController.reviewDone.value,
                                      progressController.reviewDue.value,
                                    )),
                                SizedBox(height: 16.h),

                                // Nhiệm vụ
                                Center(
                                  child: Text(
                                    'Nhiệm vụ',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,

                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Nhiệm vụ tháng
                                Obx(() {
                                  final monthly = progressController.monthlyQuest.value;
                                  final current = monthly?.completedCount ?? 0;
                                  final total = progressController.monthlyTarget;
                                  return _buildMonthlyQuest(
                                    devicePixelRatio,
                                    current: current,
                                    total: total,
                                  );
                                }),
                                SizedBox(height: 16.h),

                                // Nhiệm vụ hàng ngày
                                Obx(() => _buildDailyQuests(
                                      devicePixelRatio,
                                      progressController.dailyQuests,
                                    )),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _handleNewLearningTap() async {
    try {
      final auth = Get.find<AuthService>();
      if (!auth.isLoggedIn) {
        Get.snackbar(
          'Cần đăng nhập',
          'Bạn cần đăng nhập để bắt đầu học từ mới.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.log('LearningTab: Bắt đầu Học từ mới từ trang chủ');
      final progressCtrl = Get.find<LearningTabController>();
      final target = progressCtrl.newTarget.value > 0 ? progressCtrl.newTarget.value : 15;
      final learned = progressCtrl.newLearned.value;
      final remaining = math.max(0, target - learned);
      if (remaining <= 0) {
        Get.snackbar(
          'Bạn đã đạt mục tiêu',
          'Hôm nay bạn đã hoàn thành số từ mới theo mục tiêu.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final takeCount = math.min(10, remaining);
      final deck = await _buildNewLearningDeck(takeCount);
      if (deck.isEmpty) {
        Get.log('LearningTab: Không tìm thấy từ vựng nào để học', isError: true);
        Get.snackbar(
          'Không có từ mới',
          'Kho từ vựng hiện trống hoặc chưa được tải.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.toNamed(
        Routes.learningSession,
        arguments: LearningSessionArguments(
          words: deck,
          round: LearningSessionController.roundLearning,
          sessionType: 'new_learning',
        ),
      );
    } catch (e, stack) {
      Get.log('LearningTab: Lỗi khi bắt đầu học từ mới - $e', isError: true);
      Get.log(stack.toString(), isError: true);
      Get.snackbar(
        'Không thể bắt đầu học',
        'Đã xảy ra lỗi: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<List<LearningWord>> _buildNewLearningDeck(int takeCount) async {
    final vocabService = Get.find<VocabularyService>();
    final all = await vocabService.getAllVocabulary();
    if (all.isEmpty) return const [];

    all.shuffle();
    final take = math.min(takeCount, all.length);
    return all.take(take).map((Vocabulary v) {
      return LearningWord(
        vocabularyId: v.id,
        word: v.word,
        translation: v.translation ?? v.definition,
        phonetic: v.phonetic,
        exampleEn: v.example,
        exampleVi: '',
        status: VocabularyService.statusNew,
        personalWordId: null,
        srsStage: 0,
        repetitions: 0,
        wrongStreak: 0,
        lapses: 0,
        srsEase: 250,
        srsIntervalDays: 0,
        srsDueAt: null,
        isLeech: false,
      );
    }).toList();
  }

  Future<void> _handleReviewTap() async {
    try {
      final reviewController = Get.isRegistered<ReviewController>()
          ? Get.find<ReviewController>()
          : Get.put(ReviewController());
      Get.log('LearningTab: Bắt đầu luồng Ôn tập ngay từ trang chủ');
      await reviewController.startReviewSession();
    } catch (e, stack) {
      Get.log('LearningTab: Lỗi khi bắt đầu ôn tập ngay - $e', isError: true);
      Get.log(stack.toString(), isError: true);
      Get.snackbar(
        'Không thể ôn tập ngay',
        'Đã xảy ra lỗi: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildHeader(
    double devicePixelRatio, {
    required FirestoreUser? user,
    required int streak,
    required int unreadNotifications,
  }) {
    final scales = user?.scalesBalance ?? 0;
    final gems = user?.gemsBalance ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          _buildStatItem('assets/images/vay.png', '$scales', const Color(0xFFB8C3D1), Routes.shop, devicePixelRatio),
          _buildStatItem('assets/images/ngoc.png', '$gems', const Color(0xFF0571E6), Routes.shop, devicePixelRatio),
          _buildStatItem('assets/images/streak/streak6.png', '$streak', const Color(0xFF4E67F8), Routes.streak, devicePixelRatio),
          Stack(
            children: [
              _buildStatItem('assets/images/thongbao.png', '', Colors.black, Routes.notification, devicePixelRatio),
              if (unreadNotifications > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      unreadNotifications > 99 ? '99+' : '$unreadNotifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildStatItem(
    String imagePath,
    String value,
    Color textColor,
    String? route,
    double devicePixelRatio,
  ) {
    return GestureDetector(
      onTap: route != null
          ? () async {
              try {
                Get.log('LearningTab: navigate to $route');
                await Get.toNamed(route);
              } catch (e) {
                Get.snackbar(
                  'Lỗi',
                  'Không thể mở màn hình: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
                Get.log('Navigate error: $e');
              }
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            _buildOptimizedAsset(
              imagePath: imagePath,
              width: 32.w,
              height: 32.h,
              devicePixelRatio: devicePixelRatio,
              fallback: Icon(Icons.error, size: 20.sp, color: Colors.red),
            ),
            if (value.isNotEmpty) ...[
              SizedBox(width: 4.w),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLearningCard(double devicePixelRatio) {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF027DE0),
            Color(0xFFB2FFF1),
            Color(0xFF02D099),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
        child: Stack(
          children: [
            // Penguin character positioned on the left
            Positioned(
              left: 15.w,
              top: 10.h,
              child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: _buildOptimizedAsset(
                imagePath: 'assets/images/chimcanhcut/chim_chupanh.png',
                width: 176.w,
                height: 176.h,
                devicePixelRatio: devicePixelRatio,
                fit: BoxFit.contain,
                fallback: Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 50.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Text and button on the right side
          Positioned(
            right: 10.w,
            left: 170.w,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Gửi ảnh',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF008BBE),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'học ngay từ mới!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF008BBE),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 12.h),
                AppWidgets.actionButton(
                  text: 'Gửi ảnh',
                  onPressed: () {
                    // Đảm bảo controller được khởi tạo
                    if (!Get.isRegistered<CameraDetectionController>()) {
                      Get.lazyPut(() => CameraDetectionController());
                    }
                    // Gọi chức năng chụp ảnh
                    CameraDetectionController.to.takePhoto();
                  },
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabularyCard(double devicePixelRatio, int current, int total) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.7, 1.0],
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color(0xFF02D099),
            Color(0xFF027ED0),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          // Nội dung chính
          Padding(
            padding: EdgeInsets.only(left: 40.w, top: 10.h, bottom: 10.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Vòng tròn progress
                  _buildProgressCircle(
                    current: current.clamp(0, total),
                    total: total <= 0 ? 1 : total,
                    color: const Color(0xFF3D8EF7),
                  ),
                  SizedBox(height: 12.h),
                  // Nút học từ mới
                  AppWidgets.actionButton(
                    text: 'Học từ mới',
                    onPressed: _handleNewLearningTap,
                  ),
                ],
              ),
            ),
          ),
          // Hình ảnh con chim positioned
          Positioned(
            right: 10.w,
            bottom: -30.h,
            child: _buildOptimizedAsset(
              imagePath: 'assets/images/chimcanhcut/chim_nhachoc.png',
              width: 160.w,
              height: 160.h,
              devicePixelRatio: devicePixelRatio,
              fallback: Container(
                width: 147.w,
                height: 147.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.school,
                  size: 40.sp,
                  color: const Color(0xFF1CB0F6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(double devicePixelRatio, int current, int total) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF027ED0),
            Color(0xFF02D099),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          // Hình ảnh con chim positioned bên trái
          Positioned(
            left: 20.w,
            bottom: -30.h,
            child: _buildOptimizedAsset(
              imagePath: 'assets/images/chimcanhcut/chim_mung.png',
              width: 160.w,
              height: 160.h,
              devicePixelRatio: devicePixelRatio,
              fallback: Container(
                width: 147.w,
                height: 147.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.refresh,
                  size: 40.sp,
                  color: const Color(0xFF58CC02),
                ),
              ),
            ),
          ),

          // Nội dung chính
          Padding(
            padding: EdgeInsets.only(right: 35.w, top: 10.h, bottom: 10.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Vòng tròn progress
                  _buildProgressCircle(
                    current: current.clamp(0, total),
                    total: total <= 0 ? 1 : total,
                    color: const Color(0xFF3D8EF7),
                  ),
                  SizedBox(height: 12.h),
                  // Nút ôn tập ngay
                  AppWidgets.actionButton(
                    text: 'Ôn tập ngay',
                    onPressed: _handleReviewTap,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildMonthlyQuest(
    double devicePixelRatio, {
    required int current,
    required int total,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: AppWidgets.questGradientDecoration(),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhiệm vụ\ntháng Mười',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                // Progress bar và số liệu
                _buildQuestProgressBar(
                  current: current,
                  total: total,
                ),
              ],
            ),
          ),
        ),
        // Hình ảnh con chim positioned bên ngoài khung
        Positioned(
          right: 20.w,
          top: -40.h,
          child: _buildOptimizedAsset(
            imagePath: 'assets/images/chimcanhcut/chim_muadong5.png',
            width: 118.w,
            height: 118.h,
            devicePixelRatio: devicePixelRatio,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyQuests(
    double devicePixelRatio,
    List<FirestoreDailyQuest> quests,
  ) {
    if (quests.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: AppWidgets.questGradientDecoration(),
        child: Text(
          'Chưa có nhiệm vụ hôm nay',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: AppWidgets.questGradientDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhiệm vụ hàng ngày',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(quests.length, (index) {
            final quest = quests[index];
            final imagePath = 'assets/images/chimcanhcut/chim_camqua.png';
            return Padding(
              padding: EdgeInsets.only(bottom: index == quests.length - 1 ? 0 : 16.h),
              child: _buildQuestProgressBar(
                current: quest.progress,
                total: quest.target,
                title: questTitleForType(quest.type),
                imagePath: imagePath,
                devicePixelRatio: devicePixelRatio,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOptimizedAsset({
    required String imagePath,
    required double width,
    required double height,
    required double devicePixelRatio,
    Widget? fallback,
    BoxFit fit = BoxFit.cover,
  }) {
    final safeRatio = devicePixelRatio <= 0 ? 1.0 : devicePixelRatio;
    final targetWidthPx = (width * safeRatio).clamp(1, double.maxFinite).round();
    final targetHeightPx = (height * safeRatio).clamp(1, double.maxFinite).round();
    const maxDimensionPx = 512;

    final cacheWidth = targetWidthPx > maxDimensionPx
        ? maxDimensionPx
        : targetWidthPx;
    final cacheHeight = targetHeightPx > maxDimensionPx
        ? (targetHeightPx * (cacheWidth / targetWidthPx)).round()
        : targetHeightPx;

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) => fallback ?? const SizedBox.shrink(),
    );
  }
}
