import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of merged dictionary words.
class FirestoreWordMergeMap {
  FirestoreWordMergeMap({
    required this.mergeId,
    required this.sourceWordId,
    required this.targetWordId,
    this.reason,
    required this.mergedAt,
  });

  final String mergeId;
  final String sourceWordId;
  final String targetWordId;
  final String? reason;
  final DateTime mergedAt;

  factory FirestoreWordMergeMap.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Word merge document ${doc.id} is missing data.');
    }

    return FirestoreWordMergeMap(
      mergeId: doc.id,
      sourceWordId: (data['source_word_id'] as String?) ?? '',
      targetWordId: (data['target_word_id'] as String?) ?? '',
      reason: data['reason'] as String?,
      mergedAt: _asDateTime(data['merged_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source_word_id': sourceWordId,
      'target_word_id': targetWordId,
      'reason': reason,
      'merged_at': Timestamp.fromDate(mergedAt),
    };
  }

  FirestoreWordMergeMap copyWith({
    String? sourceWordId,
    String? targetWordId,
    String? reason,
    DateTime? mergedAt,
  }) {
    return FirestoreWordMergeMap(
      mergeId: mergeId,
      sourceWordId: sourceWordId ?? this.sourceWordId,
      targetWordId: targetWordId ?? this.targetWordId,
      reason: reason ?? this.reason,
      mergedAt: mergedAt ?? this.mergedAt,
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
