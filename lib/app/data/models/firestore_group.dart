import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of community groups.
class FirestoreGroup {
  FirestoreGroup({
    required this.groupId,
    required this.name,
    required this.requireApproval,
    required this.memberCount,
    this.description,
    this.iconPath,
    required this.createdBy,
    required this.status,
    required this.createdAt,
  });

  final String groupId;
  final String name;
  final bool requireApproval;
  final int memberCount;
  final String? description;
  final String? iconPath;
  final String createdBy;
  final String status;
  final DateTime createdAt;

  factory FirestoreGroup.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Group document ${doc.id} is missing data.');
    }

    return FirestoreGroup(
      groupId: doc.id,
      name: (data['name'] as String?) ?? '',
      requireApproval: (data['require_approval'] as bool?) ?? false,
      memberCount: (data['member_count'] as num?)?.toInt() ?? 0,
      description: data['description'] as String?,
      iconPath: data['icon_path'] as String?,
      createdBy: (data['created_by'] as String?) ?? '',
      status: (data['status'] as String?) ?? 'active',
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'require_approval': requireApproval,
      'member_count': memberCount,
      'description': description,
      'icon_path': iconPath,
      'created_by': createdBy,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreGroup copyWith({
    String? name,
    bool? requireApproval,
    int? memberCount,
    String? description,
    String? iconPath,
    String? createdBy,
    String? status,
    DateTime? createdAt,
  }) {
    return FirestoreGroup(
      groupId: groupId,
      name: name ?? this.name,
      requireApproval: requireApproval ?? this.requireApproval,
      memberCount: memberCount ?? this.memberCount,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
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
