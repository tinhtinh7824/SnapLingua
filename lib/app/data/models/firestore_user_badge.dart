import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation linking users to earned badges.
class FirestoreUserBadge {
  FirestoreUserBadge({
    required this.userId,
    required this.badgeId,
    required this.awardedAt,
  });

  final String userId;
  final String badgeId;
  final DateTime awardedAt;

  factory FirestoreUserBadge.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User badge document ${doc.id} is missing data.');
    }

    final badgeId = doc.id;
    final userId = (data['user_id'] as String?) ?? '';
    final awardedAt = _asDateTime(data['awarded_at']);

    return FirestoreUserBadge(
      userId: userId,
      badgeId: badgeId,
      awardedAt: awardedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'awarded_at': Timestamp.fromDate(awardedAt),
    };
  }

  FirestoreUserBadge copyWith({
    String? userId,
    DateTime? awardedAt,
  }) {
    return FirestoreUserBadge(
      userId: userId ?? this.userId,
      badgeId: badgeId,
      awardedAt: awardedAt ?? this.awardedAt,
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
