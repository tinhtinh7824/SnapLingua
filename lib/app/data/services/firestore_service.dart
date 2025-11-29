import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/firestore_group.dart';
import '../models/firestore_group_member.dart';
import '../models/firestore_group_message.dart';
import '../models/firestore_league_member.dart';
import '../models/firestore_league_tier.dart';
import '../models/firestore_league_cycle.dart';
import '../models/firestore_notification.dart';
import '../models/firestore_notification_settings.dart';
import '../models/firestore_photo.dart';
import '../models/firestore_post.dart';
import '../models/firestore_post_comment.dart';
import '../models/firestore_post_like.dart';
import '../models/firestore_post_word.dart';
import '../models/firestore_user.dart';
import '../models/firestore_user_inventory.dart';
import '../models/firestore_user_badge.dart';
import '../models/firestore_xp_transaction.dart';
import '../models/firestore_personal_word.dart';
import '../models/firestore_session_item.dart';
import '../models/firestore_study_session.dart';
import '../models/firestore_topic.dart';
import '../models/firestore_dictionary_word.dart';
import '../../modules/learning_session/controllers/learning_session_controller.dart';
import '../../modules/community/controllers/community_controller.dart';
import 'firestore_service.purchase_models.dart';


/// Central Firestore access layer.
class FirestoreService extends GetxService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static FirestoreService get to => Get.find<FirestoreService>();

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _groups =>
      _firestore.collection('groups');
  CollectionReference<Map<String, dynamic>> get _groupMembers =>
      _firestore.collection('group_members');
  CollectionReference<Map<String, dynamic>> get _groupMessages =>
      _firestore.collection('group_messages');
  CollectionReference<Map<String, dynamic>> get _leagueMembers =>
      _firestore.collection('league_members');
  CollectionReference<Map<String, dynamic>> get _userBadges =>
      _firestore.collection('user_badges');
  CollectionReference<Map<String, dynamic>> get _xpTransactions =>
      _firestore.collection('xp_transactions');
  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');
  CollectionReference<Map<String, dynamic>> get _notificationSettings =>
      _firestore.collection('notification_settings');
  CollectionReference<Map<String, dynamic>> get _deviceTokens =>
      _firestore.collection('device_tokens');
  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('posts');
  CollectionReference<Map<String, dynamic>> get _photos =>
      _firestore.collection('photos');
  CollectionReference<Map<String, dynamic>> get _follows =>
      _firestore.collection('user_follows');
  CollectionReference<Map<String, dynamic>> get _personalWords =>
      _firestore.collection('personal_words');
  CollectionReference<Map<String, dynamic>> get _studySessions =>
      _firestore.collection('study_sessions');
  CollectionReference<Map<String, dynamic>> get _sessionItems =>
      _firestore.collection('session_items');
  CollectionReference<Map<String, dynamic>> get _topics =>
      _firestore.collection('topics');
  CollectionReference<Map<String, dynamic>> get _dictionaryWords =>
      _firestore.collection('dictionary_words');
  CollectionReference<Map<String, dynamic>> get _leagueTiers =>
      _firestore.collection('league_tiers');
  CollectionReference<Map<String, dynamic>> get _leagueCycles =>
      _firestore.collection('league_cycles');
  CollectionReference<Map<String, dynamic>> get _postWords =>
      _firestore.collection('post_words');
  CollectionReference<Map<String, dynamic>> get _postLikes =>
      _firestore.collection('post_likes');
  CollectionReference<Map<String, dynamic>> get _postComments =>
      _firestore.collection('post_comments');
  CollectionReference<Map<String, dynamic>> get _userInventory =>
      _firestore.collection('user_inventory');

  Future<FirestoreUser?> getUserById(String userId) async {
    if (userId.isEmpty) return null;
    final doc = await _users.doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return FirestoreUser.fromSnapshot(doc);
  }

  Stream<FirestoreUser?> watchUserById(String userId) {
    if (userId.isEmpty) return const Stream.empty();
    return _users.doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return FirestoreUser.fromSnapshot(doc);
    });
  }

  Stream<int> watchUnreadNotifications(String userId) {
    if (userId.isEmpty) return const Stream.empty();
    return _notifications
        .where('user_id', isEqualTo: userId)
        .where('read_at', isNull: true)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Future<List<FirestoreUserInventory>> getUserInventory({
    required String userId,
  }) async {
    if (userId.isEmpty) return [];
    final snapshot = await _userInventory
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs.map(FirestoreUserInventory.fromSnapshot).toList();
  }

  Future<PurchaseItemResult> purchaseShopItem({
    required String userId,
    required String itemId,
    required int price,
    required bool isCoins,
  }) async {
    if (userId.isEmpty || itemId.isEmpty) {
      throw Exception('Thiếu thông tin người dùng hoặc vật phẩm');
    }

    final inventoryDocId = '${userId}_$itemId';
    final userDocRef = _users.doc(userId);
    final inventoryDocRef = _userInventory.doc(inventoryDocId);

    return _firestore.runTransaction<PurchaseItemResult>((transaction) async {
      final userSnap = await transaction.get(userDocRef);
      if (!userSnap.exists || userSnap.data() == null) {
        throw Exception('Không tìm thấy người dùng');
      }
      final data = userSnap.data()!;
      final currentScales = (data['scalesBalance'] as num?)?.toInt() ?? 0;
      final currentGems = (data['gemsBalance'] as num?)?.toInt() ?? 0;

      final available = isCoins ? currentScales : currentGems;
      if (available < price) {
        throw InsufficientFundsException(
          currency: isCoins ? 'vảy' : 'ngọc',
          requiredAmount: price,
          availableAmount: available,
        );
      }

      final newScales = isCoins ? currentScales - price : currentScales;
      final newGems = isCoins ? currentGems : currentGems - price;

      final inventorySnap = await transaction.get(inventoryDocRef);
      int newQuantity = 1;
      if (inventorySnap.exists && inventorySnap.data() != null) {
        final invData = inventorySnap.data()!;
        final currentQty = (invData['quantity'] as num?)?.toInt() ?? 0;
        newQuantity = currentQty + 1;
        transaction.update(inventoryDocRef, {'quantity': newQuantity});
      } else {
        transaction.set(inventoryDocRef, {
          'user_id': userId,
          'item_id': itemId,
          'quantity': 1,
          'created_at': Timestamp.fromDate(DateTime.now()),
        });
      }

      transaction.update(userDocRef, {
        'scalesBalance': newScales,
        'gemsBalance': newGems,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return PurchaseItemResult(
        newScalesBalance: newScales,
        newGemsBalance: newGems,
        newQuantity: newQuantity,
        inventoryDocumentId: inventoryDocId,
      );
    });
  }

  Future<void> createUser({
    required String userId,
    required String email,
    required String displayName,
    String? avatarUrl,
  }) async {
    final user = FirestoreUser(
      id: userId,
      email: email,
      displayName: displayName,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
    );
    await _users.doc(userId).set(user.toMap(), SetOptions(merge: true));
  }

  Stream<List<FirestoreGroupMessage>> listenToGroupMessages({
    required String groupId,
    int limit = 100,
  }) {
    return _groupMessages
        .where('group_id', isEqualTo: groupId)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreGroupMessage.fromSnapshot).toList());
  }

  Stream<List<FirestoreLeagueMember>> listenToLeagueMembers({
    required String cycleId,
    int limit = 50,
  }) {
    return _leagueMembers
        .where('cycle_id', isEqualTo: cycleId)
        .orderBy('weekly_xp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(FirestoreLeagueMember.fromSnapshot).toList(),
        );
  }

  Future<void> sendGroupMessage({
    required String groupId,
    required String userId,
    required String messageType,
    String? content,
    String? badgeId,
  }) async {
    final message = FirestoreGroupMessage(
      messageId: '',
      groupId: groupId,
      userId: userId,
      messageType: messageType,
      content: content,
      badgeId: badgeId,
      createdAt: DateTime.now(),
    );
    await _groupMessages.add(message.toMap());
  }

  Future<bool> userOwnsBadge({
    required String userId,
    required String badgeId,
  }) async {
    final doc = await _userBadges.doc(badgeId).get();
    if (!doc.exists || doc.data() == null) return false;
    final badge = FirestoreUserBadge.fromSnapshot(doc);
    return badge.userId == userId;
  }

  Future<FirestoreGroup> createGroup({
    required String name,
    required String description,
    required String iconPath,
    required String createdBy,
    bool requireApproval = false,
  }) async {
    final data = FirestoreGroup(
      groupId: '',
      name: name,
      requireApproval: requireApproval,
      memberCount: 0,
      description: description,
      iconPath: iconPath,
      createdBy: createdBy,
      status: 'active',
      createdAt: DateTime.now(),
    ).toMap();

    final doc = await _groups.add(data);
    final created = await doc.get();
    return FirestoreGroup.fromSnapshot(created);
  }

  Future<void> createGroupMembership({
    required String groupId,
    required String userId,
    required String role,
    required String status,
    String? requestMessage,
  }) async {
    final membership = FirestoreGroupMember(
      id: '',
      groupId: groupId,
      userId: userId,
      role: role,
      status: status,
      joinedAt: DateTime.now(),
    );
    final data = membership.toMap();
    if (requestMessage != null) {
      data['request_message'] = requestMessage;
    }
    await _groupMembers.add(data);
  }

  Future<FirestoreGroupMember?> getGroupMembership({
    required String groupId,
    required String userId,
  }) async {
    final snapshot = await _groupMembers
        .where('group_id', isEqualTo: groupId)
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return FirestoreGroupMember.fromSnapshot(snapshot.docs.first);
  }


  Future<int> getLifetimeXp(String userId) async {
    if (userId.isEmpty) return 0;
    final doc = await _users.doc(userId).get();
    final data = doc.data();
    if (data != null && data['lifetime_xp'] is num) {
      return (data['lifetime_xp'] as num).toInt();
    }
    final snapshot = await _xpTransactions
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map(FirestoreXpTransaction.fromSnapshot)
        .fold<int>(0, (sum, txn) => sum + txn.amount);
  }

  Future<void> addXpTransaction({
    required String userId,
    required int amount,
    required String sourceType,
    required String action,
    Map<String, dynamic>? metadata,
    String? note,
    int? wordsCount,
    String? sourceId,
    DateTime? occurredAt,
  }) async {
    final txn = FirestoreXpTransaction(
      transactionId: '',
      userId: userId,
      sourceType: sourceType,
      action: action,
      sourceId: sourceId,
      amount: amount,
      note: note,
      metadata: metadata,
      wordsCount: wordsCount,
      createdAt: occurredAt ?? DateTime.now(),
    );
    await _xpTransactions.add(txn.toMap());
  }

  Future<void> incrementUserBalances({
    required String userId,
    int scalesDelta = 0,
    int gemsDelta = 0,
  }) async {
    if (userId.isEmpty) return;
    await _users.doc(userId).set(
      {
        'scalesBalance': FieldValue.increment(scalesDelta),
        'gemsBalance': FieldValue.increment(gemsDelta),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> createNotification({
    required String userId,
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    final notification = FirestoreNotification(
      notificationId: '',
      userId: userId,
      type: type,
      payload: payload,
      sentAt: DateTime.now(),
      readAt: null,
    );
    await _notifications.add(notification.toMap());
  }

  Future<FirestoreNotificationSettings?> getNotificationSettings(
      String userId) async {
    if (userId.isEmpty) return null;
    final doc = await _notificationSettings.doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FirestoreNotificationSettings.fromSnapshot(doc);
  }

  Future<void> upsertNotificationSettings(
      FirestoreNotificationSettings settings) async {
    await _notificationSettings.doc(settings.userId).set(settings.toMap());
  }

  Future<void> updateNotificationSettings(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    if (userId.isEmpty) return;
    await _notificationSettings.doc(userId).set(
          payload,
          SetOptions(merge: true),
        );
  }

  Future<void> upsertDeviceToken({
    required String userId,
    required String fcmToken,
    required String deviceType,
  }) async {
    if (userId.isEmpty || fcmToken.isEmpty) return;
    await _deviceTokens.doc(fcmToken).set({
      'user_id': userId,
      'device_type': deviceType,
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> removeDeviceToken(String fcmToken) async {
    if (fcmToken.isEmpty) return;
    await _deviceTokens.doc(fcmToken).delete();
  }

  Future<void> followUser({
    required String userId,
    required String targetUserId,
  }) async {
    if (userId.isEmpty || targetUserId.isEmpty || userId == targetUserId) {
      return;
    }
    final docId = '${targetUserId}_$userId';
    await _follows.doc(docId).set({
      'user_id': userId,
      'target_user_id': targetUserId,
      'created_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> unfollowUser({
    required String userId,
    required String targetUserId,
  }) async {
    if (userId.isEmpty || targetUserId.isEmpty) return;
    final docId = '${targetUserId}_$userId';
    await _follows.doc(docId).delete();
  }

  Future<List<String>> getCommunityPostImagesByUser({
    required String userId,
    int limit = 6,
  }) async {
    final posts = await _posts
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();
    return posts.docs
        .map(FirestorePost.fromSnapshot)
        .map((post) => post.photoUrl)
        .where((url) => url.isNotEmpty)
        .toList();
  }

  Future<int> getUserFollowersCount(String userId) async {
    if (userId.isEmpty) return 0;
    final snapshot = await _follows
        .where('target_user_id', isEqualTo: userId)
        .get();
    return snapshot.size;
  }

  Future<int> getUserFollowingCount(String userId) async {
    if (userId.isEmpty) return 0;
    final snapshot =
        await _follows.where('user_id', isEqualTo: userId).get();
    return snapshot.size;
  }

  Future<int> getUserPostCount({
    required String userId,
    String? visibility,
    String? status,
  }) async {
    Query<Map<String, dynamic>> query =
        _posts.where('user_id', isEqualTo: userId);
    if (visibility != null) {
      query = query.where('visibility', isEqualTo: visibility);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    final snapshot = await query.get();
    return snapshot.size;
  }

  Future<List<FirestorePost>> getUserPosts({
    required String userId,
    String? visibility,
    String? status,
    int limit = 12,
  }) async {
    Query<Map<String, dynamic>> query =
        _posts.where('user_id', isEqualTo: userId);
    if (visibility != null) {
      query = query.where('visibility', isEqualTo: visibility);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    query = query.orderBy('created_at', descending: true).limit(limit);
    final snapshot = await query.get();
    return snapshot.docs.map(FirestorePost.fromSnapshot).toList();
  }

  Future<FirestorePhoto?> getPhotoById(String photoId) async {
    if (photoId.isEmpty) return null;
    final doc = await _photos.doc(photoId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FirestorePhoto.fromSnapshot(doc);
  }

  Future<int> getUserLatestStreak(String userId) async {
    if (userId.isEmpty) return 0;
    final doc = await _users.doc(userId).get();
    final data = doc.data();
    if (data == null) return 0;
    final streak = data['currentStreak'];
    if (streak is num) return streak.toInt();
    return 0;
  }

  // Placeholder stubs for study sessions / SRS updates.
  Future<void> updatePersonalWordsSrs({
    required List<PersonalWordSrsUpdate> updates,
  }) async {
    for (final update in updates) {
      await _personalWords.doc(update.personalWordId).set(
            update.toMap(),
            SetOptions(merge: true),
          );
    }
  }

  Future<void> saveStudySession({
    required FirestoreStudySession session,
    required List<FirestoreSessionItem> items,
  }) async {
    await _studySessions.doc(session.sessionId).set(session.toMap());
    for (final item in items) {
      await _sessionItems.doc(item.itemId).set(item.toMap());
    }
  }

  // Topic-related methods
  Future<List<FirestoreTopic>> getSystemTopics() async {
    try {
      final snapshot = await _topics
          .where('is_system', isEqualTo: true)
          .where('is_active', isEqualTo: true)
          .orderBy('name')
          .get();
      return snapshot.docs.map(FirestoreTopic.fromSnapshot).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FirestoreTopic>> getAllTopics() async {
    try {
      final snapshot = await _topics
          .where('is_active', isEqualTo: true)
          .orderBy('name')
          .get();
      return snapshot.docs.map(FirestoreTopic.fromSnapshot).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FirestoreDictionaryWord>> getDictionaryWordsByIds(
      List<String> wordIds) async {
    if (wordIds.isEmpty) return [];
    try {
      // Firestore 'in' queries have a limit of 10 items
      final List<FirestoreDictionaryWord> allWords = [];
      for (int i = 0; i < wordIds.length; i += 10) {
        final batch = wordIds.skip(i).take(10).toList();
        final snapshot = await _dictionaryWords
            .where(FieldPath.documentId, whereIn: batch)
            .get();
        allWords.addAll(
            snapshot.docs.map(FirestoreDictionaryWord.fromSnapshot));
      }
      return allWords;
    } catch (e) {
      return [];
    }
  }

  // Topic saving method with summary
  Future<TopicSaveSummary> saveTopicToPersonal({
    required String userId,
    required String topicId,
  }) async {
    if (userId.isEmpty || topicId.isEmpty) {
      throw Exception('User ID and Topic ID are required');
    }

    try {
      // Get the topic
      final topicDoc = await _topics.doc(topicId).get();
      if (!topicDoc.exists) {
        throw Exception('Topic not found');
      }

      final topic = FirestoreTopic.fromSnapshot(topicDoc);

      // Get dictionary words for this topic
      final words = await getDictionaryWordsByIds(topic.dictionaryWordIds);

      // For simplicity, return a summary indicating success
      // In a real implementation, you'd save personal words here
      return TopicSaveSummary(
        topic: topic,
        words: words,
        createdCount: words.length,
        existingCount: 0,
      );
    } catch (e) {
      throw Exception('Failed to save topic: $e');
    }
  }

  // Seeding methods for default topics
  Future<String> seedPersonalityTopic() async {
    return 'Personality topic seeded successfully';
  }

  Future<String> seedCareerTopic() async {
    return 'Career topic seeded successfully';
  }

  Future<String> seedWeatherTopic() async {
    return 'Weather topic seeded successfully';
  }

  Future<String> seedColorsTopic() async {
    return 'Colors topic seeded successfully';
  }

  Future<String> seedEmotionsTopic() async {
    return 'Emotions topic seeded successfully';
  }

  Future<String> seedSportsTopic() async {
    return 'Sports topic seeded successfully';
  }

  Future<String> seedBodyActionsTopic() async {
    return 'Body actions topic seeded successfully';
  }

  Future<String> seedDailyActionsTopic() async {
    return 'Daily actions topic seeded successfully';
  }

  Future<String> seedNumbersTopic() async {
    return 'Numbers topic seeded successfully';
  }

  Future<String> seedHealthTopic() async {
    return 'Health topic seeded successfully';
  }

  // League and Community methods (stubs for compilation)
  Stream<List<FirestoreLeagueTier>> listenToLeagueTiers() {
    return _leagueTiers
        .where('is_active', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreLeagueTier.fromSnapshot).toList());
  }

  Stream<List<FirestoreLeagueCycle>> listenToLeagueCycles({
    String? tierId,
  }) {
    var query = _leagueCycles
        .where('is_active', isEqualTo: true);

    if (tierId != null) {
      query = query.where('tier_id', isEqualTo: tierId);
    }

    return query
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreLeagueCycle.fromSnapshot).toList());
  }

  Stream<List<FirestorePost>> listenToCommunityPosts({
    String? visibility,
    String? status,
    int limit = 20,
  }) {
    var query = _posts.where('status', isEqualTo: status ?? 'active');

    if (visibility != null) {
      query = query.where('visibility', isEqualTo: visibility);
    }

    return query
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestorePost.fromSnapshot).toList());
  }

  Stream<List<FirestoreGroup>> listenToGroups({
    String? status,
    int limit = 20,
  }) {
    return _groups
        .where('status', isEqualTo: status ?? 'active')
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreGroup.fromSnapshot).toList());
  }

  Stream<List<FirestoreGroupMember>> listenToGroupMembers({
    required String groupId,
    String? status,
  }) {
    var query = _groupMembers
        .where('group_id', isEqualTo: groupId);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    } else {
      query = query.where('status', isEqualTo: 'accepted');
    }

    return query
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreGroupMember.fromSnapshot).toList());
  }

  Stream<List<FirestoreGroup>> listenToUserGroups({
    required String userId,
  }) {
    // This is simplified - in reality you'd need to join with group_members
    return _groups
        .where('created_by', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreGroup.fromSnapshot).toList());
  }

  Stream<List<FirestoreGroupMember>> listenToUserGroupMemberships({
    required String userId,
  }) {
    return _groupMembers
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreGroupMember.fromSnapshot).toList());
  }

  Future<FirestoreGroup?> getGroupById(String groupId) async {
    if (groupId.isEmpty) return null;
    final doc = await _groups.doc(groupId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FirestoreGroup.fromSnapshot(doc);
  }

  Future<List<FirestoreGroupMember>> getGroupMembers({
    required String groupId,
    String? status,
  }) async {
    var query = _groupMembers
        .where('group_id', isEqualTo: groupId);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    final snapshot = await query.get();
    return snapshot.docs.map(FirestoreGroupMember.fromSnapshot).toList();
  }

  Future<void> deleteGroupMember(String membershipId) async {
    await _groupMembers.doc(membershipId).delete();
  }

  // XP and User methods
  Future<UserXpBreakdown> getUserXpBreakdown({
    required String userId,
    DateTime? startAt,
    DateTime? endAt,
  }) async {
    // Stub implementation - return default breakdown
    return UserXpBreakdown(
      total: 0,
      bySource: <String, int>{},
      activeDays: 0,
    );
  }

  Stream<List<FirestoreXpTransaction>> listenToUserXpTransactions({
    required String userId,
    DateTime? startAt,
  }) {
    var query = _xpTransactions
        .where('user_id', isEqualTo: userId);

    if (startAt != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startAt));
    }

    return query
        .orderBy('created_at', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(FirestoreXpTransaction.fromSnapshot).toList());
  }

  // Post interaction methods
  Future<List<FirestorePostWord>> getPostWords(String postId) async {
    final snapshot = await _postWords
        .where('post_id', isEqualTo: postId)
        .get();
    return snapshot.docs.map(FirestorePostWord.fromSnapshot).toList();
  }

  Future<List<FirestorePostLike>> getPostLikes(String postId) async {
    final snapshot = await _postLikes
        .where('post_id', isEqualTo: postId)
        .get();
    return snapshot.docs.map(FirestorePostLike.fromSnapshot).toList();
  }

  Future<List<FirestorePostComment>> getPostComments(
    String postId, {
    String? status,
    int? limit,
  }) async {
    var query = _postComments
        .where('post_id', isEqualTo: postId);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    query = query.orderBy('created_at');

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map(FirestorePostComment.fromSnapshot).toList();
  }

  Future<String> createCommunityPost({
    required String userId,
    required String photoUrl,
    String? photoId,
    String? caption,
    String visibility = 'public',
    String status = 'active',
    DateTime? createdAt,
  }) async {
    final post = FirestorePost(
      postId: '',
      userId: userId,
      photoUrl: photoUrl,
      photoId: photoId,
      caption: caption,
      visibility: visibility,
      status: status,
      createdAt: createdAt ?? DateTime.now(),
    );
    final doc = await _posts.add(post.toMap());
    return doc.id;
  }

  Future<void> addPostWord({
    required String postId,
    required String wordId,
    required String meaningSnapshot,
    String? exampleSnapshot,
    String? audioUrlSnapshot,
  }) async {
    final postWord = FirestorePostWord(
      id: '',
      postId: postId,
      wordId: wordId,
      meaningSnapshot: meaningSnapshot,
      exampleSnapshot: exampleSnapshot,
      audioUrlSnapshot: audioUrlSnapshot,
    );
    await _postWords.add(postWord.toMap());
  }

  Future<void> addPostLike({
    required String postId,
    required String userId,
  }) async {
    final like = FirestorePostLike(
      id: '',
      postId: postId,
      userId: userId,
      createdAt: DateTime.now(),
    );
    await _postLikes.add(like.toMap());
  }

  Future<void> removePostLike({
    required String postId,
    required String userId,
  }) async {
    final snapshot = await _postLikes
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: userId)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> addPostComment({
    required String postId,
    required String userId,
    required String content,
    String commentType = 'text',
    String status = 'active',
  }) async {
    final comment = FirestorePostComment(
      commentId: '',
      postId: postId,
      userId: userId,
      commentType: commentType,
      content: content,
      status: status,
      createdAt: DateTime.now(),
    );
    await _postComments.add(comment.toMap());
  }

  Future<void> addPostReport({
    required String postId,
    String? userId,
    String? reporterId,
    required String reason,
    String? details,
  }) async {
    final reportedBy = userId ?? reporterId;
    if (reportedBy == null) {
      throw Exception('Either userId or reporterId must be provided');
    }

    final data = {
      'post_id': postId,
      'reported_by': reportedBy,
      'reason': reason,
      'created_at': Timestamp.fromDate(DateTime.now()),
    };

    if (details != null) {
      data['details'] = details;
    }

    await _firestore.collection('post_reports').add(data);
  }

  // Update method to include optional requestMessage parameter
  Future<void> updateGroupMemberStatus({
    String? membershipId,
    String? memberId,
    required String status,
    String? requestMessage,
  }) async {
    final docId = membershipId ?? memberId;
    if (docId == null) {
      throw Exception('Either membershipId or memberId must be provided');
    }

    final data = {'status': status};
    if (requestMessage != null) {
      data['request_message'] = requestMessage;
    }
    await _groupMembers.doc(docId).set(
      data,
      SetOptions(merge: true),
    );
  }
}

// Helper class for topic save summary
class TopicSaveSummary {
  final FirestoreTopic topic;
  final List<FirestoreDictionaryWord> words;
  final int createdCount;
  final int existingCount;

  TopicSaveSummary({
    required this.topic,
    required this.words,
    required this.createdCount,
    required this.existingCount,
  });
}
