import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of labels produced by a detection.
class FirestoreDetectionWord {
  FirestoreDetectionWord({
    required this.id,
    required this.detectionId,
    required this.label,
    required this.confidence,
    this.mappedWordId,
    this.bbox,
    required this.selected,
    required this.createdAt,
  });

  final String id;
  final String detectionId;
  final String label;
  final int confidence;
  final String? mappedWordId;
  final Map<String, dynamic>? bbox;
  final bool selected;
  final DateTime createdAt;

  factory FirestoreDetectionWord.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Detection word document ${doc.id} is missing data.');
    }

    return FirestoreDetectionWord(
      id: doc.id,
      detectionId: (data['detection_id'] as String?) ?? '',
      label: (data['label'] as String?) ?? '',
      confidence: (data['confidence'] as num?)?.toInt() ?? 0,
      mappedWordId: data['mapped_word_id'] as String?,
      bbox: data['bbox'] as Map<String, dynamic>?,
      selected: (data['selected'] as bool?) ?? false,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detection_id': detectionId,
      'label': label,
      'confidence': confidence,
      'mapped_word_id': mappedWordId,
      'bbox': bbox,
      'selected': selected,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreDetectionWord copyWith({
    String? detectionId,
    String? label,
    int? confidence,
    String? mappedWordId,
    Map<String, dynamic>? bbox,
    bool? selected,
    DateTime? createdAt,
  }) {
    return FirestoreDetectionWord(
      id: id,
      detectionId: detectionId ?? this.detectionId,
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      mappedWordId: mappedWordId ?? this.mappedWordId,
      bbox: bbox ?? this.bbox,
      selected: selected ?? this.selected,
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
