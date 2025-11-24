import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of store items.
class FirestoreItem {
  FirestoreItem({
    required this.itemId,
    required this.code,
    required this.name,
    this.description,
    this.costScales,
    this.costGems,
    required this.createdAt,
  });

  final String itemId;
  final String code;
  final String name;
  final String? description;
  final int? costScales;
  final int? costGems;
  final DateTime createdAt;

  factory FirestoreItem.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Item document ${doc.id} is missing data.');
    }

    return FirestoreItem(
      itemId: doc.id,
      code: (data['code'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      description: data['description'] as String?,
      costScales: (data['cost_scales'] as num?)?.toInt(),
      costGems: (data['cost_gems'] as num?)?.toInt(),
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'cost_scales': costScales,
      'cost_gems': costGems,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreItem copyWith({
    String? code,
    String? name,
    String? description,
    int? costScales,
    int? costGems,
    DateTime? createdAt,
  }) {
    return FirestoreItem(
      itemId: itemId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      costScales: costScales ?? this.costScales,
      costGems: costGems ?? this.costGems,
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
