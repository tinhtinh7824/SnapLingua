import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a league cycle (weekly stage).
class FirestoreLeagueCycle {
  FirestoreLeagueCycle({
    required this.cycleId,
    required this.tierId,
    required this.startAt,
    required this.endAt,
    required this.status,
  });

  final String cycleId;
  final String tierId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;

  factory FirestoreLeagueCycle.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('League cycle document ${doc.id} is missing data.');
    }

    return FirestoreLeagueCycle(
      cycleId: doc.id,
      tierId: (data['tier_id'] as String?) ?? '',
      startAt: _asDateTime(data['start_at']),
      endAt: _asDateTime(data['end_at']),
      status: (data['status'] as String?) ?? 'running',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tier_id': tierId,
      'start_at': Timestamp.fromDate(startAt),
      'end_at': Timestamp.fromDate(endAt),
      'status': status,
    };
  }

  FirestoreLeagueCycle copyWith({
    String? tierId,
    DateTime? startAt,
    DateTime? endAt,
    String? status,
  }) {
    return FirestoreLeagueCycle(
      cycleId: cycleId,
      tierId: tierId ?? this.tierId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      status: status ?? this.status,
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
