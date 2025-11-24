import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of the personal_words to topics relation.
class FirestorePersonalWordTopic {
  FirestorePersonalWordTopic({
    required this.id,
    required this.personalWordId,
    required this.topicId,
    required this.isPrimary,
    required this.createdAt,
  });

  final String id;
  final String personalWordId;
  final String topicId;
  final bool isPrimary;
  final DateTime createdAt;

  factory FirestorePersonalWordTopic.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Personal word topic document ${doc.id} is missing data.');
    }

    return FirestorePersonalWordTopic(
      id: doc.id,
      personalWordId: (data['personal_word_id'] as String?) ?? '',
      topicId: (data['topic_id'] as String?) ?? '',
      isPrimary: (data['is_primary'] as bool?) ?? false,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personal_word_id': personalWordId,
      'topic_id': topicId,
      'is_primary': isPrimary,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestorePersonalWordTopic copyWith({
    String? personalWordId,
    String? topicId,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return FirestorePersonalWordTopic(
      id: id,
      personalWordId: personalWordId ?? this.personalWordId,
      topicId: topicId ?? this.topicId,
      isPrimary: isPrimary ?? this.isPrimary,
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
