import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a user's item inventory entry.
class FirestoreUserInventory {
  FirestoreUserInventory({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.quantity,
    this.expiresAt,
    this.lastUsedAt,
  });

  final String id;
  final String userId;
  final String itemId;
  final int quantity;
  final DateTime? expiresAt;
  final DateTime? lastUsedAt;

  factory FirestoreUserInventory.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User inventory document ${doc.id} is missing data.');
    }

    return FirestoreUserInventory(
      id: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      itemId: (data['item_id'] as String?) ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      expiresAt:
          data['expires_at'] != null ? _asDateTime(data['expires_at']) : null,
      lastUsedAt:
          data['last_used_at'] != null ? _asDateTime(data['last_used_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'item_id': itemId,
      'quantity': quantity,
      'expires_at': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'last_used_at':
          lastUsedAt != null ? Timestamp.fromDate(lastUsedAt!) : null,
    };
  }

  FirestoreUserInventory copyWith({
    String? userId,
    String? itemId,
    int? quantity,
    DateTime? expiresAt,
    DateTime? lastUsedAt,
  }) {
    return FirestoreUserInventory(
      id: id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      expiresAt: expiresAt ?? this.expiresAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
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
