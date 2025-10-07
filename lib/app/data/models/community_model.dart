import 'package:realm/realm.dart';

part 'community_model.realm.dart';

@RealmModel()
class _StudyGroup {
  @PrimaryKey()
  late String id;
  late String name;
  late String? description;
  late String creatorId;
  late String? imageUrl;
  late int memberLimit;
  late int currentMembers;
  late String joinType; // public, private, invite_only
  late String? joinCode;
  late bool isActive;
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _StudyGroupMember {
  @PrimaryKey()
  late String id;
  late String studyGroupId;
  late String userId;
  late String role; // admin, moderator, member
  late DateTime joinedAt;
  late bool isActive;
  late DateTime? lastActiveAt;
}

@RealmModel()
class _StudyGroupMessage {
  @PrimaryKey()
  late String id;
  late String studyGroupId;
  late String senderId;
  late String messageType; // text, image, vocabulary_share
  late String content;
  late String? metadata; // JSON for additional data
  late DateTime sentAt;
  late bool isEdited;
  late DateTime? editedAt;
  late bool isDeleted;
}

@RealmModel()
class _Friend {
  @PrimaryKey()
  late String id;
  late String userId;
  late String friendId;
  late String status; // pending, accepted, blocked
  late DateTime requestedAt;
  late DateTime? acceptedAt;
  late DateTime? lastInteractionAt;
}

@RealmModel()
class _UserSession {
  @PrimaryKey()
  late String id;
  late String userId;
  late DateTime startTime;
  late DateTime? endTime;
  late int xpEarned;
  late int wordsLearned;
  late int lessonsCompleted;
  late int timeSpentMinutes;
  late String? activityType;
}

@RealmModel()
class _Competition {
  @PrimaryKey()
  late String id;
  late String name;
  late String description;
  late String type; // weekly_xp, vocabulary_challenge, streak_challenge
  late DateTime startDate;
  late DateTime endDate;
  late String? rules; // JSON string
  late String? rewards; // JSON string
  late bool isActive;
  late DateTime createdAt;
}

@RealmModel()
class _CompetitionParticipant {
  @PrimaryKey()
  late String id;
  late String competitionId;
  late String userId;
  late int score;
  late int rank;
  late DateTime joinedAt;
  late DateTime? lastUpdateAt;
}