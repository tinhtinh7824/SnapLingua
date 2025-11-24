import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of dictionary words.
class FirestoreDictionaryWord {
  FirestoreDictionaryWord({
    required this.wordId,
    required this.headword,
    required this.normalizedHeadword,
    this.ipa,
    this.partOfSpeech,
    required this.meaningVi,
    this.exampleEn,
    this.exampleVi,
    this.audioUrl,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
  });

  final String wordId;
  final String headword;
  final String normalizedHeadword;
  final String? ipa;
  final String? partOfSpeech;
  final String meaningVi;
  final String? exampleEn;
  final String? exampleVi;
  final String? audioUrl;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;

  factory FirestoreDictionaryWord.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Dictionary word document ${doc.id} is missing data.');
    }

    return FirestoreDictionaryWord(
      wordId: doc.id,
      headword: (data['headword'] as String?) ?? '',
      normalizedHeadword: (data['normalized_headword'] as String?) ?? '',
      ipa: data['ipa'] as String?,
      partOfSpeech: data['pos'] as String?,
      meaningVi: (data['meaning_vi'] as String?) ?? '',
      exampleEn: data['example_en'] as String?,
      exampleVi: data['example_vi'] as String?,
      audioUrl: data['audio_url'] as String?,
      imageUrl: data['image_url'] as String?,
      createdBy: (data['created_by'] as String?) ?? '',
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'headword': headword,
      'normalized_headword': normalizedHeadword,
      'ipa': ipa,
      'pos': partOfSpeech,
      'meaning_vi': meaningVi,
      'example_en': exampleEn,
      'example_vi': exampleVi,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'created_by': createdBy,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreDictionaryWord copyWith({
    String? headword,
    String? normalizedHeadword,
    String? ipa,
    String? partOfSpeech,
    String? meaningVi,
    String? exampleEn,
    String? exampleVi,
    String? audioUrl,
    String? imageUrl,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return FirestoreDictionaryWord(
      wordId: wordId,
      headword: headword ?? this.headword,
      normalizedHeadword: normalizedHeadword ?? this.normalizedHeadword,
      ipa: ipa ?? this.ipa,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      meaningVi: meaningVi ?? this.meaningVi,
      exampleEn: exampleEn ?? this.exampleEn,
      exampleVi: exampleVi ?? this.exampleVi,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
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
