import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of notification preferences for a user.
class FirestoreNotificationSettings {
  FirestoreNotificationSettings({
    required this.userId,
    required this.pushEnabled,
    this.morningTime,
    this.eveningTime,
    required this.contextualAllowed,
  });

  final String userId;
  final bool pushEnabled;
  final String? morningTime;
  final String? eveningTime;
  final bool contextualAllowed;

  factory FirestoreNotificationSettings.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Notification settings document ${doc.id} is missing data.');
    }

    return FirestoreNotificationSettings(
      userId: doc.id,
      pushEnabled: (data['push_enabled'] as bool?) ?? false,
      morningTime: data['morning_time'] as String?,
      eveningTime: data['evening_time'] as String?,
      contextualAllowed: (data['contextual_allowed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'push_enabled': pushEnabled,
      'morning_time': morningTime,
      'evening_time': eveningTime,
      'contextual_allowed': contextualAllowed,
    };
  }

  FirestoreNotificationSettings copyWith({
    bool? pushEnabled,
    String? morningTime,
    String? eveningTime,
    bool? contextualAllowed,
  }) {
    return FirestoreNotificationSettings(
      userId: userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
      contextualAllowed: contextualAllowed ?? this.contextualAllowed,
    );
  }
}
