import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of words attached to a community post.
class FirestorePostWord {
  FirestorePostWord({
    required this.id,
    required this.postId,
    this.wordId,
    required this.meaningSnapshot,
    this.exampleSnapshot,
    this.audioUrlSnapshot,
  });

  final String id;
  final String postId;
  final String? wordId;
  final String meaningSnapshot;
  final String? exampleSnapshot;
  final String? audioUrlSnapshot;

  factory FirestorePostWord.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Post word document ${doc.id} is missing data.');
    }

    return FirestorePostWord(
      id: doc.id,
      postId: (data['post_id'] as String?) ?? '',
      wordId: data['word_id'] as String?,
      meaningSnapshot: (data['meaning_snapshot'] as String?) ?? '',
      exampleSnapshot: data['example_snapshot'] as String?,
      audioUrlSnapshot: data['audio_url_snapshot'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'word_id': wordId,
      'meaning_snapshot': meaningSnapshot,
      'example_snapshot': exampleSnapshot,
      'audio_url_snapshot': audioUrlSnapshot,
    };
  }

  FirestorePostWord copyWith({
    String? postId,
    String? wordId,
    String? meaningSnapshot,
    String? exampleSnapshot,
    String? audioUrlSnapshot,
  }) {
    return FirestorePostWord(
      id: id,
      postId: postId ?? this.postId,
      wordId: wordId ?? this.wordId,
      meaningSnapshot: meaningSnapshot ?? this.meaningSnapshot,
      exampleSnapshot: exampleSnapshot ?? this.exampleSnapshot,
      audioUrlSnapshot: audioUrlSnapshot ?? this.audioUrlSnapshot,
    );
  }
}
