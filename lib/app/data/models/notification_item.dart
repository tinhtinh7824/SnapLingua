enum NotificationType {
  follow,
  streak,
  rankUp,
  achievement,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String? subtitle;
  final String? imagePath;
  final DateTime date;
  final bool hasAction;
  final String? actionText;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.imagePath,
    required this.date,
    this.hasAction = false,
    this.actionText,
    this.isRead = false,
  });

  // Format date as dd/MM/yyyy
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
