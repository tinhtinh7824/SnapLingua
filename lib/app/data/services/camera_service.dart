import 'package:get/get.dart';
import 'package:snaplingua/app/data/models/realm/camera_model.dart';

import 'realm_service.dart';

class CameraService extends GetxService {
  static CameraService get to => Get.find<CameraService>();

  final RealmService _realmService = RealmService.to;

  // Create camera session
  Future<String?> createCameraSession(String userId, String imagePath) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final session = CameraSession(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        'processing', // status
        DateTime.now(),
        imagePath: imagePath,
        processedImagePath: null,
        processedAt: null,
      );

      realm.write(() => realm.add(session));
      return session.id;
    } catch (e) {
      print('Error creating camera session: $e');
      return null;
    }
  }

  // Update session status and results
  Future<bool> updateSessionResults(String sessionId, String status, String? processedImagePath, List<Map<String, dynamic>> detectedObjects) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final session = realm.find<CameraSession>(sessionId);
      if (session == null) {
        print('Camera session not found');
        return false;
      }

      realm.write(() {
        session.status = status;
        session.processedImagePath = processedImagePath;
        session.processedAt = DateTime.now();
      });

      // Save detected objects
      for (final objectData in detectedObjects) {
        final detectedObject = DetectedObject(
          DateTime.now().millisecondsSinceEpoch.toString(),
          sessionId,
          objectData['objectName'] ?? '',
          objectData['confidence']?.toDouble() ?? 0.0,
          objectData['isKnownVocabulary'] ?? false,
          DateTime.now(),
          vietnameseName: objectData['vietnameseName'],
          boundingBox: objectData['boundingBox']?.toString(),
          vocabularyId: objectData['vocabularyId'],
        );

        realm.write(() => realm.add(detectedObject));
      }

      return true;
    } catch (e) {
      print('Error updating session results: $e');
      return false;
    }
  }

  // Get camera session with detected objects
  Future<Map<String, dynamic>?> getCameraSessionDetails(String sessionId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final session = realm.find<CameraSession>(sessionId);
      if (session == null) return null;

      final detectedObjects = realm.all<DetectedObject>()
          .where((obj) => obj.cameraSessionId == sessionId);

      return {
        'session': session,
        'detectedObjects': detectedObjects.toList(),
      };
    } catch (e) {
      print('Error getting camera session details: $e');
      return null;
    }
  }

  // Get user's camera history
  Future<List<CameraHistory>> getUserCameraHistory(String userId, {int limit = 50}) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<CameraHistory>()
          .where((ch) => ch.userId == userId)
          .toList()
        ..sort((a, b) => b.sessionDate.compareTo(a.sessionDate));

      return results.take(limit).toList();
    } catch (e) {
      print('Error getting camera history: $e');
      return [];
    }
  }

  // Create camera history entry
  Future<bool> createCameraHistory(String userId, String sessionId, int objectsDetected, int newWordsLearned, int xpEarned) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final history = CameraHistory(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        sessionId,
        objectsDetected,
        newWordsLearned,
        xpEarned,
        DateTime.now(),
      );

      realm.write(() => realm.add(history));
      return true;
    } catch (e) {
      print('Error creating camera history: $e');
      return false;
    }
  }

  // Get recent camera sessions
  Future<List<CameraSession>> getRecentSessions(String userId, {int limit = 20}) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<CameraSession>()
          .where((cs) => cs.userId == userId)
          .toList()
        ..sort((a, b) => b.capturedAt.compareTo(a.capturedAt));

      return results.take(limit).toList();
    } catch (e) {
      print('Error getting recent sessions: $e');
      return [];
    }
  }

  // Get objects detected in a session
  Future<List<DetectedObject>> getSessionObjects(String sessionId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<DetectedObject>()
          .where((obj) => obj.cameraSessionId == sessionId)
          .toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));

      return results;
    } catch (e) {
      print('Error getting session objects: $e');
      return [];
    }
  }

  // Get statistics for user's camera usage
  Future<Map<String, int>> getCameraStats(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final sessions = realm.all<CameraSession>()
          .where((cs) => cs.userId == userId && cs.status == 'completed');

      final history = realm.all<CameraHistory>()
          .where((ch) => ch.userId == userId);

      final totalSessions = sessions.length;
      final totalObjectsDetected = history.fold<int>(0, (sum, h) => sum + h.objectsDetected);
      final totalWordsLearned = history.fold<int>(0, (sum, h) => sum + h.newWordsLearned);
      final totalXpEarned = history.fold<int>(0, (sum, h) => sum + h.xpEarned);

      return {
        'totalSessions': totalSessions,
        'totalObjectsDetected': totalObjectsDetected,
        'totalWordsLearned': totalWordsLearned,
        'totalXpEarned': totalXpEarned,
      };
    } catch (e) {
      print('Error getting camera stats: $e');
      return {
        'totalSessions': 0,
        'totalObjectsDetected': 0,
        'totalWordsLearned': 0,
        'totalXpEarned': 0,
      };
    }
  }

  // Clean up old camera sessions (for storage management)
  Future<void> cleanupOldSessions({int daysToKeep = 30}) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

      final oldSessions = realm.all<CameraSession>()
          .where((cs) => cs.capturedAt.isBefore(cutoffDate));

      final oldHistory = realm.all<CameraHistory>()
          .where((ch) => ch.sessionDate.isBefore(cutoffDate));

      final oldObjects = realm.all<DetectedObject>()
          .where((obj) => obj.detectedAt.isBefore(cutoffDate));

      realm.write(() {
        realm.deleteMany(oldSessions);
        realm.deleteMany(oldHistory);
        realm.deleteMany(oldObjects);
      });

      print('Cleaned up ${oldSessions.length} old camera sessions');
    } catch (e) {
      print('Error cleaning up old sessions: $e');
    }
  }

  // Search detected objects by name
  Future<List<DetectedObject>> searchDetectedObjects(String userId, String query) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Get user's sessions first
      final userSessions = realm.all<CameraSession>()
          .where((cs) => cs.userId == userId)
          .map((cs) => cs.id)
          .toSet();

      final results = realm.all<DetectedObject>()
          .where((obj) => userSessions.contains(obj.cameraSessionId) &&
                         (obj.objectName.toLowerCase().contains(query.toLowerCase()) ||
                          (obj.vietnameseName?.toLowerCase().contains(query.toLowerCase()) ?? false)));

      return results.toList();
    } catch (e) {
      print('Error searching detected objects: $e');
      return [];
    }
  }
}
