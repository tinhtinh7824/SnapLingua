import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of detection results for photos.
class FirestoreDetection {
  FirestoreDetection({
    required this.detectionId,
    required this.photoId,
    required this.modelVersion,
    required this.resultJson,
    required this.createdAt,
  });

  final String detectionId;
  final String photoId;
  final String modelVersion;
  final Map<String, dynamic> resultJson;
  final DateTime createdAt;

  factory FirestoreDetection.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Detection document ${doc.id} is missing data.');
    }

    return FirestoreDetection(
      detectionId: doc.id,
      photoId: (data['photo_id'] as String?) ?? '',
      modelVersion: (data['model_version'] as String?) ?? '',
      resultJson:
          (data['result_json'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'photo_id': photoId,
      'model_version': modelVersion,
      'result_json': resultJson,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreDetection copyWith({
    String? photoId,
    String? modelVersion,
    Map<String, dynamic>? resultJson,
    DateTime? createdAt,
  }) {
    return FirestoreDetection(
      detectionId: detectionId,
      photoId: photoId ?? this.photoId,
      modelVersion: modelVersion ?? this.modelVersion,
      resultJson: resultJson ?? this.resultJson,
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
