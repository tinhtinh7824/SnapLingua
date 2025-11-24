import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/data/models/firestore_group_message.dart';
import 'package:snaplingua/app/data/models/firestore_user.dart';
import 'package:snaplingua/app/data/services/auth_service.dart';
import 'package:snaplingua/app/data/services/firestore_service.dart';

import '../../community/controllers/community_controller.dart' hide CommunityChatMessage, CommunityGroupDetails, CommunityStudyGroup;
import '../models/community_chat_models.dart';


class CommunityChatController extends GetxController {
  CommunityChatController({
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
  final RxList<CommunityChatMessage> messages = <CommunityChatMessage>[].obs;
  late final CommunityGroupDetails groupDetails;
  StreamSubscription<List<FirestoreGroupMessage>>? _messageSubscription;
  final Map<String, FirestoreUser> _userCache = {};
  final ScrollController scrollController = ScrollController();
  final CommunityController? _communityController =
      Get.isRegistered<CommunityController>()
          ? Get.find<CommunityController>()
          : null;

  @override
  void onInit() {
    super.onInit();
    final details = Get.arguments as CommunityGroupDetails?;
    groupDetails = details ??
        CommunityGroupDetails(
          group: CommunityStudyGroup(
            groupId: 'fallback_group',
            name: 'Câu lạc bộ từ vựng',
            requirement: 'Chia sẻ từ mới hằng ngày',
            memberCount: 0,
            assetImage: 'assets/images/nhom/nhom2.png',
            leaderId: 'leader_fallback',
            leaderName: 'Trưởng nhóm',
          ),
          currentMilestoneLabel: 'Đảo băng',
          remainingLabel: '5 ngày',
          currentPoints: 0,
          milestones: const [],
          memberScores: const [],
        );
    // Note: markGroupChatAsRead() was called here but method doesn't exist
    // Consider implementing read status tracking if needed
    _bindMessages();
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  void _bindMessages() {
    _messageSubscription?.cancel();
    _messageSubscription = _firestoreService
        .listenToGroupMessages(groupId: groupDetails.group.groupId, limit: 100)
        .listen(
          (messageList) => _mapMessages(messageList),
          onError: (error) => Get.log('Không thể tải tin nhắn nhóm: $error'),
        );
  }

  void _mapMessages(List<FirestoreGroupMessage> messageList) {
    Future<void>(() async {
      try {
        final ordered = List<FirestoreGroupMessage>.from(messageList)
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        final currentUserId = _resolveUserId();
        final List<CommunityChatMessage> mapped = [];
        for (final message in ordered) {
          final FirestoreUser? sender = await _getUser(message.userId);
          final senderName = _formatSenderName(
            sender?.displayName,
            message.userId,
            isLeader: message.userId == groupDetails.group.leaderId,
          );
          mapped.add(
            CommunityChatMessage(
              senderName: senderName,
              content: message.content ?? '',
              isCurrentUser:
                  currentUserId != null && message.userId == currentUserId,
              isLeader: message.userId == groupDetails.group.leaderId,
              isSticker: message.messageType == 'sticker',
            ),
          );
        }
        messages.assignAll(mapped);
        _scrollToBottom();
      } catch (e) {
        Get.log('Không thể hiển thị tin nhắn nhóm: $e');
      }
    });
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final userId = _resolveUserId();
    if (userId == null) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để trò chuyện với nhóm.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    CommunityChatMessage? pendingMessage;
    try {
      final senderName = _formatSenderName(
        null,
        userId,
        isLeader: userId == groupDetails.group.leaderId,
      );
      pendingMessage = CommunityChatMessage(
        senderName: senderName,
        content: trimmed,
        isCurrentUser: true,
        isLeader: userId == groupDetails.group.leaderId,
      );
      messages.add(pendingMessage);
      _scrollToBottom();

      await _firestoreService.sendGroupMessage(
        groupId: groupDetails.group.groupId,
        userId: userId,
        messageType: 'text',
        content: trimmed,
      );
    } catch (e) {
      if (pendingMessage != null) {
        messages.remove(pendingMessage);
      }
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể gửi tin nhắn: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) {
      return;
    }
    Future<void>(() {
      final position = scrollController.position.maxScrollExtent;
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> sendSticker({
    required String badgeId,
    required String stickerPath,
  }) async {
    final userId = _resolveUserId();
    if (userId == null) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để sử dụng sticker.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final ownsBadge = await _firestoreService.userOwnsBadge(
      userId: userId,
      badgeId: badgeId,
    );
    if (!ownsBadge) {
      Get.snackbar(
        'Chưa sở hữu sticker',
        'Bạn cần sở hữu huy hiệu tương ứng để sử dụng sticker này.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    CommunityChatMessage? pendingSticker;
    try {
      await _firestoreService.sendGroupMessage(
        groupId: groupDetails.group.groupId,
        userId: userId,
        messageType: 'sticker',
        content: stickerPath,
        badgeId: badgeId,
      );
      final senderName = _formatSenderName(
        null,
        userId,
        isLeader: userId == groupDetails.group.leaderId,
      );
      pendingSticker = CommunityChatMessage(
        senderName: senderName,
        content: stickerPath,
        isCurrentUser: true,
        isLeader: userId == groupDetails.group.leaderId,
        isSticker: true,
      );
      messages.add(pendingSticker);
      _scrollToBottom();
    } catch (e) {
      if (pendingSticker != null) {
        messages.remove(pendingSticker);
      }
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể gửi sticker: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<FirestoreUser?> _getUser(String userId) async {
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
        _userCache[userId] = user;
      }
      return user;
    } catch (e) {
      Get.log('Không thể tải người dùng $userId: $e');
      return null;
    }
  }

  String? _resolveUserId() {
    final auth = _authService ??
        (Get.isRegistered<AuthService>() ? AuthService.to : null);
    if (auth != null && auth.isLoggedIn && auth.currentUserId.isNotEmpty) {
      return auth.currentUserId;
    }
    return null;
  }

  String _formatSenderName(
    String? displayName,
    String userId, {
    required bool isLeader,
  }) {
    final baseName = displayName?.trim().isNotEmpty == true
        ? displayName!.trim()
        : 'Thành viên SnapLingua';
    if (isLeader) {
      return '$baseName (trưởng nhóm)';
    }
    return baseName;
  }
}
