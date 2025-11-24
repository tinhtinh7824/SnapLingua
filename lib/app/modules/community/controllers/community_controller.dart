import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/data/models/realm/vocabulary_model.dart';
import 'package:snaplingua/app/data/services/example_sentence_service.dart';
import 'package:snaplingua/app/data/services/auth_service.dart';
import 'package:snaplingua/app/data/services/realm_service.dart';
import 'package:snaplingua/app/data/services/vocabulary_service.dart';
import 'package:snaplingua/app/routes/app_pages.dart';
import 'package:snaplingua/app/data/models/firestore_post.dart';
import 'package:snaplingua/app/data/models/firestore_post_comment.dart';
import 'package:snaplingua/app/data/models/firestore_post_like.dart';
import 'package:snaplingua/app/data/models/firestore_post_word.dart';
import 'package:snaplingua/app/data/models/firestore_photo.dart';
import 'package:snaplingua/app/data/models/firestore_group.dart';
import 'package:snaplingua/app/data/models/firestore_group_member.dart';
import 'package:snaplingua/app/data/models/firestore_user.dart';
import 'package:snaplingua/app/data/models/firestore_xp_transaction.dart';
import 'package:snaplingua/app/data/services/firestore_service.dart';
import 'package:snaplingua/app/data/models/firestore_league_cycle.dart';
import 'package:snaplingua/app/data/models/firestore_league_member.dart';
import 'package:snaplingua/app/data/models/firestore_league_tier.dart';
import 'package:snaplingua/app/data/models/firestore_daily_quest.dart';
import 'package:snaplingua/app/data/services/quest_service.dart';

import '../../community_member_profile/controllers/community_member_profile_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../home/controllers/learning_tab_controller.dart';
import '../../review/controllers/review_controller.dart';
import '../../vocabulary_topic/controllers/vocabulary_topic_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';

int _boundIndex(int length, int index) {
  if (length <= 0) {
    return 0;
  }
  if (index < 0) {
    return 0;
  }
  if (index >= length) {
    return length - 1;
  }
  return index;
}

class CommunityVocabularyItem {
  CommunityVocabularyItem({
    required this.label,
    required this.confidence,
    required this.headword,
    required this.phonetic,
    required this.translation,
    String? topic,
    bool isSelected = false,
  })  : topic = RxnString(topic),
        isSelected = isSelected.obs;

  final String label;
  final double confidence;
  final String headword;
  final String phonetic;
  final String translation;
  final RxnString topic;
  final RxBool isSelected;
}

class CommunityStudyGroup {
  CommunityStudyGroup({
    required this.groupId,
    required this.name,
    required this.requirement,
    required this.memberCount,
    required this.assetImage,
    required this.leaderId,
    required this.leaderName,
    this.requireApproval = false,
    this.description,
    this.status = 'active',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String groupId;
  final String name;
  final String requirement;
  final int memberCount;
  final String assetImage;
  final String leaderId;
  final bool requireApproval;
  final String leaderName;
  final String? description;
  final String status;
  final DateTime createdAt;

  CommunityStudyGroup copyWith({
    String? groupId,
    String? name,
    String? requirement,
    int? memberCount,
    String? assetImage,
    String? leaderId,
    bool? requireApproval,
    String? leaderName,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return CommunityStudyGroup(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      requirement: requirement ?? this.requirement,
      memberCount: memberCount ?? this.memberCount,
      assetImage: assetImage ?? this.assetImage,
      leaderId: leaderId ?? this.leaderId,
      leaderName: leaderName ?? this.leaderName,
      requireApproval: requireApproval ?? this.requireApproval,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CommunityJoinRequest {
  CommunityJoinRequest({
    required this.groupId,
    required this.memberId,
    required this.senderUserId,
    required this.groupName,
    required this.leaderName,
    required this.message,
    required this.senderName,
  });

  // Firestore ids and sender info used by leaders to accept/reject
  final String groupId;
  final String memberId;
  final String senderUserId;

  final String groupName;
  final String leaderName;
  final String message;
  final String senderName;
}

class CommunityGroupMilestone {
  CommunityGroupMilestone({
    required this.label,
    required this.requiredPoints,
    required this.isReached,
  });

  final String label;
  final int requiredPoints;
  final bool isReached;
}

class CommunityGroupMemberScore {
  CommunityGroupMemberScore({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.totalPoints,
    required this.weeklyPoints,
    required this.avatarUrl,
    this.isHighlighted = false,
  });

  final int rank;
  final String userId;
  final String displayName;
  final int totalPoints;
  final int weeklyPoints;
  final String avatarUrl;
  final bool isHighlighted;
}

class CommunityGroupDetails {
  CommunityGroupDetails({
    required this.group,
    required this.currentMilestoneLabel,
    required this.daysRemaining,
    required this.currentPoints,
    required this.milestones,
    required this.memberScores,
  });

  final CommunityStudyGroup group;
  final String currentMilestoneLabel;
  final int daysRemaining;
  final int currentPoints;
  final List<CommunityGroupMilestone> milestones;
  final List<CommunityGroupMemberScore> memberScores;
}

class CommunityChatMessage {
  CommunityChatMessage({
    required this.senderName,
    required this.content,
    required this.isCurrentUser,
    required this.isLeader,
    this.isSticker = false,
  });

  final String senderName;
  final String content;
  final bool isCurrentUser;
  final bool isLeader;
  final bool isSticker;
}

enum CommunityLeaderboardStatus { promotion, safe, demotion }

class CommunityLeaderboardParticipant {
  CommunityLeaderboardParticipant({
    required this.rank,
    required this.userId,
    required this.name,
    required this.totalPoints,
    required this.weeklyPoints,
    required this.avatarUrl,
    required this.status,
    required this.xpBreakdown,
    required this.rawPoints,
    this.isVirtual = false,
  });

  final int rank;
  final String userId;
  final String name;
  final int totalPoints;
  final int weeklyPoints;
  final String avatarUrl;
  final CommunityLeaderboardStatus status;
  final Map<String, int> xpBreakdown;
  final int rawPoints;
  final bool isVirtual;

  CommunityLeaderboardParticipant copyWith({
    int? rank,
    String? userId,
    String? name,
    int? totalPoints,
    int? weeklyPoints,
    String? avatarUrl,
    CommunityLeaderboardStatus? status,
    Map<String, int>? xpBreakdown,
    int? rawPoints,
    bool? isVirtual,
  }) {
    return CommunityLeaderboardParticipant(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      totalPoints: totalPoints ?? this.totalPoints,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      xpBreakdown: xpBreakdown ?? this.xpBreakdown,
      rawPoints: rawPoints ?? this.rawPoints,
      isVirtual: isVirtual ?? this.isVirtual,
    );
  }
}

class CommunityLeagueInfo {
  CommunityLeagueInfo({
    required this.tierId,
    required this.name,
    required this.daysRemaining,
    required this.rankIcon,
    required this.promotionCount,
    required this.safeThreshold,
    required this.demotionCount,
    required this.participants,
    this.xpCapDescription,
    this.desiredParticipants = 20,
  });

  final String tierId;
  final String name;
  final int daysRemaining;
  final String rankIcon;
  final int promotionCount;
  final int safeThreshold;
  final int demotionCount;
  final List<CommunityLeaderboardParticipant> participants;
  final String? xpCapDescription;
  final int desiredParticipants;

  factory CommunityLeagueInfo.empty() => CommunityLeagueInfo(
        tierId: '',
        name: 'Đang tải giải đấu',
        daysRemaining: 0,
        rankIcon: 'assets/images/rank/rank6.png',
        promotionCount: 0,
        safeThreshold: 0,
        demotionCount: 0,
        participants: const [],
        xpCapDescription: null,
        desiredParticipants: 20,
      );
}

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.postedAt,
    required this.imageUrl,
    this.photoId,
    required List<CommunityVocabularyItem> vocabularyItems,
    required int likes,
    required int comments,
    required int bookmarks,
    bool isLiked = false,
    int initialVocabularyIndex = 0,
    bool initiallySelected = false,
    List<String>? initialComments,
    bool isSendingComment = false,
    bool canFollowAuthor = false,
    bool isFollowingAuthor = false,
    bool isFollowActionPending = false,
  })  : vocabularyItems = vocabularyItems.isEmpty
            ? [
                CommunityVocabularyItem(
                  label: 'vocabulary',
                  confidence: 0,
                  headword: 'Từ vựng',
                  phonetic: '',
                  translation: '',
                ),
              ]
            : vocabularyItems,
        currentVocabularyIndex = _boundIndex(
          vocabularyItems.isEmpty ? 1 : vocabularyItems.length,
          initialVocabularyIndex,
        ).obs,
        likes = likes.obs,
        comments = (initialComments?.length ?? comments).obs,
        bookmarks = bookmarks.obs,
        isLiked = isLiked.obs,
        commentMessages = (initialComments ??
                List<String>.generate(
                  comments,
                  (index) => 'Bình luận ${index + 1}',
                ))
            .obs,
        isCommentsExpanded = false.obs,
        isVocabularyExpanded = true.obs,
        isSendingComment = isSendingComment.obs,
        canFollowAuthor = canFollowAuthor,
        isFollowingAuthor = isFollowingAuthor.obs,
        isFollowActionPending = isFollowActionPending.obs {
    if (initiallySelected && this.vocabularyItems.isNotEmpty) {
      this.vocabularyItems[currentVocabularyIndex.value].isSelected.value =
          true;
    }
  }

  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String postedAt;
  final String imageUrl;
  final String? photoId;
  final List<CommunityVocabularyItem> vocabularyItems;
  final RxInt currentVocabularyIndex;
  final RxInt likes;
  final RxInt comments;
  final RxInt bookmarks;
  final RxBool isLiked;
  final RxList<String> commentMessages;
  final RxBool isCommentsExpanded;
  final RxBool isVocabularyExpanded;
  final RxBool isSendingComment;

  // Follow functionality properties
  final bool canFollowAuthor;
  final RxBool isFollowingAuthor;
  final RxBool isFollowActionPending;

  CommunityVocabularyItem get currentVocabulary => vocabularyItems[
      _boundIndex(vocabularyItems.length, currentVocabularyIndex.value)];
}

class CommunityPostReport {
  CommunityPostReport({
    required this.postId,
    required this.reason,
    this.description,
    DateTime? reportedAt,
  }) : reportedAt = reportedAt ?? DateTime.now();

  final String postId;
  final String reason;
  final String? description;
  final DateTime reportedAt;
}

class CommunityController extends GetxController {
  CommunityController({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestoreService = firestoreService ??
            (Get.isRegistered<FirestoreService>()
                ? FirestoreService.to
                : Get.put(FirestoreService())),
        _authService = authService ??
            (Get.isRegistered<AuthService>() ? AuthService.to : null);

  final FirestoreService _firestoreService;
  final AuthService? _authService;
  // This service is provided here for potential use by community features.
  // It may be unused in some builds; ignore unused-field lint to avoid analyzer noise.
  // ignore: unused_field
  final VocabularyService _vocabularyService =
    Get.isRegistered<VocabularyService>()
      ? VocabularyService.to
      : Get.put(VocabularyService(), permanent: true);
  StreamSubscription<List<FirestorePost>>? _postsSubscription;
  StreamSubscription<List<FirestoreGroup>>? _groupsSubscription;
  StreamSubscription<List<FirestoreGroupMember>>? _membershipSubscription;
  StreamSubscription<List<FirestoreLeagueTier>>? _leagueTiersSubscription;
  StreamSubscription<List<FirestoreLeagueCycle>>? _leagueCyclesSubscription;
  StreamSubscription<List<FirestoreLeagueMember>>? _leagueMembersSubscription;
  FirestoreGroupMember? _activeMembership;
  final Map<String, FirestoreUser> _userCache = {};
  final Map<String, UserXpBreakdown> _xpBreakdownCache = {};
  final Map<String, StreamSubscription<List<FirestoreXpTransaction>>>
      _groupXpSubscriptions = {};
  final Map<String, int> _groupXpTotals = {};

  // Cache limits for memory optimization
  static const int _maxUserCacheSize = 100;
  static const int _maxXpBreakdownCacheSize = 500;
  static const int _maxPhotoCacheSize = 50;

  // Validation constants
  static const int _maxCommentLength = 500;
  static const int _maxPostCaptionLength = 1000;
  // Subscriptions used when the current user is a leader to listen to pending
  // membership requests for groups they manage.
  final Map<String, StreamSubscription<List<FirestoreGroupMember>>>
    _leaderPendingSubscriptions = {};
  _GroupCycleWindow? _activeGroupCycleWindow;
  String? _activeGroupXpId;
  static const List<String> _groupIconAssets = [
    'assets/images/nhom/nhom1.png',
    'assets/images/nhom/nhom2.png',
    'assets/images/nhom/nhom3.png',
    'assets/images/nhom/nhom4.png',
    'assets/images/nhom/nhom5.png',
  ];
  static const List<String> _leagueRankIcons = [
    'assets/images/rank/rank1.png',
    'assets/images/rank/rank2.png',
    'assets/images/rank/rank3.png',
    'assets/images/rank/rank4.png',
    'assets/images/rank/rank5.png',
    'assets/images/rank/rank6.png',
    'assets/images/rank/rank7.png',
    'assets/images/rank/rank8.png',
    'assets/images/rank/rank9.png',
    'assets/images/rank/rank10.png',
  ];
  static const List<String> _virtualNames = [
    'Nguyễn Công Vinh',
    'Lê Hồng',
    'Hoàng Cường',
    'Quốc Tấn',
    'Đình Tấn',
    'Thảo Đan',
    'Lê Hữu',
    'Bá Đạo',
    'Quốc Việt',
    'Nguyễn An Bích',
    'Lê Trần Việt',
    'Phí Hữu',
    'Trần Đình Đức',
    'Lê Cường',
    'Chu Tâm Lý',
    'Hà Cào',
    'Bá Đức',
    'Đức Hội',
    'Nguyễn Phương Uyên',
    'Trần Nhật Long',
    'Vũ Gia Linh',
    'Phạm Quang Minh',
    'Ngô Ngọc Anh',
    'Đỗ Thảo Nhi',
    'Phan Trọng Nhân',
    'Bùi Thị Kiều',
    'Đặng Hải Đăng',
    'Đoàn Mai Trang',
    'Nguyễn Lữ Hoài Nam',
    'Trịnh Võ Phương',
  ];

  final RxList<CommunityPost> posts = <CommunityPost>[].obs;
  final Map<String, FirestorePhoto> _photoCache = {};
  final RxList<CommunityStudyGroup> studyGroups = <CommunityStudyGroup>[].obs;
  final RxList<FirestoreLeagueTier> leagueTiers = <FirestoreLeagueTier>[].obs;
  final Rxn<FirestoreLeagueTier> selectedLeagueTier =
      Rxn<FirestoreLeagueTier>();
  final Rxn<FirestoreLeagueCycle> activeLeagueCycle =
      Rxn<FirestoreLeagueCycle>();
  final RxList<String> availableTopics = <String>[..._defaultTopics].obs;
  final RxString groupSearchQuery = ''.obs;
  final TextEditingController groupSearchController = TextEditingController();
  final RxList<CommunityJoinRequest> pendingJoinRequests =
      <CommunityJoinRequest>[].obs;
  // Incoming join requests for groups the current user leads
  final RxList<CommunityJoinRequest> incomingJoinRequests =
    <CommunityJoinRequest>[].obs;
  final Rxn<CommunityGroupDetails> joinedGroupDetails =
      Rxn<CommunityGroupDetails>();
  late final Rx<CommunityLeagueInfo> currentLeague;
  final RxList<CommunityPostReport> submittedReports =
      <CommunityPostReport>[].obs;

  static const String _fallbackUserId = 'current_user_id';
  static const List<String> _defaultTopics = [
    'Động vật hoang dã',
    'Thế giới động vật',
    'Khám phá thiên nhiên',
    'Sở thích cá nhân',
    'Ẩm thực',
    'Du lịch',
    'Đời sống hằng ngày',
    'Khác',
  ];
  static const List<String> reportReasons = [
    'Nội dung sai sự thật / gây hiểu nhầm.',
    'Ngôn ngữ thô tục / xúc phạm.',
    'Hình ảnh không phù hợp.',
    'Spam / quảng cáo.',
    'Khác',
  ];
  static const List<MapEntry<String, int>> _milestoneDefinitions = [
    MapEntry('Băng mới', 600),
    MapEntry('Bờ băng vững', 16000),
    MapEntry('Đảo băng', 30000),
    MapEntry('Cực quang rực', 44000),
    MapEntry('Ngai Băng', 60000),
  ];

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _bindPosts();
    _bindGroups();
    _bindUserMemberships();
    currentLeague = Rx<CommunityLeagueInfo>(CommunityLeagueInfo.empty());
    _bindLeagueTiers();
    _loadAvailableTopics();
  }

  /// Public helper to be called when a user's profile changed.
  /// This clears the cached user entry and forces posts to be reloaded so
  /// updated displayName/avatarUrl are reflected immediately in the feed.
  Future<void> refreshPostsForUser(String userId) async {
    if (userId.isEmpty) return;
    // Remove cached user so subsequent fetches read the updated Firestore doc.
    _userCache.remove(userId);

    // Remove any cached XP breakdowns for this user (keys use pattern '<userId>:<cycleId>').
    try {
      final keysToRemove = _xpBreakdownCache.keys
          .where((k) => k.startsWith('$userId:'))
          .toList(growable: false);
      for (final k in keysToRemove) {
        _xpBreakdownCache.remove(k);
      }
    } catch (e) {
      Get.log('refreshPostsForUser: failed clearing xp breakdown cache: $e');
    }

    try {
      // Rebind posts to force rebuild with fresh author data.
      _bindPosts();

      // If a league cycle is active, rebind league members so leaderboard is rebuilt.
      if (activeLeagueCycle.value != null) {
        _bindLeagueMembers(activeLeagueCycle.value!.cycleId);
      }

      // Refresh joined group details (if any) so group leaderboard updates.
      _refreshJoinedGroupFromGroups();
    } catch (e) {
      Get.log('refreshPostsForUser error: $e');
    }
  }

  @override
  void onClose() {
    try {
      _tts.stop();
    } catch (_) {}
    groupSearchController.dispose();
    _postsSubscription?.cancel();
    _groupsSubscription?.cancel();
    _membershipSubscription?.cancel();
    _leagueTiersSubscription?.cancel();
    _leagueCyclesSubscription?.cancel();
    _leagueMembersSubscription?.cancel();
    // Cancel any leader pending listeners
    try {
      for (final sub in _leaderPendingSubscriptions.values) {
        sub.cancel();
      }
    } catch (_) {}
    _leaderPendingSubscriptions.clear();
    _disposeGroupXpSubscriptions();
    super.onClose();
  }

  // Text-to-speech for pronouncing words in community cards
  final FlutterTts _tts = FlutterTts();

  /// Initializes Text-to-Speech with proper null safety and error handling
  Future<void> _initTts() async {
    try {
      final languages = await _tts.getLanguages;
      if (languages != null && languages.contains('en-US')) {
        await _tts.setLanguage('en-US');
      }
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
    } catch (_) {
      // ignore TTS setup errors
    }
  }

  Future<void> speakWord(String word) async {
    if (word.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _tts.speak(word.trim());
    } catch (e) {
      Get.log('speakWord error: $e');
    }
  }

  List<CommunityStudyGroup> get filteredStudyGroups {
    final query = groupSearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return studyGroups;
    }
    return studyGroups
        .where(
          (group) =>
              group.name.toLowerCase().contains(query) ||
              group.requirement.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  void onStudyGroupSearch(String query) {
    groupSearchQuery.value = query;
  }

  void _bindPosts() {
    _postsSubscription?.cancel();
    _postsSubscription = _firestoreService
        .listenToCommunityPosts(
      visibility: 'public',
      status: 'active',
      limit: 50,
    )
        .listen(
      (postList) => _mapFirestorePosts(postList),
      onError: (error) {
        Get.log('Không thể tải bài viết cộng đồng: $error');
      },
    );
  }

  void _mapFirestorePosts(List<FirestorePost> postList) {
    Future<void>(() async {
      try {
        final mapped = await Future.wait(
          postList.map(_buildCommunityPost),
        );
        posts.assignAll(mapped);
      } catch (e) {
        Get.log('Không thể chuyển đổi bài viết cộng đồng: $e');
      }
    });
  }

  void _bindGroups() {
    _groupsSubscription?.cancel();
    _groupsSubscription =
        _firestoreService.listenToGroups(status: 'active').listen(
      (groupList) => _mapFirestoreGroups(groupList),
      onError: (error) {
        Get.log('Không thể tải danh sách nhóm học tập: $error');
      },
    );
  }

  void _mapFirestoreGroups(List<FirestoreGroup> groupList) {
    Future<void>(() async {
      try {
        final mapped = await Future.wait(
          groupList.map(_buildCommunityGroup),
        );
        studyGroups.assignAll(mapped);
        // If the current user leads one or more groups, bind to their pending
        // member requests so they can accept/reject in-app.
        _updateLeaderPendingSubscriptions();
        _refreshJoinedGroupFromGroups();
      } catch (e) {
        Get.log('Không thể chuyển đổi nhóm học tập: $e');
      }
    });
  }

  void _updateLeaderPendingSubscriptions() {
    // Cancel subscriptions for groups we no longer lead.
    final currentUserId = _resolveUserId();
    final leaderGroupIds = studyGroups
        .where((g) => g.leaderId == currentUserId && g.requireApproval)
        .map((g) => g.groupId)
        .toSet();

    final toRemove = _leaderPendingSubscriptions.keys
        .where((id) => !leaderGroupIds.contains(id))
        .toList(growable: false);
    for (final id in toRemove) {
      _leaderPendingSubscriptions.remove(id)?.cancel();
    }

    // Add subscriptions for new leader groups
    for (final gid in leaderGroupIds) {
      if (_leaderPendingSubscriptions.containsKey(gid)) continue;
      final subscription = _firestoreService
          .listenToGroupMembers(groupId: gid, status: 'pending')
          .listen((members) => _handlePendingMembersUpdate(gid, members),
              onError: (e) =>
                  Get.log('Không thể lắng nghe yêu cầu tham gia nhóm $gid: $e'));
      _leaderPendingSubscriptions[gid] = subscription;
    }
  }

  Future<void> _handlePendingMembersUpdate(
      String groupId, List<FirestoreGroupMember> members) async {
    // Build requests for this group and merge into incomingJoinRequests
    final List<CommunityJoinRequest> groupRequests = [];
    final group = _findGroupById(groupId);
    for (final member in members) {
      try {
        final user = await _getPostAuthor(member.userId);
        final senderName = user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : 'Thành viên SnapLingua';
        groupRequests.add(CommunityJoinRequest(
          groupId: groupId,
          memberId: member.id,
          senderUserId: member.userId,
          groupName: group?.name ?? '',
          leaderName: group?.leaderName ?? '',
          message: member.requestMessage ?? 'Đang chờ trưởng nhóm phê duyệt.',
          senderName: senderName,
        ));
      } catch (e) {
        Get.log('Không thể xử lý yêu cầu tham gia của ${member.userId}: $e');
      }
    }

    // replace existing entries for this group
    final remaining = incomingJoinRequests.where((r) => r.groupId != groupId);
    final merged = <CommunityJoinRequest>[];
    merged.addAll(remaining);
    merged.addAll(groupRequests);
    incomingJoinRequests.assignAll(merged);
  }

  Future<void> approveJoinRequest(String memberId) async {
    try {
      await _firestoreService.updateGroupMemberStatus(
        memberId: memberId,
        status: 'active',
      );
      incomingJoinRequests.removeWhere((r) => r.memberId == memberId);
      Get.snackbar('Đã chấp thuận', 'Đã thêm thành viên vào nhóm.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chấp thuận yêu cầu: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> rejectJoinRequest(String memberId) async {
    try {
      await _firestoreService.deleteGroupMember(memberId);
      incomingJoinRequests.removeWhere((r) => r.memberId == memberId);
      Get.snackbar('Đã từ chối', 'Yêu cầu đã bị từ chối.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể từ chối yêu cầu: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Show a bottom sheet listing pending join requests for a specific group.
  void showPendingJoinRequestsSheet(BuildContext context, String groupId) {
    final group = _findGroupById(groupId);
    if (group == null) return;
    Get.bottomSheet(
      Builder(builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Obx(() {
            final requests = incomingJoinRequests
                .where((r) => r.groupId == groupId)
                .toList(growable: false);
            if (requests.isEmpty) {
              return SizedBox(
                height: 160,
                child: Center(child: Text('Không có yêu cầu nào.')),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: requests.map((r) {
                return ListTile(
                  title: Text(r.senderName),
                  subtitle: Text(r.message),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => approveJoinRequest(r.memberId),
                        child: const Text('Chấp nhận'),
                      ),
                      TextButton(
                        onPressed: () => rejectJoinRequest(r.memberId),
                        child: const Text('Từ chối'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        );
      }),
      isScrollControlled: true,
    );
  }

  void _bindLeagueTiers() {
    _leagueTiersSubscription?.cancel();
    _leagueTiersSubscription = _firestoreService.listenToLeagueTiers().listen(
          (tiers) => _handleLeagueTiers(tiers),
          onError: (error) =>
              Get.log('Không thể tải danh sách giải đấu: $error'),
        );
  }

  void _handleLeagueTiers(List<FirestoreLeagueTier> tiers) {
    final ordered = List<FirestoreLeagueTier>.from(tiers)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    leagueTiers.assignAll(ordered);

    if (ordered.isEmpty) {
      selectedLeagueTier.value = null;
      activeLeagueCycle.value = null;
      _leagueCyclesSubscription?.cancel();
      _leagueMembersSubscription?.cancel();
      currentLeague.value = CommunityLeagueInfo.empty();
      return;
    }

    final FirestoreLeagueTier? currentSelected = selectedLeagueTier.value;
    FirestoreLeagueTier nextTier = ordered.first;
    if (currentSelected != null) {
      final match = _firstWhereOrNull(
        ordered,
        (tier) => tier.tierId == currentSelected.tierId,
      );
      if (match != null) {
        nextTier = match;
      }
    }

    if (selectedLeagueTier.value?.tierId != nextTier.tierId) {
      selectedLeagueTier.value = nextTier;
      _xpBreakdownCache.clear();
      _bindLeagueCycles(nextTier.tierId);
    } else {
      _bindLeagueCycles(nextTier.tierId, preserveCycle: true);
    }
  }

  void _bindLeagueCycles(String tierId, {bool preserveCycle = false}) {
    _leagueCyclesSubscription?.cancel();
    _leagueCyclesSubscription = _firestoreService
        .listenToLeagueCycles(tierId: tierId)
        .listen(
          (cycles) => _handleLeagueCycles(cycles, preserveCycle: preserveCycle),
          onError: (error) => Get.log('Không thể tải chu kỳ giải đấu: $error'),
        );
  }

  void _handleLeagueCycles(
    List<FirestoreLeagueCycle> cycles, {
    bool preserveCycle = false,
  }) {
    if (cycles.isEmpty) {
      activeLeagueCycle.value = null;
      _leagueMembersSubscription?.cancel();
      currentLeague.value = CommunityLeagueInfo.empty();
      return;
    }

    FirestoreLeagueCycle? nextCycle;
    nextCycle = _firstWhereOrNull(cycles, (cycle) => cycle.status == 'running');

    final currentCycleId = activeLeagueCycle.value?.cycleId;
    if (preserveCycle &&
        currentCycleId != null &&
        cycles.any((cycle) => cycle.cycleId == currentCycleId)) {
      nextCycle = _firstWhereOrNull(
            cycles,
            (cycle) => cycle.cycleId == currentCycleId,
          ) ??
          nextCycle;
    }

    final previousCycleId = currentCycleId;
    final FirestoreLeagueCycle resolvedCycle = nextCycle ?? cycles.first;
    activeLeagueCycle.value = resolvedCycle;

    if (previousCycleId != resolvedCycle.cycleId) {
      _xpBreakdownCache.clear();
      _bindLeagueMembers(resolvedCycle.cycleId);
    } else {
      // Refresh countdown if cycle unchanged but metadata updated.
      _updateLeagueMetaWithoutMembers();
    }
  }

  void _bindLeagueMembers(String cycleId) {
    _leagueMembersSubscription?.cancel();
    _leagueMembersSubscription = _firestoreService
        .listenToLeagueMembers(cycleId: cycleId)
        .listen(
          (members) => _mapLeagueMembers(members),
          onError: (error) => Get.log('Không thể tải bảng xếp hạng: $error'),
        );
  }

  void _mapLeagueMembers(List<FirestoreLeagueMember> members) {
    Future<void>(() async {
      try {
        final tier = selectedLeagueTier.value;
        final cycle = activeLeagueCycle.value;
        if (tier == null || cycle == null) {
          currentLeague.value = CommunityLeagueInfo.empty();
          return;
        }

        final _LeagueRuleSet ruleSet = _parseLeagueRule(tier.xpCapRule);

        // Optimize: Parallelize async operations for better performance
        final List<Future<_LeagueParticipantData?>> participantFutures =
            members.map((member) => _buildParticipantData(member, cycle, ruleSet))
                   .toList();

        final rawParticipantsResults = await Future.wait(participantFutures);
        final List<_LeagueParticipantData> rawParticipants = rawParticipantsResults
            .where((participant) => participant != null)
            .cast<_LeagueParticipantData>()
            .toList();

      } catch (e) {
        Get.log('Error mapping league members: $e');
        currentLeague.value = CommunityLeagueInfo.empty();
        return;
      }

      rawParticipants.sort((a, b) {
        final xpCompare = b.cappedXp.compareTo(a.cappedXp);
        if (xpCompare != 0) return xpCompare;
        final rawCompare = b.rawXp.compareTo(a.rawXp);
        if (rawCompare != 0) return rawCompare;
        final rankA = a.member.rank ?? 999;
        final rankB = b.member.rank ?? 999;
        return rankA.compareTo(rankB);
      });

      final List<CommunityLeaderboardParticipant> participants = [];
      for (var index = 0; index < rawParticipants.length; index++) {
        final data = rawParticipants[index];
        final rank = index + 1;
        final FirestoreUser? user = data.user;
        final String displayName = user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : 'Người học SnapLingua';
        final String avatar = _normalizeAvatar(user?.avatarUrl) ??
            'https://i.pravatar.cc/150?u=${data.member.userId.hashCode}';
        final int streakDays = data.activityDays > 0
            ? data.activityDays
            : math.max(1, data.member.rank ?? 1);

        participants.add(
          CommunityLeaderboardParticipant(
            rank: rank,
            userId: data.member.userId,
            name: displayName,
            totalPoints: data.cappedXp,
            weeklyPoints: streakDays,
            avatarUrl: avatar,
            status: CommunityLeaderboardStatus.safe,
            xpBreakdown: data.xpBreakdown,
            rawPoints: data.rawXp,
            isVirtual: false,
          ),
        );
      }

      final int desiredCount = ruleSet.desiredParticipants;
      final int deficit = desiredCount - participants.length;
      if (deficit > 0) {
        final virtuals = _generateVirtualParticipants(
          count: deficit,
          tier: tier,
          cycle: cycle,
          ruleSet: ruleSet,
        );
        participants.addAll(virtuals);
      }

      participants.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      final int promotionCount =
          math.min(ruleSet.promotionCount, participants.length);
      final int demotionCount = math.min(
        ruleSet.demotionCount,
        math.max(0, participants.length - promotionCount),
      );

      for (var index = 0; index < participants.length; index++) {
        final rank = index + 1;
        final CommunityLeaderboardStatus status;
        if (index < promotionCount) {
          status = CommunityLeaderboardStatus.promotion;
        } else if (index >= participants.length - demotionCount) {
          status = CommunityLeaderboardStatus.demotion;
        } else {
          status = CommunityLeaderboardStatus.safe;
        }
        participants[index] = participants[index].copyWith(
          rank: rank,
          status: status,
        );
      }

      final int safeThreshold =
          math.max(0, participants.length - demotionCount);
      currentLeague.value = CommunityLeagueInfo(
        tierId: tier.tierId,
        name: tier.name,
        daysRemaining: _computeDaysRemaining(cycle.endAt),
        rankIcon: _rankIconForTier(tier),
        promotionCount: promotionCount,
        safeThreshold: safeThreshold,
        demotionCount: demotionCount,
        participants: participants,
        xpCapDescription: _formatXpCapDescription(ruleSet.xpCaps),
        desiredParticipants: desiredCount,
      );
    });
  }

  void _updateLeagueMetaWithoutMembers() {
    final tier = selectedLeagueTier.value;
    final cycle = activeLeagueCycle.value;
    if (tier == null || cycle == null) {
      return;
    }
    final info = currentLeague.value;
    currentLeague.value = CommunityLeagueInfo(
      tierId: tier.tierId,
      name: tier.name,
      daysRemaining: _computeDaysRemaining(cycle.endAt),
      rankIcon: _rankIconForTier(tier),
      promotionCount: info.promotionCount,
      safeThreshold: info.safeThreshold,
      demotionCount: info.demotionCount,
      participants: info.participants,
      xpCapDescription: info.xpCapDescription,
      desiredParticipants: info.desiredParticipants,
    );
  }

  /// Helper method to build participant data with parallel async operations
  Future<_LeagueParticipantData?> _buildParticipantData(
    FirestoreLeagueMember member,
    FirestoreLeagueCycle cycle,
    _LeagueRuleSet ruleSet,
  ) async {
    try {
      final cacheKey = '${member.userId}:${cycle.cycleId}';

      // Fetch XP breakdown and user data in parallel
      final futures = await Future.wait([
        _getXpBreakdown(cacheKey, member.userId, cycle),
        _getPostAuthor(member.userId),
      ]);

      final UserXpBreakdown breakdown = futures[0] as UserXpBreakdown;
      final FirestoreUser? user = futures[1] as FirestoreUser?;

      final cappedXp = _applyXpCap(ruleSet, breakdown, member.weeklyXp);

      return _LeagueParticipantData(
        member: member,
        user: user,
        cappedXp: cappedXp,
        rawXp: member.weeklyXp,
        xpBreakdown: Map<String, int>.from(breakdown.bySource),
        activityDays: breakdown.activeDays,
      );
    } catch (e) {
      Get.log('Error building participant data for ${member.userId}: $e');
      return null;
    }
  }

  /// Helper method to get XP breakdown with caching
  Future<UserXpBreakdown> _getXpBreakdown(
    String cacheKey,
    String userId,
    FirestoreLeagueCycle cycle,
  ) async {
    final cached = _xpBreakdownCache[cacheKey];
    if (cached != null) return cached;

    final breakdown = await _firestoreService.getUserXpBreakdown(
      userId: userId,
      startAt: cycle.startAt,
      endAt: cycle.endAt,
    );

    // Enforce cache size limit
    if (_xpBreakdownCache.length >= _maxXpBreakdownCacheSize) {
      _cleanupXpBreakdownCache();
    }
    _xpBreakdownCache[cacheKey] = breakdown;
    return breakdown;
  }

  /// Clean up cache to prevent memory leaks
  void _cleanupUserCache() {
    if (_userCache.length > _maxUserCacheSize) {
      final keysToRemove = _userCache.keys.take(_userCache.length - _maxUserCacheSize);
      for (final key in keysToRemove) {
        _userCache.remove(key);
      }
    }
  }

  void _cleanupXpBreakdownCache() {
    if (_xpBreakdownCache.length > _maxXpBreakdownCacheSize) {
      final keysToRemove = _xpBreakdownCache.keys.take(_xpBreakdownCache.length - _maxXpBreakdownCacheSize);
      for (final key in keysToRemove) {
        _xpBreakdownCache.remove(key);
      }
    }
  }

  void _cleanupPhotoCache() {
    if (_photoCache.length > _maxPhotoCacheSize) {
      final keysToRemove = _photoCache.keys.take(_photoCache.length - _maxPhotoCacheSize);
      for (final key in keysToRemove) {
        _photoCache.remove(key);
      }
    }
  }

  int _applyXpCap(
    _LeagueRuleSet ruleSet,
    UserXpBreakdown breakdown,
    int fallback,
  ) {
    if (ruleSet.xpCaps.isEmpty) {
      return breakdown.total > 0 ? breakdown.total : fallback;
    }
    int total = 0;
    breakdown.bySource.forEach((source, amount) {
      if (amount <= 0) return;
      final cap = ruleSet.xpCaps[source];
      total += cap != null ? math.min(amount, cap) : amount;
    });
    if (total == 0) {
      return fallback;
    }
    return total;
  }

  _LeagueRuleSet _parseLeagueRule(String? rule) {
    const int defaultPromotion = 3;
    const int defaultDemotion = 3;
    const int defaultParticipants = 20;

    Map<String, int> caps = {};
    int promotion = defaultPromotion;
    int demotion = defaultDemotion;
    int participantsTarget = defaultParticipants;

    if (rule != null && rule.trim().isNotEmpty) {
      final trimmed = rule.trim();
      bool parsed = false;
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          final xpCapRaw = decoded['xpCap'];
          if (xpCapRaw is Map) {
            caps = xpCapRaw.map(
              (key, value) => MapEntry(
                key.toString(),
                (value as num?)?.toInt() ?? 0,
              ),
            )..removeWhere((_, value) => value <= 0);
          }
          promotion = (decoded['promotion'] as num?)?.toInt() ?? promotion;
          demotion = (decoded['demotion'] as num?)?.toInt() ?? demotion;
          participantsTarget =
              (decoded['participants'] as num?)?.toInt() ?? participantsTarget;
          parsed = true;
        }
      } catch (_) {
        parsed = false;
      }

      if (!parsed) {
        final parts = trimmed.split('|');
        for (final raw in parts) {
          final entry = raw.trim();
          if (entry.isEmpty) continue;
          if (entry.startsWith('xpCap')) {
            final eqIndex = entry.indexOf(':');
            final capsPart =
                eqIndex >= 0 ? entry.substring(eqIndex + 1) : entry;
            final capItems = capsPart.split(',');
            for (final item in capItems) {
              final kv = item.split('=');
              if (kv.length != 2) continue;
              final key = kv[0].trim();
              final value = int.tryParse(kv[1].trim());
              if (key.isNotEmpty && value != null && value > 0) {
                caps[key] = value;
              }
            }
          } else {
            final kv = entry.split('=');
            if (kv.length != 2) continue;
            final key = kv[0].trim().toLowerCase();
            final value = int.tryParse(kv[1].trim());
            if (value == null) continue;
            switch (key) {
              case 'promotion':
                promotion = value;
                break;
              case 'demotion':
                demotion = value;
                break;
              case 'participants':
                participantsTarget = value;
                break;
            }
          }
        }
      }
    }

    promotion = promotion <= 0 ? defaultPromotion : promotion;
    participantsTarget =
        participantsTarget <= 0 ? defaultParticipants : participantsTarget;
    demotion = demotion < 0 ? 0 : demotion;
    if (promotion + demotion > participantsTarget) {
      demotion = math.max(0, participantsTarget - promotion);
    }

    final safe = participantsTarget - demotion;

    caps.removeWhere((_, value) => value <= 0);

    return _LeagueRuleSet(
      xpCaps: caps,
      promotionCount: promotion,
      demotionCount: demotion,
      safeThreshold: safe,
      desiredParticipants: participantsTarget,
    );
  }

  int _computeDaysRemaining(DateTime endAt) {
    final now = DateTime.now();
    if (!endAt.isAfter(now)) {
      return 0;
    }
    final diff = endAt.difference(now).inDays;
    return diff.clamp(0, 7);
  }

  String _rankIconForTier(FirestoreLeagueTier tier) {
    if (_leagueRankIcons.isEmpty) {
      return 'assets/images/rank/rank6.png';
    }
    final index = tier.orderIndex.clamp(0, _leagueRankIcons.length - 1);
    return _leagueRankIcons[index];
  }

  String? _formatXpCapDescription(Map<String, int> xpCaps) {
    if (xpCaps.isEmpty) {
      return null;
    }
    final entries = xpCaps.entries
        .map((entry) =>
            '${_localizeSourceLabel(entry.key)} ≤ ${entry.value.toString()} XP')
        .toList(growable: false);
    return entries.join(' • ');
  }

  String _localizeSourceLabel(String source) {
    switch (source) {
      case 'lesson':
        return 'Bài học';
      case 'review':
        return 'Ôn tập';
      case 'challenge':
        return 'Thử thách';
      case 'quest':
        return 'Nhiệm vụ';
      case 'speaking':
        return 'Nói';
      default:
        return source;
    }
  }

  List<CommunityLeaderboardParticipant> _generateVirtualParticipants({
    required int count,
    required FirestoreLeagueTier tier,
    required FirestoreLeagueCycle cycle,
    required _LeagueRuleSet ruleSet,
  }) {
    if (count <= 0) {
      return const [];
    }
    final random = math.Random(tier.tierId.hashCode ^ cycle.cycleId.hashCode);
    final List<CommunityLeaderboardParticipant> results = [];

    for (var i = 0; i < count; i++) {
      final name =
          _virtualNames[(i + tier.orderIndex * 5) % _virtualNames.length];
      final Map<String, int> xpBreakdown = {};
      int totalXp = 0;

      if (ruleSet.xpCaps.isEmpty) {
        final base = math.max(400, 900 - (i * 35) + random.nextInt(60));
        final lessonXp = math.max(120, (base * 0.55).round());
        final reviewXp = math.max(70, (base * 0.25).round());
        final challengeXp = math.max(40, base - lessonXp - reviewXp);
        xpBreakdown['lesson'] = lessonXp;
        xpBreakdown['review'] = reviewXp;
        xpBreakdown['challenge'] = challengeXp;
        totalXp = lessonXp + reviewXp + challengeXp;
      } else {
        for (final entry in ruleSet.xpCaps.entries) {
          final variance = 0.55 + (random.nextDouble() * 0.35);
          final cappedValue =
              math.min(entry.value, (entry.value * variance).round());
          final value = math.max(30, cappedValue);
          xpBreakdown[entry.key] = value;
        }
        totalXp = xpBreakdown.values.fold<int>(0, (sum, value) => sum + value);
        if (totalXp == 0) {
          totalXp = math.max(200, 600 - (i * 25));
        }
      }

      final streak = math.max(2, math.min(7, 2 + random.nextInt(6)));
      final avatarIndex =
          (i + tier.orderIndex * 11 + cycle.cycleId.hashCode) % 70;

      results.add(
        CommunityLeaderboardParticipant(
          rank: 0,
          userId: 'virtual_${tier.tierId}_${cycle.cycleId}_$i',
          name: name,
          totalPoints: totalXp,
          weeklyPoints: streak,
          avatarUrl: 'https://i.pravatar.cc/150?img=${avatarIndex + 1}',
          status: CommunityLeaderboardStatus.safe,
          xpBreakdown: xpBreakdown,
          rawPoints: totalXp,
          isVirtual: true,
        ),
      );
    }

    return results;
  }

  Future<CommunityStudyGroup> _buildCommunityGroup(FirestoreGroup group) async {
    final FirestoreUser? leader = await _getPostAuthor(group.createdBy);
    final String leaderName = leader?.displayName?.trim().isNotEmpty == true
        ? leader!.displayName!.trim()
        : 'Thành viên SnapLingua';
    final requirement = group.description?.trim().isNotEmpty == true
        ? group.description!.trim()
        : 'Chưa có mô tả';
    final assetImage = group.iconPath?.trim().isNotEmpty == true
        ? group.iconPath!.trim()
        : _resolveGroupAsset(group.groupId);
    return CommunityStudyGroup(
      groupId: group.groupId,
      name: group.name,
      requirement: requirement,
      memberCount: group.memberCount,
      assetImage: assetImage,
      leaderId: group.createdBy,
      leaderName: leaderName,
      requireApproval: group.requireApproval,
      description: group.description,
      status: group.status,
      createdAt: group.createdAt,
    );
  }

  void _bindUserMemberships() {
    _membershipSubscription?.cancel();
    final userId = _resolveUserId();
    pendingJoinRequests.clear();
    if (userId == _fallbackUserId) {
      _activeMembership = null;
      joinedGroupDetails.value = null;
      return;
    }
    _membershipSubscription =
        _firestoreService.listenToUserGroups(userId: userId).listen(
              (memberships) => _handleMemberships(memberships),
              onError: (error) =>
                  Get.log('Không thể tải thông tin thành viên nhóm: $error'),
            );
  }

  void _handleMemberships(List<FirestoreGroupMember> memberships) {
    Future<void>(() async {
      final sorted = List<FirestoreGroupMember>.from(memberships)
        ..sort((a, b) => b.joinedAt.compareTo(a.joinedAt));

      final pending = sorted.where((member) => member.status == 'pending');
      if (pending.isNotEmpty) {
        final List<CommunityJoinRequest> requests = [];
        for (final member in pending) {
          final group = _findGroupById(member.groupId);
          if (group != null) {
            requests.add(
              CommunityJoinRequest(
                groupId: member.groupId,
                memberId: member.id,
                senderUserId: member.userId,
                groupName: group.name,
                leaderName: group.leaderName,
                message:
                    member.requestMessage ?? 'Đang chờ trưởng nhóm phê duyệt.',
                senderName: 'Bạn',
              ),
            );
          }
        }
        pendingJoinRequests.assignAll(requests);
      } else {
        pendingJoinRequests.clear();
      }

      final activeMembership =
          _firstWhereOrNull(sorted, (member) => member.status == 'active');
      if (activeMembership == null) {
        _disposeGroupXpSubscriptions();
        _activeMembership = null;
        joinedGroupDetails.value = null;
        return;
      }

      if (_activeMembership?.id == activeMembership.id) {
        _refreshJoinedGroupFromGroups();
        return;
      }

      _disposeGroupXpSubscriptions();
      _activeMembership = activeMembership;
      final existing = _findGroupById(activeMembership.groupId);
      if (existing != null) {
        joinedGroupDetails.value =
            await _buildGroupDetailsFromFirestore(existing);
        return;
      }
      final FirestoreGroup? fetchedGroup =
          await _firestoreService.getGroupById(activeMembership.groupId);
      if (fetchedGroup == null) {
        return;
      }
      final mapped = await _buildCommunityGroup(fetchedGroup);
      studyGroups.add(mapped);
      joinedGroupDetails.value = await _buildGroupDetailsFromFirestore(mapped);
    });
  }

  Future<CommunityGroupDetails> _buildGroupDetailsFromFirestore(
    CommunityStudyGroup group,
  ) async {
    final List<FirestoreGroupMember> members = await _firestoreService
        .getGroupMembers(groupId: group.groupId, status: 'active');
    members.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

    CommunityStudyGroup updatedGroup = group;
    if (group.memberCount != members.length) {
      updatedGroup = group.copyWith(memberCount: members.length);
      _updateGroupInList(updatedGroup);
    }

    final String currentUserId = _resolveUserId();
    final _GroupCycleWindow cycleWindow =
        _resolveGroupCycleWindow(updatedGroup.createdAt);
    final List<_PendingGroupMemberScore> pendingScores = [];
    final Map<String, int> initialTotals = {};

    for (final member in members) {
      final FirestoreUser? user = await _getPostAuthor(member.userId);
      final displayName = user?.displayName?.trim().isNotEmpty == true
          ? user!.displayName!.trim()
          : 'Thành viên SnapLingua';
      final avatarUrl = _normalizeAvatar(user?.avatarUrl) ??
          'https://i.pravatar.cc/150?u=${member.userId.hashCode}';

      int totalXp = 0;
      try {
        final breakdown = await _firestoreService.getUserXpBreakdown(
          userId: member.userId,
          startAt: cycleWindow.startAt,
          endAt: cycleWindow.endAt,
        );
        totalXp = breakdown.total;
      } catch (error) {
        Get.log('Không thể lấy XP cho thành viên ${member.userId}: $error');
      }
      if (totalXp <= 0 && (user?.scalesBalance ?? 0) > 0) {
        totalXp = user!.scalesBalance;
      }

      initialTotals[member.userId] = totalXp;
      pendingScores.add(
        _PendingGroupMemberScore(
          userId: member.userId,
          displayName: displayName,
          avatarUrl: avatarUrl,
          totalXp: totalXp,
          weeklyXp: totalXp,
          isHighlighted: member.userId == currentUserId,
          joinedAt: member.joinedAt,
        ),
      );
    }

    _bindGroupXpListeners(
      group: updatedGroup,
      members: members,
      cycleWindow: cycleWindow,
      initialTotals: initialTotals,
    );

    pendingScores.sort((a, b) {
      final xpCompare = b.totalXp.compareTo(a.totalXp);
      if (xpCompare != 0) return xpCompare;
      return a.joinedAt.compareTo(b.joinedAt);
    });

    final List<CommunityGroupMemberScore> memberScores = [];
    for (var index = 0; index < pendingScores.length; index++) {
      final pending = pendingScores[index];
      memberScores.add(
        CommunityGroupMemberScore(
          rank: index + 1,
          userId: pending.userId,
          displayName: pending.displayName,
          totalPoints: pending.totalXp,
          weeklyPoints: pending.weeklyXp,
          avatarUrl: pending.avatarUrl,
          isHighlighted: pending.isHighlighted,
        ),
      );
    }

    final int rawPoints =
        memberScores.fold<int>(0, (sum, score) => sum + score.totalPoints);
    final int currentPoints = rawPoints;
    final milestones = _buildMilestones(currentPoints);
    final currentMilestoneLabel = _resolveCurrentMilestoneLabel(milestones);
    final daysRemaining = _estimateDaysRemaining(updatedGroup.createdAt);

    return CommunityGroupDetails(
      group: updatedGroup,
      currentMilestoneLabel: currentMilestoneLabel,
      daysRemaining: daysRemaining,
      currentPoints: currentPoints,
      milestones: milestones,
      memberScores: memberScores,
    );
  }

  void _bindGroupXpListeners({
    required CommunityStudyGroup group,
    required List<FirestoreGroupMember> members,
    required _GroupCycleWindow cycleWindow,
    required Map<String, int> initialTotals,
  }) {
    final bool groupChanged = _activeGroupXpId != group.groupId;
    final bool windowChanged =
        _activeGroupCycleWindow?.startAt != cycleWindow.startAt;
    if (groupChanged || windowChanged) {
      _disposeGroupXpSubscriptions();
      _activeGroupXpId = group.groupId;
      _activeGroupCycleWindow = cycleWindow;
    } else {
      _activeGroupCycleWindow = cycleWindow;
    }

    final Set<String> memberIds =
        members.map((member) => member.userId).toSet();
    final List<String> toRemove = _groupXpSubscriptions.keys
        .where((id) => !memberIds.contains(id))
        .toList(growable: false);
    for (final userId in toRemove) {
      _groupXpSubscriptions.remove(userId)?.cancel();
      _groupXpTotals.remove(userId);
    }

    for (final member in members) {
      final String userId = member.userId;
      final int? initialTotal = initialTotals[userId];
      if (initialTotal != null) {
        _groupXpTotals[userId] = initialTotal;
      } else {
        _groupXpTotals.putIfAbsent(userId, () => 0);
      }

      if (_groupXpSubscriptions.containsKey(userId)) {
        continue;
      }

      final subscription = _firestoreService
          .listenToUserXpTransactions(
            userId: userId,
            startAt: cycleWindow.startAt,
          )
          .listen(
        (transactions) => _handleGroupMemberTransactionsUpdate(
          group.groupId,
          userId,
          transactions,
        ),
        onError: (error) => Get.log(
          'Không thể lắng nghe XP của thành viên $userId: $error',
        ),
      );
      _groupXpSubscriptions[userId] = subscription;
    }
  }

  void _handleGroupMemberTransactionsUpdate(
    String groupId,
    String userId,
    List<FirestoreXpTransaction> transactions,
  ) {
    if (_activeGroupXpId != groupId) {
      return;
    }
    final _GroupCycleWindow? window = _activeGroupCycleWindow;
    if (window == null) {
      return;
    }

    int total = 0;
    for (final tx in transactions) {
      if (tx.amount <= 0) continue;
      if (tx.createdAt.isBefore(window.startAt)) continue;
      total += tx.amount;
    }

    final int? previous = _groupXpTotals[userId];
    if (previous != null && previous == total) {
      return;
    }
    _groupXpTotals[userId] = total;
    _refreshJoinedGroupFromGroups();
  }

  List<CommunityGroupMilestone> _buildMilestones(int points) {
    return _milestoneDefinitions
        .map(
          (entry) => CommunityGroupMilestone(
            label: entry.key,
            requiredPoints: entry.value,
            isReached: points >= entry.value,
          ),
        )
        .toList(growable: false);
  }

  String _resolveCurrentMilestoneLabel(
      List<CommunityGroupMilestone> milestones) {
    CommunityGroupMilestone? latestReached;
    for (final milestone in milestones) {
      if (milestone.isReached) {
        latestReached = milestone;
      } else {
        break;
      }
    }
    if (latestReached != null) {
      return latestReached.label;
    }
    return milestones.isNotEmpty ? milestones.first.label : 'Mốc đầu tiên';
  }

  int _estimateDaysRemaining(DateTime createdAt) {
    const int cycleLength = 7;
    final int elapsed = DateTime.now().difference(createdAt).inDays;
    final int remaining = cycleLength - (elapsed % cycleLength);
    if (remaining <= 0) {
      return cycleLength;
    }
    return remaining;
  }

  _GroupCycleWindow _resolveGroupCycleWindow(DateTime createdAt) {
    const int cycleLengthDays = 7;
    final DateTime now = DateTime.now();
    final DateTime startOfCreatedDay =
        DateTime(createdAt.year, createdAt.month, createdAt.day);
    int elapsedDays = now.difference(startOfCreatedDay).inDays;
    if (elapsedDays < 0) {
      elapsedDays = 0;
    }
    final int cycleIndex = elapsedDays ~/ cycleLengthDays;
    DateTime startAt =
        startOfCreatedDay.add(Duration(days: cycleIndex * cycleLengthDays));
    if (startAt.isAfter(now)) {
      startAt = startAt.subtract(const Duration(days: cycleLengthDays));
    }
    DateTime endAt = startAt.add(const Duration(days: cycleLengthDays));
    if (endAt.isAfter(now)) {
      endAt = now;
    }
    if (!endAt.isAfter(startAt)) {
      endAt = startAt.add(const Duration(minutes: 1));
    }
    return _GroupCycleWindow(startAt: startAt, endAt: endAt);
  }

  void _refreshJoinedGroupFromGroups() {
    final membership = _activeMembership;
    if (membership == null) {
      return;
    }
    final group = _findGroupById(membership.groupId);
    if (group == null) {
      return;
    }
    Future<void>(() async {
      joinedGroupDetails.value = await _buildGroupDetailsFromFirestore(group);
    });
  }

  void _disposeGroupXpSubscriptions() {
    for (final subscription in _groupXpSubscriptions.values) {
      subscription.cancel();
    }
    _groupXpSubscriptions.clear();
    _groupXpTotals.clear();
    _activeGroupCycleWindow = null;
    _activeGroupXpId = null;
  }

  CommunityStudyGroup? _findGroupById(String groupId) {
    for (final group in studyGroups) {
      if (group.groupId == groupId) {
        return group;
      }
    }
    return null;
  }

  void _updateGroupInList(CommunityStudyGroup updatedGroup) {
    final index = studyGroups
        .indexWhere((element) => element.groupId == updatedGroup.groupId);
    if (index >= 0) {
      studyGroups[index] = updatedGroup;
    }
  }

  String _resolveGroupAsset(String groupId) {
    if (_groupIconAssets.isEmpty) {
      return 'assets/images/nhom/nhom1.png';
    }
    final index = groupId.hashCode.abs() % _groupIconAssets.length;
    return _groupIconAssets[index];
  }

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T element) test) {
    for (final element in items) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  Future<CommunityPost> _buildCommunityPost(FirestorePost post) async {
    final List<FirestorePostWord> words =
        await _firestoreService.getPostWords(post.postId);
    final List<FirestorePostLike> likes =
        await _firestoreService.getPostLikes(post.postId);
    final List<FirestorePostComment> comments =
        await _firestoreService.getPostComments(
      post.postId,
      status: 'active',
      limit: 20,
    );

    final FirestoreUser? author = await _getPostAuthor(post.userId);
    final String currentUserId = _resolveUserId();
    final bool hasLiked = currentUserId != _fallbackUserId &&
        likes.any((like) => like.userId == currentUserId);

    final List<CommunityVocabularyItem> vocabularyItems = words.map((word) {
  final raw = word.meaningSnapshot.trim();
      // meaningSnapshot is stored as either "headword" or "headword - translation".
      // Parse into headword (english) and translation (vietnamese).
      String head = raw;
      String translation = '';
      // Use the first occurrence of ' - ' as separator (created in addUserPost).
      final sep = ' - ';
      final idx = raw.indexOf(sep);
      if (idx != -1) {
        head = raw.substring(0, idx).trim();
        translation = raw.substring(idx + sep.length).trim();
      }

      return CommunityVocabularyItem(
        label: raw.isNotEmpty ? raw : head,
        confidence: 1.0,
        headword: head,
        phonetic: word.exampleSnapshot ?? '',
        translation: translation,
      );
    }).toList(growable: false);

    final List<String> commentMessages = comments
        .where(
          (comment) =>
              comment.commentType == 'text' &&
              (comment.content != null && comment.content!.trim().isNotEmpty),
        )
        .map((comment) => comment.content!.trim())
        .toList(growable: false);

    String imageUrl = post.photoUrl;
    String? photoId = post.photoId;
    if (photoId != null && photoId.isNotEmpty) {
      final photo = await _getPhotoById(photoId);
      if (photo != null && photo.imageUrl.isNotEmpty) {
        imageUrl = photo.imageUrl;
      }
    }

    // Determine follow functionality based on author and current user
    final bool canFollowAuthor = currentUserId != _fallbackUserId &&
        post.userId != currentUserId &&
        post.userId.isNotEmpty;
    final bool isFollowingAuthor = false; // TODO: Check actual follow status from service

    return CommunityPost(
      id: post.postId,
      authorId: post.userId,
      authorName: author?.displayName?.trim().isNotEmpty == true
          ? author!.displayName!
          : 'Người học SnapLingua',
      authorAvatar: _normalizeAvatar(
            author?.avatarUrl,
          ) ??
          'https://i.pravatar.cc/150?u=${post.userId.hashCode}',
      postedAt: _formatRelativeTime(post.createdAt),
      imageUrl: imageUrl,
      photoId: photoId,
      vocabularyItems: vocabularyItems,
      likes: likes.length,
      comments: commentMessages.length,
      bookmarks: 0,
      isLiked: hasLiked,
      initialComments: commentMessages,
      canFollowAuthor: canFollowAuthor,
      isFollowingAuthor: isFollowingAuthor,
      isFollowActionPending: false,
    );
  }

  Future<FirestoreUser?> _getPostAuthor(String userId) async {
    if (userId.isEmpty) {
      return null;
    }
    final cached = _userCache[userId];
    if (cached != null) {
      return cached;
    }
    try {
      final user = await _firestoreService.getUserById(userId);
      if (user != null) {
        // Enforce cache size limit
        if (_userCache.length >= _maxUserCacheSize) {
          _cleanupUserCache();
        }
        _userCache[userId] = user;
      }
      return user;
    } catch (e) {
      Get.log('Không thể tải thông tin người dùng $userId: $e');
      return null;
    }
  }

  Future<FirestorePhoto?> _getPhotoById(String photoId) async {
    if (photoId.isEmpty) return null;
    final cached = _photoCache[photoId];
    if (cached != null) {
      return cached;
    }
    try {
      final photo = await _firestoreService.getPhotoById(photoId);
      if (photo != null) {
        // Enforce cache size limit
        if (_photoCache.length >= _maxPhotoCacheSize) {
          _cleanupPhotoCache();
        }
        _photoCache[photoId] = photo;
      }
      return photo;
    } catch (e) {
      Get.log('Không thể tải ảnh $photoId: $e');
      return null;
    }
  }

  String _formatRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    if (createdAt.isAfter(now)) {
      return 'Vừa xong';
    }
    final difference = now.difference(createdAt);
    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    }
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? '1 phút trước' : '$minutes phút trước';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1 ? '1 giờ trước' : '$hours giờ trước';
    }
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1 ? '1 ngày trước' : '$days ngày trước';
    }
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks <= 1 ? '1 tuần trước' : '$weeks tuần trước';
    }
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months <= 1 ? '1 tháng trước' : '$months tháng trước';
    }
    final years = (difference.inDays / 365).floor();
    return years <= 1 ? '1 năm trước' : '$years năm trước';
  }

  Future<void> onCreateGroup() async {
    final result = await Get.toNamed(
      Routes.communityCreateGroup,
    );
    if (result is CommunityStudyGroup) {
      addStudyGroup(result);
    }
  }

  void addStudyGroup(CommunityStudyGroup group) {
    studyGroups.insert(0, group);
  }

  Future<void> joinGroup(CommunityStudyGroup group) async {
    // Input validation
    if (group.groupId.trim().isEmpty || group.name.trim().isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Thông tin nhóm không hợp lệ.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final userId = _resolveUserId();
    if (userId == _fallbackUserId) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để tham gia nhóm học tập.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Prevent self-join for group leaders
    if (group.leaderId == userId) {
      Get.snackbar(
        'Không thể tham gia',
        'Bạn là trưởng nhóm của "${group.name}".',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final existing = await _firestoreService.getGroupMembership(
        groupId: group.groupId,
        userId: userId,
      );
      final status = group.requireApproval ? 'pending' : 'active';
      if (existing != null) {
        if (existing.status == 'active') {
          Get.snackbar(
            'Đã tham gia',
            'Bạn đã là thành viên của "${group.name}".',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        if (existing.status == 'pending') {
          Get.snackbar(
            'Đang chờ phê duyệt',
            'Bạn đã gửi yêu cầu tham gia "${group.name}".',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        await _firestoreService.updateGroupMemberStatus(
          memberId: existing.id,
          status: status,
          requestMessage:
              status == 'pending' ? 'Đang chờ trưởng nhóm phê duyệt.' : null,
        );
      } else {
        await _firestoreService.createGroupMembership(
          groupId: group.groupId,
          userId: userId,
          role: group.leaderId == userId ? 'leader' : 'member',
          status: status,
          requestMessage:
              status == 'pending' ? 'Đang chờ trưởng nhóm phê duyệt.' : null,
        );
      }

      if (status == 'active') {
        Get.snackbar(
          'Tham gia thành công',
          'Bạn đã tham gia "${group.name}".',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // attempt to find the membership doc we just created so we can include
        // the member id for leader actions; fall back to empty id if not yet available
        String memberId = '';
        try {
          final membership = await _firestoreService.getGroupMembership(
            groupId: group.groupId,
            userId: userId,
          );
          memberId = membership?.id ?? '';
        } catch (_) {
          memberId = '';
        }
        pendingJoinRequests.add(
          CommunityJoinRequest(
            groupId: group.groupId,
            memberId: memberId,
            senderUserId: userId,
            groupName: group.name,
            leaderName: group.leaderName,
            message: 'Đang chờ trưởng nhóm phê duyệt.',
            senderName: 'Bạn',
          ),
        );
        Get.snackbar(
          'Đã gửi yêu cầu',
          'Yêu cầu tham gia "${group.name}" đang chờ phê duyệt.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể tham gia nhóm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void openGroupMemberProfile(CommunityGroupMemberScore member) {
    final args = _buildMemberProfileArguments(
      name: member.displayName,
      avatar: member.avatarUrl,
      experience: member.totalPoints,
      streak: member.weeklyPoints,
      groupName: joinedGroupDetails.value?.group.name,
      userId: member.userId,
    );
    Get.toNamed(Routes.communityMemberProfile, arguments: args);
  }

  void openLeaderboardProfile(CommunityLeaderboardParticipant participant) {
    final args = _buildMemberProfileArguments(
      name: participant.name,
      avatar: participant.avatarUrl,
      experience: participant.totalPoints,
      streak: participant.weeklyPoints,
      groupName: currentLeague.value.name,
      userId: participant.userId,
      xpBreakdown: participant.xpBreakdown,
      leagueTier: currentLeague.value.name,
      weeklyXp: participant.totalPoints,
      isVirtual: participant.isVirtual,
    );
    Get.toNamed(Routes.communityMemberProfile, arguments: args);
  }

  void openStudyGroupLeaderProfile(CommunityStudyGroup group) {
    final args = _buildMemberProfileArguments(
      name: group.leaderName,
      avatar: group.assetImage,
      experience: group.memberCount * 120,
      streak: 10,
      groupName: group.name,
    );
    Get.toNamed(Routes.communityMemberProfile, arguments: args);
  }

  void openPostAuthorProfile(CommunityPost post) {
    final args = _buildMemberProfileArguments(
      name: post.authorName,
      avatar: post.authorAvatar,
      experience: (post.bookmarks.value * 150) + (post.likes.value * 60),
      streak: post.comments.value,
      groupName:
          joinedGroupDetails.value?.group.name ?? currentLeague.value.name,
    );
    Get.toNamed(Routes.communityMemberProfile, arguments: args);
  }

  Future<void> leaveGroup() async {
    final membership = _activeMembership;
    final groupName = joinedGroupDetails.value?.group.name;
    if (membership == null) {
      return;
    }
    try {
      await _firestoreService.deleteGroupMember(membership.id);
      _activeMembership = null;
      _disposeGroupXpSubscriptions();
      joinedGroupDetails.value = null;
      Get.snackbar(
        'Đã rời nhóm',
        groupName != null
            ? 'Bạn đã rời khỏi "$groupName".'
            : 'Bạn đã rời khỏi nhóm.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể rời nhóm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool hasReportedPost(String postId) {
    return submittedReports.any((report) => report.postId == postId);
  }

  Future<void> submitPostReport({
    required CommunityPost post,
    required String reason,
    String? description,
  }) async {
    final trimmedDescription =
        description != null && description.trim().isNotEmpty
            ? description.trim()
            : null;

    final userId = _resolveUserId();
    if (userId == _fallbackUserId) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để báo cáo bài viết.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _firestoreService.addPostReport(
        postId: post.id,
        reporterId: userId,
        reason: reason,
        details: trimmedDescription,
      );

      submittedReports.add(
        CommunityPostReport(
          postId: post.id,
          reason: reason,
          description: trimmedDescription,
        ),
      );
      Get.back<void>();
      Get.snackbar(
        'Đã gửi báo cáo',
        'Cảm ơn bạn đã giúp SnapLingua giữ cộng đồng an toàn.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể gửi báo cáo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> submitJoinRequest({
    required CommunityStudyGroup group,
    required String message,
  }) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty && group.requireApproval) {
      Get.snackbar(
        'Thiếu thông tin',
        'Hãy giới thiệu ngắn gọn về bản thân trước khi gửi yêu cầu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final userId = _resolveUserId();
    if (userId == _fallbackUserId) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để gửi yêu cầu tham gia nhóm.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final existing = await _firestoreService.getGroupMembership(
        groupId: group.groupId,
        userId: userId,
      );
      if (existing != null) {
        if (existing.status == 'pending') {
          Get.snackbar(
            'Đang chờ phê duyệt',
            'Bạn đã gửi yêu cầu tham gia "${group.name}".',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        if (existing.status == 'active') {
          Get.snackbar(
            'Đã tham gia',
            'Bạn đã là thành viên của "${group.name}".',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        await _firestoreService.updateGroupMemberStatus(
          memberId: existing.id,
          status: 'pending',
          requestMessage: trimmedMessage,
        );
      } else {
        await _firestoreService.createGroupMembership(
          groupId: group.groupId,
          userId: userId,
          role: group.leaderId == userId ? 'leader' : 'member',
          status: 'pending',
          requestMessage: trimmedMessage,
        );
      }

      final displayMessage = trimmedMessage.isEmpty
          ? 'Đang chờ trưởng nhóm phê duyệt.'
          : trimmedMessage;
      // attempt to find the membership doc to include memberId for leader actions
      String memberId = '';
      try {
        final membership = await _firestoreService.getGroupMembership(
          groupId: group.groupId,
          userId: userId,
        );
        memberId = membership?.id ?? '';
      } catch (_) {
        memberId = '';
      }
      pendingJoinRequests.add(
        CommunityJoinRequest(
          groupId: group.groupId,
          memberId: memberId,
          senderUserId: userId,
          groupName: group.name,
          leaderName: group.leaderName,
          message: displayMessage,
          senderName: 'Bạn',
        ),
      );
      if (Get.isBottomSheetOpen ?? false) {
        Get.back<void>();
      }
      Get.snackbar(
        'Đã gửi yêu cầu',
        'Trưởng nhóm ${group.leaderName} sẽ nhận thông báo về bạn.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể gửi yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void openChat() {
    final details = joinedGroupDetails.value;
    if (details == null) return;
    Get.toNamed(
      Routes.communityChat,
      arguments: details,
    );
  }

  List<CommunityLeaderboardParticipant> get promotionLeaders =>
      currentLeague.value.participants
          .where((p) => p.status == CommunityLeaderboardStatus.promotion)
          .toList();

  List<CommunityLeaderboardParticipant> get safeLeaders =>
      currentLeague.value.participants
          .where((p) => p.status == CommunityLeaderboardStatus.safe)
          .toList();

  List<CommunityLeaderboardParticipant> get demotionLeaders =>
      currentLeague.value.participants
          .where((p) => p.status == CommunityLeaderboardStatus.demotion)
          .toList();

  Future<void> addUserPost({
    required String imageUrl,
    String? photoId,
    required List<CommunityVocabularyItem> vocabularyItems,
    String? caption,
  }) async {
    final userId = _resolveUserId();
    final DateTime createdAt = DateTime.now();
    try {
      final firestorePost = await _firestoreService.createCommunityPost(
        userId: userId,
        photoUrl: imageUrl,
        photoId: photoId,
        caption: caption,
        createdAt: createdAt,
      );

      for (final vocab in vocabularyItems) {
        final topic = vocab.topic.value;
        if (topic != null && topic.isNotEmpty) {
          _addTopicIfMissing(topic);
        }
        final trimmedHeadword = vocab.headword.trim();
        final trimmedTranslation = vocab.translation.trim();
        final meaningSnapshot = trimmedTranslation.isEmpty
            ? trimmedHeadword
            : '$trimmedHeadword - $trimmedTranslation';

        await _firestoreService.addPostWord(
          postId: firestorePost.postId,
          wordId: null,
          meaningSnapshot: meaningSnapshot,
          exampleSnapshot:
              vocab.phonetic.trim().isEmpty ? null : vocab.phonetic.trim(),
        );
      }

      await _insertLocalPostPreview(
        postId: firestorePost.postId,
        imageUrl: imageUrl,
        photoId: photoId,
        vocabularyItems: vocabularyItems,
        createdAt: createdAt,
      );
    } catch (e) {
      Get.log('Không thể tạo bài viết cộng đồng: $e');
      rethrow;
    }
  }

  CommunityMemberProfileArguments _buildMemberProfileArguments({
    required String name,
    required int experience,
    required int streak,
    String? avatar,
    String? groupName,
    String? userId,
    Map<String, int>? xpBreakdown,
    String? leagueTier,
    int? weeklyXp,
    bool isVirtual = false,
  }) {
    final normalizedAvatar = _normalizeAvatar(avatar);
    final images = posts
        .where((post) =>
            userId != null ? post.authorId == userId : post.authorName == name)
        .map((post) => post.imageUrl)
        .toList();
    final xp = experience < 0 ? 0 : experience;
    final rank = _resolveCommunityRank(xp);
    final followers = ((xp ~/ 5) + 40).clamp(30, 5000).toInt();
    final following = ((streak * 2) + 20).clamp(10, 2000).toInt();

    final summary = ProfileSummary(
      displayName: name,
      avatarUrl: normalizedAvatar,
      rankTitle: rank.title,
      rankIcon: rank.iconPath,
      groupName: groupName ?? 'Cộng đồng Snaplingua',
      groupIcon: 'assets/images/nhom/nhom2.png',
      experience: xp,
      streak: streak,
      posts: images.length,
      followers: followers,
      following: following,
    );

    return CommunityMemberProfileArguments(
      summary: summary,
      recentPosts: images,
      isFollowing: false,
      leagueTier: leagueTier,
      weeklyXp: weeklyXp,
      xpBreakdown: xpBreakdown ?? const <String, int>{},
      userId: userId,
      isVirtual: isVirtual,
    );
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
    return const ProfileRank(
      title: 'Tân binh Igloo',
      iconPath: 'assets/images/rank/rank6.png',
    );
  }

  String? _normalizeAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return null;
    }
    return avatar;
  }

  Future<void> toggleLike(CommunityPost post) async {
    final previousLiked = post.isLiked.value;
    final previousLikes = post.likes.value;

    post.isLiked.value = !previousLiked;
    final int delta = post.isLiked.value ? 1 : -1;
    final int nextLikes = previousLikes + delta;
    post.likes.value = nextLikes < 0 ? 0 : nextLikes;

    final userId = _resolveUserId();
    if (userId == _fallbackUserId) {
      post.isLiked.value = previousLiked;
      post.likes.value = previousLikes;
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để tương tác với bài viết.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      if (post.isLiked.value) {
        await _firestoreService.addPostLike(
          postId: post.id,
          userId: userId,
        );
        if (Get.isRegistered<QuestService>()) {
          await QuestService.to.incrementQuestProgress(
            DailyQuestType.engageCommunity,
            amount: 1,
          );
        }
      } else {
        await _firestoreService.removePostLike(
          postId: post.id,
          userId: userId,
        );
      }
    } catch (e) {
      post.isLiked.value = previousLiked;
      post.likes.value = previousLikes;
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể cập nhật lượt thích: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Follow or unfollow a post's author
  Future<void> followAuthor(CommunityPost post) async {
    try {
      if (!post.canFollowAuthor) {
        Get.snackbar(
          'Không thể theo dõi',
          'Bạn không thể theo dõi tác giả này.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userId = _resolveUserId();
      if (userId == _fallbackUserId) {
        Get.snackbar(
          'Cần đăng nhập',
          'Hãy đăng nhập để theo dõi tác giả.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (post.authorId.isEmpty || post.authorId == userId) {
        Get.snackbar(
          'Lỗi',
          'Không thể theo dõi chính mình hoặc tác giả không hợp lệ.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Set loading state
      post.isFollowActionPending.value = true;

      try {
        // TODO: Implement actual follow functionality
        // This should connect to your follow/unfollow service
        // For now, just simulate the action
        await Future.delayed(const Duration(milliseconds: 800));

        // Update follow state
        post.isFollowingAuthor.value = true;

        Get.snackbar(
          'Thành công',
          'Đã theo dõi ${post.authorName}',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Update quest progress
        if (Get.isRegistered<QuestService>()) {
          await QuestService.to.incrementQuestProgress(
            DailyQuestType.engageCommunity,
            amount: 1,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Lỗi',
          'Không thể theo dõi tác giả: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        post.isFollowActionPending.value = false;
      }
    } catch (e) {
      debugPrint('Error in followAuthor: $e');
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra khi thực hiện thao tác.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Mark a post as viewed for analytics/tracking purposes
  void markPostAsViewed(CommunityPost post) {
    try {
      if (post.id.isEmpty) {
        debugPrint('Cannot mark post as viewed: invalid post ID');
        return;
      }

      final userId = _resolveUserId();
      if (userId == _fallbackUserId) {
        debugPrint('Cannot mark post as viewed: user not logged in');
        return;
      }

      // Log the view event for analytics
      debugPrint('Post viewed: ${post.id} by user: $userId');

      // TODO: Implement actual post view tracking
      // This could include:
      // - Sending analytics event to your tracking service
      // - Updating view count in Firestore
      // - Recording user engagement metrics
      // Example:
      // await _firestoreService.recordPostView(postId: post.id, userId: userId);

    } catch (e) {
      debugPrint('Error marking post as viewed: $e');
      // Don't show error to user as this is a background operation
    }
  }

  Future<void> addComment(CommunityPost post, String comment) async {
    // Enhanced input validation
    final trimmed = comment.trim();
    if (trimmed.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Bình luận không được để trống.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (trimmed.length > _maxCommentLength) {
      Get.snackbar(
        'Lỗi',
        'Bình luận không được quá $_maxCommentLength ký tự.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (post.id.trim().isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Không thể bình luận về bài viết này.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final userId = _resolveUserId();
    if (userId == _fallbackUserId) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để bình luận về bài viết.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    post.commentMessages.add(trimmed);
    post.comments.value = post.commentMessages.length;
    showComments(post);

    final int insertedIndex = post.commentMessages.length - 1;

    try {
      await _firestoreService.addPostComment(
        postId: post.id,
        userId: userId,
        commentType: 'text',
        content: trimmed,
      );
      if (Get.isRegistered<QuestService>()) {
        await QuestService.to.incrementQuestProgress(
          DailyQuestType.engageCommunity,
          amount: 1,
        );
      }
    } catch (e) {
      if (insertedIndex >= 0 && insertedIndex < post.commentMessages.length) {
        post.commentMessages.removeAt(insertedIndex);
      }
      post.comments.value = post.commentMessages.length;
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể gửi bình luận: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showComments(CommunityPost post) {
    post.isCommentsExpanded.value = true;
    post.isVocabularyExpanded.value = false;
  }

  void showVocabulary(CommunityPost post) {
    post.isVocabularyExpanded.value = true;
    post.isCommentsExpanded.value = false;
  }

  void toggleSelection(CommunityPost post, CommunityVocabularyItem vocabulary) {
    vocabulary.isSelected.toggle();
  }

  void updateTopic(CommunityVocabularyItem vocabulary, String topicName) {
    final normalized = topicName.trim();
    vocabulary.topic.value = normalized;
    _addTopicIfMissing(normalized);
  }

  Future<void> saveVocabulary(
    CommunityPost post,
    CommunityVocabularyItem vocabulary,
  ) async {
    if (!vocabulary.isSelected.value) {
      Get.snackbar(
        'Chọn từ vựng',
        'Vui lòng chọn từ trước khi lưu vào kho của bạn.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final topicName = vocabulary.topic.value?.trim();
    if (topicName == null ||
        topicName.isEmpty ||
        topicName.toLowerCase() == 'chọn chủ đề') {
      Get.snackbar(
        'Thiếu chủ đề',
        'Vui lòng chọn hoặc tạo chủ đề trước khi lưu từ vựng.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final now = DateTime.now();
    final userId = _resolveUserId();

    try {
      // Create or update vocabulary in user's Firestore-backed dictionary
      late Vocabulary savedVocabulary;

      final realm = RealmService.to.realm;
      if (realm == null) {
        throw StateError('Realm is not initialized.');
      }

      realm.write(() {
        final sanitizedTopic = topicName.trim();
        _addTopicIfMissing(sanitizedTopic);

        final categoryResults =
            realm.query<Category>('name == \$0', [sanitizedTopic]);
        if (categoryResults.isNotEmpty) {
          final category = categoryResults.first;
          if (!category.isActive) {
            category.isActive = true;
          }
        } else {
          final categoryId = _generateCategoryId(sanitizedTopic, now);
          final sortOrder = realm.all<Category>().length;
          realm.add(
            Category(
              categoryId,
              sanitizedTopic,
              sortOrder,
              true,
              now,
            ),
          );
        }

        final vocabResults = realm.query<Vocabulary>(
          'word == \$0 AND category == \$1',
          [vocabulary.headword.trim(), sanitizedTopic],
        );

        if (vocabResults.isNotEmpty) {
          final existing = vocabResults.first;
          existing
            ..translation = vocabulary.translation
            ..phonetic = vocabulary.phonetic
            ..pronunciation = vocabulary.phonetic
            ..definition = _ensureDefinition(
              existing.definition,
              vocabulary.translation,
            )
            ..updatedAt = now
            ..isActive = true
            ..category = sanitizedTopic;
          savedVocabulary = existing;
        } else {
          final vocabId = _generateVocabularyId(
              vocabulary.headword.trim(), sanitizedTopic, now);
          final definition = vocabulary.translation.isNotEmpty
              ? vocabulary.translation
              : 'Đang cập nhật nghĩa';
          savedVocabulary = Vocabulary(
            vocabId,
            vocabulary.headword.trim(),
            definition,
            'beginner',
            sanitizedTopic,
            0,
            true,
            now,
            phonetic: vocabulary.phonetic,
            pronunciation: vocabulary.phonetic,
            translation: vocabulary.translation,
            updatedAt: now,
          );
          realm.add(savedVocabulary);
        }

        final examplePair = ExampleSentenceService.generate(
          word: savedVocabulary.word,
          translation:
              savedVocabulary.translation ?? savedVocabulary.definition,
          topic: sanitizedTopic,
          seed: savedVocabulary.id.hashCode,
        );

        final currentExample = savedVocabulary.example;
        if (currentExample == null || currentExample.trim().isEmpty) {
          savedVocabulary.example = examplePair.english;
        }
        final mergedTags = ExampleSentenceService.mergeExamplesIntoTags(
          savedVocabulary.tags,
          ExampleSentencePair(
            english: savedVocabulary.example ?? examplePair.english,
            vietnamese: examplePair.vietnamese,
          ),
          overrideVietnamese: true,
        );
        if (mergedTags.isEmpty) {
          savedVocabulary.tags = null;
        } else {
          savedVocabulary.tags = mergedTags;
        }

        final userVocabResults = realm.query<UserVocabulary>(
          'userId == \$0 AND vocabularyId == \$1',
          [userId, savedVocabulary.id],
        );

        if (userVocabResults.isNotEmpty) {
          final existing = userVocabResults.first;
          existing
            ..status = existing.status.isEmpty
                ? VocabularyService.statusNotStarted
                : existing.status
            ..updatedAt = now
            ..nextReviewDate ??= now.add(const Duration(days: 1));
        } else {
          realm.add(
            UserVocabulary(
              '${userId}_${savedVocabulary.id}',
              userId,
              savedVocabulary.id,
              1,
              0,
              2.5,
              1,
              0,
              0,
              false,
              false,
              VocabularyService.statusNotStarted,
              now,
              nextReviewDate: now.add(const Duration(days: 1)),
              updatedAt: now,
            ),
          );
        }
      });

      vocabulary.isSelected.value = false;

      Get.snackbar(
        'Đã lưu từ vựng',
        '\'${vocabulary.headword}\' đã được thêm vào kho của bạn với chủ đề $topicName.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      // Notify learning/review/topic controllers so UI updates immediately
      try {
        if (Get.isRegistered<LearningTabController>()) {
          await Get.find<LearningTabController>().refreshProgress();
        }
      } catch (e) {
        Get.log('saveVocabulary: failed to refresh learning tab: $e');
      }

      try {
        if (Get.isRegistered<ReviewController>()) {
          await Get.find<ReviewController>().loadCategories();
        }
      } catch (e) {
        Get.log('saveVocabulary: failed to refresh review categories: $e');
      }

      try {
        if (Get.isRegistered<VocabularyTopicController>()) {
          // Update topic controller status for the saved word (set to notStarted)
          Get.find<VocabularyTopicController>().updateWordStatus(
            vocabulary.headword,
            VocabularyLearningStatus.notStarted,
          );
        }
      } catch (e) {
        Get.log('saveVocabulary: failed to update vocabulary topic controller: $e');
      }
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể lưu từ vựng: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _loadAvailableTopics() {
    final realm = RealmService.to.realm;
    if (realm == null) {
      availableTopics.sort();
      return;
    }

    try {
      final topics = <String>{..._defaultTopics};

      final categories = realm.all<Category>();
      for (final category in categories) {
        final name = category.name.trim();
        if (category.isActive && name.isNotEmpty) {
          topics.add(name);
        }
      }

      final vocabularies = realm.all<Vocabulary>();
      for (final vocab in vocabularies) {
        final category = vocab.category.trim();
        if (category.isNotEmpty) {
          topics.add(category);
        }
      }

      final sorted = topics.toList()..sort((a, b) => a.compareTo(b));
      availableTopics.assignAll(sorted);
    } catch (e) {
      Get.log('Error loading community topics: $e');
      availableTopics.sort();
    }
  }

  void _addTopicIfMissing(String topicName) {
    final normalized = topicName.trim();
    if (normalized.isEmpty) {
      return;
    }
    if (!availableTopics.contains(normalized)) {
      availableTopics.add(normalized);
      availableTopics.sort((a, b) => a.compareTo(b));
    }
  }

  Future<void> _insertLocalPostPreview({
    required String postId,
    required String imageUrl,
    String? photoId,
    required List<CommunityVocabularyItem> vocabularyItems,
    required DateTime createdAt,
  }) async {
    final currentUserId = _resolveUserId();
    final currentUser = await _getPostAuthor(currentUserId);

    String authorName = 'Bạn học SnapLingua';
    String? authorAvatar;

    if (currentUser != null) {
      authorName = currentUser.displayName?.trim() ?? authorName;
      if (authorName.isEmpty) {
        authorName = 'Bạn học SnapLingua';
      }
      authorAvatar = _normalizeAvatar(currentUser.avatarUrl);
    } else if (Get.isRegistered<ProfileController>()) {
      final profileSummary = Get.find<ProfileController>().summary.value;
      authorName = profileSummary.displayName;
      authorAvatar = profileSummary.avatarUrl;
    }
    authorAvatar ??= 'https://i.pravatar.cc/150?u=${authorName.hashCode}';


    final clonedVocabulary = vocabularyItems
        .map(
          (item) => CommunityVocabularyItem(
            label: item.label,
            confidence: item.confidence,
            headword: item.headword,
            phonetic: item.phonetic,
            translation: item.translation,
            topic: item.topic.value,
          ),
        )
        .toList(growable: false);

    if (photoId != null && photoId.isNotEmpty && !_photoCache.containsKey(photoId)) {
      _photoCache[photoId] = FirestorePhoto(
        photoId: photoId,
        userId: currentUserId,
        imageUrl: imageUrl,
        width: 0,
        height: 0,
        format: 'jpg',
        sizeBytes: null,
        source: 'camera_detection',
        takenAt: createdAt,
        uploadedAt: createdAt,
        exif: null,
        checksumSha256: null,
      );
    }

    final previewPost = CommunityPost(
      id: postId,
      authorId: currentUserId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      postedAt: 'Vừa xong',
      imageUrl: imageUrl,
      photoId: photoId,
      vocabularyItems: clonedVocabulary,
      likes: 0,
      comments: 0,
      bookmarks: 0,
      initialComments: const [],
      initiallySelected: true,
    );

    final existingIndex = posts.indexWhere((element) => element.id == postId);
    if (existingIndex >= 0) {
      posts[existingIndex] = previewPost;
    } else {
      posts.insert(0, previewPost);
    }

    if (Get.isRegistered<ProfileController>()) {
      try {
        ProfileController.to.addLocalPostPreview(imageUrl);
      } catch (_) {
        // ignore profile update errors
      }
    }
  }

  String _resolveUserId() {
    try {
      final auth = _authService ??
          (Get.isRegistered<AuthService>() ? AuthService.to : null);
      if (auth?.isLoggedIn == true &&
          auth?.currentUserId?.isNotEmpty == true) {
        return auth!.currentUserId!;
      }
    } catch (e) {
      Get.log('Error resolving user ID: $e');
    }
    return _fallbackUserId;
  }

  String _generateCategoryId(String name, DateTime timestamp) {
    final normalized = name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '_')
        .replaceAll(RegExp('_+'), '_')
        .trim();
    if (normalized.isEmpty) {
      return 'category_${timestamp.millisecondsSinceEpoch}';
    }
    return 'category_$normalized';
  }

  String _generateVocabularyId(String word, String topic, DateTime timestamp) {
    final base =
        '${word}_$topic'.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '_');
    final normalized = base.replaceAll(RegExp('_+'), '_').trim();
    final suffix = timestamp.millisecondsSinceEpoch;
    return normalized.isEmpty ? 'vocab_$suffix' : 'vocab_${normalized}_$suffix';
  }

  String _ensureDefinition(String currentDefinition, String translation) {
    if (currentDefinition.trim().isNotEmpty) {
      return currentDefinition;
    }
    if (translation.trim().isNotEmpty) {
      return translation;
    }
    return 'Đang cập nhật nghĩa';
  }

  void goToPreviousVocabulary(CommunityPost post) {
    if (post.vocabularyItems.length <= 1) return;
    final current = post.currentVocabularyIndex.value;
    if (current > 0) {
      post.currentVocabularyIndex.value = current - 1;
    }
  }

  void goToNextVocabulary(CommunityPost post) {
    if (post.vocabularyItems.length <= 1) return;
    final current = post.currentVocabularyIndex.value;
    if (current < post.vocabularyItems.length - 1) {
      post.currentVocabularyIndex.value = current + 1;
    }
  }

  void updateFollowStateForUser(String userId, bool isFollowing) {
    if (userId.trim().isEmpty) {
      Get.log('CommunityController.updateFollowStateForUser: Invalid user ID');
      return;
    }

    try {
      // Update any relevant follow state in community data structures
      // This method is called when a user's follow state changes
      // to keep community views in sync

      Get.log('Updated follow state for user $userId: following=$isFollowing');

      // Notify any registered community member profile controllers
      if (Get.isRegistered<CommunityMemberProfileController>()) {
        try {
          final controller = Get.find<CommunityMemberProfileController>();
          controller.applyExternalFollowUpdate(
            targetUserId: userId,
            followerDelta: isFollowing ? 1 : -1,
            isFollowing: isFollowing,
          );
        } catch (e) {
          Get.log('Failed to update CommunityMemberProfileController: $e');
        }
      }

      // Potentially update leaderboard or other community displays here
      // if needed in the future

    } catch (e) {
      Get.log('Error updating follow state for user $userId: $e');
    }
  }
}

class _PendingGroupMemberScore {
  _PendingGroupMemberScore({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.totalXp,
    required this.weeklyXp,
    required this.isHighlighted,
    required this.joinedAt,
  });

  final String userId;
  final String displayName;
  final String avatarUrl;
  final int totalXp;
  final int weeklyXp;
  final bool isHighlighted;
  final DateTime joinedAt;
}

class _GroupCycleWindow {
  const _GroupCycleWindow({
    required this.startAt,
    required this.endAt,
  });

  final DateTime startAt;
  final DateTime endAt;
}

class _LeagueRuleSet {
  const _LeagueRuleSet({
    required this.xpCaps,
    required this.promotionCount,
    required this.demotionCount,
    required this.safeThreshold,
    required this.desiredParticipants,
  });

  final Map<String, int> xpCaps;
  final int promotionCount;
  final int demotionCount;
  final int safeThreshold;
  final int desiredParticipants;
}

class _LeagueParticipantData {
  _LeagueParticipantData({
    required this.member,
    required this.user,
    required this.cappedXp,
    required this.rawXp,
    required this.xpBreakdown,
    required this.activityDays,
  });

  final FirestoreLeagueMember member;
  final FirestoreUser? user;
  final int cappedXp;
  final int rawXp;
  final Map<String, int> xpBreakdown;
  final int activityDays;
}
