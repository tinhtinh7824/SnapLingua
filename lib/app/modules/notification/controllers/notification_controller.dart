import 'package:get/get.dart';
import 'package:snaplingua/app/modules/community_detail/bindings/community_detail_binding.dart';
import '../../../data/models/notification_item.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/firestore_notification.dart';
import '../../community/controllers/community_controller.dart';
import '../../community/views/community_view.dart';
import '../../community_detail/controllers/community_detail_controller.dart';
import '../../community_detail/views/community_detail_view.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();
  AuthService? _auth;
  FirestoreService? _firestore;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    _firestore =
        Get.isRegistered<FirestoreService>() ? FirestoreService.to : null;
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      error.value = null;

      final userId = _auth?.currentUserId;
      if (_auth == null || _firestore == null || userId == null || !_auth!.isLoggedIn) {
        error.value = 'Bạn cần đăng nhập để xem thông báo';
        notifications.clear();
        return;
      }

      final raw = await _firestore!.getUserNotifications(userId: userId);
      notifications.value = raw.map(_mapNotification).toList();
      await _hydrateNotificationImages();
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

  Future<void> onNotificationTap(NotificationItem notification) async {
    // Mark notification as read when tapped
    markAsRead(notification.id);

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.follow:
        final profileUser = notification.targetUserId ?? notification.actorId;
        if (profileUser != null && profileUser.isNotEmpty) {
          Get.toNamed(
            Routes.communityMemberProfile,
            arguments: {'userId': profileUser},
          );
        }
        break;
      case NotificationType.postReaction:
      case NotificationType.postComment:
        final postId = notification.postId;
        if (postId != null && postId.isNotEmpty) {
          await _openPostDetail(
            postId,
            notification.imagePath,
            photoId: notification.postPhotoId,
          );
        }
        break;
      case NotificationType.streak:
        Get.toNamed(Routes.streak);
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

  Future<void> _openPostDetail(String postId, String? imageUrl, {String? photoId}) async {
    // Try to reuse existing posts from CommunityController
    CommunityPost? post;
    if (Get.isRegistered<CommunityController>()) {
      final community = Get.find<CommunityController>();
      post = community.posts.firstWhereOrNull((p) => p.id == postId);
    }

    // If not found, fetch from Firestore to get accurate photo
    if (post == null) {
      final fetched = await _firestore?.getPostById(postId);
      final resolvedImage = fetched?.photoUrl ??
          imageUrl ??
          await _resolvePhotoById(photoId ?? fetched?.photoId);
      post = CommunityPost(
        id: postId,
        authorId: fetched?.userId ?? '',
        authorName: '',
        authorAvatar: '',
        postedAt: '',
        imageUrl: resolvedImage ?? '',
        photoId: fetched?.photoId ?? photoId,
        vocabularyItems: const [],
        likes: 0,
        comments: 0,
        bookmarks: 0,
      );
    }

    Get.to(
      () => const CommunityDetailView(),
      binding: CommunityDetailBinding(),
      arguments: CommunityDetailArguments(post: post),
    );
  }

  Future<String?> _resolvePhotoById(String? photoId) async {
    if (photoId == null || photoId.isEmpty) return null;
    try {
      final photo = await _firestore?.getPhotoById(photoId);
      return photo?.imageUrl;
    } catch (e) {
      return null;
    }
  }

  void markAsRead(String notificationId) {
    _firestore?.markNotificationRead(notificationId: notificationId);
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
    _markAllAsReadAsync();
  }

  Future<void> _markAllAsReadAsync() async {
    try {
      final userId = _auth?.currentUserId;
      if (userId == null || _auth?.isLoggedIn != true || _firestore == null) {
        return;
      }

      await _firestore!.markAllNotificationsRead(userId: userId);

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
            actorId: notification.actorId,
            targetUserId: notification.targetUserId,
            postId: notification.postId,
            streakCount: notification.streakCount,
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
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể đánh dấu đã đọc: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  NotificationItem _mapNotification(FirestoreNotification raw) {
    final payload = raw.payload ?? {};
    final typeString = raw.type.toLowerCase();
    NotificationType resolvedType = NotificationType.achievement;
    switch (typeString) {
      case 'follow':
        resolvedType = NotificationType.follow;
        break;
      case 'post_like':
        resolvedType = NotificationType.postReaction;
        break;
      case 'post_comment':
        resolvedType = NotificationType.postComment;
        break;
      case 'streak':
      case 'streak_milestone':
        resolvedType = NotificationType.streak;
        break;
      default:
        resolvedType = NotificationType.achievement;
    }

    final title = (payload['title'] as String?) ??
        _defaultTitleFor(resolvedType, payload);
    final subtitle = payload['subtitle'] as String?;
    final imagePath = (payload['postImage'] ??
            payload['postThumbnail'] ??
            payload['photoUrl'] ??
            payload['imagePath'] ??
            payload['image_url'] ??
            payload['thumbnail']) as String?;
    final actionText = payload['actionText'] as String?;
    final hasAction = payload['hasAction'] as bool? ?? false;

    return NotificationItem(
      id: raw.notificationId,
      type: resolvedType,
      title: title,
      subtitle: subtitle,
      imagePath: imagePath,
      date: raw.sentAt,
      hasAction: hasAction,
      actionText: actionText,
      isRead: raw.readAt != null,
      actorId: payload['actorId'] as String?,
      targetUserId: (payload['profileUserId'] as String?) ??
          (payload['targetUserId'] as String?),
      postId: payload['postId'] as String? ?? payload['post_id'] as String?,
      postPhotoId:
          payload['photoId'] as String? ?? payload['photo_id'] as String?,
      streakCount: payload['streak'] as int?,
    );
  }

  Future<void> _hydrateNotificationImages() async {
    try {
      final updated = <NotificationItem>[];
      for (final n in notifications) {
        if (n.imagePath != null && n.imagePath!.trim().isNotEmpty) {
          updated.add(n);
          continue;
        }
        String? resolvedImage;

        // 1) Try cached posts already loaded in CommunityController
        if (Get.isRegistered<CommunityController>() &&
            n.postId != null &&
            n.postId!.isNotEmpty) {
          final post = Get.find<CommunityController>()
              .posts
              .firstWhereOrNull((p) => p.id == n.postId);
          if (post != null && post.imageUrl.isNotEmpty) {
            resolvedImage = post.imageUrl;
          }
        }

        // Try photoId first if present
        if ((resolvedImage == null || resolvedImage.isEmpty) &&
            n.postPhotoId != null &&
            n.postPhotoId!.isNotEmpty) {
          resolvedImage = await _resolvePhotoById(n.postPhotoId);
        }
        // Next, try fetching the post to read photoUrl/photoId
        if ((resolvedImage == null || resolvedImage.isEmpty) &&
            n.postId != null &&
            n.postId!.isNotEmpty) {
          try {
            final post = await _firestore?.getPostById(n.postId!);
            resolvedImage = post?.photoUrl;
            if ((resolvedImage == null || resolvedImage.isEmpty) &&
                post?.photoId != null &&
                post!.photoId!.isNotEmpty) {
              resolvedImage = await _resolvePhotoById(post.photoId!);
            }
          } catch (_) {}
        }

        if (resolvedImage == null || resolvedImage.isEmpty) {
          updated.add(n);
          continue;
        }

        updated.add(n.copyWith(imagePath: resolvedImage));
      }
      notifications.assignAll(updated);
    } catch (_) {
      // Ignore hydration errors to avoid breaking UI
    }
  }

  String _defaultTitleFor(
    NotificationType type,
    Map<String, dynamic> payload,
  ) {
    switch (type) {
      case NotificationType.follow:
        final actor = payload['actorName'] as String? ?? 'Người dùng';
        return '$actor đã theo dõi bạn';
      case NotificationType.postReaction:
        final actor = payload['actorName'] as String? ?? 'Ai đó';
        return '$actor đã thả tym bài viết của bạn';
      case NotificationType.postComment:
        final actor = payload['actorName'] as String? ?? 'Ai đó';
        return '$actor đã bình luận bài viết của bạn';
      case NotificationType.streak:
        final streak = payload['streak'] as int? ?? 0;
        return 'Bạn đã đạt $streak ngày streak!';
      case NotificationType.rankUp:
        return 'Bạn vừa thăng hạng mới!';
      case NotificationType.achievement:
        return 'Bạn vừa nhận được thành tựu mới';
    }
  }
}
