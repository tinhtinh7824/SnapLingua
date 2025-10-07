import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../routes/app_pages.dart';
import '../../camera_detection/controllers/camera_detection_controller.dart';

class LearningTabView extends StatelessWidget {
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
                backgroundColor: Colors.white.withValues(alpha: 0.3),
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
          Image.asset(
            imagePath,
            width: 60.w,
            height: 60.h,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(width: 60.w, height: 60.h);
            },
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5FFFD),
      body: Column(
        children: [
          // AppBar với màu BBFFEE
          Container(
            color: const Color(0xFFBBFFEE),
            child: SafeArea(
              child: _buildHeader(),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card học với ảnh
                    _buildLearningCard(),
                    SizedBox(height: 20.h),

                    // Học từ mới
                    _buildVocabularyCard(),
                    SizedBox(height: 20.h),

                    // Ôn tập ngay
                    _buildReviewCard(),
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
                    _buildMonthlyQuest(),
                    SizedBox(height: 16.h),

                    // Nhiệm vụ hàng ngày
                    _buildDailyQuests(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('assets/images/vay.png', '160', const Color(0xFFB8C3D1), Routes.shop),
          _buildStatItem('assets/images/ngoc.png', '2', const Color(0xFF0571E6), Routes.shop),
          _buildStatItem('assets/images/streak/streak6.png', '15', const Color(0xFF4E67F8), Routes.streak),
          _buildStatItem('assets/images/thongbao.png', '', Colors.black, Routes.notification),
        ],
      ),
    );
  }


  Widget _buildStatItem(String imagePath, String value, Color textColor, String? route) {
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
            Image.asset(
              imagePath,
              width: 32.w,
              height: 32.h,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 20.sp, color: Colors.red);
              },
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

  Widget _buildLearningCard() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.5, 1.0],
          colors: [
            Color(0xFF027DE0),
            Color(0xFFB2FFF1),
            Color(0xFF02D099),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          // Con chim bên trái
          Positioned(
            left: 55.w,
            bottom: 20.h,
            child: Image.asset(
              'assets/images/chimcanhcut/chim_chupanh.png',
              width: 54.w,
              height: 54.h,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          // Con chim bên phải
          Positioned(
            right: 55.w,
            bottom: 20.h,
            child: Image.asset(
              'assets/images/chimcanhcut/chim_chaomung.png',
              width: 54.w,
              height: 54.h,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          // Nội dung chính
          Column(
            children: [
              Text(
                'Gửi ảnh, học ngay từ mới!',
                style: TextStyle(
                  color: const Color(0xFF008BBE),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 35.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppWidgets.actionButton(
                    text: 'Chụp ảnh',
                    onPressed: () {
                      // Đảm bảo controller được khởi tạo
                      if (!Get.isRegistered<CameraDetectionController>()) {
                        Get.lazyPut(() => CameraDetectionController());
                      }
                      // Gọi chức năng chụp ảnh
                      CameraDetectionController.to.takePhoto();
                    },
                  ),
                  SizedBox(width: 50.w),
                  AppWidgets.actionButton(
                    text: 'Chọn ảnh',
                    onPressed: () {
                      // Đảm bảo controller được khởi tạo
                      if (!Get.isRegistered<CameraDetectionController>()) {
                        Get.lazyPut(() => CameraDetectionController());
                      }
                      // Gọi chức năng chọn ảnh
                      CameraDetectionController.to.pickFromGallery();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyCard() {
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
            child: Image.asset(
              'assets/images/chimcanhcut/chim_nhachoc.png',
              width: 160.w,
              height: 160.h,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 147.w,
                  height: 147.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.school,
                    size: 40.sp,
                    color: const Color(0xFF1CB0F6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
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
            child: Image.asset(
              'assets/images/chimcanhcut/chim_mung.png',
              width: 160.w,
              height: 160.h,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 147.w,
                  height: 147.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.refresh,
                    size: 40.sp,
                    color: const Color(0xFF58CC02),
                  ),
                );
              },
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

  Widget _buildMonthlyQuest() {
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
          child: Image.asset(
            'assets/images/chimcanhcut/chim_muadong5.png',
            width: 118.w,
            height: 118.h,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyQuests() {
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
          ),
          SizedBox(height: 16.h),
          _buildQuestProgressBar(
            current: 1,
            total: 30,
            title: 'Ôn tập 30 từ vựng',
            imagePath: 'assets/images/chimcanhcut/chim_camqua.png',
          ),
          SizedBox(height: 16.h),
          _buildQuestProgressBar(
            current: 0,
            total: 1,
            title: 'Đăng hình ảnh lên cộng đồng 1 lần',
            imagePath: 'assets/images/chimcanhcut/chim_camqua.png',
          ),
        ],
      ),
    );
  }
}
