import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMonthlyQuestProgress {
  FirestoreMonthlyQuestProgress({
    required this.docId,
    required this.userId,
    required this.monthKey,
    required this.monthStart,
    required this.completedCount,
    required this.rewardClaimed,
    this.rewardClaimedAt,
  });

  final String docId;
  final String userId;
  final String monthKey;
  final DateTime monthStart;
  final int completedCount;
  final bool rewardClaimed;
  final DateTime? rewardClaimedAt;

  factory FirestoreMonthlyQuestProgress.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Monthly quest document ${snapshot.id} is missing data.');
    }

    return FirestoreMonthlyQuestProgress(
      docId: snapshot.id,
      userId: (data['user_id'] as String?) ?? '',
      monthKey: (data['month_key'] as String?) ?? '',
      monthStart: _asDateTime(data['month_start']),
      completedCount: (data['completed_count'] as num?)?.toInt() ?? 0,
      rewardClaimed: (data['reward_claimed'] as bool?) ?? false,
      rewardClaimedAt: data['reward_claimed_at'] != null
          ? _asDateTime(data['reward_claimed_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'month_key': monthKey,
      'month_start': Timestamp.fromDate(monthStart),
      'completed_count': completedCount,
      'reward_claimed': rewardClaimed,
      'reward_claimed_at':
          rewardClaimedAt != null ? Timestamp.fromDate(rewardClaimedAt!) : null,
    };
  }

  FirestoreMonthlyQuestProgress copyWith({
    int? completedCount,
    bool? rewardClaimed,
    DateTime? rewardClaimedAt,
  }) {
    return FirestoreMonthlyQuestProgress(
      docId: docId,
      userId: userId,
      monthKey: monthKey,
      monthStart: monthStart,
      completedCount: completedCount ?? this.completedCount,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      rewardClaimedAt: rewardClaimedAt ?? this.rewardClaimedAt,
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
