import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of an XP transaction.
class FirestoreXpTransaction {
  FirestoreXpTransaction({
    required this.transactionId,
    required this.userId,
    required this.sourceType,
    required this.action,
    this.sourceId,
    required this.amount,
    this.note,
    this.metadata,
    this.wordsCount,
    required this.createdAt,
  });

  final String transactionId;
  final String userId;
  final String sourceType;
  final String action;
  final String? sourceId;
  final int amount;
  final String? note;
  final Map<String, dynamic>? metadata;
  final int? wordsCount;
  final DateTime createdAt;

  factory FirestoreXpTransaction.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('XP transaction document ${doc.id} is missing data.');
    }

    return FirestoreXpTransaction(
      transactionId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      sourceType: (data['source_type'] as String?) ?? '',
      action: (data['action'] as String?) ?? '',
      sourceId: data['source_id'] as String?,
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      note: data['note'] as String?,
      metadata: _readMetadata(data['metadata']),
      wordsCount: (data['words_count'] as num?)?.toInt(),
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'user_id': userId,
      'source_type': sourceType,
      'action': action,
      'source_id': sourceId,
      'amount': amount,
      'note': note,
      'metadata': metadata,
      'words_count': wordsCount,
      'created_at': Timestamp.fromDate(createdAt),
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }

  FirestoreXpTransaction copyWith({
    String? userId,
    String? sourceType,
    String? action,
    String? sourceId,
    int? amount,
    String? note,
    Map<String, dynamic>? metadata,
    int? wordsCount,
    DateTime? createdAt,
  }) {
    return FirestoreXpTransaction(
      transactionId: transactionId,
      userId: userId ?? this.userId,
      sourceType: sourceType ?? this.sourceType,
      action: action ?? this.action,
      sourceId: sourceId ?? this.sourceId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      metadata: metadata ?? this.metadata,
      wordsCount: wordsCount ?? this.wordsCount,
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

  static Map<String, dynamic>? _readMetadata(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map<String, Object?>) {
      return value.map((key, dynamic v) => MapEntry(key, v));
    }
    return null;
  }
}
