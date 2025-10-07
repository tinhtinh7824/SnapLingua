import 'package:get/get.dart';
import '../../../data/models/notification_item.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
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
  }

  void onActionTap(NotificationItem notification) {
    // Handle action button tap (e.g., follow back)
    Get.snackbar(
      'Đã theo dõi',
      'Bạn đã theo dõi ${notification.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void markAsRead(String notificationId) {
    // Mark notification as read
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // Update notification as read
    }
  }
}
