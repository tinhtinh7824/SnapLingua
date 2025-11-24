import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of comments on posts.
class FirestorePostComment {
  FirestorePostComment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.commentType,
    this.content,
    this.badgeId,
    required this.status,
    required this.createdAt,
  });

  final String commentId;
  final String postId;
  final String userId;
  final String commentType;
  final String? content;
  final String? badgeId;
  final String status;
  final DateTime createdAt;

  factory FirestorePostComment.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Post comment document ${doc.id} is missing data.');
    }

    return FirestorePostComment(
      commentId: doc.id,
      postId: (data['post_id'] as String?) ?? '',
      userId: (data['user_id'] as String?) ?? '',
      commentType: (data['comment_type'] as String?) ?? 'text',
      content: data['content'] as String?,
      badgeId: data['badge_id'] as String?,
      status: (data['status'] as String?) ?? 'active',
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'comment_type': commentType,
      'content': content,
      'badge_id': badgeId,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestorePostComment copyWith({
    String? postId,
    String? userId,
    String? commentType,
    String? content,
    String? badgeId,
    String? status,
    DateTime? createdAt,
  }) {
    return FirestorePostComment(
      commentId: commentId,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      commentType: commentType ?? this.commentType,
      content: content ?? this.content,
      badgeId: badgeId ?? this.badgeId,
      status: status ?? this.status,
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
