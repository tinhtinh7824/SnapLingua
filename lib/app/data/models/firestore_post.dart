import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of community posts.
class FirestorePost {
  FirestorePost({
    required this.postId,
    required this.userId,
    required this.photoUrl,
    this.photoId,
    this.caption,
    required this.visibility,
    required this.status,
    required this.createdAt,
    this.saveCount = 0,
  });

  final String postId;
  final String userId;
  final String photoUrl;
  final String? photoId;
  final String? caption;
  final String visibility;
  final String status;
  final DateTime createdAt;
  final int saveCount;

  factory FirestorePost.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Post document ${doc.id} is missing data.');
    }

    return FirestorePost(
      postId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      photoUrl: (data['photo_url'] as String?) ?? '',
      photoId: data['photo_id'] as String?,
      caption: data['caption'] as String?,
      visibility: (data['visibility'] as String?) ?? 'public',
      status: (data['status'] as String?) ?? 'active',
      createdAt: _asDateTime(data['created_at']),
      saveCount: (data['save_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'user_id': userId,
      'photo_url': photoUrl,
      'photo_id': photoId,
      'caption': caption,
      'visibility': visibility,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
      'save_count': saveCount,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }

  FirestorePost copyWith({
    String? userId,
    String? photoUrl,
    String? photoId,
    String? caption,
    String? visibility,
    String? status,
    DateTime? createdAt,
    int? saveCount,
  }) {
    return FirestorePost(
      postId: postId,
      userId: userId ?? this.userId,
      photoUrl: photoUrl ?? this.photoUrl,
      photoId: photoId ?? this.photoId,
      caption: caption ?? this.caption,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      saveCount: saveCount ?? this.saveCount,
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
