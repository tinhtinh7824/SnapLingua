import 'package:realm/realm.dart';

part 'study_session_realm.g.dart';

@RealmModel()
class _StudySession {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  // User reference
  late String userId;

  // Session info
  late String sessionType = 'review'; // review, learn, test
  late int wordsStudied = 0;
  late int correctAnswers = 0;
  late int wrongAnswers = 0;
  late int durationSeconds = 0;
  late int xpEarned = 0;

  // Metadata
  late DateTime startedAt;
  DateTime? completedAt;
  late DateTime createdAt;
  DateTime? lastSyncedAt;

  // Offline tracking
  late bool needsSync = false;
}
