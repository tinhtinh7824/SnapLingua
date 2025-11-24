import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a group's membership record.
class FirestoreGroupMember {
  FirestoreGroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.requestMessage,
  });

  final String id;
  final String groupId;
  final String userId;
  final String role;
  final String status;
  final DateTime joinedAt;
  final String? requestMessage;

  factory FirestoreGroupMember.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Group member document ${doc.id} is missing data.');
    }

    return FirestoreGroupMember(
      id: doc.id,
      groupId: (data['group_id'] as String?) ?? '',
      userId: (data['user_id'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'member',
      status: (data['status'] as String?) ?? 'active',
      joinedAt: _asDateTime(data['joined_at']),
      requestMessage: data['request_message'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'role': role,
      'status': status,
      'joined_at': Timestamp.fromDate(joinedAt),
      'request_message': requestMessage,
    };
  }

  FirestoreGroupMember copyWith({
    String? groupId,
    String? userId,
    String? role,
    String? status,
    DateTime? joinedAt,
    String? requestMessage,
  }) {
    return FirestoreGroupMember(
      id: id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      requestMessage: requestMessage ?? this.requestMessage,
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
