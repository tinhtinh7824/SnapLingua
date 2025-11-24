import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of actions performed by administrators.
class FirestoreAdminAction {
  FirestoreAdminAction({
    required this.actionId,
    required this.adminId,
    required this.targetType,
    required this.targetId,
    required this.action,
    this.reason,
    required this.createdAt,
  });

  final String actionId;
  final String adminId;
  final String targetType;
  final String targetId;
  final String action;
  final String? reason;
  final DateTime createdAt;

  factory FirestoreAdminAction.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Admin action document ${doc.id} is missing data.');
    }

    return FirestoreAdminAction(
      actionId: doc.id,
      adminId: (data['admin_id'] as String?) ?? '',
      targetType: (data['target_type'] as String?) ?? '',
      targetId: (data['target_id'] as String?) ?? '',
      action: (data['action'] as String?) ?? '',
      reason: data['reason'] as String?,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admin_id': adminId,
      'target_type': targetType,
      'target_id': targetId,
      'action': action,
      'reason': reason,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreAdminAction copyWith({
    String? adminId,
    String? targetType,
    String? targetId,
    String? action,
    String? reason,
    DateTime? createdAt,
  }) {
    return FirestoreAdminAction(
      actionId: actionId,
      adminId: adminId ?? this.adminId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      action: action ?? this.action,
      reason: reason ?? this.reason,
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
