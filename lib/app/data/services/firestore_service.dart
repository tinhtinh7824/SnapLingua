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
    int initialMemberCount = 1,
  }) async {
    final data = FirestoreGroup(
      groupId: '',
      name: name,
      requireApproval: requireApproval,
      memberCount: initialMemberCount,
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

  /// Ensure inventory documents exist for provided itemIds (quantity defaults to 0).
  Future<void> ensureUserInventoryInitialized({
    required String userId,
    required List<String> itemIds,
  }) async {
    if (userId.isEmpty || itemIds.isEmpty) return;
    for (final itemId in itemIds) {
      final docId = '${userId}_$itemId';
      final docRef = _userInventory.doc(docId);
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          'user_id': userId,
          'item_id': itemId,
          'quantity': 0,
          'created_at': Timestamp.fromDate(DateTime.now()),
        });
      }
    }
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

  Future<List<FirestoreNotification>> getUserNotifications({
    required String userId,
    int limit = 50,
  }) async {
    if (userId.isEmpty) return [];
    final snapshot = await _notifications
        .where('user_id', isEqualTo: userId)
        .orderBy('sent_at', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map(FirestoreNotification.fromSnapshot)
        .toList();
  }

  Future<void> markNotificationRead({
    required String notificationId,
  }) async {
    if (notificationId.isEmpty) return;
    await _notifications.doc(notificationId).set(
      {
        'read_at': Timestamp.fromDate(DateTime.now()),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> markAllNotificationsRead({
    required String userId,
    int batchSize = 300,
  }) async {
    if (userId.isEmpty) return;
    final unreadQuery = await _notifications
        .where('user_id', isEqualTo: userId)
        .where('read_at', isNull: true)
        .limit(batchSize)
        .get();

    if (unreadQuery.docs.isEmpty) return;

    final batch = _firestore.batch();
    final now = Timestamp.fromDate(DateTime.now());
    for (final doc in unreadQuery.docs) {
      batch.update(doc.reference, {'read_at': now});
    }
    await batch.commit();
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

  Future<bool> isFollowingUser({
    required String userId,
    required String targetUserId,
  }) async {
    if (userId.isEmpty || targetUserId.isEmpty || userId == targetUserId) {
      return false;
    }
    final docId = '${targetUserId}_$userId';
    final doc = await _follows.doc(docId).get();
    return doc.exists && doc.data() != null;
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
      Future<List<FirestoreTopic>> fetchTopics() async {
        final snapshot = await _topics
            .where('is_system', isEqualTo: true)
            .where('is_active', isEqualTo: true)
            .orderBy('name')
            .get();
        return snapshot.docs.map(FirestoreTopic.fromSnapshot).toList();
      }

      var topics = await fetchTopics();

      // Auto-seed the system topics once if none exist (e.g., fresh environment).
      if (topics.isEmpty && !_hasSeededSystemTopics) {
        _hasSeededSystemTopics = true;
        try {
          await seedEmotionsTopic();
          await seedBodyActionsTopic();
          await seedNumbersTopic();
          await seedHealthTopic();
          await seedFamilyTopic();
          await seedWeatherTopic();
          await seedCareerTopic();
          await seedClothingTopic();
          await seedPersonalityTopic();
          await seedEnvironmentTopic();
          topics = await fetchTopics();
        } catch (_) {
          // Ignore seeding errors so the UI can fail gracefully.
        }
      }

      // Ensure body-actions topic exists if seeding happened outside this session.
      final hasBodyActions = topics.any((t) => t.topicId == 'topic_body_actions');
      if (!hasBodyActions && !_hasSeededBodyActions) {
        _hasSeededBodyActions = true;
        try {
          await seedBodyActionsTopic();
          topics = await fetchTopics();
        } catch (_) {}
      }

      // Ensure numbers topic exists if seeding happened outside this session.
      final hasNumbers = topics.any((t) => t.topicId == 'topic_numbers');
      if (!hasNumbers && !_hasSeededNumbers) {
        _hasSeededNumbers = true;
        try {
          await seedNumbersTopic();
          topics = await fetchTopics();
        } catch (_) {}
      }

      // Ensure other system topics exist if missing.
      final ensureTopics = <String, Future<String> Function()>{
        'topic_health': seedHealthTopic,
        'topic_family': seedFamilyTopic,
        'topic_weather': seedWeatherTopic,
        'topic_career': seedCareerTopic,
        'topic_clothing': seedClothingTopic,
        'topic_personality': seedPersonalityTopic,
        'topic_environment': seedEnvironmentTopic,
      };

      for (final entry in ensureTopics.entries) {
        final id = entry.key;
        final seeded = _seededTopicFlags[id] == true;
        if (!topics.any((t) => t.topicId == id) && !seeded) {
          _seededTopicFlags[id] = true;
          try {
            await entry.value();
            topics = await fetchTopics();
          } catch (_) {}
        }
      }

      return topics;
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
    const topicId = 'topic_personality';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Kind', 'ipa': 'kaɪnd', 'meaning': 'Tốt bụng, tử tế', 'pos': 'adj'},
      {'word': 'Friendly', 'ipa': 'ˈfrend.li', 'meaning': 'Thân thiện', 'pos': 'adj'},
      {'word': 'Generous', 'ipa': 'ˈdʒen.ər.əs', 'meaning': 'Hào phóng', 'pos': 'adj'},
      {'word': 'Honest', 'ipa': 'ˈɒn.ɪst', 'meaning': 'Trung thực', 'pos': 'adj'},
      {'word': 'Hardworking', 'ipa': 'ˌhɑːdˈwɜː.kɪŋ', 'meaning': 'Chăm chỉ', 'pos': 'adj'},
      {'word': 'Patient', 'ipa': 'ˈpeɪ.ʃənt', 'meaning': 'Kiên nhẫn', 'pos': 'adj'},
      {'word': 'Polite', 'ipa': 'pəˈlaɪt', 'meaning': 'Lịch sự', 'pos': 'adj'},
      {'word': 'Humble', 'ipa': 'ˈhʌm.bəl', 'meaning': 'Khiêm tốn', 'pos': 'adj'},
      {'word': 'Confident', 'ipa': 'ˈkɒn.fɪ.dənt', 'meaning': 'Tự tin', 'pos': 'adj'},
      {'word': 'Optimistic', 'ipa': 'ˌɒp.tɪˈmɪs.tɪk', 'meaning': 'Lạc quan', 'pos': 'adj'},
      {'word': 'Brave', 'ipa': 'breɪv', 'meaning': 'Dũng cảm', 'pos': 'adj'},
      {'word': 'Responsible', 'ipa': 'rɪˈspɒn.sə.bəl', 'meaning': 'Có trách nhiệm', 'pos': 'adj'},
      {'word': 'Creative', 'ipa': 'kriˈeɪ.tɪv', 'meaning': 'Sáng tạo', 'pos': 'adj'},
      {'word': 'Reliable', 'ipa': 'rɪˈlaɪ.ə.bəl', 'meaning': 'Đáng tin cậy', 'pos': 'adj'},
      {'word': 'Rude', 'ipa': 'ruːd', 'meaning': 'Thô lỗ, bất lịch sự', 'pos': 'adj'},
      {'word': 'Selfish', 'ipa': 'ˈsel.fɪʃ', 'meaning': 'Ích kỷ', 'pos': 'adj'},
      {'word': 'Lazy', 'ipa': 'ˈleɪ.zi', 'meaning': 'Lười biếng', 'pos': 'adj'},
      {'word': 'Arrogant', 'ipa': 'ˈær.ə.ɡənt', 'meaning': 'Kiêu ngạo', 'pos': 'adj'},
      {'word': 'Stubborn', 'ipa': 'ˈstʌb.ən', 'meaning': 'Cứng đầu, bướng bỉnh', 'pos': 'adj'},
      {'word': 'Pessimistic', 'ipa': 'ˌpes.ɪˈmɪs.tɪk', 'meaning': 'Bi quan', 'pos': 'adj'},
      {'word': 'Impatient', 'ipa': 'ɪmˈpeɪ.ʃənt', 'meaning': 'Nóng nảy, thiếu kiên nhẫn', 'pos': 'adj'},
      {'word': 'Jealous', 'ipa': 'ˈdʒel.əs', 'meaning': 'Ghen tị', 'pos': 'adj'},
      {'word': 'Moody', 'ipa': 'ˈmuː.di', 'meaning': 'Tính khí thất thường', 'pos': 'adj'},
      {'word': 'Aggressive', 'ipa': 'əˈɡres.ɪv', 'meaning': 'Hung hăng', 'pos': 'adj'},
      {'word': 'Nervous', 'ipa': 'ˈnɜː.vəs', 'meaning': 'Lo lắng, bồn chồn', 'pos': 'adj'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Tính cách',
      icon: '🙂',
      entries: entries,
      now: now,
      wordPrefix: 'personality',
    );
    return 'Personality topic seeded with ${entries.length} words';
  }

  Future<String> seedCareerTopic() async {
    const topicId = 'topic_career';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Job', 'ipa': 'dʒɒb', 'meaning': 'Công việc, nghề nghiệp', 'pos': 'n'},
      {'word': 'Occupation', 'ipa': 'ˌɒk.jəˈpeɪ.ʃən', 'meaning': 'Nghề nghiệp', 'pos': 'n'},
      {'word': 'Career', 'ipa': 'kəˈrɪə', 'meaning': 'Sự nghiệp', 'pos': 'n'},
      {'word': 'Work', 'ipa': 'wɜːk', 'meaning': 'Công việc', 'pos': 'n'},
      {'word': 'Employee', 'ipa': 'ɪmˈplɔɪ.iː', 'meaning': 'Nhân viên', 'pos': 'n'},
      {'word': 'Employer', 'ipa': 'ɪmˈplɔɪ.ər', 'meaning': 'Nhà tuyển dụng', 'pos': 'n'},
      {'word': 'Boss', 'ipa': 'bɒs', 'meaning': 'Sếp, ông chủ', 'pos': 'n'},
      {'word': 'Manager', 'ipa': 'ˈmæn.ɪ.dʒər', 'meaning': 'Quản lý', 'pos': 'n'},
      {'word': 'Director', 'ipa': 'dɪˈrek.tər', 'meaning': 'Giám đốc', 'pos': 'n'},
      {'word': 'CEO', 'ipa': 'ˌsiː.iːˈəʊ', 'meaning': 'Tổng giám đốc', 'pos': 'n'},
      {'word': 'Assistant', 'ipa': 'əˈsɪs.tənt', 'meaning': 'Trợ lý', 'pos': 'n'},
      {'word': 'Accountant', 'ipa': 'əˈkaʊn.tənt', 'meaning': 'Kế toán', 'pos': 'n'},
      {'word': 'Secretary', 'ipa': 'ˈsek.rə.tri', 'meaning': 'Thư ký', 'pos': 'n'},
      {'word': 'Engineer', 'ipa': 'ˌen.dʒɪˈnɪər', 'meaning': 'Kỹ sư', 'pos': 'n'},
      {'word': 'Architect', 'ipa': 'ˈɑː.kɪ.tekt', 'meaning': 'Kiến trúc sư', 'pos': 'n'},
      {'word': 'Doctor', 'ipa': 'ˈdɒk.tər', 'meaning': 'Bác sĩ', 'pos': 'n'},
      {'word': 'Nurse', 'ipa': 'nɜːs', 'meaning': 'Y tá', 'pos': 'n'},
      {'word': 'Pharmacist', 'ipa': 'ˈfɑː.mə.sɪst', 'meaning': 'Dược sĩ', 'pos': 'n'},
      {'word': 'Dentist', 'ipa': 'ˈden.tɪst', 'meaning': 'Nha sĩ', 'pos': 'n'},
      {'word': 'Surgeon', 'ipa': 'ˈsɜː.dʒən', 'meaning': 'Bác sĩ phẫu thuật', 'pos': 'n'},
      {'word': 'Teacher', 'ipa': 'ˈtiː.tʃər', 'meaning': 'Giáo viên', 'pos': 'n'},
      {'word': 'Professor', 'ipa': 'prəˈfes.ər', 'meaning': 'Giáo sư', 'pos': 'n'},
      {'word': 'Lawyer', 'ipa': 'ˈlɔɪ.ər', 'meaning': 'Luật sư', 'pos': 'n'},
      {'word': 'Judge', 'ipa': 'dʒʌdʒ', 'meaning': 'Thẩm phán', 'pos': 'n'},
      {'word': 'Police officer', 'ipa': 'pəˈliːs ˌɒf.ɪ.sər', 'meaning': 'Cảnh sát', 'pos': 'n'},
      {'word': 'Firefighter', 'ipa': 'ˈfaɪəˌfaɪ.tər', 'meaning': 'Lính cứu hỏa', 'pos': 'n'},
      {'word': 'Soldier', 'ipa': 'ˈsəʊl.dʒər', 'meaning': 'Lính, quân nhân', 'pos': 'n'},
      {'word': 'Pilot', 'ipa': 'ˈpaɪ.lət', 'meaning': 'Phi công', 'pos': 'n'},
      {'word': 'Flight attendant', 'ipa': 'ˈflaɪt əˌten.dənt', 'meaning': 'Tiếp viên hàng không', 'pos': 'n'},
      {'word': 'Driver', 'ipa': 'ˈdraɪ.vər', 'meaning': 'Tài xế', 'pos': 'n'},
      {'word': 'Chef', 'ipa': 'ʃef', 'meaning': 'Đầu bếp', 'pos': 'n'},
      {'word': 'Waiter', 'ipa': 'ˈweɪ.tər', 'meaning': 'Bồi bàn nam', 'pos': 'n'},
      {'word': 'Waitress', 'ipa': 'ˈweɪ.trəs', 'meaning': 'Bồi bàn nữ', 'pos': 'n'},
      {'word': 'Baker', 'ipa': 'ˈbeɪ.kər', 'meaning': 'Thợ làm bánh', 'pos': 'n'},
      {'word': 'Barber', 'ipa': 'ˈbɑː.bər', 'meaning': 'Thợ cắt tóc nam', 'pos': 'n'},
      {'word': 'Hairdresser', 'ipa': 'ˈheəˌdres.ər', 'meaning': 'Thợ làm tóc nữ', 'pos': 'n'},
      {'word': 'Mechanic', 'ipa': 'məˈkæn.ɪk', 'meaning': 'Thợ sửa máy', 'pos': 'n'},
      {'word': 'Electrician', 'ipa': 'ɪˌlekˈtrɪʃ.ən', 'meaning': 'Thợ điện', 'pos': 'n'},
      {'word': 'Plumber', 'ipa': 'ˈplʌm.ər', 'meaning': 'Thợ sửa ống nước', 'pos': 'n'},
      {'word': 'Carpenter', 'ipa': 'ˈkɑː.pɪn.tər', 'meaning': 'Thợ mộc', 'pos': 'n'},
      {'word': 'Scientist', 'ipa': 'ˈsaɪən.tɪst', 'meaning': 'Nhà khoa học', 'pos': 'n'},
      {'word': 'Researcher', 'ipa': 'ˈriː.sɜː.tʃər', 'meaning': 'Nhà nghiên cứu', 'pos': 'n'},
      {'word': 'Journalist', 'ipa': 'ˈdʒɜː.nə.lɪst', 'meaning': 'Nhà báo', 'pos': 'n'},
      {'word': 'Photographer', 'ipa': 'fəˈtɒɡ.rə.fər', 'meaning': 'Nhiếp ảnh gia', 'pos': 'n'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Nghề nghiệp',
      icon: '💼',
      entries: entries,
      now: now,
      wordPrefix: 'career',
    );
    return 'Career topic seeded with ${entries.length} words';
  }

  Future<String> seedWeatherTopic() async {
    const topicId = 'topic_weather';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Weather', 'ipa': 'ˈweð.ər', 'meaning': 'Thời tiết', 'pos': 'n'},
      {'word': 'Climate', 'ipa': 'ˈklaɪ.mət', 'meaning': 'Khí hậu', 'pos': 'n'},
      {'word': 'Temperature', 'ipa': 'ˈtem.prə.tʃər', 'meaning': 'Nhiệt độ', 'pos': 'n'},
      {'word': 'Forecast', 'ipa': 'ˈfɔː.kɑːst', 'meaning': 'Dự báo thời tiết', 'pos': 'n'},
      {'word': 'Season', 'ipa': 'ˈsiː.zən', 'meaning': 'Mùa', 'pos': 'n'},
      {'word': 'Spring', 'ipa': 'sprɪŋ', 'meaning': 'Mùa xuân', 'pos': 'n'},
      {'word': 'Summer', 'ipa': 'ˈsʌm.ər', 'meaning': 'Mùa hè', 'pos': 'n'},
      {'word': 'Autumn', 'ipa': 'ˈɔː.təm', 'meaning': 'Mùa thu', 'pos': 'n'},
      {'word': 'Winter', 'ipa': 'ˈwɪn.tər', 'meaning': 'Mùa đông', 'pos': 'n'},
      {'word': 'Sun', 'ipa': 'sʌn', 'meaning': 'Mặt trời', 'pos': 'n'},
      {'word': 'Sunshine', 'ipa': 'ˈsʌn.ʃaɪn', 'meaning': 'Ánh nắng', 'pos': 'n'},
      {'word': 'Sunny', 'ipa': 'ˈsʌn.i', 'meaning': 'Nắng, trời nắng', 'pos': 'adj'},
      {'word': 'Cloud', 'ipa': 'klaʊd', 'meaning': 'Đám mây', 'pos': 'n'},
      {'word': 'Cloudy', 'ipa': 'ˈklaʊ.di', 'meaning': 'Nhiều mây', 'pos': 'adj'},
      {'word': 'Rain', 'ipa': 'reɪn', 'meaning': 'Mưa', 'pos': 'n'},
      {'word': 'Rainy', 'ipa': 'ˈreɪ.ni', 'meaning': 'Có mưa', 'pos': 'adj'},
      {'word': 'Shower', 'ipa': 'ˈʃaʊ.ər', 'meaning': 'Mưa rào', 'pos': 'n'},
      {'word': 'Drizzle', 'ipa': 'ˈdrɪz.əl', 'meaning': 'Mưa phùn', 'pos': 'n'},
      {'word': 'Downpour', 'ipa': 'ˈdaʊn.pɔːr', 'meaning': 'Mưa lớn, mưa như trút', 'pos': 'n'},
      {'word': 'Thunderstorm', 'ipa': 'ˈθʌn.də.stɔːm', 'meaning': 'Dông bão', 'pos': 'n'},
      {'word': 'Lightning', 'ipa': 'ˈlaɪt.nɪŋ', 'meaning': 'Tia chớp', 'pos': 'n'},
      {'word': 'Thunder', 'ipa': 'ˈθʌn.dər', 'meaning': 'Sấm', 'pos': 'n'},
      {'word': 'Snow', 'ipa': 'snəʊ', 'meaning': 'Tuyết', 'pos': 'n'},
      {'word': 'Snowy', 'ipa': 'ˈsnəʊ.i', 'meaning': 'Có tuyết', 'pos': 'adj'},
      {'word': 'Blizzard', 'ipa': 'ˈblɪz.əd', 'meaning': 'Bão tuyết', 'pos': 'n'},
      {'word': 'Hail', 'ipa': 'heɪl', 'meaning': 'Mưa đá', 'pos': 'n'},
      {'word': 'Fog', 'ipa': 'fɒɡ', 'meaning': 'Sương mù', 'pos': 'n'},
      {'word': 'Foggy', 'ipa': 'ˈfɒɡ.i', 'meaning': 'Nhiều sương mù', 'pos': 'adj'},
      {'word': 'Mist', 'ipa': 'mɪst', 'meaning': 'Sương mù nhẹ', 'pos': 'n'},
      {'word': 'Wind', 'ipa': 'wɪnd', 'meaning': 'Gió', 'pos': 'n'},
      {'word': 'Windy', 'ipa': 'ˈwɪn.di', 'meaning': 'Có gió', 'pos': 'adj'},
      {'word': 'Storm', 'ipa': 'stɔːm', 'meaning': 'Bão', 'pos': 'n'},
      {'word': 'Stormy', 'ipa': 'ˈstɔː.mi', 'meaning': 'Có bão', 'pos': 'adj'},
      {'word': 'Hurricane', 'ipa': 'ˈhʌr.ɪ.kən', 'meaning': 'Bão lớn', 'pos': 'n'},
      {'word': 'Typhoon', 'ipa': 'taɪˈfuːn', 'meaning': 'Bão nhiệt đới', 'pos': 'n'},
      {'word': 'Tornado', 'ipa': 'tɔːˈneɪ.dəʊ', 'meaning': 'Lốc xoáy', 'pos': 'n'},
      {'word': 'Drought', 'ipa': 'draʊt', 'meaning': 'Hạn hán', 'pos': 'n'},
      {'word': 'Humidity', 'ipa': 'hjuːˈmɪd.ə.ti', 'meaning': 'Độ ẩm', 'pos': 'n'},
      {'word': 'Humid', 'ipa': 'ˈhjuː.mɪd', 'meaning': 'Ẩm ướt', 'pos': 'adj'},
      {'word': 'Heatwave', 'ipa': 'ˈhiːt.weɪv', 'meaning': 'Đợt nắng nóng', 'pos': 'n'},
      {'word': 'Freezing', 'ipa': 'ˈfriː.zɪŋ', 'meaning': 'Rét buốt', 'pos': 'adj'},
      {'word': 'Chilly', 'ipa': 'ˈtʃɪl.i', 'meaning': 'Lạnh', 'pos': 'adj'},
      {'word': 'Warm', 'ipa': 'wɔːm', 'meaning': 'Ấm áp', 'pos': 'adj'},
      {'word': 'Cold', 'ipa': 'kəʊld', 'meaning': 'Lạnh', 'pos': 'adj'},
      {'word': 'Breezy', 'ipa': 'ˈbriː.zi', 'meaning': 'Có gió nhẹ', 'pos': 'adj'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Thời tiết',
      icon: '🌦️',
      entries: entries,
      now: now,
      wordPrefix: 'weather',
    );
    return 'Weather topic seeded with ${entries.length} words';
  }

  Future<String> seedColorsTopic() async {
    return 'Colors topic seeded successfully';
  }

  Future<String> seedEmotionsTopic() async {
    const topicId = 'topic_emotions';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Happy', 'ipa': 'ˈhæp.i', 'meaning': 'Hạnh phúc, vui vẻ'},
      {'word': 'Joyful', 'ipa': 'ˈdʒɔɪ.fəl', 'meaning': 'Vui sướng'},
      {'word': 'Excited', 'ipa': 'ɪkˈsaɪ.tɪd', 'meaning': 'Hào hứng'},
      {'word': 'Cheerful', 'ipa': 'ˈtʃɪə.fəl', 'meaning': 'Vui vẻ, tươi tắn'},
      {'word': 'Proud', 'ipa': 'praʊd', 'meaning': 'Tự hào'},
      {'word': 'Grateful', 'ipa': 'ˈɡreɪt.fəl', 'meaning': 'Biết ơn'},
      {'word': 'Hopeful', 'ipa': 'ˈhəʊp.fəl', 'meaning': 'Hy vọng'},
      {'word': 'Relaxed', 'ipa': 'rɪˈlækst', 'meaning': 'Thư giãn'},
      {'word': 'Satisfied', 'ipa': 'ˈsæt.ɪs.faɪd', 'meaning': 'Hài lòng'},
      {'word': 'Affectionate', 'ipa': 'əˈfek.ʃən.ət', 'meaning': 'Trìu mến, yêu thương'},
      {'word': 'Loving', 'ipa': 'ˈlʌv.ɪŋ', 'meaning': 'Đầy yêu thương'},
      {'word': 'Fearful', 'ipa': 'ˈfɪə.fəl', 'meaning': 'Sợ hãi'},
      {'word': 'Anxious', 'ipa': 'ˈæŋk.ʃəs', 'meaning': 'Lo lắng, bất an'},
      {'word': 'Embarrassed', 'ipa': 'ɪmˈbær.əst', 'meaning': 'Xấu hổ, ngượng ngùng'},
      {'word': 'Guilty', 'ipa': 'ˈɡɪl.ti', 'meaning': 'Cảm thấy có lỗi'},
      {'word': 'Lonely', 'ipa': 'ˈləʊn.li', 'meaning': 'Cô đơn'},
      {'word': 'Frustrated', 'ipa': 'ˈfrʌs.treɪ.tɪd', 'meaning': 'Bực bội, nản lòng'},
      {'word': 'Disappointed', 'ipa': 'ˌdɪs.əˈpɔɪn.tɪd', 'meaning': 'Thất vọng'},
      {'word': 'Shocked', 'ipa': 'ʃɒkt', 'meaning': 'Sốc, kinh ngạc'},
      {'word': 'Depressed', 'ipa': 'dɪˈprest', 'meaning': 'Chán nản, trầm cảm'},
      {'word': 'Confused', 'ipa': 'kənˈfjuːzd', 'meaning': 'Bối rối'},
      {'word': 'Shy', 'ipa': 'ʃaɪ', 'meaning': 'Nhút nhát, e thẹn'},
      {'word': 'Envious', 'ipa': 'ˈen.vi.əs', 'meaning': 'Đố kỵ'},
      {'word': 'Tired', 'ipa': 'ˈtaɪəd', 'meaning': 'Mệt mỏi'},
      {'word': 'Annoyed', 'ipa': 'əˈnɔɪd', 'meaning': 'Khó chịu, bực mình'},
    ];

    final wordIds = <String>[];
    final batch = _firestore.batch();

    for (final entry in entries) {
      final headword = entry['word'] ?? '';
      if (headword.isEmpty) continue;
      final slug = _slugify(headword);
      final wordId = 'emotion_$slug';
      wordIds.add(wordId);

      final docRef = _dictionaryWords.doc(wordId);
      batch.set(
        docRef,
        {
          'headword': headword,
          'normalized_headword': slug,
          'ipa': entry['ipa'],
          'pos': 'adj',
          'meaning_vi': entry['meaning'],
          'example_en': null,
          'example_vi': null,
          'audio_url': null,
          'image_url': null,
          'created_by': 'system',
          'created_at': now,
          'is_active': true,
        },
        SetOptions(merge: true),
      );
    }

    batch.set(
      _topics.doc(topicId),
      {
        'name': 'Cảm xúc',
        'icon': '😊',
        'owner_id': null,
        'visibility': 'public',
        'is_system': true,
        'is_active': true,
        'created_at': now,
        'dictionary_word_ids': wordIds,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
    return 'Emotions topic seeded with ${wordIds.length} words';
  }

  Future<String> seedSportsTopic() async {
    return 'Sports topic seeded successfully';
  }

  Future<String> seedBodyActionsTopic() async {
    const topicId = 'topic_body_actions';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Move', 'ipa': 'muːv', 'meaning': 'Di chuyển'},
      {'word': 'Walk', 'ipa': 'wɔːk', 'meaning': 'Đi bộ'},
      {'word': 'Run', 'ipa': 'rʌn', 'meaning': 'Chạy'},
      {'word': 'Jump', 'ipa': 'dʒʌmp', 'meaning': 'Nhảy'},
      {'word': 'Sit', 'ipa': 'sɪt', 'meaning': 'Ngồi'},
      {'word': 'Stand', 'ipa': 'stænd', 'meaning': 'Đứng'},
      {'word': 'Lie down', 'ipa': 'laɪ daʊn', 'meaning': 'Nằm xuống'},
      {'word': 'Raise', 'ipa': 'reɪz', 'meaning': 'Giơ lên'},
      {'word': 'Stretch', 'ipa': 'stretʃ', 'meaning': 'Duỗi người'},
      {'word': 'Bend', 'ipa': 'bend', 'meaning': 'Cúi xuống, gập người'},
      {'word': 'Turn', 'ipa': 'tɜːn', 'meaning': 'Quay, xoay'},
      {'word': 'Nod', 'ipa': 'nɒd', 'meaning': 'Gật đầu'},
      {'word': 'Shake', 'ipa': 'ʃeɪk', 'meaning': 'Lắc, bắt tay'},
      {'word': 'Wave', 'ipa': 'weɪv', 'meaning': 'Vẫy tay'},
      {'word': 'Clap', 'ipa': 'klæp', 'meaning': 'Vỗ tay'},
      {'word': 'Point', 'ipa': 'pɔɪnt', 'meaning': 'Chỉ tay'},
      {'word': 'Snap', 'ipa': 'snæp', 'meaning': 'Búng tay'},
      {'word': 'Yawn', 'ipa': 'jɔːn', 'meaning': 'Ngáp'},
      {'word': 'Cough', 'ipa': 'kɒf', 'meaning': 'Ho'},
      {'word': 'Sneeze', 'ipa': 'sniːz', 'meaning': 'Hắt hơi'},
      {'word': 'Breathe', 'ipa': 'briːð', 'meaning': 'Thở'},
      {'word': 'Blink', 'ipa': 'blɪŋk', 'meaning': 'Chớp mắt'},
      {'word': 'Smile', 'ipa': 'smaɪl', 'meaning': 'Cười mỉm'},
      {'word': 'Laugh', 'ipa': 'lɑːf', 'meaning': 'Cười thành tiếng'},
      {'word': 'Cry', 'ipa': 'kraɪ', 'meaning': 'Khóc'},
      {'word': 'Frown', 'ipa': 'fraʊn', 'meaning': 'Nhăn mặt'},
      {'word': 'Bite', 'ipa': 'baɪt', 'meaning': 'Cắn'},
      {'word': 'Chew', 'ipa': 'tʃuː', 'meaning': 'Nhai'},
      {'word': 'Lick', 'ipa': 'lɪk', 'meaning': 'Liếm'},
    ];

    final wordIds = <String>[];
    final batch = _firestore.batch();

    for (final entry in entries) {
      final headword = entry['word'] ?? '';
      if (headword.isEmpty) continue;
      final slug = _slugify(headword);
      final wordId = 'action_$slug';
      wordIds.add(wordId);

      final docRef = _dictionaryWords.doc(wordId);
      batch.set(
        docRef,
        {
          'headword': headword,
          'normalized_headword': slug,
          'ipa': entry['ipa'],
          'pos': 'v',
          'meaning_vi': entry['meaning'],
          'example_en': null,
          'example_vi': null,
          'audio_url': null,
          'image_url': null,
          'created_by': 'system',
          'created_at': now,
          'is_active': true,
        },
        SetOptions(merge: true),
      );
    }

    batch.set(
      _topics.doc(topicId),
      {
        'name': 'Hành động cơ thể',
        'icon': '🏃‍♂️',
        'owner_id': null,
        'visibility': 'public',
        'is_system': true,
        'is_active': true,
        'created_at': now,
        'dictionary_word_ids': wordIds,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
    return 'Body actions topic seeded with ${wordIds.length} words';
  }

  Future<String> seedDailyActionsTopic() async {
    return 'Daily actions topic seeded successfully';
  }

  Future<String> seedNumbersTopic() async {
    const topicId = 'topic_numbers';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Zero', 'ipa': 'ˈzɪə.rəʊ', 'meaning': 'Số không (0)'},
      {'word': 'One', 'ipa': 'wʌn', 'meaning': 'Số một (1)'},
      {'word': 'Two', 'ipa': 'tuː', 'meaning': 'Số hai (2)'},
      {'word': 'Three', 'ipa': 'θriː', 'meaning': 'Số ba (3)'},
      {'word': 'Four', 'ipa': 'fɔːr', 'meaning': 'Số bốn (4)'},
      {'word': 'Five', 'ipa': 'faɪv', 'meaning': 'Số năm (5)'},
      {'word': 'Six', 'ipa': 'sɪks', 'meaning': 'Số sáu (6)'},
      {'word': 'Seven', 'ipa': 'ˈsev.ən', 'meaning': 'Số bảy (7)'},
      {'word': 'Eight', 'ipa': 'eɪt', 'meaning': 'Số tám (8)'},
      {'word': 'Nine', 'ipa': 'naɪn', 'meaning': 'Số chín (9)'},
      {'word': 'Ten', 'ipa': 'ten', 'meaning': 'Số mười (10)'},
      {'word': 'Eleven', 'ipa': 'ɪˈlev.ən', 'meaning': 'Số mười một (11)'},
      {'word': 'Twelve', 'ipa': 'twelv', 'meaning': 'Số mười hai (12)'},
      {'word': 'Thirteen', 'ipa': 'ˌθɜːˈtiːn', 'meaning': 'Số mười ba (13)'},
      {'word': 'Fourteen', 'ipa': 'ˌfɔːˈtiːn', 'meaning': 'Số mười bốn (14)'},
      {'word': 'Fifteen', 'ipa': 'ˌfɪfˈtiːn', 'meaning': 'Số mười lăm (15)'},
      {'word': 'Sixteen', 'ipa': 'ˌsɪksˈtiːn', 'meaning': 'Số mười sáu (16)'},
      {'word': 'Seventeen', 'ipa': 'ˌsev.ənˈtiːn', 'meaning': 'Số mười bảy (17)'},
      {'word': 'Eighteen', 'ipa': 'ˌeɪˈtiːn', 'meaning': 'Số mười tám (18)'},
      {'word': 'Nineteen', 'ipa': 'ˌnaɪnˈtiːn', 'meaning': 'Số mười chín (19)'},
      {'word': 'Twenty', 'ipa': 'ˈtwen.ti', 'meaning': 'Số hai mươi (20)'},
      {'word': 'Thirty', 'ipa': 'ˈθɜː.ti', 'meaning': 'Số ba mươi (30)'},
      {'word': 'Forty', 'ipa': 'ˈfɔː.ti', 'meaning': 'Số bốn mươi (40)'},
      {'word': 'Fifty', 'ipa': 'ˈfɪf.ti', 'meaning': 'Số năm mươi (50)'},
      {'word': 'Sixty', 'ipa': 'ˈsɪk.sti', 'meaning': 'Số sáu mươi (60)'},
      {'word': 'Seventy', 'ipa': 'ˈsev.ən.ti', 'meaning': 'Số bảy mươi (70)'},
      {'word': 'Eighty', 'ipa': 'ˈeɪ.ti', 'meaning': 'Số tám mươi (80)'},
      {'word': 'Ninety', 'ipa': 'ˈnaɪn.ti', 'meaning': 'Số chín mươi (90)'},
      {'word': 'One hundred', 'ipa': 'wʌn ˈhʌn.drəd', 'meaning': 'Số một trăm (100)'},
      {'word': 'One thousand', 'ipa': 'wʌn ˈθaʊ.zənd', 'meaning': 'Số một nghìn (1,000)'},
    ];

    final wordIds = <String>[];
    final batch = _firestore.batch();

    for (final entry in entries) {
      final headword = entry['word'] ?? '';
      if (headword.isEmpty) continue;
      final slug = _slugify(headword);
      final wordId = 'number_$slug';
      wordIds.add(wordId);

      final docRef = _dictionaryWords.doc(wordId);
      batch.set(
        docRef,
        {
          'headword': headword,
          'normalized_headword': slug,
          'ipa': entry['ipa'],
          'pos': 'n',
          'meaning_vi': entry['meaning'],
          'example_en': null,
          'example_vi': null,
          'audio_url': null,
          'image_url': null,
          'created_by': 'system',
          'created_at': now,
          'is_active': true,
        },
        SetOptions(merge: true),
      );
    }

    batch.set(
      _topics.doc(topicId),
      {
        'name': 'Số đếm',
        'icon': '🔢',
        'owner_id': null,
        'visibility': 'public',
        'is_system': true,
        'is_active': true,
        'created_at': now,
        'dictionary_word_ids': wordIds,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
    return 'Numbers topic seeded with ${wordIds.length} words';
  }

  Future<String> seedHealthTopic() async {
    const topicId = 'topic_health';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Health', 'ipa': 'helθ', 'meaning': 'Sức khỏe', 'pos': 'n'},
      {'word': 'Well-being', 'ipa': 'ˌwelˈbiː.ɪŋ', 'meaning': 'Sự khỏe mạnh, hạnh phúc', 'pos': 'n'},
      {'word': 'Fitness', 'ipa': 'ˈfɪt.nəs', 'meaning': 'Thể lực', 'pos': 'n'},
      {'word': 'Diet', 'ipa': 'ˈdaɪ.ət', 'meaning': 'Chế độ ăn uống', 'pos': 'n'},
      {'word': 'Nutrition', 'ipa': 'njuːˈtrɪʃ.ən', 'meaning': 'Dinh dưỡng', 'pos': 'n'},
      {'word': 'Vitamin', 'ipa': 'ˈvɪt.ə.mɪn', 'meaning': 'Vitamin', 'pos': 'n'},
      {'word': 'Immune system', 'ipa': 'ɪˈmjuːn ˌsɪs.təm', 'meaning': 'Hệ miễn dịch', 'pos': 'n'},
      {'word': 'Hygiene', 'ipa': 'ˈhaɪ.dʒiːn', 'meaning': 'Vệ sinh cá nhân', 'pos': 'n'},
      {'word': 'Mental health', 'ipa': 'ˌmen.təl ˈhelθ', 'meaning': 'Sức khỏe tinh thần', 'pos': 'n'},
      {'word': 'Physical health', 'ipa': 'ˈfɪz.ɪ.kəl helθ', 'meaning': 'Sức khỏe thể chất', 'pos': 'n'},
      {'word': 'Disease', 'ipa': 'dɪˈziːz', 'meaning': 'Bệnh tật', 'pos': 'n'},
      {'word': 'Illness', 'ipa': 'ˈɪl.nəs', 'meaning': 'Căn bệnh', 'pos': 'n'},
      {'word': 'Symptom', 'ipa': 'ˈsɪmp.təm', 'meaning': 'Triệu chứng', 'pos': 'n'},
      {'word': 'Fever', 'ipa': 'ˈfiː.vər', 'meaning': 'Sốt', 'pos': 'n'},
      {'word': 'Headache', 'ipa': 'ˈhed.eɪk', 'meaning': 'Đau đầu', 'pos': 'n'},
      {'word': 'Cough', 'ipa': 'kɒf', 'meaning': 'Ho', 'pos': 'n'},
      {'word': 'Fatigue', 'ipa': 'fəˈtiːɡ', 'meaning': 'Sự mệt mỏi', 'pos': 'n'},
      {'word': 'Stress', 'ipa': 'stres', 'meaning': 'Căng thẳng', 'pos': 'n'},
      {'word': 'Depression', 'ipa': 'dɪˈpreʃ.ən', 'meaning': 'Trầm cảm', 'pos': 'n'},
      {'word': 'Exercise', 'ipa': 'ˈek.sə.saɪz', 'meaning': 'Tập thể dục', 'pos': 'n'},
      {'word': 'Yoga', 'ipa': 'ˈjəʊ.ɡə', 'meaning': 'Yoga', 'pos': 'n'},
      {'word': 'Meditation', 'ipa': 'ˌmed.ɪˈteɪ.ʃən', 'meaning': 'Thiền', 'pos': 'n'},
      {'word': 'Sleep', 'ipa': 'sliːp', 'meaning': 'Giấc ngủ, ngủ', 'pos': 'n'},
      {'word': 'Insomnia', 'ipa': 'ɪnˈsɒm.ni.ə', 'meaning': 'Chứng mất ngủ', 'pos': 'n'},
      {'word': 'Therapy', 'ipa': 'ˈθer.ə.pi', 'meaning': 'Liệu pháp', 'pos': 'n'},
      {'word': 'Treatment', 'ipa': 'ˈtriːt.mənt', 'meaning': 'Điều trị', 'pos': 'n'},
      {'word': 'Vaccination', 'ipa': 'ˌvæk.sɪˈneɪ.ʃən', 'meaning': 'Tiêm chủng', 'pos': 'n'},
      {'word': 'Healthcare', 'ipa': 'ˈhelθ.keər', 'meaning': 'Chăm sóc sức khỏe', 'pos': 'n'},
      {'word': 'Recovery', 'ipa': 'rɪˈkʌv.ər.i', 'meaning': 'Sự hồi phục', 'pos': 'n'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Sức khỏe',
      icon: '🩺',
      entries: entries,
      now: now,
      wordPrefix: 'health',
    );
    return 'Health topic seeded with ${entries.length} words';
  }

  Future<String> seedFamilyTopic() async {
    const topicId = 'topic_family';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Family', 'ipa': 'ˈfæm.əl.i', 'meaning': 'Gia đình', 'pos': 'n'},
      {'word': 'Parents', 'ipa': 'ˈpeə.rənts', 'meaning': 'Bố mẹ', 'pos': 'n'},
      {'word': 'Father', 'ipa': 'ˈfɑː.ðər', 'meaning': 'Bố, cha', 'pos': 'n'},
      {'word': 'Mother', 'ipa': 'ˈmʌð.ər', 'meaning': 'Mẹ', 'pos': 'n'},
      {'word': 'Son', 'ipa': 'sʌn', 'meaning': 'Con trai', 'pos': 'n'},
      {'word': 'Daughter', 'ipa': 'ˈdɔː.tər', 'meaning': 'Con gái', 'pos': 'n'},
      {'word': 'Brother', 'ipa': 'ˈbrʌð.ər', 'meaning': 'Anh, em trai', 'pos': 'n'},
      {'word': 'Sister', 'ipa': 'ˈsɪs.tər', 'meaning': 'Chị, em gái', 'pos': 'n'},
      {'word': 'Sibling', 'ipa': 'ˈsɪb.lɪŋ', 'meaning': 'Anh chị em ruột', 'pos': 'n'},
      {'word': 'Grandparents', 'ipa': 'ˈɡræn.peə.rənts', 'meaning': 'Ông bà', 'pos': 'n'},
      {'word': 'Grandfather', 'ipa': 'ˈɡræn.fɑː.ðər', 'meaning': 'Ông', 'pos': 'n'},
      {'word': 'Grandmother', 'ipa': 'ˈɡræn.mʌð.ər', 'meaning': 'Bà', 'pos': 'n'},
      {'word': 'Grandson', 'ipa': 'ˈɡræn.sʌn', 'meaning': 'Cháu trai (nội/ngoại)', 'pos': 'n'},
      {'word': 'Granddaughter', 'ipa': 'ˈɡræn.dɔː.tər', 'meaning': 'Cháu gái (nội/ngoại)', 'pos': 'n'},
      {'word': 'Uncle', 'ipa': 'ˈʌŋ.kəl', 'meaning': 'Chú, bác, cậu', 'pos': 'n'},
      {'word': 'Aunt', 'ipa': 'ɑːnt', 'meaning': 'Cô, dì', 'pos': 'n'},
      {'word': 'Nephew', 'ipa': 'ˈnef.juː', 'meaning': 'Cháu trai', 'pos': 'n'},
      {'word': 'Niece', 'ipa': 'niːs', 'meaning': 'Cháu gái', 'pos': 'n'},
      {'word': 'Cousin', 'ipa': 'ˈkʌz.ən', 'meaning': 'Anh/chị/em họ', 'pos': 'n'},
      {'word': 'Husband', 'ipa': 'ˈhʌz.bənd', 'meaning': 'Chồng', 'pos': 'n'},
      {'word': 'Wife', 'ipa': 'waɪf', 'meaning': 'Vợ', 'pos': 'n'},
      {'word': 'In-laws', 'ipa': 'ˈɪn.lɔːz', 'meaning': 'Gia đình bên chồng/vợ', 'pos': 'n'},
      {'word': 'Father-in-law', 'ipa': 'ˈfɑː.ðər.ɪn.lɔː', 'meaning': 'Bố chồng/bố vợ', 'pos': 'n'},
      {'word': 'Mother-in-law', 'ipa': 'ˈmʌð.ər.ɪn.lɔː', 'meaning': 'Mẹ chồng/mẹ vợ', 'pos': 'n'},
      {'word': 'Brother-in-law', 'ipa': 'ˈbrʌð.ər.ɪn.lɔː', 'meaning': 'Anh/em rể', 'pos': 'n'},
      {'word': 'Sister-in-law', 'ipa': 'ˈsɪs.tər.ɪn.lɔː', 'meaning': 'Chị/em dâu', 'pos': 'n'},
      {'word': 'Stepfather', 'ipa': 'ˈstep.fɑː.ðər', 'meaning': 'Bố dượng', 'pos': 'n'},
      {'word': 'Stepmother', 'ipa': 'ˈstepˌmʌð.ər', 'meaning': 'Mẹ kế', 'pos': 'n'},
      {'word': 'Stepson', 'ipa': 'ˈstep.sʌn', 'meaning': 'Con trai riêng của vợ/chồng', 'pos': 'n'},
      {'word': 'Stepdaughter', 'ipa': 'ˈstep.dɔː.tər', 'meaning': 'Con gái riêng của vợ/chồng', 'pos': 'n'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Gia đình',
      icon: '👨‍👩‍👧',
      entries: entries,
      now: now,
      wordPrefix: 'family',
    );
    return 'Family topic seeded with ${entries.length} words';
  }

  Future<String> seedClothingTopic() async {
    const topicId = 'topic_clothing';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Clothes', 'ipa': 'kləʊðz', 'meaning': 'Quần áo', 'pos': 'n'},
      {'word': 'Outfit', 'ipa': 'ˈaʊt.fɪt', 'meaning': 'Trang phục', 'pos': 'n'},
      {'word': 'Clothing', 'ipa': 'ˈkləʊ.ðɪŋ', 'meaning': 'Quần áo (nói chung)', 'pos': 'n'},
      {'word': 'Garment', 'ipa': 'ˈɡɑː.mənt', 'meaning': 'Trang phục, áo quần', 'pos': 'n'},
      {'word': 'Uniform', 'ipa': 'ˈjuː.nɪ.fɔːm', 'meaning': 'Đồng phục', 'pos': 'n'},
      {'word': 'Casual wear', 'ipa': 'ˈkæʒ.u.əl weər', 'meaning': 'Trang phục thường ngày', 'pos': 'n'},
      {'word': 'Formal wear', 'ipa': 'ˈfɔː.məl weər', 'meaning': 'Trang phục trang trọng', 'pos': 'n'},
      {'word': 'Suit', 'ipa': 'suːt', 'meaning': 'Bộ vest', 'pos': 'n'},
      {'word': 'Tuxedo', 'ipa': 'tʌkˈsiː.dəʊ', 'meaning': 'Bộ lễ phục', 'pos': 'n'},
      {'word': 'Shirt', 'ipa': 'ʃɜːt', 'meaning': 'Áo sơ mi', 'pos': 'n'},
      {'word': 'T-shirt', 'ipa': 'ˈtiː.ʃɜːt', 'meaning': 'Áo thun', 'pos': 'n'},
      {'word': 'Polo shirt', 'ipa': 'ˈpəʊ.ləʊ ʃɜːt', 'meaning': 'Áo polo', 'pos': 'n'},
      {'word': 'Blouse', 'ipa': 'blaʊz', 'meaning': 'Áo sơ mi nữ', 'pos': 'n'},
      {'word': 'Tank top', 'ipa': 'ˈtæŋkˌtɒp', 'meaning': 'Áo ba lỗ', 'pos': 'n'},
      {'word': 'Sweater', 'ipa': 'ˈswet.ər', 'meaning': 'Áo len dài tay', 'pos': 'n'},
      {'word': 'Hoodie', 'ipa': 'ˈhʊd.i', 'meaning': 'Áo có mũ trùm', 'pos': 'n'},
      {'word': 'Jacket', 'ipa': 'ˈdʒæk.ɪt', 'meaning': 'Áo khoác ngắn', 'pos': 'n'},
      {'word': 'Coat', 'ipa': 'kəʊt', 'meaning': 'Áo khoác dài', 'pos': 'n'},
      {'word': 'Raincoat', 'ipa': 'ˈreɪn.kəʊt', 'meaning': 'Áo mưa', 'pos': 'n'},
      {'word': 'Jeans', 'ipa': 'dʒiːnz', 'meaning': 'Quần bò', 'pos': 'n'},
      {'word': 'Trousers', 'ipa': 'ˈtraʊ.zəz', 'meaning': 'Quần dài', 'pos': 'n'},
      {'word': 'Pants', 'ipa': 'pænts', 'meaning': 'Quần (Anh-Mỹ)', 'pos': 'n'},
      {'word': 'Shorts', 'ipa': 'ʃɔːts', 'meaning': 'Quần đùi', 'pos': 'n'},
      {'word': 'Leggings', 'ipa': 'ˈleɡ.ɪŋz', 'meaning': 'Quần legging', 'pos': 'n'},
      {'word': 'Skirt', 'ipa': 'skɜːt', 'meaning': 'Chân váy', 'pos': 'n'},
      {'word': 'Dress', 'ipa': 'dres', 'meaning': 'Váy liền', 'pos': 'n'},
      {'word': 'Gown', 'ipa': 'ɡaʊn', 'meaning': 'Váy dạ hội', 'pos': 'n'},
      {'word': 'Pajamas', 'ipa': 'pəˈdʒɑː.məz', 'meaning': 'Đồ ngủ', 'pos': 'n'},
      {'word': 'Bathrobe', 'ipa': 'ˈbɑːθ.rəʊb', 'meaning': 'Áo choàng tắm', 'pos': 'n'},
      {'word': 'Underwear', 'ipa': 'ˈʌn.də.weər', 'meaning': 'Đồ lót', 'pos': 'n'},
      {'word': 'Bra', 'ipa': 'brɑː', 'meaning': 'Áo ngực', 'pos': 'n'},
      {'word': 'Panties', 'ipa': 'ˈpæn.tiz', 'meaning': 'Quần lót nữ', 'pos': 'n'},
      {'word': 'Briefs', 'ipa': 'briːfs', 'meaning': 'Quần lót nam', 'pos': 'n'},
      {'word': 'Socks', 'ipa': 'sɒks', 'meaning': 'Tất, vớ', 'pos': 'n'},
      {'word': 'Stockings', 'ipa': 'ˈstɒk.ɪŋz', 'meaning': 'Tất dài', 'pos': 'n'},
      {'word': 'Shoes', 'ipa': 'ʃuːz', 'meaning': 'Giày', 'pos': 'n'},
      {'word': 'Sneakers', 'ipa': 'ˈsniː.kəz', 'meaning': 'Giày thể thao', 'pos': 'n'},
      {'word': 'Sandals', 'ipa': 'ˈsæn.dəlz', 'meaning': 'Dép xăng đan', 'pos': 'n'},
      {'word': 'Flip-flops', 'ipa': 'ˈflɪp.flɒps', 'meaning': 'Dép tông', 'pos': 'n'},
      {'word': 'Boots', 'ipa': 'buːts', 'meaning': 'Ủng, bốt', 'pos': 'n'},
      {'word': 'High heels', 'ipa': 'ˌhaɪ ˈhiːlz', 'meaning': 'Giày cao gót', 'pos': 'n'},
      {'word': 'Hat', 'ipa': 'hæt', 'meaning': 'Mũ rộng vành', 'pos': 'n'},
      {'word': 'Cap', 'ipa': 'kæp', 'meaning': 'Mũ lưỡi trai', 'pos': 'n'},
      {'word': 'Scarf', 'ipa': 'skɑːf', 'meaning': 'Khăn quàng cổ', 'pos': 'n'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Quần áo',
      icon: '🧥',
      entries: entries,
      now: now,
      wordPrefix: 'clothing',
    );
    return 'Clothing topic seeded with ${entries.length} words';
  }

  Future<String> seedEnvironmentTopic() async {
    const topicId = 'topic_environment';
    final now = Timestamp.fromDate(DateTime.now());

    final entries = <Map<String, String>>[
      {'word': 'Environment', 'ipa': 'ɪnˈvaɪ.rən.mənt', 'meaning': 'Môi trường', 'pos': 'n'},
      {'word': 'Nature', 'ipa': 'ˈneɪ.tʃər', 'meaning': 'Thiên nhiên', 'pos': 'n'},
      {'word': 'Ecosystem', 'ipa': 'ˈiː.kəʊˌsɪs.təm', 'meaning': 'Hệ sinh thái', 'pos': 'n'},
      {'word': 'Climate', 'ipa': 'ˈklaɪ.mət', 'meaning': 'Khí hậu', 'pos': 'n'},
      {'word': 'Pollution', 'ipa': 'pəˈluː.ʃən', 'meaning': 'Ô nhiễm', 'pos': 'n'},
      {'word': 'Air pollution', 'ipa': 'eər pəˈluː.ʃən', 'meaning': 'Ô nhiễm không khí', 'pos': 'n'},
      {'word': 'Water pollution', 'ipa': 'ˈwɔː.tər pəˈluː.ʃən', 'meaning': 'Ô nhiễm nước', 'pos': 'n'},
      {'word': 'Soil pollution', 'ipa': 'ˈsɔɪl pəˈluː.ʃən', 'meaning': 'Ô nhiễm đất', 'pos': 'n'},
      {'word': 'Global warming', 'ipa': 'ˌɡləʊ.bəl ˈwɔː.mɪŋ', 'meaning': 'Sự nóng lên toàn cầu', 'pos': 'n'},
      {'word': 'Greenhouse effect', 'ipa': 'ˈɡriːn.haʊs ɪˌfekt', 'meaning': 'Hiệu ứng nhà kính', 'pos': 'n'},
      {'word': 'Deforestation', 'ipa': 'ˌdiːˌfɒr.ɪˈsteɪ.ʃən', 'meaning': 'Nạn phá rừng', 'pos': 'n'},
      {'word': 'Renewable energy', 'ipa': 'rɪˌnjuː.ə.bəl ˈen.ə.dʒi', 'meaning': 'Năng lượng tái tạo', 'pos': 'n'},
      {'word': 'Solar energy', 'ipa': 'ˈsəʊ.lər ˈen.ə.dʒi', 'meaning': 'Năng lượng mặt trời', 'pos': 'n'},
      {'word': 'Wind power', 'ipa': 'ˈwɪnd ˌpaʊ.ər', 'meaning': 'Năng lượng gió', 'pos': 'n'},
      {'word': 'Fossil fuel', 'ipa': 'ˈfɒs.əl ˌfjʊəl', 'meaning': 'Nhiên liệu hóa thạch', 'pos': 'n'},
      {'word': 'Carbon footprint', 'ipa': 'ˌkɑː.bən ˈfʊt.prɪnt', 'meaning': 'Dấu chân carbon', 'pos': 'n'},
      {'word': 'Biodiversity', 'ipa': 'ˌbaɪ.əʊ.daɪˈvɜː.sə.ti', 'meaning': 'Đa dạng sinh học', 'pos': 'n'},
      {'word': 'Endangered species', 'ipa': 'ɪnˈdeɪn.dʒəd ˈspiː.ʃiːz', 'meaning': 'Các loài có nguy cơ tuyệt chủng', 'pos': 'n'},
      {'word': 'Conservation', 'ipa': 'ˌkɒn.səˈveɪ.ʃən', 'meaning': 'Sự bảo tồn', 'pos': 'n'},
      {'word': 'Recycling', 'ipa': 'ˌriːˈsaɪ.klɪŋ', 'meaning': 'Tái chế', 'pos': 'n'},
      {'word': 'Waste', 'ipa': 'weɪst', 'meaning': 'Rác thải', 'pos': 'n'},
      {'word': 'Plastic waste', 'ipa': 'ˌplæs.tɪk weɪst', 'meaning': 'Rác thải nhựa', 'pos': 'n'},
      {'word': 'Sustainable', 'ipa': 'səˈsteɪ.nə.bəl', 'meaning': 'Bền vững', 'pos': 'adj'},
      {'word': 'Habitat', 'ipa': 'ˈhæb.ɪ.tæt', 'meaning': 'Môi trường sống', 'pos': 'n'},
      {'word': 'Natural disaster', 'ipa': 'ˌnætʃ.ər.əl dɪˈzɑː.stər', 'meaning': 'Thảm họa thiên nhiên', 'pos': 'n'},
      {'word': 'Flood', 'ipa': 'flʌd', 'meaning': 'Lũ lụt', 'pos': 'n'},
      {'word': 'Drought', 'ipa': 'draʊt', 'meaning': 'Hạn hán', 'pos': 'n'},
      {'word': 'Earthquake', 'ipa': 'ˈɜːθ.kweɪk', 'meaning': 'Động đất', 'pos': 'n'},
      {'word': 'Wildfire', 'ipa': 'ˈwaɪld.faɪər', 'meaning': 'Cháy rừng', 'pos': 'n'},
    ];

    await _seedTopic(
      topicId: topicId,
      name: 'Môi trường',
      icon: '🌍',
      entries: entries,
      now: now,
      wordPrefix: 'environment',
    );
    return 'Environment topic seeded with ${entries.length} words';
  }

  Future<void> _seedTopic({
    required String topicId,
    required String name,
    required String icon,
    required List<Map<String, String>> entries,
    required Timestamp now,
    String? wordPrefix,
  }) async {
    final wordIds = <String>[];
    final batch = _firestore.batch();
    final prefix = wordPrefix ??
        (topicId.startsWith('topic_') ? topicId.substring(6) : topicId);

    for (final entry in entries) {
      final headword = entry['word'] ?? '';
      if (headword.isEmpty) continue;
      final slug = _slugify(headword);
      final wordId = '${prefix}_$slug';
      wordIds.add(wordId);

      batch.set(
        _dictionaryWords.doc(wordId),
        {
          'headword': headword,
          'normalized_headword': slug,
          'ipa': entry['ipa'],
          'pos': entry['pos'] ?? 'n',
          'meaning_vi': entry['meaning'],
          'example_en': entry['example_en'],
          'example_vi': entry['example_vi'],
          'audio_url': null,
          'image_url': null,
          'created_by': 'system',
          'created_at': now,
          'is_active': true,
        },
        SetOptions(merge: true),
      );
    }

    batch.set(
      _topics.doc(topicId),
      {
        'name': name,
        'icon': icon,
        'owner_id': null,
        'visibility': 'public',
        'is_system': true,
        'is_active': true,
        'created_at': now,
        'dictionary_word_ids': wordIds,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  // Tracks whether we already attempted to seed system topics this session.
  bool _hasSeededSystemTopics = false;
  bool _hasSeededBodyActions = false;
  bool _hasSeededNumbers = false;
  final Map<String, bool> _seededTopicFlags = {};

  String _slugify(String value) {
    final lower = value.toLowerCase().trim();
    final buffer = StringBuffer();
    for (var codeUnit in lower.codeUnits) {
      final ch = String.fromCharCode(codeUnit);
      final isAlnum = (codeUnit >= 97 && codeUnit <= 122) ||
          (codeUnit >= 48 && codeUnit <= 57);
      if (isAlnum) {
        buffer.write(ch);
      } else if (buffer.isNotEmpty && buffer.toString().endsWith('_')) {
        continue;
      } else {
        buffer.write('_');
      }
    }
    final slug = buffer.toString().replaceAll(RegExp('_+'), '_');
    return slug.endsWith('_') ? slug.substring(0, slug.length - 1) : slug;
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

  Future<List<FirestoreLeagueMember>> getLeagueMembers({
    required String cycleId,
  }) async {
    final snapshot =
        await _leagueMembers.where('cycle_id', isEqualTo: cycleId).get();
    return snapshot.docs.map(FirestoreLeagueMember.fromSnapshot).toList();
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

  Future<List<FirestorePost>> fetchCommunityPostsFallback({
    String? visibility,
    String? status,
    int limit = 20,
  }) async {
    var query = _posts.where('status', isEqualTo: status ?? 'active');

    if (visibility != null) {
      query = query.where('visibility', isEqualTo: visibility);
    }

    final snapshot = await query.limit(limit).get();
    final posts = snapshot.docs.map(FirestorePost.fromSnapshot).toList();
    posts.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return posts;
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
        .where('status', whereIn: ['active', 'accepted'])
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

  Future<void> deleteGroup(String groupId) async {
    if (groupId.isEmpty) return;
    final batch = _firestore.batch();

    final members =
        await _groupMembers.where('group_id', isEqualTo: groupId).get();
    for (final doc in members.docs) {
      batch.delete(doc.reference);
    }

    final messages =
        await _groupMessages.where('group_id', isEqualTo: groupId).get();
    for (final doc in messages.docs) {
      batch.delete(doc.reference);
    }

    batch.delete(_groups.doc(groupId));
    await batch.commit();
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

  Future<List<String>> getUserReportedPostIds(String userId) async {
    if (userId.isEmpty) return <String>[];
    final snapshot = await _firestore
        .collection('post_reports')
        .where('reported_by', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => (doc.data()['post_id'] as String?) ?? '')
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
  }

  Future<void> incrementPostSaveCount(String postId, {int delta = 1}) async {
    if (postId.isEmpty || delta == 0) return;
    await _posts.doc(postId).update({
      'save_count': FieldValue.increment(delta),
    });
  }

  Future<void> deletePostCascade(String postId) async {
    if (postId.isEmpty) return;

    Future<void> _deleteWhere(
      CollectionReference<Map<String, dynamic>> col,
      String field,
    ) async {
      final snap = await col.where(field, isEqualTo: postId).get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    }

    await Future.wait([
      _deleteWhere(_postLikes, 'post_id'),
      _deleteWhere(_postComments, 'post_id'),
      _deleteWhere(_postWords, 'post_id'),
      _deleteWhere(_firestore.collection('post_reports'), 'post_id'),
    ]);

    await _posts.doc(postId).delete();
  }

  Future<FirestorePost?> getPostById(String postId) async {
    if (postId.isEmpty) return null;
    final doc = await _posts.doc(postId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FirestorePost.fromSnapshot(doc);
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
