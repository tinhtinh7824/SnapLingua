import 'package:realm/realm.dart';

part 'lesson_model.realm.dart';

@RealmModel()
class _Lesson {
  @PrimaryKey()
  late String id;
  late String title;
  late String? description;
  late String categoryId;
  late int level;
  late int sortOrder;
  late String difficulty; // beginner, intermediate, advanced
  late String type; // vocabulary, grammar, pronunciation
  late int estimatedTime; // minutes
  late int xpReward;
  late bool isPremium;
  late bool isActive;
  late String? imageUrl;
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _LessonContent {
  @PrimaryKey()
  late String id;
  late String lessonId;
  late String contentType; // text, image, audio, video
  late String content;
  late String? metadata; // JSON string for additional data
  late int sortOrder;
  late DateTime createdAt;
}

@RealmModel()
class _UserLesson {
  @PrimaryKey()
  late String id;
  late String userId;
  late String lessonId;
  late String status; // not_started, in_progress, completed
  late double progress; // 0.0 to 1.0
  late int xpEarned;
  late DateTime? startedAt;
  late DateTime? completedAt;
  late DateTime? lastAccessedAt;
  late DateTime createdAt;
}

@RealmModel()
class _Exercise {
  @PrimaryKey()
  late String id;
  late String lessonId;
  late String type; // multiple_choice, fill_blank, matching, pronunciation
  late String question;
  late String correctAnswer;
  late String? options; // JSON array for multiple choice
  late String? explanation;
  late int points;
  late int sortOrder;
  late DateTime createdAt;
}

@RealmModel()
class _UserExercise {
  @PrimaryKey()
  late String id;
  late String userId;
  late String exerciseId;
  late String userAnswer;
  late bool isCorrect;
  late int pointsEarned;
  late int attempts;
  late String? feedback;
  late DateTime submittedAt;
}