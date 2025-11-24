import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a post like.
class FirestorePostLike {
  FirestorePostLike({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final DateTime createdAt;

  factory FirestorePostLike.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Post like document ${doc.id} is missing data.');
    }

    return FirestorePostLike(
      id: doc.id,
      postId: (data['post_id'] as String?) ?? '',
      userId: (data['user_id'] as String?) ?? '',
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestorePostLike copyWith({
    String? postId,
    String? userId,
    DateTime? createdAt,
  }) {
    return FirestorePostLike(
      id: id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
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
