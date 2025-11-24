import 'package:cloud_firestore/cloud_firestore.dart';

enum DailyQuestType {
  saveWords,
  reachLearnGoal,
  reachReviewGoal,
  postCommunityImage,
  engageCommunity,
}

DailyQuestType questTypeFromString(String value) {
  switch (value) {
    case 'save_words':
      return DailyQuestType.saveWords;
    case 'reach_learn_goal':
      return DailyQuestType.reachLearnGoal;
    case 'reach_review_goal':
      return DailyQuestType.reachReviewGoal;
    case 'post_community_image':
      return DailyQuestType.postCommunityImage;
    case 'engage_community':
      return DailyQuestType.engageCommunity;
    default:
      throw ArgumentError('Unsupported quest type: $value');
  }
}

String questTypeToString(DailyQuestType type) {
  switch (type) {
    case DailyQuestType.saveWords:
      return 'save_words';
    case DailyQuestType.reachLearnGoal:
      return 'reach_learn_goal';
    case DailyQuestType.reachReviewGoal:
      return 'reach_review_goal';
    case DailyQuestType.postCommunityImage:
      return 'post_community_image';
    case DailyQuestType.engageCommunity:
      return 'engage_community';
  }
}

class FirestoreDailyQuestDay {
  FirestoreDailyQuestDay({
    required this.docId,
    required this.userId,
    required this.date,
    required this.quests,
    required this.completedCount,
  });

  final String docId;
  final String userId;
  final DateTime date;
  final List<FirestoreDailyQuest> quests;
  final int completedCount;

  factory FirestoreDailyQuestDay.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Daily quest document ${snapshot.id} is missing data.');
    }

    final questList = (data['quests'] as List<dynamic>? ?? const [])
        .map((entry) => FirestoreDailyQuest.fromMap(entry as Map<String, dynamic>))
        .toList(growable: false);

    return FirestoreDailyQuestDay(
      docId: snapshot.id,
      userId: (data['user_id'] as String?) ?? '',
      date: _asDateTime(data['date']),
      quests: questList,
      completedCount: (data['completed_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': Timestamp.fromDate(date),
      'quests': quests.map((quest) => quest.toMap()).toList(growable: false),
      'completed_count': completedCount,
    };
  }

  FirestoreDailyQuestDay copyWith({
    DateTime? date,
    List<FirestoreDailyQuest>? quests,
    int? completedCount,
  }) {
    return FirestoreDailyQuestDay(
      docId: docId,
      userId: userId,
      date: date ?? this.date,
      quests: quests ?? this.quests,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}

class FirestoreDailyQuest {
  FirestoreDailyQuest({
    required this.type,
    required this.target,
    required this.progress,
    required this.completed,
    this.completedAt,
    this.rewardClaimed = false,
  });

  final DailyQuestType type;
  final int target;
  final int progress;
  final bool completed;
  final DateTime? completedAt;
  final bool rewardClaimed;

  factory FirestoreDailyQuest.fromMap(Map<String, dynamic> map) {
    return FirestoreDailyQuest(
      type: questTypeFromString((map['type'] as String?) ?? ''),
      target: (map['target'] as num?)?.toInt() ?? 0,
      progress: (map['progress'] as num?)?.toInt() ?? 0,
      completed: (map['completed'] as bool?) ?? false,
      completedAt: map['completed_at'] != null ? _asDateTime(map['completed_at']) : null,
      rewardClaimed: (map['reward_claimed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': questTypeToString(type),
      'target': target,
      'progress': progress,
      'completed': completed,
      'completed_at': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'reward_claimed': rewardClaimed,
    };
  }

  FirestoreDailyQuest copyWith({
    int? target,
    int? progress,
    bool? completed,
    DateTime? completedAt,
    bool? rewardClaimed,
  }) {
    return FirestoreDailyQuest(
      type: type,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
    );
  }
}

DateTime _asDateTime(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  }
  throw StateError('Unsupported timestamp value: $value');
}
