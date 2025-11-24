import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_widgets.dart';
import '../controllers/review_controller.dart';
// import '../../vocabulary_topic/controllers/vocabulary_topic_controller.dart'; // not used here
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../data/models/firestore_topic.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: [
          IconButton(
            onPressed: () => _showSystemTopicsSheet(context),
            icon: const Icon(Icons.library_books_outlined),
            tooltip: 'Chủ đề hệ thống',
          ),
          Obx(() {
            final isSeeding = controller.isSeedingDefault.value;
            if (isSeeding) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
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
                    color: AppColors.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm nhanh từ vựng',
                  hintStyle: AppTextStyles.hintText,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textHint,
                    size: 24.sp,
                  ),
                  suffixIcon: Obx(() {
                    final hasText =
                        controller.currentQuery.value.isNotEmpty ||
                        controller.searchController.text.isNotEmpty;
                    if (!hasText) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      tooltip: 'Xoá nội dung',
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.textHint,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.onSearchChanged('');
                        controller.currentQuery.value = '';
                      },
                    );
                  }),
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
            child: Obx(() {
              if (controller.isSearching.value) {
                if (controller.searchResults.isEmpty) {
                  return _buildEmptySearchState(controller.currentQuery.value);
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final result = controller.searchResults[index];
                    return _buildSearchResultCard(result);
                  },
                );
              }

              if (controller.filteredCategories.isEmpty) {
                return _buildEmptyCategoryState(context);
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.filteredCategories[index];
                  return _buildCategoryCard(category);
                },
              );
            }),
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

  Widget _buildSuggestedTopicsSection(BuildContext context) {
    return Obx(() {
      if (controller.isSearching.value) {
        return const SizedBox.shrink();
      }

      final hasUserTopics = controller.categories
          .any((category) => !category.isSystem);
      if (hasUserTopics) {
        return const SizedBox.shrink();
      }

      final isLoading = controller.isLoadingRecommendations.value;
      final topics = controller.recommendedTopics;
      final unsavedTopics = topics
          .where((topic) => !controller.isTopicSaved(topic))
          .toList();

      if (isLoading && topics.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Đang tải chủ đề gợi ý...',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (unsavedTopics.isEmpty) {
        return const SizedBox.shrink();
      }

      final preview = unsavedTopics.take(3).toList();
      final hasMore = unsavedTopics.length > preview.length;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        
        ),
      );
    });
  }

  Widget _buildSuggestedTopicRow(FirestoreTopic topic) {
    final isSaving = controller.isTopicSaving(topic.topicId);
    final icon = (topic.icon != null && topic.icon!.isNotEmpty)
        ? topic.icon!
        : '📘';
    final wordCount = topic.dictionaryWordIds.length;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: 22.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$wordCount từ vựng',
                  style: AppTextStyles.captionMedium,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          OutlinedButton(
            onPressed: isSaving ? null : () => controller.onSaveTopic(topic),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryAccent,
              side: const BorderSide(color: AppColors.primaryAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
            ),
            child: isSaving
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showSystemTopicsSheet(BuildContext context) {
    controller.ensureRecommendedTopicsLoaded();
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Obx(() {
              final isLoading = controller.isLoadingRecommendations.value;
              final topics = controller.recommendedTopics;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 8.w, 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chủ đề hệ thống',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor:
                          AppColors.progressLocked.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primaryAccent),
                    ),
                  Expanded(
                    child: topics.isEmpty && !isLoading
                        ? Center(
                            child: Text(
                              'Chưa có chủ đề hệ thống khả dụng.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            itemBuilder: (context, index) {
                              final topic = topics[index];
                              return _buildSystemTopicTile(topic);
                            },
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemCount: topics.length,
                          ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSystemTopicTile(FirestoreTopic topic) {
    final isSaved = controller.isTopicSaved(topic);
    final isSaving = controller.isTopicSaving(topic.topicId);
    final icon = (topic.icon != null && topic.icon!.isNotEmpty)
        ? topic.icon!
        : '📘';
    final wordCount = topic.dictionaryWordIds.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.shadow.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$wordCount từ vựng',
                  style: AppTextStyles.captionMedium,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          if (isSaved)
            Icon(
              Icons.check_circle,
              color: AppColors.buttonSuccess,
              size: 24.sp,
            )
          else
            SizedBox(
              height: 40.h,
              child: ElevatedButton(
                onPressed: isSaving ? null : () => controller.onSaveTopic(topic),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: isSaving
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Lưu'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(VocabularyCategory category) {
    return Slidable(
      key: ValueKey(category.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.46,
        children: [
          CustomSlidableAction(
            onPressed: (_) => controller.onEditCategory(category),
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.backgroundLight,
            child: SizedBox(
              width: 136.w,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                height: 90.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9F0),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, color: const Color(0xFFE64980), size: 22.sp),
                    SizedBox(height: 6.h),
                    Text(
                      'Sửa',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE64980),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomSlidableAction(
            onPressed: (_) => controller.onDeleteCategory(category),
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.backgroundLight,
            child: SizedBox(
              width: 136.w,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                height: 90.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E5),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: const Color(0xFFF97316), size: 22.sp),
                    SizedBox(height: 6.h),
                    Text(
                      'Xoá',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF97316),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => controller.onCategoryTap(category),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.08),
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
                  color: const Color(0xFF6BA5F2).withValues(alpha: 0.15),
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
                backgroundColor: AppColors.progressLocked.withValues(alpha: 0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(VocabularySearchResult result) {
    final item = result.item;
    final category = result.category;
  // statusColor not needed here; style is computed inline where required.

    return GestureDetector(
      onTap: () => controller.onSearchResultTap(result),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: AppWidgets.questGradientDecoration().copyWith(
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item.word,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                              color: const Color(0xFF023047),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            item.ipa,
                            style: AppTextStyles.captionMedium.copyWith(
                              fontSize: 14.sp,
                              color: const Color(0xFF0096C7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => controller.speakWord(item.word),
                            child: Icon(
                              Icons.volume_up,
                              size: 18.sp,
                              color: const Color(0xFF1CB0F6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        item.translation,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'EX: ${item.exampleEn}',
              style: AppTextStyles.captionMedium.copyWith(
                fontSize: 13.sp,
                color: const Color(0xFF4A5568),
                height: 1.35,
              ),
            ),
            Text(
              'VD: ${item.exampleVi}',
              style: AppTextStyles.captionMedium.copyWith(
                fontSize: 13.sp,
                color: const Color(0xFF4A5568),
                height: 1.35,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.folder_outlined,
                    size: 16,
                    color: Color(0xFF1CB0F6),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    category.name,
                    style: AppTextStyles.captionMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1CB0F6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(String query) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.sp,
              color: AppColors.textHint,
            ),
            SizedBox(height: 12.h),
            Text(
              'Không tìm thấy kết quả cho "$query"',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Hãy thử tìm kiếm với từ khóa khác hoặc kiểm tra lại chính tả.',
              style: AppTextStyles.captionMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCategoryState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open,
              size: 48.sp,
              color: AppColors.textHint,
            ),
            SizedBox(height: 12.h),
            Text(
              'Bạn chưa lưu chủ đề nào',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Khám phá các chủ đề gợi ý từ hệ thống hoặc tự tạo chủ đề mới để bắt đầu.',
              style: AppTextStyles.captionMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () => _showSystemTopicsSheet(context),
              icon: const Icon(Icons.library_books_outlined),
              label: const Text('Chọn chủ đề hệ thống'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
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

  // Status label/color helpers removed; not used in this view.
}
