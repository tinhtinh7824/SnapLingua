import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:snaplingua/app/data/models/realm/vocabulary_model.dart';

import 'realm_service.dart';

class VocabularyService extends GetxService {
  static VocabularyService get to => Get.find<VocabularyService>();

  final RealmService _realmService = RealmService.to;

  // Get all vocabulary words
  Future<List<Vocabulary>> getAllVocabulary() async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Vocabulary>().where((v) => v.isActive);
      return results.toList();
    } catch (e) {
      print('Error getting vocabulary: $e');
      return [];
    }
  }

  // Get vocabulary by category
  Future<List<Vocabulary>> getVocabularyByCategory(String category) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Vocabulary>()
          .where((v) => v.category == category && v.isActive);
      return results.toList();
    } catch (e) {
      print('Error getting vocabulary by category: $e');
      return [];
    }
  }

  // Get user's vocabulary progress
  Future<List<UserVocabulary>> getUserVocabulary(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<UserVocabulary>()
          .where((uv) => uv.userId == userId);
      return results.toList();
    } catch (e) {
      print('Error getting user vocabulary: $e');
      return [];
    }
  }

  // Get words due for review
  Future<List<UserVocabulary>> getDueForReview(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final now = DateTime.now();
      final results = realm.all<UserVocabulary>()
          .where((uv) => uv.userId == userId &&
                        uv.nextReviewDate != null &&
                        uv.nextReviewDate!.isBefore(now) &&
                        !uv.isMastered);
      return results.toList();
    } catch (e) {
      print('Error getting due vocabulary: $e');
      return [];
    }
  }

  // Add word to user's learning list
  Future<bool> addWordToLearning(String userId, String vocabularyId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if already exists
      final existing = realm.all<UserVocabulary>()
          .where((uv) => uv.userId == userId && uv.vocabularyId == vocabularyId)
          .firstOrNull;

      if (existing != null) {
        print('Word already in learning list');
        return false;
      }

      final userVocab = UserVocabulary(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        vocabularyId,
        0, // level
        0, // repetitions
        2.5, // easeFactor
        1, // interval
        0, // correctCount
        0, // incorrectCount
        false, // isMastered
        false, // isFavorite
        'learning', // status
        DateTime.now(),
        nextReviewDate: DateTime.now().add(Duration(days: 1)),
        lastReviewedAt: null,
        updatedAt: null,
      );

      realm.write(() => realm.add(userVocab));
      return true;
    } catch (e) {
      print('Error adding word to learning: $e');
      return false;
    }
  }

  // Submit vocabulary review
  Future<bool> submitReview(String userId, String vocabularyId, bool isCorrect, int responseTime, String reviewType) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Find user vocabulary
      final userVocab = realm.all<UserVocabulary>()
          .where((uv) => uv.userId == userId && uv.vocabularyId == vocabularyId)
          .firstOrNull;

      if (userVocab == null) {
        print('User vocabulary not found');
        return false;
      }

      // Create review record
      final review = VocabularyReview(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        vocabularyId,
        userVocab.id,
        isCorrect,
        responseTime,
        reviewType,
        isCorrect ? 5 : 1,
        DateTime.now(),
        feedback: null,
      );

      // Update SRS algorithm
      realm.write(() {
        realm.add(review);
        _updateSRSProgress(userVocab, isCorrect);
      });

      return true;
    } catch (e) {
      print('Error submitting review: $e');
      return false;
    }
  }

  // Update SRS (Spaced Repetition System) progress
  void _updateSRSProgress(UserVocabulary userVocab, bool isCorrect) {
    final now = DateTime.now();

    if (isCorrect) {
      userVocab.correctCount++;
      userVocab.repetitions++;

      if (userVocab.repetitions == 1) {
        userVocab.interval = 1;
      } else if (userVocab.repetitions == 2) {
        userVocab.interval = 6;
      } else {
        userVocab.interval = (userVocab.interval * userVocab.easeFactor).round();
      }

      userVocab.easeFactor = userVocab.easeFactor + (0.1 - (5 - 4) * (0.08 + (5 - 4) * 0.02));
      if (userVocab.easeFactor < 1.3) userVocab.easeFactor = 1.3;

      // Check if mastered (level 8 in SRS)
      if (userVocab.repetitions >= 8 && userVocab.easeFactor >= 2.5) {
        userVocab.isMastered = true;
        userVocab.status = 'mastered';
      }
    } else {
      userVocab.incorrectCount++;
      userVocab.repetitions = 0;
      userVocab.interval = 1;
      userVocab.easeFactor = userVocab.easeFactor - 0.8;
      if (userVocab.easeFactor < 1.3) userVocab.easeFactor = 1.3;
    }

    userVocab.nextReviewDate = now.add(Duration(days: userVocab.interval));
    userVocab.lastReviewedAt = now;
    userVocab.updatedAt = now;
  }

  // Get user progress for a category
  Future<UserProgress?> getCategoryProgress(String userId, String categoryId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final progress = realm.all<UserProgress>()
          .where((p) => p.userId == userId && p.categoryId == categoryId)
          .firstOrNull;

      return progress;
    } catch (e) {
      print('Error getting category progress: $e');
      return null;
    }
  }

  // Search vocabulary
  Future<List<Vocabulary>> searchVocabulary(String query) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Vocabulary>()
          .where((v) => v.isActive &&
                       (v.word.toLowerCase().contains(query.toLowerCase()) ||
                        (v.translation?.toLowerCase().contains(query.toLowerCase()) ?? false)));
      return results.toList();
    } catch (e) {
      print('Error searching vocabulary: $e');
      return [];
    }
  }
}
