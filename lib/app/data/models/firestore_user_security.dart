import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore schema for storing user security preferences.
class FirestoreUserSecurity {
  FirestoreUserSecurity({
    required this.userId,
    this.passwordHash,
    required this.twoFactorEnabled,
    this.twoFactorMethod,
    this.twoFactorSecret,
    this.lastPasswordChange,
  });

  final String userId;
  final String? passwordHash;
  final bool twoFactorEnabled;
  final String? twoFactorMethod;
  final String? twoFactorSecret;
  final DateTime? lastPasswordChange;

  factory FirestoreUserSecurity.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User security document ${doc.id} is missing data.');
    }

    return FirestoreUserSecurity(
      userId: doc.id,
      passwordHash: data['password_hash'] as String?,
      twoFactorEnabled: (data['two_factor_enabled'] as bool?) ?? false,
      twoFactorMethod: data['two_factor_method'] as String?,
      twoFactorSecret: data['two_factor_secret'] as String?,
      lastPasswordChange: data['last_password_change'] != null
          ? _asDateTime(data['last_password_change'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'password_hash': passwordHash,
      'two_factor_enabled': twoFactorEnabled,
      'two_factor_method': twoFactorMethod,
      'two_factor_secret': twoFactorSecret,
      'last_password_change': lastPasswordChange != null
          ? Timestamp.fromDate(lastPasswordChange!)
          : null,
    };
  }

  FirestoreUserSecurity copyWith({
    String? passwordHash,
    bool? twoFactorEnabled,
    String? twoFactorMethod,
    String? twoFactorSecret,
    DateTime? lastPasswordChange,
  }) {
    return FirestoreUserSecurity(
      userId: userId,
      passwordHash: passwordHash ?? this.passwordHash,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      twoFactorMethod: twoFactorMethod ?? this.twoFactorMethod,
      twoFactorSecret: twoFactorSecret ?? this.twoFactorSecret,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
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
