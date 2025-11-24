import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a message within a group.
class FirestoreGroupMessage {
  FirestoreGroupMessage({
    required this.messageId,
    required this.groupId,
    required this.userId,
    required this.messageType,
    this.content,
    this.badgeId,
    required this.createdAt,
  });

  final String messageId;
  final String groupId;
  final String userId;
  final String messageType;
  final String? content;
  final String? badgeId;
  final DateTime createdAt;

  factory FirestoreGroupMessage.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Group message document ${doc.id} is missing data.');
    }

    return FirestoreGroupMessage(
      messageId: doc.id,
      groupId: (data['group_id'] as String?) ?? '',
      userId: (data['user_id'] as String?) ?? '',
      messageType: (data['message_type'] as String?) ?? 'text',
      content: data['content'] as String?,
      badgeId: data['badge_id'] as String?,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'message_type': messageType,
      'content': content,
      'badge_id': badgeId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreGroupMessage copyWith({
    String? groupId,
    String? userId,
    String? messageType,
    String? content,
    String? badgeId,
    DateTime? createdAt,
  }) {
    return FirestoreGroupMessage(
      messageId: messageId,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      badgeId: badgeId ?? this.badgeId,
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
