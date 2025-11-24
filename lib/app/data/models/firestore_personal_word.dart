import 'package:cloud_firestore/cloud_firestore.dart';

/// Trạng thái học của từ vựng cá nhân trong Firestore.
class FirestorePersonalWordStatus {
  const FirestorePersonalWordStatus._();

  /// Người dùng chưa bắt đầu học từ này.
  static const String notStarted = 'not_started';

  /// Người dùng đang học/ôn tập từ này.
  static const String learning = 'learning';

  /// Người dùng đã ghi nhớ từ này.
  static const String mastered = 'mastered';
}

/// Firestore representation of a personal word entry owned by a user.
class FirestorePersonalWord {
  FirestorePersonalWord({
    required this.personalWordId,
    required this.userId,
    this.wordId,
    this.customHeadword,
    this.customIpa,
    this.customMeaningVi,
    required this.status,
    required this.source,
    this.sourcePhotoId,
    required this.srsStage,
    required this.srsEase,
    required this.srsIntervalDays,
    required this.srsDueAt,
    required this.repetitions,
    required this.wrongStreak,
    required this.forgetCount,
    this.lastReviewedAt,
    required this.createdAt,
  });

  final String personalWordId;
  final String userId;
  final String? wordId;
  final String? customHeadword;
  final String? customIpa;
  final String? customMeaningVi;
  final String status;
  final String source;
  final String? sourcePhotoId;
  final int srsStage;
  final int srsEase;
  final int srsIntervalDays;
  final DateTime srsDueAt;
  final int repetitions;
  final int wrongStreak;
  final int forgetCount;
  final DateTime? lastReviewedAt;
  final DateTime createdAt;

  factory FirestorePersonalWord.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Personal word document ${doc.id} is missing data.');
    }

    return FirestorePersonalWord(
      personalWordId: doc.id,
      userId: (data['user_id'] as String?) ?? '',
      wordId: data['word_id'] as String?,
      customHeadword: data['custom_headword'] as String?,
      customIpa: data['custom_ipa'] as String?,
      customMeaningVi: data['custom_meaning_vi'] as String?,
      status: (data['status'] as String?) ??
          FirestorePersonalWordStatus.notStarted,
      source: (data['source'] as String?) ?? 'manual',
      sourcePhotoId: data['source_photo_id'] as String?,
      srsStage: (data['srs_stage'] as num?)?.toInt() ?? 0,
      srsEase: (data['srs_ease'] as num?)?.toInt() ?? 0,
      srsIntervalDays: (data['srs_interval_days'] as num?)?.toInt() ?? 0,
      srsDueAt: _asDateTime(data['srs_due_at']),
      repetitions: (data['repetitions'] as num?)?.toInt() ?? 0,
      wrongStreak: (data['wrong_streak'] as num?)?.toInt() ?? 0,
      forgetCount: (data['forget_count'] as num?)?.toInt() ?? 0,
      lastReviewedAt: data['last_reviewed_at'] != null
          ? _asDateTime(data['last_reviewed_at'])
          : null,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'word_id': wordId,
      'custom_headword': customHeadword,
      'custom_ipa': customIpa,
      'custom_meaning_vi': customMeaningVi,
      'status': status,
      'source': source,
      'source_photo_id': sourcePhotoId,
      'srs_stage': srsStage,
      'srs_ease': srsEase,
      'srs_interval_days': srsIntervalDays,
      'srs_due_at': Timestamp.fromDate(srsDueAt),
      'repetitions': repetitions,
      'wrong_streak': wrongStreak,
      'forget_count': forgetCount,
      'last_reviewed_at':
          lastReviewedAt != null ? Timestamp.fromDate(lastReviewedAt!) : null,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestorePersonalWord copyWith({
    String? userId,
    String? wordId,
    String? customHeadword,
    String? customIpa,
    String? customMeaningVi,
    String? status,
    String? source,
    String? sourcePhotoId,
    int? srsStage,
    int? srsEase,
    int? srsIntervalDays,
    DateTime? srsDueAt,
    int? repetitions,
    int? wrongStreak,
    int? forgetCount,
    DateTime? lastReviewedAt,
    DateTime? createdAt,
  }) {
    return FirestorePersonalWord(
      personalWordId: personalWordId,
      userId: userId ?? this.userId,
      wordId: wordId ?? this.wordId,
      customHeadword: customHeadword ?? this.customHeadword,
      customIpa: customIpa ?? this.customIpa,
      customMeaningVi: customMeaningVi ?? this.customMeaningVi,
      status: status ?? this.status,
      source: source ?? this.source,
      sourcePhotoId: sourcePhotoId ?? this.sourcePhotoId,
      srsStage: srsStage ?? this.srsStage,
      srsEase: srsEase ?? this.srsEase,
      srsIntervalDays: srsIntervalDays ?? this.srsIntervalDays,
      srsDueAt: srsDueAt ?? this.srsDueAt,
      repetitions: repetitions ?? this.repetitions,
      wrongStreak: wrongStreak ?? this.wrongStreak,
      forgetCount: forgetCount ?? this.forgetCount,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
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
