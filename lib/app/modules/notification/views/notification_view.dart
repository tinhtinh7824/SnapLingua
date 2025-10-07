import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../data/models/notification_item.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5FFFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5FFFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              'Chưa có thông báo',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildNotificationCard(notification),
            );
          },
        );
      }),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    if (notification.type == NotificationType.follow) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: AppWidgets.questGradientDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Image, Name+Date, Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Image
                if (notification.imagePath != null)
                  Image.asset(
                    notification.imagePath!,
                    width: 43.w,
                    height: 43.h,

                  ),
                SizedBox(width: 12.w),
                // Column 2: Name and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.formattedDate,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Column 3: Action Button
                if (notification.hasAction)
                  AppWidgets.actionButton(
                    text: notification.actionText ?? '',
                    onPressed: () => controller.onActionTap(notification),
                  ),
              ],
            ),
            // Row 2: Subtitle
            if (notification.subtitle != null) ...[
              SizedBox(height: 12.h),
              Text(
                notification.subtitle!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Other notification types (streak, rankUp, achievement)
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: AppWidgets.questGradientDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar/Icon
          if (notification.imagePath != null)
            Image.asset(
              notification.imagePath!,
              height: 90.h,

            ),
          SizedBox(width: 6.w),
          // Content
          Expanded(
            child: Text(
              notification.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
