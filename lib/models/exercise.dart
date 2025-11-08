import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 1)
enum ExerciseDifficulty {
  @HiveField(0)
  beginner,
  @HiveField(1)
  intermediate,
  @HiveField(2)
  advanced,
}

extension ExerciseDifficultyExtension on ExerciseDifficulty {
  String get difficultyText {
    switch (this) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';
      case ExerciseDifficulty.intermediate:
        return 'Intermediate';
      case ExerciseDifficulty.advanced:
        return 'Advanced';
    }
  }
}

@HiveType(typeId: 2)
enum ExerciseCategory {
  @HiveField(0)
  business,
  @HiveField(1)
  academic,
  @HiveField(2)
  general,
}

extension ExerciseCategoryExtension on ExerciseCategory {
  String get categoryText {
    switch (this) {
      case ExerciseCategory.business:
        return 'Business';
      case ExerciseCategory.academic:
        return 'Academic';
      case ExerciseCategory.general:
        return 'General';
    }
  }
}

@HiveType(typeId: 3)
class Exercise extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String idealNotes;

  @HiveField(4)
  ExerciseDifficulty difficulty;

  @HiveField(5)
  int duration; // seconds

  @HiveField(6)
  ExerciseCategory category;

  @HiveField(7)
  bool isPremium;

  @HiveField(8)
  double estimatedWPM;

  @HiveField(9)
  List<String> keyTerms;

  @HiveField(10)
  List<String> suggestedAbbreviations;

  @HiveField(11)
  String? audioFilePath;

  Exercise({
    required this.id,
    required this.title,
    required this.content,
    required this.idealNotes,
    required this.difficulty,
    required this.duration,
    required this.category,
    required this.isPremium,
    required this.estimatedWPM,
    this.keyTerms = const [],
    this.suggestedAbbreviations = const [],
    this.audioFilePath,
  });

  String get difficultyText {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';
      case ExerciseDifficulty.intermediate:
        return 'Intermediate';
      case ExerciseDifficulty.advanced:
        return 'Advanced';
    }
  }

  String get categoryText {
    switch (category) {
      case ExerciseCategory.business:
        return 'Business';
      case ExerciseCategory.academic:
        return 'Academic';
      case ExerciseCategory.general:
        return 'General';
    }
  }

  String get durationText {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes > 0) {
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    }
    return '${seconds}s';
  }
}
