import 'package:get/get.dart';
import 'package:snaplingua/app/data/models/realm/community_model.dart';

import 'realm_service.dart';

class CommunityService extends GetxService {
  static CommunityService get to => Get.find<CommunityService>();

  final RealmService _realmService = RealmService.to;

  // Study Group Methods
  Future<List<StudyGroup>> getAllStudyGroups() async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<StudyGroup>()
          .where((sg) => sg.isActive);
      return results.toList();
    } catch (e) {
      print('Error getting study groups: $e');
      return [];
    }
  }

  Future<bool> createStudyGroup(String creatorId, String name, String? description, String joinType) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final studyGroup = StudyGroup(
        DateTime.now().millisecondsSinceEpoch.toString(),
        name,
        creatorId,
        20, // memberLimit
        1, // currentMembers (creator)
        joinType,
        true, // isActive
        DateTime.now(),
        description: description,
        imageUrl: null,
        joinCode: joinType == 'invite_only' ? _generateJoinCode() : null,
        updatedAt: DateTime.now(),
      );

      realm.write(() => realm.add(studyGroup));

      // Add creator as admin member
      await joinStudyGroup(studyGroup.id, creatorId, 'admin');

      return true;
    } catch (e) {
      print('Error creating study group: $e');
      return false;
    }
  }

  Future<bool> joinStudyGroup(String studyGroupId, String userId, [String role = 'member']) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if already a member
      final existing = realm.all<StudyGroupMember>()
          .where((sgm) => sgm.studyGroupId == studyGroupId && sgm.userId == userId)
          .firstOrNull;

      if (existing != null) {
        print('User already a member');
        return false;
      }

      final studyGroup = realm.find<StudyGroup>(studyGroupId);
      if (studyGroup == null) {
        print('Study group not found');
        return false;
      }

      if (studyGroup.currentMembers >= studyGroup.memberLimit) {
        print('Study group is full');
        return false;
      }

      final member = StudyGroupMember(
        DateTime.now().millisecondsSinceEpoch.toString(),
        studyGroupId,
        userId,
        role,
        DateTime.now(),
        true, // isActive
        lastActiveAt: DateTime.now(),
      );

      realm.write(() {
        realm.add(member);
        studyGroup.currentMembers++;
      });

      return true;
    } catch (e) {
      print('Error joining study group: $e');
      return false;
    }
  }

  Future<bool> leaveStudyGroup(String studyGroupId, String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final member = realm.all<StudyGroupMember>()
          .where((sgm) => sgm.studyGroupId == studyGroupId && sgm.userId == userId)
          .firstOrNull;

      if (member == null) {
        print('User not a member');
        return false;
      }

      final studyGroup = realm.find<StudyGroup>(studyGroupId);

      realm.write(() {
        realm.delete(member);
        if (studyGroup != null) {
          studyGroup.currentMembers--;
        }
      });

      return true;
    } catch (e) {
      print('Error leaving study group: $e');
      return false;
    }
  }

  Future<List<StudyGroupMessage>> getGroupMessages(String studyGroupId, {int limit = 50}) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<StudyGroupMessage>()
          .where((sgm) => sgm.studyGroupId == studyGroupId && !sgm.isDeleted)
          .toList()
        ..sort((a, b) => b.sentAt.compareTo(a.sentAt));

      return results.take(limit).toList();
    } catch (e) {
      print('Error getting group messages: $e');
      return [];
    }
  }

  Future<bool> sendMessage(String studyGroupId, String senderId, String content, String messageType) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final message = StudyGroupMessage(
        DateTime.now().millisecondsSinceEpoch.toString(),
        studyGroupId,
        senderId,
        messageType,
        content,
        DateTime.now(),
        false, // isEdited
        false, // isDeleted
        metadata: null,
        editedAt: null,
      );

      realm.write(() => realm.add(message));
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  // Friend Methods
  Future<bool> sendFriendRequest(String userId, String friendId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if relationship already exists
      final existing = realm.all<Friend>()
          .where((f) => (f.userId == userId && f.friendId == friendId) ||
                       (f.userId == friendId && f.friendId == userId))
          .firstOrNull;

      if (existing != null) {
        print('Friend relationship already exists');
        return false;
      }

      final friendRequest = Friend(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        friendId,
        'pending',
        DateTime.now(),
        acceptedAt: null,
        lastInteractionAt: DateTime.now(),
      );

      realm.write(() => realm.add(friendRequest));
      return true;
    } catch (e) {
      print('Error sending friend request: $e');
      return false;
    }
  }

  Future<bool> acceptFriendRequest(String requestId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final friendRequest = realm.find<Friend>(requestId);
      if (friendRequest == null) {
        print('Friend request not found');
        return false;
      }

      realm.write(() {
        friendRequest.status = 'accepted';
        friendRequest.acceptedAt = DateTime.now();
        friendRequest.lastInteractionAt = DateTime.now();
      });

      return true;
    } catch (e) {
      print('Error accepting friend request: $e');
      return false;
    }
  }

  Future<List<Friend>> getFriends(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Friend>()
          .where((f) => (f.userId == userId || f.friendId == userId) && f.status == 'accepted');
      return results.toList();
    } catch (e) {
      print('Error getting friends: $e');
      return [];
    }
  }

  // User Session Methods
  Future<bool> startSession(String userId, String? activityType) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final session = UserSession(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        DateTime.now(),
        0, // xpEarned
        0, // wordsLearned
        0, // lessonsCompleted
        0, // timeSpentMinutes
        endTime: null,
        activityType: activityType,
      );

      realm.write(() => realm.add(session));
      return true;
    } catch (e) {
      print('Error starting session: $e');
      return false;
    }
  }

  Future<bool> endSession(String sessionId, int xpEarned, int wordsLearned, int lessonsCompleted) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final session = realm.find<UserSession>(sessionId);
      if (session == null) {
        print('Session not found');
        return false;
      }

      final timeSpent = DateTime.now().difference(session.startTime).inMinutes;

      realm.write(() {
        session.endTime = DateTime.now();
        session.xpEarned = xpEarned;
        session.wordsLearned = wordsLearned;
        session.lessonsCompleted = lessonsCompleted;
        session.timeSpentMinutes = timeSpent;
      });

      return true;
    } catch (e) {
      print('Error ending session: $e');
      return false;
    }
  }

  // Competition Methods
  Future<List<Competition>> getActiveCompetitions() async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final now = DateTime.now();
      final results = realm.all<Competition>()
          .where((c) => c.isActive &&
                       c.startDate.isBefore(now) &&
                       c.endDate.isAfter(now));
      return results.toList();
    } catch (e) {
      print('Error getting active competitions: $e');
      return [];
    }
  }

  Future<bool> joinCompetition(String competitionId, String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if already participating
      final existing = realm.all<CompetitionParticipant>()
          .where((cp) => cp.competitionId == competitionId && cp.userId == userId)
          .firstOrNull;

      if (existing != null) {
        print('User already participating');
        return false;
      }

      final participant = CompetitionParticipant(
        DateTime.now().millisecondsSinceEpoch.toString(),
        competitionId,
        userId,
        0, // score
        0, // rank
        DateTime.now(),
        lastUpdateAt: DateTime.now(),
      );

      realm.write(() => realm.add(participant));
      return true;
    } catch (e) {
      print('Error joining competition: $e');
      return false;
    }
  }

  Future<List<CompetitionParticipant>> getCompetitionLeaderboard(String competitionId, {int limit = 50}) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<CompetitionParticipant>()
          .where((cp) => cp.competitionId == competitionId)
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      return results.take(limit).toList();
    } catch (e) {
      print('Error getting competition leaderboard: $e');
      return [];
    }
  }

  // Helper method to generate join code
  String _generateJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(
        DateTime.now().millisecondsSinceEpoch % chars.length)),
    );
  }
}
