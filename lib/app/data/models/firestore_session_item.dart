import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of study session items.
class FirestoreSessionItem {
  FirestoreSessionItem({
    required this.itemId,
    required this.sessionId,
    required this.personalWordId,
    required this.round,
    required this.questionType,
    required this.firstTryCorrect,
    required this.attemptsCount,
    this.score,
    this.payload,
    required this.createdAt,
  });

  final String itemId;
  final String sessionId;
  final String personalWordId;
  final int round;
  final String questionType;
  final bool firstTryCorrect;
  final int attemptsCount;
  final int? score;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  factory FirestoreSessionItem.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Session item document ${doc.id} is missing data.');
    }

    return FirestoreSessionItem(
      itemId: doc.id,
      sessionId: (data['session_id'] as String?) ?? '',
      personalWordId: (data['personal_word_id'] as String?) ?? '',
      round: (data['round'] as num?)?.toInt() ?? 0,
      questionType: (data['question_type'] as String?) ?? '',
      firstTryCorrect: (data['first_try_correct'] as bool?) ?? false,
      attemptsCount: (data['attempts_count'] as num?)?.toInt() ?? 0,
      score: (data['score'] as num?)?.toInt(),
      payload: data['payload'] as Map<String, dynamic>?,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'session_id': sessionId,
      'personal_word_id': personalWordId,
      'round': round,
      'question_type': questionType,
      'first_try_correct': firstTryCorrect,
      'attempts_count': attemptsCount,
      'score': score,
      'payload': payload,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreSessionItem copyWith({
    String? sessionId,
    String? personalWordId,
    int? round,
    String? questionType,
    bool? firstTryCorrect,
    int? attemptsCount,
    int? score,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
  }) {
    return FirestoreSessionItem(
      itemId: itemId,
      sessionId: sessionId ?? this.sessionId,
      personalWordId: personalWordId ?? this.personalWordId,
      round: round ?? this.round,
      questionType: questionType ?? this.questionType,
      firstTryCorrect: firstTryCorrect ?? this.firstTryCorrect,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      score: score ?? this.score,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
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
