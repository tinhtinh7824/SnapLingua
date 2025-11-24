import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of league tiers.
class FirestoreLeagueTier {
  FirestoreLeagueTier({
    required this.tierId,
    required this.name,
    required this.orderIndex,
    this.xpCapRule,
  });

  final String tierId;
  final String name;
  final int orderIndex;
  final String? xpCapRule;

  factory FirestoreLeagueTier.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('League tier document ${doc.id} is missing data.');
    }

    return FirestoreLeagueTier(
      tierId: doc.id,
      name: (data['name'] as String?) ?? '',
      orderIndex: (data['order_index'] as num?)?.toInt() ?? 0,
      xpCapRule: data['xp_cap_rule'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order_index': orderIndex,
      'xp_cap_rule': xpCapRule,
    };
  }

  FirestoreLeagueTier copyWith({
    String? name,
    int? orderIndex,
    String? xpCapRule,
  }) {
    return FirestoreLeagueTier(
      tierId: tierId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      xpCapRule: xpCapRule ?? this.xpCapRule,
    );
  }
}
