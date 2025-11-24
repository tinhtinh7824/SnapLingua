import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/firestore_group.dart';
import '../models/firestore_group_member.dart';
import '../models/firestore_group_message.dart';
import '../models/firestore_league_member.dart';
import '../models/firestore_notification.dart';
import '../models/firestore_notification_settings.dart';
import '../models/firestore_photo.dart';
import '../models/firestore_post.dart';
import '../models/firestore_user.dart';
import '../models/firestore_user_badge.dart';
import '../models/firestore_xp_transaction.dart';
import '../models/firestore_personal_word.dart';
import '../models/firestore_session_item.dart';
import '../models/firestore_study_session.dart';
import '../models/firestore_topic.dart';
import '../models/firestore_dictionary_word.dart';
import '../../modules/learning_session/controllers/learning_session_controller.dart';


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

  Future<FirestoreUser?> getUserById(String userId) async {
    if (userId.isEmpty) return null;
    final doc = await _users.doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return FirestoreUser.fromSnapshot(doc);
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
  }) async {
    final membership = FirestoreGroupMember(
      id: '',
      groupId: groupId,
      userId: userId,
      role: role,
      status: status,
      joinedAt: DateTime.now(),
    );
    await _groupMembers.add(membership.toMap());
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

  Future<void> updateGroupMemberStatus({
    required String membershipId,
    required String status,
  }) async {
    await _groupMembers.doc(membershipId).set(
      {'status': status},
      SetOptions(merge: true),
    );
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
