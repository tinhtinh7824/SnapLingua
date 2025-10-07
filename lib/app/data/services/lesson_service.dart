import 'package:get/get.dart';
import 'package:realm/realm.dart';
import '../models/lesson_model.dart';
import 'realm_service.dart';

class LessonService extends GetxService {
  static LessonService get to => Get.find<LessonService>();

  final RealmService _realmService = RealmService.to;

  // Get all lessons
  Future<List<Lesson>> getAllLessons() async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Lesson>()
          .where((l) => l.isActive)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      return results;
    } catch (e) {
      print('Error getting lessons: $e');
      return [];
    }
  }

  // Get lessons by category
  Future<List<Lesson>> getLessonsByCategory(String categoryId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Lesson>()
          .where((l) => l.categoryId == categoryId && l.isActive)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      return results;
    } catch (e) {
      print('Error getting lessons by category: $e');
      return [];
    }
  }

  // Get lesson content
  Future<List<LessonContent>> getLessonContent(String lessonId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<LessonContent>()
          .where((lc) => lc.lessonId == lessonId)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      return results;
    } catch (e) {
      print('Error getting lesson content: $e');
      return [];
    }
  }

  // Get lesson exercises
  Future<List<Exercise>> getLessonExercises(String lessonId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Exercise>()
          .where((e) => e.lessonId == lessonId)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      return results;
    } catch (e) {
      print('Error getting lesson exercises: $e');
      return [];
    }
  }

  // Get user lesson progress
  Future<UserLesson?> getUserLessonProgress(String userId, String lessonId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final userLesson = realm.all<UserLesson>()
          .where((ul) => ul.userId == userId && ul.lessonId == lessonId)
          .firstOrNull;

      return userLesson;
    } catch (e) {
      print('Error getting user lesson progress: $e');
      return null;
    }
  }

  // Start lesson
  Future<bool> startLesson(String userId, String lessonId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Check if already exists
      final existing = realm.all<UserLesson>()
          .where((ul) => ul.userId == userId && ul.lessonId == lessonId)
          .firstOrNull;

      if (existing != null) {
        // Update last accessed
        realm.write(() {
          existing.lastAccessedAt = DateTime.now();
          if (existing.status == 'not_started') {
            existing.status = 'in_progress';
            existing.startedAt = DateTime.now();
          }
        });
        return true;
      }

      // Create new user lesson
      final userLesson = UserLesson(
        DateTime.now().millisecondsSinceEpoch.toString(),
        userId,
        lessonId,
        'in_progress',
        0.0,
        0,
        DateTime.now(),
        startedAt: DateTime.now(),
        completedAt: null,
        lastAccessedAt: DateTime.now(),
      );

      realm.write(() => realm.add(userLesson));
      return true;
    } catch (e) {
      print('Error starting lesson: $e');
      return false;
    }
  }

  // Update lesson progress
  Future<bool> updateLessonProgress(String userId, String lessonId, double progress) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final userLesson = realm.all<UserLesson>()
          .where((ul) => ul.userId == userId && ul.lessonId == lessonId)
          .firstOrNull;

      if (userLesson == null) {
        print('User lesson not found');
        return false;
      }

      realm.write(() {
        userLesson.progress = progress;
        userLesson.lastAccessedAt = DateTime.now();

        if (progress >= 1.0 && userLesson.status != 'completed') {
          userLesson.status = 'completed';
          userLesson.completedAt = DateTime.now();

          // Award XP
          final lesson = realm.find<Lesson>(userLesson.lessonId);
          if (lesson != null) {
            userLesson.xpEarned = lesson.xpReward;
          }
        }
      });

      return true;
    } catch (e) {
      print('Error updating lesson progress: $e');
      return false;
    }
  }

  // Submit exercise answer
  Future<bool> submitExerciseAnswer(String userId, String exerciseId, String answer) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final exercise = realm.find<Exercise>(exerciseId);
      if (exercise == null) {
        print('Exercise not found');
        return false;
      }

      final isCorrect = _checkAnswer(exercise, answer);
      final points = isCorrect ? exercise.points : 0;

      // Check if user exercise already exists
      final existing = realm.all<UserExercise>()
          .where((ue) => ue.userId == userId && ue.exerciseId == exerciseId)
          .firstOrNull;

      if (existing != null) {
        realm.write(() {
          existing.userAnswer = answer;
          existing.isCorrect = isCorrect;
          existing.pointsEarned = points;
          existing.attempts++;
          existing.submittedAt = DateTime.now();
        });
      } else {
        final userExercise = UserExercise(
          DateTime.now().millisecondsSinceEpoch.toString(),
          userId,
          exerciseId,
          answer,
          isCorrect,
          points,
          1,
          DateTime.now(),
          feedback: null,
        );

        realm.write(() => realm.add(userExercise));
      }

      return true;
    } catch (e) {
      print('Error submitting exercise answer: $e');
      return false;
    }
  }

  // Check if answer is correct
  bool _checkAnswer(Exercise exercise, String userAnswer) {
    switch (exercise.type) {
      case 'multiple_choice':
        return userAnswer.toLowerCase() == exercise.correctAnswer.toLowerCase();
      case 'fill_blank':
        return userAnswer.toLowerCase().trim() == exercise.correctAnswer.toLowerCase().trim();
      case 'matching':
        // For matching exercises, answer format might be "1-A,2-B,3-C"
        return userAnswer == exercise.correctAnswer;
      default:
        return userAnswer.toLowerCase() == exercise.correctAnswer.toLowerCase();
    }
  }

  // Get user's completed lessons
  Future<List<UserLesson>> getCompletedLessons(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<UserLesson>()
          .where((ul) => ul.userId == userId && ul.status == 'completed');
      return results.toList();
    } catch (e) {
      print('Error getting completed lessons: $e');
      return [];
    }
  }

  // Get lessons by difficulty
  Future<List<Lesson>> getLessonsByDifficulty(String difficulty) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      final results = realm.all<Lesson>()
          .where((l) => l.difficulty == difficulty && l.isActive)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      return results;
    } catch (e) {
      print('Error getting lessons by difficulty: $e');
      return [];
    }
  }

  // Get recommended lessons for user
  Future<List<Lesson>> getRecommendedLessons(String userId) async {
    try {
      final realm = _realmService.realm;
      if (realm == null) throw Exception('Realm not initialized');

      // Get user's completed lessons
      final completedLessons = await getCompletedLessons(userId);
      final completedLessonIds = completedLessons.map((ul) => ul.lessonId).toSet();

      // Get lessons not completed yet
      final allLessons = await getAllLessons();
      final availableLessons = allLessons
          .where((lesson) => !completedLessonIds.contains(lesson.id))
          .take(10)
          .toList();

      return availableLessons;
    } catch (e) {
      print('Error getting recommended lessons: $e');
      return [];
    }
  }
}