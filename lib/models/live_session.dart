import 'package:hive/hive.dart';

part 'live_session.g.dart';

@HiveType(typeId: 7)
enum SessionType {
  @HiveField(0)
  meeting,
  @HiveField(1)
  lecture,
  @HiveField(2)
  practice,
}

@HiveType(typeId: 8)
class LiveSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String transcript;

  @HiveField(2)
  String userNotes;

  @HiveField(3)
  int duration; // minutes

  @HiveField(4)
  double score;

  @HiveField(5)
  SessionType sessionType;

  @HiveField(6)
  DateTime completedAt;

  @HiveField(7)
  String? audioFilePath;

  @HiveField(8)
  double transcriptionAccuracy;

  @HiveField(9)
  List<String> keyPointsCaptured;

  @HiveField(10)
  List<String> missedPoints;

  LiveSession({
    required this.id,
    required this.transcript,
    required this.userNotes,
    required this.duration,
    required this.score,
    required this.sessionType,
    required this.completedAt,
    this.audioFilePath,
    this.transcriptionAccuracy = 0.0,
    this.keyPointsCaptured = const [],
    this.missedPoints = const [],
  });

  factory LiveSession.create({
    required String transcript,
    required String userNotes,
    required int duration,
    required SessionType sessionType,
    String? audioFilePath,
  }) {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    
    // Calculate score based on how well user notes match transcript
    final score = _calculateMatchScore(userNotes, transcript);
    
    return LiveSession(
      id: id,
      transcript: transcript,
      userNotes: userNotes,
      duration: duration,
      score: score,
      sessionType: sessionType,
      completedAt: now,
      audioFilePath: audioFilePath,
      keyPointsCaptured: _extractKeyPoints(userNotes),
      missedPoints: _findMissedPoints(userNotes, transcript),
    );
  }

  static double _calculateMatchScore(String userNotes, String transcript) {
    if (transcript.isEmpty) return 0.0;
    
    final userWords = userNotes.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
    final transcriptWords = transcript.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
    
    final intersection = userWords.intersection(transcriptWords);
    final union = userWords.union(transcriptWords);
    
    if (union.isEmpty) return 0.0;
    
    // Jaccard similarity
    return (intersection.length / union.length) * 100;
  }

  static List<String> _extractKeyPoints(String userNotes) {
    // Simple key point extraction - look for capitalized words, numbers, and common business terms
    final words = userNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final keyPoints = <String>[];
    
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      
      // Check for numbers, percentages, dollar amounts
      if (RegExp(r'\d+').hasMatch(word)) {
        keyPoints.add(word);
      }
      
      // Check for capitalized words (likely proper nouns)
      if (word.length > 2 && word[0] == word[0].toUpperCase() && word.substring(1) == word.substring(1).toLowerCase()) {
        keyPoints.add(word);
      }
      
      // Check for common business terms
      final businessTerms = ['budget', 'meeting', 'project', 'deadline', 'goal', 'target', 'revenue', 'profit'];
      if (businessTerms.contains(word.toLowerCase())) {
        keyPoints.add(word);
      }
    }
    
    return keyPoints;
  }

  static List<String> _findMissedPoints(String userNotes, String transcript) {
    final userLower = userNotes.toLowerCase();
    final transcriptWords = transcript.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final missed = <String>[];
    
    // Look for important words in transcript that aren't in user notes
    final importantWords = ['budget', 'deadline', 'meeting', 'project', 'goal', 'target', 'revenue', 'profit', 'cost', 'price'];
    
    for (final word in importantWords) {
      if (transcriptWords.contains(word) && !userLower.contains(word)) {
        missed.add(word);
      }
    }
    
    return missed;
  }

  String get sessionTypeText {
    switch (sessionType) {
      case SessionType.meeting:
        return 'Meeting';
      case SessionType.lecture:
        return 'Lecture';
      case SessionType.practice:
        return 'Practice';
    }
  }

  String get performanceDescription {
    if (score >= 80) return 'Excellent capture of key points!';
    if (score >= 60) return 'Good job capturing most important details';
    if (score >= 40) return 'Decent notes, try focusing on key decisions';
    return 'Keep practicing to improve your note-taking speed';
  }
}

