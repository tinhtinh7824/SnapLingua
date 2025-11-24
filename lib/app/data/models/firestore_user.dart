import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  static const String defaultAvatarPath =
      'assets/images/chimcanhcut/chim_vui1.png';

  FirestoreUser({
    required this.id,
    required this.email,
    this.displayName,
    String? avatarUrl,
    this.role = 'user',
    this.status = 'active',
    required this.createdAt,
    this.updatedAt,
    this.scalesBalance = 0,
    this.gemsBalance = 0,
  }) : avatarUrl =
            (avatarUrl == null || avatarUrl.trim().isEmpty) ? defaultAvatarPath : avatarUrl.trim();

  final String id;
  final String email;
  final String? displayName;
  final String avatarUrl;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int scalesBalance;
  final int gemsBalance;

  factory FirestoreUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User document ${doc.id} is missing data.');
    }
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];
    return FirestoreUser(
      id: doc.id,
      email: (data['email'] as String?) ?? '',
      displayName: data['displayName'] as String?,
      avatarUrl: data['avatarUrl'] as String?,
      role: (data['role'] as String?) ?? 'user',
      status: (data['status'] as String?) ?? 'active',
      createdAt: _asDateTime(createdAt),
      updatedAt: updatedAt != null ? _asDateTime(updatedAt) : null,
      scalesBalance: (data['scalesBalance'] as num?)?.toInt() ?? 0,
      gemsBalance: (data['gemsBalance'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'role': role,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'scalesBalance': scalesBalance,
      'gemsBalance': gemsBalance,
    };
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

  FirestoreUser copyWith({
    String? email,
    String? displayName,
    String? avatarUrl,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? scalesBalance,
    int? gemsBalance,
  }) {
    return FirestoreUser(
      id: id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scalesBalance: scalesBalance ?? this.scalesBalance,
      gemsBalance: gemsBalance ?? this.gemsBalance,
    );
  }
}
