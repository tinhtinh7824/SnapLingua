import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/community_controller.dart';
import '../../vocabulary_topic/controllers/vocabulary_topic_controller.dart';
import '../../../routes/app_pages.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F9FF),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  'Bảng tin',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D1F),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildTabBar(),
                SizedBox(height: 16.h),
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildFeed(),
                      _buildPlaceholder(
                        title: 'Nhóm học tập',
                        caption:
                            'Tính năng đang được phát triển. Vui lòng quay lại sau!',
                      ),
                      _buildPlaceholder(
                        title: 'Bảng xếp hạng',
                        caption:
                            'Đang tổng hợp dữ liệu cộng đồng. Bạn hãy quay lại sau nhé!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: TabBar(
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6F7B87),
        indicator: BoxDecoration(
          color: const Color(0xFF1CB0F6),
          borderRadius: BorderRadius.circular(24.r),
        ),
        indicatorPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Bảng tin'),
          Tab(text: 'Nhóm học tập'),
          Tab(text: 'Bảng xếp hạng'),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final post = controller.posts[index];
          return _FeedCard(post: post);
        },
      ),
    );
  }

  Widget _buildPlaceholder({required String title, required String caption}) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups, color: const Color(0xFF1CB0F6), size: 42.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 12.h),
          _buildImage(),
          SizedBox(height: 12.h),
          _buildActions(),
          SizedBox(height: 16.h),
          _buildVocabularyCard(),
          SizedBox(height: 12.h),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundImage: NetworkImage(post.authorAvatar),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF202124),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                post.postedAt,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8A8F9A),
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.more_vert, color: const Color(0xFF6F7B87), size: 22.sp),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${post.detectedLabel} ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      post.confidence.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionItem(
          icon: Icons.favorite_border,
          label: post.likes.toString(),
        ),
        _ActionItem(
          icon: Icons.chat_bubble_outline,
          label: post.comments.toString(),
        ),
        _ActionItem(
          icon: Icons.bookmark_border,
          label: post.bookmarks.toString(),
        ),
      ],
    );
  }

  Widget _buildVocabularyCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFCAE8FF), width: 1.5),
        color: const Color(0xFFF8FDFF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1CB0F6), width: 2),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  post.headword,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1D1F),
                  ),
                ),
              ),
              Icon(
                Icons.volume_up_rounded,
                color: const Color(0xFF1CB0F6),
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            post.translation,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF006A6A),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'Chủ đề:',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6F7B87),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  final topicName = post.topic ?? 'Động vật';
                  Get.toNamed(
                    Routes.vocabularyTopic,
                    arguments: VocabularyTopicArguments(
                      topicName: topicName,
                      items:
                          VocabularyTopicController.defaultAnimalVocabulary(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1CB0F6),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        post.topic ?? 'chọn chủ đề',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0077FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        child: Text(
          'Lưu từ vựng',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6F7B87), size: 22.sp),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF6F7B87),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
