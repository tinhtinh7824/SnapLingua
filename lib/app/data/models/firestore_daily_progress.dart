import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a user's daily progress summary.
class FirestoreDailyProgress {
  FirestoreDailyProgress({
    required this.progressId,
    required this.userId,
    required this.date,
    required this.newTarget,
    required this.newLearned,
    required this.reviewDue,
    required this.reviewDone,
    required this.streak,
    required this.xpGained,
  });

  final String progressId;
  final String userId;
  final DateTime date;
  final int newTarget;
  final int newLearned;
  final int reviewDue;
  final int reviewDone;
  final int streak;
  final int xpGained;

  factory FirestoreDailyProgress.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Daily progress document ${doc.id} is missing data.');
    }

    return FirestoreDailyProgress(
      progressId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      date: _asDateTime(data['date']),
      newTarget: (data['new_target'] as num?)?.toInt() ?? 0,
      newLearned: (data['new_learned'] as num?)?.toInt() ?? 0,
      reviewDue: (data['review_due'] as num?)?.toInt() ?? 0,
      reviewDone: (data['review_done'] as num?)?.toInt() ?? 0,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      xpGained: (data['xp_gained'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': Timestamp.fromDate(date),
      'new_target': newTarget,
      'new_learned': newLearned,
      'review_due': reviewDue,
      'review_done': reviewDone,
      'streak': streak,
      'xp_gained': xpGained,
    };
  }

  FirestoreDailyProgress copyWith({
    String? userId,
    DateTime? date,
    int? newTarget,
    int? newLearned,
    int? reviewDue,
    int? reviewDone,
    int? streak,
    int? xpGained,
  }) {
    return FirestoreDailyProgress(
      progressId: progressId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      newTarget: newTarget ?? this.newTarget,
      newLearned: newLearned ?? this.newLearned,
      reviewDue: reviewDue ?? this.reviewDue,
      reviewDone: reviewDone ?? this.reviewDone,
      streak: streak ?? this.streak,
      xpGained: xpGained ?? this.xpGained,
    );
  }

  static DateTime _asDateTime(dynamic value) {
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
}
