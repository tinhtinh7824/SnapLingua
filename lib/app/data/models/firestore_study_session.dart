import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of spaced-repetition study sessions.
class FirestoreStudySession {
  FirestoreStudySession({
    required this.sessionId,
    required this.userId,
    required this.type,
    required this.plannedCount,
    required this.completedCount,
    this.firstTryAccuracy,
    required this.startedAt,
    this.endedAt,
  });

  final String sessionId;
  final String userId;
  final String type;
  final int plannedCount;
  final int completedCount;
  final int? firstTryAccuracy;
  final DateTime startedAt;
  final DateTime? endedAt;

  factory FirestoreStudySession.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Study session document ${doc.id} is missing data.');
    }

    return FirestoreStudySession(
      sessionId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      type: (data['type'] as String?) ?? 'new',
      plannedCount: (data['planned_count'] as num?)?.toInt() ?? 0,
      completedCount: (data['completed_count'] as num?)?.toInt() ?? 0,
      firstTryAccuracy: (data['first_try_accuracy'] as num?)?.toInt(),
      startedAt: _asDateTime(data['started_at']),
      endedAt:
          data['ended_at'] != null ? _asDateTime(data['ended_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'type': type,
      'planned_count': plannedCount,
      'completed_count': completedCount,
      'first_try_accuracy': firstTryAccuracy,
      'started_at': Timestamp.fromDate(startedAt),
      'ended_at': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
    };
  }

  FirestoreStudySession copyWith({
    String? userId,
    String? type,
    int? plannedCount,
    int? completedCount,
    int? firstTryAccuracy,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return FirestoreStudySession(
      sessionId: sessionId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      plannedCount: plannedCount ?? this.plannedCount,
      completedCount: completedCount ?? this.completedCount,
      firstTryAccuracy: firstTryAccuracy ?? this.firstTryAccuracy,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
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
