import 'package:hive/hive.dart';

part 'abbreviation.g.dart';

@HiveType(typeId: 5)
enum AbbreviationCategory {
  @HiveField(0)
  business,
  @HiveField(1)
  common,
  @HiveField(2)
  custom,
}

extension AbbreviationCategoryExtension on AbbreviationCategory {
  String get categoryText {
    switch (this) {
      case AbbreviationCategory.business:
        return 'Business';
      case AbbreviationCategory.common:
        return 'Academic';
      case AbbreviationCategory.custom:
        return 'General';
    }
  }
}

@HiveType(typeId: 6)
class Abbreviation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullWord;

  @HiveField(2)
  String abbreviation;

  @HiveField(3)
  AbbreviationCategory category;

  @HiveField(4)
  int frequency; // usage tracking

  @HiveField(5)
  bool isUserCreated;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String? description;

  Abbreviation({
    required this.id,
    required this.fullWord,
    required this.abbreviation,
    required this.category,
    required this.frequency,
    required this.isUserCreated,
    required this.createdAt,
    this.description,
  });

  factory Abbreviation.create({
    required String fullWord,
    required String abbreviation,
    AbbreviationCategory category = AbbreviationCategory.custom,
    String? description,
  }) {
    return Abbreviation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullWord: fullWord,
      abbreviation: abbreviation,
      category: category,
      frequency: 0,
      isUserCreated: true,
      createdAt: DateTime.now(),
      description: description,
    );
  }

  void incrementUsage() {
    frequency++;
  }

  String get categoryText {
    switch (category) {
      case AbbreviationCategory.business:
        return 'Business';
      case AbbreviationCategory.common:
        return 'Academic';
      case AbbreviationCategory.custom:
        return 'General';
    }
  }

  bool get isPopular => frequency > 10;
}
