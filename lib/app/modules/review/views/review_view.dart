import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Thư viện từ vựng',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.searchCategories,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm nhanh từ vựng',
                  hintStyle: AppTextStyles.hintText,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textHint,
                    size: 24.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),

          // Category list
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return _buildCategoryCard(category);
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'reviewAddCategoryFab',
        onPressed: controller.onAddCategory,
        backgroundColor: AppColors.primaryAccent,
        elevation: 4,
        child: Icon(
          Icons.add,
          size: 32.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(VocabularyCategory category) {
    return GestureDetector(
      onTap: () => controller.onCategoryTap(category),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xFF6BA5F2).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: TextStyle(fontSize: 28.sp),
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Category info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${category.wordCount} từ vựng',
                    style: AppTextStyles.captionMedium,
                  ),
                ],
              ),
            ),

            // Progress indicator
            CircularPercentIndicator(
              radius: 30.r,
              lineWidth: 6.w,
              percent: category.progress,
              center: Text(
                '${(category.progress * 100).toInt()}%',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
              progressColor: _getProgressColor(category.progress),
              backgroundColor: AppColors.progressLocked.withOpacity(0.2),
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return AppColors.xpGold;
    } else if (progress >= 0.5) {
      return AppColors.xpGold;
    } else if (progress > 0) {
      return AppColors.xpGold;
    } else {
      return AppColors.progressLocked;
    }
  }
}
