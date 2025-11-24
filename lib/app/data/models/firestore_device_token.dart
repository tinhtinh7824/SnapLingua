import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of the `device_tokens` table.
class FirestoreDeviceToken {
  FirestoreDeviceToken({
    required this.tokenId,
    required this.userId,
    required this.deviceType,
    this.deviceId,
    required this.fcmToken,
    this.lastActiveAt,
    required this.createdAt,
  });

  final String tokenId;
  final String userId;
  final String deviceType;
  final String? deviceId;
  final String fcmToken;
  final DateTime? lastActiveAt;
  final DateTime createdAt;

  factory FirestoreDeviceToken.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Device token document ${doc.id} is missing data.');
    }

    return FirestoreDeviceToken(
      tokenId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      deviceType: (data['device_type'] as String?) ?? '',
      deviceId: data['device_id'] as String?,
      fcmToken: (data['fcm_token'] as String?) ?? '',
      lastActiveAt: data['last_active_at'] != null
          ? _asDateTime(data['last_active_at'])
          : null,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'device_type': deviceType,
      'device_id': deviceId,
      'fcm_token': fcmToken,
      'last_active_at':
          lastActiveAt != null ? Timestamp.fromDate(lastActiveAt!) : null,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreDeviceToken copyWith({
    String? userId,
    String? deviceType,
    String? deviceId,
    String? fcmToken,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  }) {
    return FirestoreDeviceToken(
      tokenId: tokenId,
      userId: userId ?? this.userId,
      deviceType: deviceType ?? this.deviceType,
      deviceId: deviceId ?? this.deviceId,
      fcmToken: fcmToken ?? this.fcmToken,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
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
