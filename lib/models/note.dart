import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 9)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  String? category;

  @HiveField(6)
  List<String> tags;

  // Optional images attached to the note (file paths)
  @HiveField(7)
  List<String> imagePaths;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.tags = const [],
    this.imagePaths = const [],
  });

  // Helper getters
  String get displayTitle => title.isEmpty ? 'Untitled Note' : title;
  
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays == 0) {
      return 'Today ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
    }
  }

  String get previewContent {
    if (content.isEmpty) return 'Empty note';
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }
}

