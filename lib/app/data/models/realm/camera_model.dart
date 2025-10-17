import 'package:realm/realm.dart';

part 'camera_model.realm.dart';

@RealmModel()
class _CameraSession {
  @PrimaryKey()
  late String id;
  late String userId;
  late String? imagePath;
  late String? processedImagePath;
  late String status; // processing, completed, failed
  late DateTime capturedAt;
  late DateTime? processedAt;
}

@RealmModel()
class _DetectedObject {
  @PrimaryKey()
  late String id;
  late String cameraSessionId;
  late String objectName;
  late String? vietnameseName;
  late double confidence;
  late String? boundingBox; // JSON string for coordinates
  late String? vocabularyId;
  late bool isKnownVocabulary;
  late DateTime detectedAt;
}

@RealmModel()
class _CameraHistory {
  @PrimaryKey()
  late String id;
  late String userId;
  late String cameraSessionId;
  late int objectsDetected;
  late int newWordsLearned;
  late int xpEarned;
  late DateTime sessionDate;
}