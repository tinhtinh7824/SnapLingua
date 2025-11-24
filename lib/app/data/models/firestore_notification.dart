import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of notifications delivered to users.
class FirestoreNotification {
  FirestoreNotification({
    required this.notificationId,
    required this.userId,
    required this.type,
    this.payload,
    required this.sentAt,
    this.readAt,
  });

  final String notificationId;
  final String userId;
  final String type;
  final Map<String, dynamic>? payload;
  final DateTime sentAt;
  final DateTime? readAt;

  factory FirestoreNotification.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Notification document ${doc.id} is missing data.');
    }

    return FirestoreNotification(
      notificationId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      type: (data['type'] as String?) ?? '',
      payload: data['payload'] as Map<String, dynamic>?,
      sentAt: _asDateTime(data['sent_at']),
      readAt: data['read_at'] != null ? _asDateTime(data['read_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'type': type,
      'payload': payload,
      'sent_at': Timestamp.fromDate(sentAt),
      'read_at': readAt != null ? Timestamp.fromDate(readAt!) : null,
    };
  }

  FirestoreNotification copyWith({
    String? userId,
    String? type,
    Map<String, dynamic>? payload,
    DateTime? sentAt,
    DateTime? readAt,
  }) {
    return FirestoreNotification(
      notificationId: notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
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
