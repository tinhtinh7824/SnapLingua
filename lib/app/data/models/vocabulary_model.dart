import 'package:realm/realm.dart';

part 'vocabulary_model.realm.dart';

@RealmModel()
class _Vocabulary {
  @PrimaryKey()
  late String id;
  late String word;
  late String? pronunciation;
  late String? phonetic;
  late String definition;
  late String? example;
  late String? translation;
  late String? imageUrl;
  late String? audioUrl;
  late String difficulty; // easy, medium, hard
  late String category;
  late String? tags;
  late int frequency;
  late bool isActive;
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _UserVocabulary {
  @PrimaryKey()
  late String id;
  late String userId;
  late String vocabularyId;
  late int level; // SRS level (0-8)
  late int repetitions;
  late double easeFactor;
  late int interval;
  late DateTime? nextReviewDate;
  late DateTime? lastReviewedAt;
  late int correctCount;
  late int incorrectCount;
  late bool isMastered;
  late bool isFavorite;
  late String status; // learning, reviewing, mastered
  late DateTime createdAt;
  late DateTime? updatedAt;
}

@RealmModel()
class _VocabularyReview {
  @PrimaryKey()
  late String id;
  late String userId;
  late String vocabularyId;
  late String userVocabularyId;
  late bool isCorrect;
  late int responseTime; // milliseconds
  late String reviewType; // recognition, recall, spelling
  late int difficulty; // 1-5 rating
  late String? feedback;
  late DateTime reviewedAt;
}

@RealmModel()
class _Category {
  @PrimaryKey()
  late String id;
  late String name;
  late String? description;
  late String? iconUrl;
  late String? color;
  late int sortOrder;
  late bool isActive;
  late DateTime createdAt;
}

@RealmModel()
class _UserProgress {
  @PrimaryKey()
  late String id;
  late String userId;
  late String categoryId;
  late int totalWords;
  late int learnedWords;
  late int masteredWords;
  late double accuracy;
  late int totalReviews;
  late DateTime? lastStudiedAt;
  late DateTime createdAt;
  late DateTime? updatedAt;
}