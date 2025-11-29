import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snaplingua/app/data/services/auth_service.dart';
import 'package:snaplingua/app/data/services/firestore_service.dart';

import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../community/controllers/community_controller.dart';

class CommunityMemberProfileArguments {
  const CommunityMemberProfileArguments({
    required this.summary,
    required this.recentPosts,
    this.isFollowing = false,
    this.leagueTier,
    this.weeklyXp,
    this.xpBreakdown = const <String, int>{},
    this.userId,
    this.isVirtual = false,
  });

  final ProfileSummary summary;
  final List<String> recentPosts;
  final bool isFollowing;
  final String? leagueTier;
  final int? weeklyXp;
  final Map<String, int> xpBreakdown;
  final String? userId;
  final bool isVirtual;
}

class CommunityMemberProfileController extends GetxController {
  CommunityMemberProfileController({
    CommunityMemberProfileArguments? initialArguments,
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _initialArguments = initialArguments ??
            (Get.arguments is CommunityMemberProfileArguments
                ? Get.arguments as CommunityMemberProfileArguments
                : null),
        _firestoreService = firestoreService ??
            (Get.isRegistered<FirestoreService>()
                ? FirestoreService.to
                : Get.put(FirestoreService())),
        _authService = authService ??
            (Get.isRegistered<AuthService>()
                ? AuthService.to
                : Get.put(AuthService()));

  final CommunityMemberProfileArguments? _initialArguments;
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final GetStorage _storage = GetStorage();

  late final Rx<ProfileSummary> summary;
  late final RxList<String> recentPosts;
  late final RxBool isFollowing;
  late final RxnString leagueTier;
  late final RxnInt weeklyXp;
  late final RxMap<String, int> xpBreakdown;
  late final RxBool isVirtualProfile;
  late final RxBool isFollowLoading;
  late final RxBool showFollowButton;
  bool _isLocalFollowMutation = false;
  static const String _followingKey = 'community_following_ids';

  // Performance optimization - caching expensive operations
  String? _cachedUserId;
  int? _cachedFollowerCount;
  int? _cachedFollowingCount;
  DateTime? _lastCacheTime;

  @override
  void onInit() {
    super.onInit();
    final args = _initialArguments;
    if (args == null) {
      summary = ProfileSummary.initial().obs;
      recentPosts = <String>[].obs;
      isFollowing = false.obs;
      leagueTier = RxnString();
      weeklyXp = RxnInt();
      xpBreakdown = <String, int>{}.obs;
      isVirtualProfile = false.obs;
      isFollowLoading = false.obs;
      showFollowButton = false.obs;
      return;
    }
    summary = args.summary.obs;
    recentPosts = args.recentPosts.obs;
    final persistedFollow = _isPersistedFollowing(args.userId);
    isFollowing = (persistedFollow || args.isFollowing).obs;
    leagueTier = RxnString(args.leagueTier);
    weeklyXp = RxnInt(args.weeklyXp);
    xpBreakdown = args.xpBreakdown.obs;
    isVirtualProfile = args.isVirtual.obs;
    isFollowLoading = false.obs;
    showFollowButton = _shouldShowFollowButton(args.userId).obs;

    final userId = args.userId;
    if (userId != null && userId.isNotEmpty) {
      if (args.recentPosts.isEmpty) {
        // Use microtask for better performance in initialization
        Future.microtask(() => _loadRecentCommunityPhotos(userId));
      }
      Future.microtask(() => _hydrateMemberDetails(userId));
    }
    _persistFollowingState(
      profileUserId: args.userId,
      isFollowing: isFollowing.value,
      suppressSync: true,
    );
  }

  Future<void> toggleFollow() async {
    final targetUserId = _initialArguments?.userId;
    if (targetUserId == null || targetUserId.trim().isEmpty) {
      Get.log('ToggleFollow: Invalid target user ID');
      return;
    }

    final currentUserId = _authService.currentUserId.trim();
    if (currentUserId.isEmpty) {
      Get.snackbar(
        'Lỗi xác thực',
        'Vui lòng đăng nhập để thực hiện chức năng này.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentUserId == targetUserId) {
      Get.log('ToggleFollow: Cannot follow self');
      return;
    }

    if (isFollowLoading.value) {
      Get.log('ToggleFollow: Operation already in progress');
      return;
    }

    isFollowLoading.value = true;
    final wasFollowing = isFollowing.value;

    try {
      _isLocalFollowMutation = true;
      if (wasFollowing) {
        // Optimistic update
        isFollowing.value = false;
        _applyFollowerDelta(-1);
        _persistFollowingState(profileUserId: targetUserId, isFollowing: false);

        await _firestoreService.unfollowUser(
          userId: currentUserId,
          targetUserId: targetUserId,
        );

        _notifyCommunityFollowUpdate(
          userId: targetUserId,
          isFollowing: false,
        );
        _applyFollowingDelta(-1);

        Get.log('Successfully unfollowed user $targetUserId');
      } else {
        // Optimistic update
        isFollowing.value = true;
        _applyFollowerDelta(1);

        await _firestoreService.followUser(
          userId: currentUserId,
          targetUserId: targetUserId,
        );

        _persistFollowingState(profileUserId: targetUserId, isFollowing: true);

        _notifyCommunityFollowUpdate(
          userId: targetUserId,
          isFollowing: true,
        );
        _applyFollowingDelta(1);

        // Send notification (non-blocking)
        _sendFollowNotification(
          followerId: currentUserId,
          targetUserId: targetUserId,
        ).catchError((error) {
          Get.log('Failed to send follow notification: $error');
        });

        Get.log('Successfully followed user $targetUserId');
      }
    } catch (e) {
      // Rollback optimistic updates
      isFollowing.value = wasFollowing;
      _applyFollowerDelta(wasFollowing ? 1 : -1);
      _applyFollowingDelta(wasFollowing ? 1 : -1);
      _persistFollowingState(
        profileUserId: targetUserId,
        isFollowing: wasFollowing,
      );

      Get.log('ToggleFollow error: $e');
      Get.snackbar(
        'Thông báo',
        'Không thể cập nhật trạng thái theo dõi. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLocalFollowMutation = false;
      isFollowLoading.value = false;
    }
  }

  bool _shouldShowFollowButton(String? profileUserId) {
    if (profileUserId == null || profileUserId.trim().isEmpty) {
      return false;
    }

    final trimmedProfileUserId = profileUserId.trim();
    final currentUserId = _authService.currentUserId.trim();

    // Don't show follow button if user is not logged in
    if (currentUserId.isEmpty) {
      return false;
    }

    // Don't show follow button for the user's own profile
    if (currentUserId == trimmedProfileUserId) {
      return false;
    }

    // Don't show for virtual profiles
    if (isVirtualProfile.value) {
      return false;
    }

    return true;
  }

  Future<void> _sendFollowNotification({
    required String followerId,
    required String targetUserId,
  }) async {
    if (followerId.isEmpty || targetUserId.isEmpty || followerId == targetUserId) {
      return;
    }
    try {
      final follower = await _firestoreService.getUserById(followerId);
      if (follower == null) {
        Get.log('Cannot send follow notification: follower $followerId not found');
        return;
      }

      final displayName = follower.displayName?.trim();
      final email = follower.email?.trim();
      final followerName = (displayName != null && displayName.isNotEmpty)
          ? displayName
          : (email != null && email.isNotEmpty)
              ? email
              : 'Bạn học Snaplingua';
      final avatar = _normalizeAvatarPath(follower.avatarUrl);

      final payload = <String, dynamic>{
        'title': '$followerName đã theo dõi bạn',
        'subtitle': 'Chạm để xem trang cá nhân của họ.',
        'actorId': followerId,
        'actorName': followerName,
        'hasAction': true,
        'actionText': 'Xem hồ sơ',
        'profileUserId': followerId,
        'actionRoute': Routes.communityMemberProfile,
      };

      // Only add image path if valid
      if (avatar != null && avatar.trim().isNotEmpty) {
        payload['imagePath'] = avatar.trim();
      }

      await _firestoreService.createNotification(
        userId: targetUserId,
        type: 'follow',
        payload: payload,
      );
    } catch (e) {
      Get.log('Không thể gửi thông báo follow: $e');
    }
  }

  String? _normalizeAvatarPath(String? raw) {
    if (raw == null) {
      return null;
    }
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (trimmed.startsWith('file://')) {
      final withoutScheme = trimmed.replaceFirst('file://', '');
      if (withoutScheme.startsWith('/assets/')) {
        return withoutScheme.substring(1);
      }
      return withoutScheme;
    }
    if (trimmed.startsWith('/assets/')) {
      return trimmed.substring(1);
    }
    if (trimmed.startsWith('asset://')) {
      return trimmed.replaceFirst('asset://', '');
    }
    return trimmed;
  }

  void applyExternalFollowUpdate({
    required String targetUserId,
    required int followerDelta,
    required bool isFollowing,
  }) {
    if (_isLocalFollowMutation) {
      // Ignore echo from our own optimistic update to avoid double counting
      return;
    }
    // Validate inputs
    if (targetUserId.trim().isEmpty) {
      Get.log('ApplyExternalFollowUpdate: Invalid target user ID');
      return;
    }

    final viewedUserId = _initialArguments?.userId;
    if (viewedUserId == null || viewedUserId.trim() != targetUserId.trim()) {
      Get.log('ApplyExternalFollowUpdate: Target user mismatch');
      return;
    }

    // Prevent excessive deltas that could indicate data corruption
    if (followerDelta.abs() > 1000) {
      Get.log('ApplyExternalFollowUpdate: Suspicious follower delta: $followerDelta');
      return;
    }

    this.isFollowing.value = isFollowing;
    _persistFollowingState(
      profileUserId: targetUserId,
      isFollowing: isFollowing,
    );
    if (followerDelta != 0) {
      _applyFollowerDelta(followerDelta);
    }

    Get.log('Applied external follow update for $targetUserId: delta=$followerDelta, following=$isFollowing');
  }

  Future<void> _loadRecentCommunityPhotos(String userId) async {
    if (userId.trim().isEmpty) {
      Get.log('LoadRecentCommunityPhotos: Invalid user ID');
      return;
    }

    try {
      final photos = await _firestoreService.getCommunityPostImagesByUser(
        userId: userId.trim(),
        limit: 9, // Reasonable limit to prevent excessive data
      );

      if (photos.isNotEmpty) {
        // Filter out invalid URLs and limit to prevent memory issues
        final validPhotos = photos
            .where((photo) => photo.trim().isNotEmpty)
            .take(12) // Safety limit
            .toList();

        if (validPhotos.isNotEmpty) {
          recentPosts.assignAll(validPhotos);
          Get.log('Loaded ${validPhotos.length} community photos for $userId');
        }
      }
    } catch (e) {
      Get.log('Không thể tải ảnh cộng đồng của $userId: $e');
    }
  }

  Future<void> _hydrateMemberDetails(String userId) async {
    // Check cache validity (5 minutes cache)
    final now = DateTime.now();
    if (_cachedUserId == userId &&
        _lastCacheTime != null &&
        now.difference(_lastCacheTime!).inMinutes < 5) {
      // Use cached values for follower/following counts if available
      if (_cachedFollowerCount != null && _cachedFollowingCount != null) {
        final current = summary.value;
        summary.value = current.copyWith(
          followers: _cachedFollowerCount!,
          following: _cachedFollowingCount!,
        );
        summary.refresh();
        return;
      }
    }

    try {
      final currentSummary = summary.value;

      // Parallelize independent async operations for better performance
      final futures = await Future.wait([
        _firestoreService.getUserById(userId),
        _safeGetLifetimeXp(userId),
        _firestoreService.getUserFollowersCount(userId),
        _firestoreService.getUserFollowingCount(userId),
        _firestoreService.getUserLatestStreak(userId),
        _safeGetPostCount(userId),
      ]);

      final user = futures[0] as dynamic; // FirestoreUser?
      final lifetimeXp = futures[1] as int;
      final followerCount = futures[2] as int;
      final followingCount = futures[3] as int;
      final fetchedStreak = futures[4] as int;
      final postCount = futures[5] as int;

      var experience = currentSummary.experience;
      if (lifetimeXp > 0) {
        experience = lifetimeXp;
      }

      final breakdownTotal =
          xpBreakdown.values.fold<int>(0, (sum, value) => sum + value);
      if (experience <= 0 && breakdownTotal > 0) {
        experience = breakdownTotal;
      }
      final weeklyXpValue = weeklyXp.value ?? 0;
      if (experience <= 0 && weeklyXpValue > 0) {
        experience = weeklyXpValue;
      }
      if (user != null) {
        final balances = [
          user.scalesBalance,
          user.gemsBalance,
        ];
        for (final value in balances) {
          if (value != null && value > 0 && value > experience && experience <= 0) {
            experience = value;
            break; // Only use the first valid balance found
          }
        }
      }
      if (experience < 0) {
        experience = 0;
      }

      final streak = fetchedStreak >= 0 ? fetchedStreak : currentSummary.streak;

      // Update cache
      _cachedUserId = userId;
      _cachedFollowerCount = followerCount;
      _cachedFollowingCount = followingCount;
      _lastCacheTime = now;

      if (recentPosts.isEmpty) {
        try {
          final userPosts = await _firestoreService.getUserPosts(
            userId: userId,
            visibility: 'public',
            status: 'active',
            limit: 12,
          );
          final images = userPosts
              .map((post) => post.photoUrl)
              .where((url) => url.isNotEmpty)
              .toList();
          if (images.isNotEmpty) {
            recentPosts.assignAll(images.take(12));
          }
        } catch (e) {
          Get.log('Không thể tải bài đăng Firestore của $userId: $e');
        }
      }

      final rank = _resolveCommunityRank(experience);
      final currentRankTitle = currentSummary.rankTitle.trim();
      final currentRankIcon = currentSummary.rankIcon.trim();
      final resolvedRankTitle =
          currentRankTitle.isNotEmpty || experience <= 0 ? currentRankTitle : rank.title;
      final resolvedRankIcon =
          currentRankIcon.isNotEmpty || experience <= 0 ? currentRankIcon : rank.iconPath;

      summary.value = currentSummary.copyWith(
        experience: experience,
        posts: postCount,
        followers: followerCount,
        following: followingCount,
        streak: streak,
        rankTitle: resolvedRankTitle,
        rankIcon: resolvedRankIcon,
      );
      summary.refresh();
    } catch (e) {
      Get.log('Không thể cập nhật thông tin thành viên $userId: $e');
    }
  }

  void _applyFollowerDelta(int delta) {
    if (delta == 0) {
      return;
    }
    final current = summary.value;
    final nextFollowers = (current.followers + delta);
    final clampedFollowers = nextFollowers < 0 ? 0 : nextFollowers;
    summary.value = current.copyWith(
      followers: clampedFollowers,
    );
    summary.refresh();

    // Update cache if valid
    if (_cachedFollowerCount != null) {
      _cachedFollowerCount = clampedFollowers;
    }
  }

  void _applyFollowingDelta(int delta) {
    if (delta == 0) return;
    if (Get.isRegistered<ProfileController>()) {
      try {
        ProfileController.to.adjustFollowCounts(followingDelta: delta);
      } catch (e) {
        Get.log('Failed to adjust following count: $e');
      }
    }
  }

  bool _isPersistedFollowing(String? profileUserId) {
    if (profileUserId == null || profileUserId.trim().isEmpty) return false;
    final stored = _storage.read<List<dynamic>>(_followingKey);
    if (stored == null) return false;
    return stored
        .whereType<String>()
        .any((id) => id.trim() == profileUserId.trim());
  }

  void _persistFollowingState({
    required String? profileUserId,
    required bool isFollowing,
    bool suppressSync = false,
  }) {
    if (profileUserId == null || profileUserId.trim().isEmpty) return;
    final normalized = profileUserId.trim();
    final stored = _storage.read<List<dynamic>>(_followingKey) ?? [];
    final set = <String>{
      ...stored.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty)
    };
    if (isFollowing) {
      set.add(normalized);
    } else {
      set.remove(normalized);
    }
    _storage.write(_followingKey, set.toList(growable: false));

    if (!suppressSync && Get.isRegistered<ProfileController>()) {
      try {
        ProfileController.to.adjustFollowCounts(
          followingDelta: isFollowing ? 1 : -1,
        );
      } catch (_) {}
    }
  }

  void _notifyCommunityFollowUpdate({
    required String userId,
    required bool isFollowing,
  }) {
    if (userId.trim().isEmpty) {
      Get.log('NotifyCommunityFollowUpdate: Invalid user ID');
      return;
    }

    if (!Get.isRegistered<CommunityController>()) {
      Get.log('NotifyCommunityFollowUpdate: CommunityController not registered');
      return;
    }

    try {
      final communityController = Get.find<CommunityController>();
      communityController.updateFollowStateForUser(
        userId.trim(),
        isFollowing,
      );
      Get.log('Successfully notified CommunityController of follow update for $userId');
    } catch (e) {
      Get.log('Failed to notify CommunityController of follow update: $e');
    }
  }

  ProfileRank _resolveCommunityRank(int experience) {
    if (experience >= 2000) {
      return const ProfileRank(
        title: 'Igloo Kim cương',
        iconPath: 'assets/images/rank/rank1.png',
      );
    }
    if (experience >= 1200) {
      return const ProfileRank(
        title: 'Igloo Vàng',
        iconPath: 'assets/images/rank/rank3.png',
      );
    }
    if (experience >= 600) {
      return const ProfileRank(
        title: 'Igloo Bạc',
        iconPath: 'assets/images/rank/rank4.png',
      );
    }
    if (experience >= 200) {
      return const ProfileRank(
        title: 'Igloo Đồng',
        iconPath: 'assets/images/rank/rank5.png',
      );
    }
    if (experience >= 60) {
      return const ProfileRank(
        title: 'Tân binh Igloo',
        iconPath: 'assets/images/rank/rank6.png',
      );
    }
    return const ProfileRank(
      title: 'Khởi động Igloo',
      iconPath: 'assets/images/rank/rank7.png',
    );
  }

  Future<int> _safeGetLifetimeXp(String userId) async {
    if (userId.isEmpty) return 0;
    try {
      return await _firestoreService.getLifetimeXp(userId);
    } catch (e) {
      Get.log('Không thể lấy XP tích lũy của $userId: $e');
      return 0;
    }
  }

  Future<int> _safeGetPostCount(String userId) async {
    try {
      return await _firestoreService.getUserPostCount(
        userId: userId,
        visibility: 'public',
        status: 'active',
      );
    } catch (e) {
      Get.log('Không thể đếm bài đăng của $userId: $e');
      return 0;
    }
  }

  @override
  void onClose() {
    // Clear cache for memory optimization
    _cachedUserId = null;
    _cachedFollowerCount = null;
    _cachedFollowingCount = null;
    _lastCacheTime = null;

    super.onClose();
  }
}
