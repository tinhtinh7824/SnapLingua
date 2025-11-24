import 'package:get/get.dart';
import '../../../data/models/notification_item.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      error.value = null;

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Sample notifications
      notifications.value = [
        NotificationItem(
          id: '1',
          type: NotificationType.follow,
          title: 'Đức Phúc',
          subtitle: 'Đức Phúc đã theo dõi bạn! Các bạn đang cùng học Tiếng Anh.',
          imagePath: 'assets/images/chimcanhcut/chim.png',
          date: DateTime(2025, 8, 27),
          hasAction: true,
          actionText: 'Theo dõi lại',
        ),
        NotificationItem(
          id: '2',
          type: NotificationType.streak,
          title: 'Chúc mừng bạn đã được\n14 ngày streak!',
          imagePath: 'assets/images/chimcanhcut/chim_yeu.png',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationItem(
          id: '3',
          type: NotificationType.rankUp,
          title: 'Chúc mừng thăng hạng\nRank 7: Đảo Băng Lam',
          imagePath: 'assets/images/rank/rank7.png',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
        NotificationItem(
          id: '4',
          type: NotificationType.achievement,
          title: 'Chúc mừng bạn đã đạt\nTop 1 Rank 6!',
          imagePath: 'assets/images/chimcanhcut/chim_chienthang.png',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
    } catch (e) {
      error.value = 'Không thể tải thông báo: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void onActionTap(NotificationItem notification) {
    // Handle action button tap (e.g., follow back)
    Get.snackbar(
      'Đã theo dõi',
      'Bạn đã theo dõi ${notification.title}',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Mark as read when action is tapped
    markAsRead(notification.id);
  }

  void onNotificationTap(NotificationItem notification) {
    // Mark notification as read when tapped
    markAsRead(notification.id);

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.follow:
        // Navigate to user profile
        Get.snackbar(
          'Điều hướng',
          'Đi đến trang cá nhân của ${notification.title}',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case NotificationType.streak:
        // Navigate to streak/progress page
        Get.snackbar(
          'Điều hướng',
          'Xem thống kê streak của bạn',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case NotificationType.rankUp:
      case NotificationType.achievement:
        // Navigate to achievements/rank page
        Get.snackbar(
          'Điều hướng',
          'Xem thành tựu và rank của bạn',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
    }
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notification = notifications[index];
      if (!notification.isRead) {
        // Create a new notification object with isRead = true
        final updatedNotification = NotificationItem(
          id: notification.id,
          type: notification.type,
          title: notification.title,
          subtitle: notification.subtitle,
          imagePath: notification.imagePath,
          date: notification.date,
          hasAction: notification.hasAction,
          actionText: notification.actionText,
          isRead: true,
        );

        // Update the list
        notifications[index] = updatedNotification;
      }
    }
  }

  void markAllAsRead() {
    final updatedNotifications = notifications.map((notification) {
      if (!notification.isRead) {
        return NotificationItem(
          id: notification.id,
          type: notification.type,
          title: notification.title,
          subtitle: notification.subtitle,
          imagePath: notification.imagePath,
          date: notification.date,
          hasAction: notification.hasAction,
          actionText: notification.actionText,
          isRead: true,
        );
      }
      return notification;
    }).toList();

    notifications.assignAll(updatedNotifications);

    Get.snackbar(
      'Thành công',
      'Đã đánh dấu tất cả thông báo là đã đọc',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
