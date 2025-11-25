import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../routes/app_pages.dart';
import '../../camera_detection/controllers/camera_detection_controller.dart';
import '../controllers/home_stats_controller.dart';
import '../../../data/models/firestore_user.dart';

class LearningTabView extends GetView<HomeStatsController> {
  const LearningTabView({super.key});

  // Widget vòng tròn progress dùng chung
  Widget _buildProgressCircle({
    required int current,
    required int total,
    required Color color,
  }) {
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
                value: current / total,
                strokeWidth: 8.w,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          // Text ở giữa
          Center(
            child: Text(
              '$current/$total',
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
    final percentage = ((current / total) * 100).round();
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
                  value: current / total,
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
                    '$current/$total',
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

    return Scaffold(
      backgroundColor: const Color(0xFFE5FFFD),
      body: Obx(() {
        final loading = controller.isLoading.value;
        return Column(
          children: [
            // AppBar với màu BBFFEE
            Container(
              color: const Color(0xFFBBFFEE),
              child: SafeArea(
                child: _buildHeader(devicePixelRatio),
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
                                _buildVocabularyCard(devicePixelRatio),
                                SizedBox(height: 20.h),

                                // Ôn tập ngay
                                _buildReviewCard(devicePixelRatio),
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
                                _buildMonthlyQuest(devicePixelRatio),
                                SizedBox(height: 16.h),

                                // Nhiệm vụ hàng ngày
                                _buildDailyQuests(devicePixelRatio),
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

  Widget _buildHeader(double devicePixelRatio) {
    final statsUser = controller.user.value;
    final scales = statsUser?.scalesBalance ?? 0;
    final gems = statsUser?.gemsBalance ?? 0;
    // streak placeholder; could be tied to DailyProgress
    final streak = 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('assets/images/vay.png', '$scales', const Color(0xFFB8C3D1), Routes.shop, devicePixelRatio),
          _buildStatItem('assets/images/ngoc.png', '$gems', const Color(0xFF0571E6), Routes.shop, devicePixelRatio),
          _buildStatItem('assets/images/streak/streak6.png', '$streak', const Color(0xFF4E67F8), Routes.streak, devicePixelRatio),
          _buildStatItem('assets/images/thongbao.png', '', Colors.black, Routes.notification, devicePixelRatio),
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
          ? () {
              Get.toNamed(route);
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

  Widget _buildVocabularyCard(double devicePixelRatio) {
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
                    current: 9,
                    total: 15,
                    color: const Color(0xFF3D8EF7),
                  ),
                  SizedBox(height: 12.h),
                  // Nút học từ mới
                  AppWidgets.actionButton(
                    text: 'Học từ mới',
                    onPressed: () {},
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

  Widget _buildReviewCard(double devicePixelRatio) {
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
                    current: 5,
                    total: 30,
                    color: const Color(0xFF3D8EF7),
                  ),
                  SizedBox(height: 12.h),
                  // Nút ôn tập ngay
                  AppWidgets.actionButton(
                    text: 'Ôn tập ngay',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildMonthlyQuest(double devicePixelRatio) {
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
                  current: 19,
                  total: 20,
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

  Widget _buildDailyQuests(double devicePixelRatio) {
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
          _buildQuestProgressBar(
            current: 3,
            total: 5,
            title: 'Lưu 5 từ mới qua hình ảnh',
            imagePath: 'assets/images/chimcanhcut/chim_camqua.png',
            devicePixelRatio: devicePixelRatio,
          ),
          SizedBox(height: 16.h),
          _buildQuestProgressBar(
            current: 1,
            total: 30,
            title: 'Ôn tập 30 từ vựng',
            imagePath: 'assets/images/chimcanhcut/chim_camqua.png',
            devicePixelRatio: devicePixelRatio,
          ),
          SizedBox(height: 16.h),
          _buildQuestProgressBar(
            current: 0,
            total: 1,
            title: 'Đăng hình ảnh lên cộng đồng 1 lần',
            imagePath: 'assets/images/chimcanhcut/chim_camqua.png',
            devicePixelRatio: devicePixelRatio,
          ),
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
