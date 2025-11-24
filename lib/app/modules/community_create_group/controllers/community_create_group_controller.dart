import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snaplingua/app/data/models/firestore_group.dart';
import 'package:snaplingua/app/data/services/auth_service.dart';
import 'package:snaplingua/app/data/services/firestore_service.dart';

import '../../community/models/community_models.dart';

enum StudyGroupApprovalMode { auto, require }

class CommunityCreateGroupController extends GetxController {
  CommunityCreateGroupController({
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

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final requirementController = TextEditingController();

  final RxInt selectedIconIndex = (-1).obs;
  final Rx<StudyGroupApprovalMode> approvalMode =
      StudyGroupApprovalMode.auto.obs;
  final RxBool canSubmit = false.obs;
  final RxBool isSubmitting = false.obs;

  static const List<String> iconAssets = [
    'assets/images/chimcanhcut/chim_hocnhom.png',
    'assets/images/chimcanhcut/chim_hocnhom1.png',
    'assets/images/chimcanhcut/chim_hocnhom2.png',
    'assets/images/chimcanhcut/chim_hocnhom3.png',
    'assets/images/chimcanhcut/chim_hocnhom4.png',
  ];

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_recomputeSubmitState);
    requirementController.addListener(_recomputeSubmitState);
  }

  void selectIcon(int index) {
    selectedIconIndex.value = index;
    _recomputeSubmitState();
  }

  void setApprovalMode(StudyGroupApprovalMode mode) {
    approvalMode.value = mode;
  }

  void _recomputeSubmitState() {
    final hasName = nameController.text.trim().isNotEmpty;
    final hasRequirement = requirementController.text.trim().isNotEmpty;
    final hasIcon = selectedIconIndex.value >= 0 &&
        selectedIconIndex.value < iconAssets.length;
    canSubmit.value = hasName && hasRequirement && hasIcon;
  }

  String? _resolveUserId() {
    final auth = _authService ??
        (Get.isRegistered<AuthService>() ? AuthService.to : null);
    if (auth != null && auth.isLoggedIn && auth.currentUserId.isNotEmpty) {
      return auth.currentUserId;
    }
    return null;
  }

  Future<String?> _fetchLeaderName(String userId) async {
    try {
      final user = await _firestoreService.getUserById(userId);
      final displayName = user?.displayName;
      if (displayName != null && displayName.trim().isNotEmpty) {
        return displayName.trim();
      }
    } catch (e) {
      Get.log('Không thể lấy tên người dùng $userId: $e');
    }
    return null;
  }

  Future<void> submit() async {
    if (!canSubmit.value || isSubmitting.value) {
      return;
    }

    final userId = _resolveUserId();
    if (userId == null) {
      Get.snackbar(
        'Cần đăng nhập',
        'Hãy đăng nhập để tạo nhóm học tập.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final iconIndex = selectedIconIndex.value;
    final iconPath = iconAssets[iconIndex];
    final requireApproval =
        approvalMode.value == StudyGroupApprovalMode.require;

    final name = nameController.text.trim();
    final description = requirementController.text.trim();
    isSubmitting.value = true;
    try {
      final FirestoreGroup firestoreGroup = await _firestoreService.createGroup(
        name: name,
        description: description,
        iconPath: iconPath,
        createdBy: userId,
        requireApproval: requireApproval,
      );

      await _firestoreService.createGroupMembership(
        groupId: firestoreGroup.groupId,
        userId: userId,
        role: 'leader',
        status: 'active',
      );

      final leaderName = await _fetchLeaderName(userId) ?? 'Bạn';
      final communityGroup = CommunityStudyGroup(
        groupId: firestoreGroup.groupId,
        name: firestoreGroup.name,
        requirement: description,
        memberCount: 1,
        assetImage: iconPath,
        leaderId: userId,
        leaderName: leaderName,
        requireApproval: requireApproval,
        description: firestoreGroup.description,
        status: firestoreGroup.status,
        createdAt: firestoreGroup.createdAt,
      );

      Get.back(result: communityGroup);
    } catch (e) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể tạo nhóm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameController
      ..removeListener(_recomputeSubmitState)
      ..dispose();
    requirementController
      ..removeListener(_recomputeSubmitState)
      ..dispose();
    super.onClose();
  }
}
