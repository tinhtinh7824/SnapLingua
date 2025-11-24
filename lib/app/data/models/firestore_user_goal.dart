import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a user's learning goal settings.
class FirestoreUserGoal {
  FirestoreUserGoal({
    required this.userId,
    required this.dailyNewTarget,
    required this.timezone,
    this.remindMorning,
    this.remindEvening,
    required this.smartRemind,
  });

  final String userId;
  final int dailyNewTarget;
  final String timezone;
  final String? remindMorning;
  final String? remindEvening;
  final bool smartRemind;

  factory FirestoreUserGoal.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User goal document ${doc.id} is missing data.');
    }

    return FirestoreUserGoal(
      userId: doc.id,
      dailyNewTarget: (data['daily_new_target'] as num?)?.toInt() ?? 0,
      timezone: (data['tz'] as String?) ?? 'UTC',
      remindMorning: data['remind_morning'] as String?,
      remindEvening: data['remind_evening'] as String?,
      smartRemind: (data['smart_remind'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'daily_new_target': dailyNewTarget,
      'tz': timezone,
      'remind_morning': remindMorning,
      'remind_evening': remindEvening,
      'smart_remind': smartRemind,
    };
  }

  FirestoreUserGoal copyWith({
    int? dailyNewTarget,
    String? timezone,
    String? remindMorning,
    String? remindEvening,
    bool? smartRemind,
  }) {
    return FirestoreUserGoal(
      userId: userId,
      dailyNewTarget: dailyNewTarget ?? this.dailyNewTarget,
      timezone: timezone ?? this.timezone,
      remindMorning: remindMorning ?? this.remindMorning,
      remindEvening: remindEvening ?? this.remindEvening,
      smartRemind: smartRemind ?? this.smartRemind,
    );
  }
}
