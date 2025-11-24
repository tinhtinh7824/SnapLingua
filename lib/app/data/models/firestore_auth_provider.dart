import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of an authentication provider linked to a user.
class FirestoreAuthProvider {
  FirestoreAuthProvider({
    required this.id,
    required this.userId,
    required this.provider,
    required this.providerUid,
    required this.emailVerified,
    required this.linkedAt,
  });

  final String id;
  final String userId;
  final String provider;
  final String providerUid;
  final bool emailVerified;
  final DateTime linkedAt;

  factory FirestoreAuthProvider.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Auth provider document ${doc.id} is missing data.');
    }

    return FirestoreAuthProvider(
      id: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      provider: (data['provider'] as String?) ?? '',
      providerUid: (data['provider_uid'] as String?) ?? '',
      emailVerified: (data['email_verified'] as bool?) ?? false,
      linkedAt: _asDateTime(data['linked_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'provider': provider,
      'provider_uid': providerUid,
      'email_verified': emailVerified,
      'linked_at': Timestamp.fromDate(linkedAt),
    };
  }

  FirestoreAuthProvider copyWith({
    String? userId,
    String? provider,
    String? providerUid,
    bool? emailVerified,
    DateTime? linkedAt,
  }) {
    return FirestoreAuthProvider(
      id: id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      providerUid: providerUid ?? this.providerUid,
      emailVerified: emailVerified ?? this.emailVerified,
      linkedAt: linkedAt ?? this.linkedAt,
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
