import 'package:realm/realm.dart';

part 'personal_word_realm.g.dart';

@RealmModel()
class _PersonalWord {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  // User reference
  late String userId;

  // Word reference or custom
  String? wordId;
  String? customHeadword;
  String? customIpa;
  String? customMeaningVi;

  // Learning status
  late String status = 'learning'; // learning, learned, archived
  late String source = 'camera'; // camera, manual, community, import
  String? sourcePhotoUrl;

  // SRS Algorithm (SM-2)
  late int srsStage = 0; // 0-6
  late double srsEase = 2.5; // Ease factor
  late int srsInterval = 1; // Days until next review
  late DateTime srsDueAt;
  late int repetitions = 0;
  late int wrongStreak = 0;
  late int forgetCount = 0;
  DateTime? lastReviewedAt;

  // Topics/Tags
  late List<String> topicIds = const [];

  // Metadata
  late DateTime createdAt;
  DateTime? lastSyncedAt;

  // Offline tracking
  late bool needsSync = false;
  String? conflictResolution;
}