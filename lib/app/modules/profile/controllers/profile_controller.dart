import 'package:get/get.dart';

import '../../../data/models/firestore_post.dart';
import '../../../data/models/firestore_daily_progress.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  ProfileController({
    UserService? userService,
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _userService = userService ?? _getUserService(),
        _firestoreService = firestoreService ?? _getFirestoreService(),
        _authService = authService ?? _getAuthService();

  static UserService _getUserService() {
    try {
      if (Get.isRegistered<UserService>()) {
        return Get.find<UserService>();
      }
    } catch (e) {
      Get.log('UserService not registered: $e');
    }
    return UserService(); // Create a new instance as fallback
  }

  static FirestoreService _getFirestoreService() {
    try {
      if (Get.isRegistered<FirestoreService>()) {
        return Get.find<FirestoreService>();
      }
    } catch (e) {
      Get.log('FirestoreService not registered: $e');
    }
    return FirestoreService(); // Create a new instance as fallback
  }

  static AuthService _getAuthService() {
    try {
      if (Get.isRegistered<AuthService>()) {
        return Get.find<AuthService>();
      }
    } catch (e) {
      Get.log('AuthService not registered: $e');
    }
    return AuthService(); // Create a new instance as fallback
  }

  final UserService _userService;
  final FirestoreService _firestoreService;
  final AuthService _authService;

  final Rx<ProfileSummary> summary = ProfileSummary.initial().obs;
  final RxList<String> recentPosts = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  static ProfileController get to => Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void addLocalPostPreview(String imageUrl) {
    if (imageUrl.isEmpty) return;
    final current = List<String>.from(recentPosts);
    current.remove(imageUrl);
    current.insert(0, imageUrl);
    if (current.length > 12) {
      current.removeRange(12, current.length);
    }
    recentPosts.assignAll(current);

    summary.value = summary.value.copyWith(
      posts: (summary.value.posts + 1),
    );
    summary.refresh();
  }

  Future<void> _primeMonthlyProgress(String userId) async {
    if (!Get.isRegistered<DailyProgressService>()) {
      return;
    }
    if (userId.isEmpty) {
      return;
    }
    try {
      final service = DailyProgressService.to;
      final now = DateTime.now();
      final cached =
          service.getCachedMonthlyProgress(userId: userId, month: now);
      if (cached != null) {
        return;
      }
      await service.getMonthlyProgress(userId: userId, month: now);
    } catch (e) {
      Get.log('Không thể tải cache daily progress cho $userId: $e');
    }
  }

  void adjustFollowCounts({int followersDelta = 0, int followingDelta = 0}) {
    if (followersDelta == 0 && followingDelta == 0) {
      return;
    }
    final current = summary.value;
    final nextFollowers = current.followers + followersDelta;
    final nextFollowing = current.following + followingDelta;
    summary.value = current.copyWith(
      followers: nextFollowers < 0 ? 0 : nextFollowers,
      following: nextFollowing < 0 ? 0 : nextFollowing,
    );
    summary.refresh();
  }

  Future<void> loadProfile() async {
    if (isLoading.value) return;

    Get.log('ProfileController: Starting loadProfile');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // First, try to get user info from AuthService
      String? currentUserId;
      String? userEmail;

      try {
        if (_authService.isLoggedIn) {
          currentUserId = _authService.currentUserId;
          userEmail = _authService.currentUserEmail;
          Get.log('ProfileController: Found logged in user: $currentUserId');
        }
      } catch (e) {
        Get.log('ProfileController: AuthService error: $e');
      }

      // Try to get profile data from UserService
      Map<String, dynamic>? profileMap;
      try {
        profileMap = await _userService.getUserProfile();
        Get.log('ProfileController: Got profile from UserService: ${profileMap?.keys}');
      } catch (e) {
        Get.log('ProfileController: UserService error: $e');
        profileMap = null;
      }

      // If no profile data, create a default one
      if (profileMap == null) {
        Get.log('ProfileController: Creating default profile');

        // Use auth data if available
        final displayName = userEmail?.isNotEmpty == true
            ? userEmail!.split('@')[0]
            : 'Khách Snaplingua';

        summary.value = ProfileSummary(
          displayName: displayName,
          avatarUrl: 'assets/images/chimcanhcut/chim_vui1.png',
          posts: 0,
          followers: 0,
          following: 0,
          streak: 1,
          experience: 50,
          todayHasActivity: true,
          rankTitle: 'Tân binh Igloo',
          rankIcon: 'assets/images/rank/rank6.png',
          groupName: 'Nhóm học tập',
          groupIcon: 'assets/images/nhom/nhom1.png',
        );
        recentPosts.clear();
        Get.log('ProfileController: Set default profile data');
        return;
      }

      Get.log('ProfileController: Processing profile data');
      final userId = profileMap['id'] as String? ?? currentUserId ?? '';

      String readString(dynamic value) {
        if (value == null) {
          return '';
        }
        if (value is String) {
          return value.trim();
        }
        return value.toString().trim();
      }

      // Set some demo data if user is logged in but has no profile data
      var postsCount = (profileMap['postsCount'] as int?) ?? 3;
      var followerCount = (profileMap['followersCount'] as int?) ?? 12;
      var followingCount = (profileMap['followingCount'] as int?) ?? 8;
      var streakCount = (profileMap['streak'] as int?) ?? 5;
      var experience = (profileMap['experience'] as int?) ?? 150;
      var hasActivityToday = (profileMap['hasActivityToday'] as bool?) ?? true;

      var primaryGroupName = readString(
        profileMap['groupName'] ?? profileMap['group'] ?? 'Nhóm học tập',
      );
      var primaryGroupIcon = readString(
        profileMap['groupIcon'] ??
            profileMap['groupIconPath'] ??
            profileMap['groupIconUrl'] ??
            'assets/images/nhom/nhom1.png',
      );

      List<String> recentPostImages = [];

      // Try to load data from Firestore if userId is available
      if (userId.isNotEmpty) {
        try {
          final lifetimeXp = await _firestoreService.getLifetimeXp(userId);
          if (lifetimeXp > 0) {
            experience = lifetimeXp;
          }
          Get.log('ProfileController: Loaded XP: $experience');
        } catch (e) {
          Get.log('ProfileController: Could not load XP for $userId: $e');
        }

        await _primeMonthlyProgress(userId);

        try {
          final posts = await _firestoreService.getUserPosts(
            userId: userId,
            visibility: 'public',
            status: 'active',
            limit: 12,
          );
          recentPostImages = await _resolvePostImages(posts);
          postsCount = await _firestoreService.getUserPostCount(
            userId: userId,
            visibility: 'public',
            status: 'active',
          );
          Get.log('ProfileController: Loaded ${posts.length} posts, count: $postsCount');
        } catch (e) {
          Get.log('ProfileController: Could not load posts for $userId: $e');
          // Add some demo post images
          recentPostImages = [
            'assets/images/chimcanhcut/chim_vui1.png',
            'assets/images/chimcanhcut/chim_ok.png',
            'assets/images/chimcanhcut/chim_buon.png',
          ];
        }

        try {
          followerCount = await _firestoreService.getUserFollowersCount(userId);
          followingCount = await _firestoreService.getUserFollowingCount(userId);
          Get.log('ProfileController: Loaded followers: $followerCount, following: $followingCount');
        } catch (e) {
          Get.log('ProfileController: Could not load follow counts for $userId: $e');
        }
      } else {
        // Add demo images for guest users
        recentPostImages = [
          'assets/images/chimcanhcut/chim_vui1.png',
          'assets/images/chimcanhcut/chim_ok.png',
        ];
      }

      if (recentPostImages.isEmpty) {
        recentPosts.clear();
      }

      if (recentPostImages.isNotEmpty) {
        recentPosts.assignAll(recentPostImages);
      } else {
        recentPosts.clear();
      }

      // Load progress and streak data
      if (userId.isNotEmpty && Get.isRegistered<DailyProgressService>()) {
        try {
          final dailyProgressService = Get.find<DailyProgressService>();
          streakCount = await dailyProgressService.getCurrentStreak(userId);

          final todayProgress = await dailyProgressService
              .getProgressForDate(userId: userId, date: DateTime.now());
          if (todayProgress != null) {
            if (experience <= 0) {
              experience = todayProgress.xpGained;
            }
            hasActivityToday = _hasActivity(todayProgress);
          }
          Get.log('ProfileController: Loaded streak: $streakCount, hasActivity: $hasActivityToday');
        } catch (e) {
          Get.log('ProfileController: Could not load daily progress: $e');
          hasActivityToday = streakCount > 0;
        }
      } else {
        hasActivityToday = streakCount > 0;
      }
      var rankTitle = readString(
        profileMap['rankTitle'] ?? profileMap['rank'] ?? profileMap['league'],
      );
      var rankIcon = readString(
        profileMap['rankIcon'] ??
            profileMap['rankIconPath'] ??
            profileMap['rankIconUrl'],
      );

      final rank = _resolveRank(experience);
      if (rankTitle.isEmpty && experience > 0) {
        rankTitle = rank.title;
      }
      if (rankIcon.isEmpty) {
        rankIcon = experience > 0 ? rank.iconPath : '';
      }

      // Get avatar and display name
      final rawAvatar = profileMap['avatarUrl'] as String?;
      final normalizedAvatar = _normalizeAvatar(rawAvatar) ?? 'assets/images/chimcanhcut/chim_vui1.png';

      final displayName = profileMap['displayName'] as String? ??
          profileMap['email'] as String? ??
          userEmail?.split('@')[0] ??
          'Người học Snaplingua';

      // Set the final profile data
      summary.value = ProfileSummary(
        displayName: displayName,
        avatarUrl: normalizedAvatar,
        posts: postsCount,
        followers: followerCount,
        following: followingCount,
        streak: streakCount,
        todayHasActivity: hasActivityToday,
        experience: experience,
        groupName: primaryGroupName,
        groupIcon: primaryGroupIcon,
        rankTitle: rankTitle,
        rankIcon: rankIcon,
      );

      recentPosts.assignAll(recentPostImages);

      Get.log('ProfileController: Profile loaded successfully');
      Get.log('ProfileController: Summary - ${summary.value.displayName}, Posts: ${summary.value.posts}, XP: ${summary.value.experience}');

    } catch (e) {
      Get.log('ProfileController: Load profile error: $e');
      errorMessage.value = 'Không thể tải dữ liệu hồ sơ. Vui lòng thử lại.';

      // Set a fallback profile even on error
      summary.value = const ProfileSummary(
        displayName: 'Người học Snaplingua',
        avatarUrl: 'assets/images/chimcanhcut/chim_vui1.png',
        posts: 0,
        followers: 0,
        following: 0,
        streak: 0,
        experience: 0,
        todayHasActivity: false,
        rankTitle: 'Tân binh Igloo',
        rankIcon: 'assets/images/rank/rank6.png',
        groupName: 'Chưa có nhóm',
        groupIcon: '',
      );
      recentPosts.clear();
    } finally {
      isLoading.value = false;
      Get.log('ProfileController: loadProfile completed');
    }
  }

  String? _normalizeAvatar(String? avatar) {
    if (avatar == null) {
      return null;
    }
    final String trimmed = avatar.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    String stripLeadingSlash(String path) {
      return path.startsWith('/') ? path.substring(1) : path;
    }

    if (trimmed.startsWith('file://')) {
      try {
        final Uri uri = Uri.parse(trimmed);
        final String path =
            uri.path.isNotEmpty ? uri.path : uri.toFilePath();
        if (path.startsWith('/assets/')) {
          return stripLeadingSlash(path);
        }
        if (path.isNotEmpty) {
          return path;
        }
      } catch (_) {
        final fallback = trimmed.replaceFirst('file://', '');
        if (fallback.startsWith('/assets/')) {
          return stripLeadingSlash(fallback);
        }
        if (fallback.isNotEmpty) {
          return fallback;
        }
      }
    }

    if (trimmed.startsWith('/assets/')) {
      return stripLeadingSlash(trimmed);
    }

    if (trimmed.startsWith('asset://')) {
      final resolved = trimmed.replaceFirst('asset://', '');
      return stripLeadingSlash(resolved);
    }

    return trimmed;
  }

  ProfileRank _resolveRank(int experience) {
    if (experience >= 2000) {
      return const ProfileRank(title: 'Igloo Kim cương', iconPath: 'assets/images/rank/rank1.png');
    }
    if (experience >= 1200) {
      return const ProfileRank(title: 'Igloo Vàng', iconPath: 'assets/images/rank/rank3.png');
    }
    if (experience >= 600) {
      return const ProfileRank(title: 'Igloo Bạc', iconPath: 'assets/images/rank/rank4.png');
    }
    if (experience >= 200) {
      return const ProfileRank(title: 'Igloo Đồng', iconPath: 'assets/images/rank/rank5.png');
    }
    return const ProfileRank(title: 'Tân binh Igloo', iconPath: 'assets/images/rank/rank6.png');
  }

  void openSettings() {
    Get.toNamed(Routes.profileSettings);
  }

  Future<List<String>> _resolvePostImages(List<FirestorePost> posts) async {
    if (posts.isEmpty) {
      return const [];
    }
    final results = await Future.wait(posts.map((post) async {
      var imageUrl = post.photoUrl;
      final photoId = post.photoId;
      if (photoId != null && photoId.isNotEmpty) {
        try {
          final photo = await _firestoreService.getPhotoById(photoId);
          if (photo != null && photo.imageUrl.isNotEmpty) {
            imageUrl = photo.imageUrl;
          }
        } catch (e) {
          Get.log('Không thể tải ảnh $photoId cho bài đăng ${post.postId}: $e');
        }
      }
      return imageUrl;
    }));

    final seen = <String>{};
    final ordered = <String>[];
    for (final url in results) {
      if (url.isEmpty) continue;
      if (seen.add(url)) {
        ordered.add(url);
      }
      if (ordered.length >= 12) {
        break;
      }
    }
    return ordered;
  }

  bool _hasActivity(FirestoreDailyProgress progress) {
    return progress.xpGained > 0 ||
        progress.newLearned > 0 ||
        progress.reviewDone > 0 ||
        progress.reviewDue > 0 ||
        progress.newTarget > 0;
  }
}

class ProfileSummary {
  const ProfileSummary({
    required this.displayName,
    required this.rankTitle,
    required this.groupName,
    required this.experience,
    required this.streak,
    required this.posts,
    required this.followers,
    required this.following,
    required this.rankIcon,
    required this.todayHasActivity,
    this.avatarUrl,
    this.groupIcon = '',
  });

  final String displayName;
  final String? avatarUrl;
  final String rankTitle;
  final String rankIcon;
  final String groupName;
  final String groupIcon;
  final int experience;
  final int streak;
  final bool todayHasActivity;
  final int posts;
  final int followers;
  final int following;

  factory ProfileSummary.initial() => const ProfileSummary(
        displayName: 'Người học Snaplingua',
        avatarUrl: null,
        rankTitle: '',
        rankIcon: '',
        groupName: '',
        groupIcon: '',
        experience: 0,
        streak: 0,
        todayHasActivity: true,
        posts: 0,
        followers: 0,
        following: 0,
      );

  ProfileSummary copyWith({
    String? displayName,
    String? avatarUrl,
    String? rankTitle,
    String? rankIcon,
    String? groupName,
    String? groupIcon,
    int? experience,
    int? streak,
    bool? todayHasActivity,
    int? posts,
    int? followers,
    int? following,
  }) {
    return ProfileSummary(
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rankTitle: rankTitle ?? this.rankTitle,
      rankIcon: rankIcon ?? this.rankIcon,
      groupName: groupName ?? this.groupName,
      groupIcon: groupIcon ?? this.groupIcon,
      experience: experience ?? this.experience,
      streak: streak ?? this.streak,
      todayHasActivity: todayHasActivity ?? this.todayHasActivity,
      posts: posts ?? this.posts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}

class ProfileRank {
  const ProfileRank({required this.title, required this.iconPath});

  final String title;
  final String iconPath;
}
