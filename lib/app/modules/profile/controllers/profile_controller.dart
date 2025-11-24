import 'package:get/get.dart';

import '../../../data/models/firestore_post.dart';
import '../../../data/models/firestore_daily_progress.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  ProfileController({
    UserService? userService,
    FirestoreService? firestoreService,
  })  : _userService = userService ?? UserService.to,
        _firestoreService = firestoreService ?? FirestoreService.to;

  final UserService _userService;
  final FirestoreService _firestoreService;

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
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final Map<String, dynamic>? profileMap =
          await _userService.getUserProfile();
      if (profileMap == null) {
        summary.value = summary.value.copyWith(
          displayName: 'Khách Snaplingua',
          avatarUrl: null,
          posts: 0,
          followers: 0,
          following: 0,
          streak: 0,
          experience: 0,
          todayHasActivity: false,
        );
        recentPosts.clear();
        return;
      }

      final userId = profileMap['id'] as String? ?? '';

      String readString(dynamic value) {
        if (value == null) {
          return '';
        }
        if (value is String) {
          return value.trim();
        }
        return value.toString().trim();
      }

      var postsCount = 0;
      var followerCount = 0;
      var followingCount = 0;
      var streakCount = 0;
      var experience = 0;
      var hasActivityToday = false;
      var primaryGroupName = readString(
        profileMap['groupName'] ?? profileMap['group'],
      );
      var primaryGroupIcon = readString(
        profileMap['groupIcon'] ??
            profileMap['groupIconPath'] ??
            profileMap['groupIconUrl'],
      );
      List<String> recentPostImages = [];

      if (userId.isNotEmpty) {
        try {
          final lifetimeXp =
              await _firestoreService.getLifetimeXp(userId);
          if (lifetimeXp > 0) {
            experience = lifetimeXp;
          }
        } catch (e) {
          Get.log('Không thể lấy XP tích lũy của $userId: $e');
        }
      }

      List<FirestorePost> fetchedPosts = const <FirestorePost>[];
      if (userId.isNotEmpty) {
        await _primeMonthlyProgress(userId);
        try {
          final postsFuture = _firestoreService.getUserPosts(
            userId: userId,
            visibility: 'public',
            status: 'active',
            limit: 12,
          );
          final countFuture = _firestoreService.getUserPostCount(
            userId: userId,
            visibility: 'public',
            status: 'active',
          );
          fetchedPosts = await postsFuture;
          recentPostImages = await _resolvePostImages(fetchedPosts);
          postsCount = await countFuture;
        } catch (e) {
          Get.log('Không thể tải bài đăng Firestore cho $userId: $e');
        }
        if (postsCount == 0 && fetchedPosts.isNotEmpty) {
          postsCount = fetchedPosts.length;
        }

        try {
          followerCount = await _firestoreService.getUserFollowersCount(userId);
        } catch (e) {
          Get.log('Không thể tải số người theo dõi Firestore của $userId: $e');
        }
        try {
          followingCount =
              await _firestoreService.getUserFollowingCount(userId);
        } catch (e) {
          Get.log('Không thể tải số đang theo dõi Firestore của $userId: $e');
        }
      }

      if (recentPostImages.isEmpty) {
        recentPosts.clear();
      }

      if (recentPostImages.isNotEmpty) {
        recentPosts.assignAll(recentPostImages);
      } else {
        recentPosts.clear();
      }

      if (userId.isNotEmpty) {
        var resolved = false;
        if (Get.isRegistered<DailyProgressService>()) {
          try {
            streakCount =
                await DailyProgressService.to.getCurrentStreak(userId);
            resolved = true;
          } catch (_) {
            // Fallback to gamification service below.
          }
          try {
          final todayProgress = await DailyProgressService.to
                .getProgressForDate(userId: userId, date: DateTime.now());
            if (todayProgress != null) {
              if (experience <= 0) {
                experience = todayProgress.xpGained;
              }
              hasActivityToday = _hasActivity(todayProgress);
            }
          } catch (_) {
            // Ignore and fall back.
          }
        }
        if (!Get.isRegistered<DailyProgressService>()) {
          hasActivityToday = streakCount > 0;
        }
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

      final rawAvatar = profileMap['avatarUrl'] as String?;
      final normalizedAvatar = _normalizeAvatar(rawAvatar);

      summary.value = summary.value.copyWith(
        displayName: profileMap['displayName'] as String? ??
            profileMap['email'] as String? ??
            'Bạn học Snaplingua',
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
    } catch (e) {
      errorMessage.value = 'Không thể tải dữ liệu hồ sơ. Vui lòng thử lại.';
      Get.log('Load profile error: $e');
    } finally {
      isLoading.value = false;
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
