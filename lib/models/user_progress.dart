import 'package:hive/hive.dart';
import '../services/storage_service.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 4)
class UserProgress extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String exerciseId;

  @HiveField(2)
  String userNotes;

  @HiveField(3)
  double score; // 0-100

  @HiveField(4)
  double wpm;

  @HiveField(5)
  double accuracyScore;

  @HiveField(6)
  double brevityScore;

  @HiveField(7)
  double abbreviationUsage;

  @HiveField(8)
  DateTime completedAt;

  @HiveField(9)
  int timeSpent; // seconds

  @HiveField(10)
  List<String> missedKeyPoints;

  @HiveField(11)
  List<String> improvementSuggestions;

  UserProgress({
    required this.id,
    required this.exerciseId,
    required this.userNotes,
    required this.score,
    required this.wpm,
    required this.accuracyScore,
    required this.brevityScore,
    required this.abbreviationUsage,
    required this.completedAt,
    required this.timeSpent,
    this.missedKeyPoints = const [],
    this.improvementSuggestions = const [],
  });

  factory UserProgress.create({
    required String exerciseId,
    required String userNotes,
    required String idealNotes,
    required int timeSpent,
    required List<String> keyTerms,
  }) {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    
    // Calculate scores
    final accuracyScore = _calculateAccuracyScore(userNotes, idealNotes, keyTerms);
    final brevityScore = _calculateBrevityScore(userNotes, idealNotes);
    final abbreviationUsage = _calculateAbbreviationUsage(userNotes);
    final wpm = _calculateWPM(userNotes, timeSpent);
    
    // Overall score: Accuracy is most important for production
    // If accuracy is very low, overall score should be low regardless of other factors
    double score;
    if (accuracyScore < 10.0) {
      // If accuracy is very poor, overall score should be very low
      score = accuracyScore * 0.8; // Heavily weight accuracy
    } else {
      // For decent accuracy, use weighted average
      score = (accuracyScore * 0.6) + (brevityScore * 0.25) + (abbreviationUsage * 0.15);
    }
    
    score = score.clamp(0.0, 100.0);
    
    print('🔍 OVERALL SCORE DEBUG:');
    print('🔍 Accuracy Score: ${accuracyScore.toStringAsFixed(1)}%');
    print('🔍 Brevity Score: ${brevityScore.toStringAsFixed(1)}%');
    print('🔍 Abbreviation Usage: ${abbreviationUsage.toStringAsFixed(1)}%');
    print('🔍 Final Overall Score: ${score.toStringAsFixed(1)}%');
    
    return UserProgress(
      id: id,
      exerciseId: exerciseId,
      userNotes: userNotes,
      score: score,
      wpm: wpm,
      accuracyScore: accuracyScore,
      brevityScore: brevityScore,
      abbreviationUsage: abbreviationUsage,
      completedAt: now,
      timeSpent: timeSpent,
      missedKeyPoints: _findMissedKeyPoints(userNotes, keyTerms),
      improvementSuggestions: _generateImprovementSuggestions(userNotes, idealNotes),
    );
  }

  static double _calculateAccuracyScore(String userNotes, String idealNotes, List<String> keyTerms) {
    print('🔍 ACCURACY DEBUG: keyTerms count: ${keyTerms.length}');
    print('🔍 ACCURACY DEBUG: keyTerms: $keyTerms');
    print('🔍 ACCURACY DEBUG: userNotes: $userNotes');
    
    // If keyTerms is empty, calculate accuracy based on content similarity
    if (keyTerms.isEmpty) {
      print('🔍 ACCURACY DEBUG: No keyTerms, using content similarity');
      return _calculateContentSimilarity(userNotes, idealNotes);
    }
    
    int matchedTerms = 0;
    final userLower = userNotes.toLowerCase();
    
    for (final term in keyTerms) {
      final termLower = term.toLowerCase();
      
      // Check for exact match
      bool isMatched = userLower.contains(termLower);
      
      // If no exact match, check for partial matches and synonyms
      if (!isMatched) {
        isMatched = _checkPartialMatch(userLower, termLower);
      }
      
      print('🔍 ACCURACY DEBUG: Checking term "$term" -> $isMatched');
      if (isMatched) {
        matchedTerms++;
      }
    }
    
    // For production: be strict about accuracy
    // No base score - only reward actual matches
    if (matchedTerms == 0) {
      return 0.0; // No matches = 0% accuracy
    }
    
    // Calculate accuracy based on matched terms
    final accuracy = (matchedTerms / keyTerms.length) * 100.0;
    
    print('🔍 ACCURACY DEBUG: Matched $matchedTerms out of ${keyTerms.length} terms = ${accuracy.toStringAsFixed(1)}%');
    
    return accuracy;
  }

  static bool _checkPartialMatch(String userNotes, String term) {
    // Check for common variations and synonyms
    final variations = <String>[];
    
    switch (term.toLowerCase()) {
      case 'revenue':
        variations.addAll(['income', 'sales', 'money', 'earnings', 'profit']);
        break;
      case 'expenses':
        variations.addAll(['costs', 'spending', 'budget', 'money spent', 'expenditure']);
        break;
      case 'marketing':
        variations.addAll(['promotion', 'advertising', 'campaign', 'mktg', 'mkt']);
        break;
      case 'q3':
        variations.addAll(['quarter 3', 'third quarter', 'q3']);
        break;
      case 'q4':
        variations.addAll(['quarter 4', 'fourth quarter', 'q4']);
        break;
      case 'hiring freeze':
        variations.addAll(['no hiring', 'stop hiring', 'freeze hiring', 'hiring stop']);
        break;
      case 'vendors':
        variations.addAll(['suppliers', 'contractors', 'partners', 'vendors']);
        break;
      case 'cfo':
        variations.addAll(['chief financial officer', 'financial officer', 'finance head']);
        break;
      case 'project':
        variations.addAll(['proj', 'initiative', 'program']);
        break;
      case 'budget':
        variations.addAll(['budg', 'funding', 'money allocated']);
        break;
      case 'timeline':
        variations.addAll(['schedule', 'deadline', 'timeframe', 'duration']);
        break;
      case 'features':
        variations.addAll(['functionality', 'capabilities', 'functions']);
        break;
      case 'prototype':
        variations.addAll(['proto', 'demo', 'sample', 'mockup']);
        break;
      case 'testing':
        variations.addAll(['test', 'qa', 'quality assurance', 'validation']);
        break;
      case 'launch':
        variations.addAll(['release', 'deploy', 'go live', 'rollout']);
        break;
    }
    
    // Check if any variation is found in user notes
    for (final variation in variations) {
      if (userNotes.contains(variation.toLowerCase())) {
        return true;
      }
    }
    
    return false;
  }

  static double _calculateContentSimilarity(String userNotes, String idealNotes) {
    if (userNotes.isEmpty || idealNotes.isEmpty) return 0.0;
    
    final userWords = userNotes.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
    final idealWords = idealNotes.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
    
    if (idealWords.isEmpty) return 0.0;
    
    // Calculate word overlap using Jaccard similarity
    final commonWords = userWords.intersection(idealWords);
    final union = userWords.union(idealWords);
    
    if (union.isEmpty) return 0.0;
    
    // Calculate Jaccard similarity: intersection / union
    final jaccardSimilarity = commonWords.length / union.length;
    
    // Convert to percentage and apply strict scoring
    final similarity = jaccardSimilarity * 100;
    
    // For production: be very strict about accuracy
    // If there are no common words at all, return 0%
    if (commonWords.isEmpty) {
      return 0.0;
    }
    
    // If similarity is very low (less than 5%), return a very low score
    if (similarity < 5.0) {
      return 0.0;
    }
    
    // Apply length penalty for very short responses
    final userLength = userNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final idealLength = idealNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    
    double lengthPenalty = 1.0;
    if (userLength < idealLength * 0.3) {
      lengthPenalty = 0.5; // Heavy penalty for very short responses
    } else if (userLength < idealLength * 0.6) {
      lengthPenalty = 0.8; // Moderate penalty for short responses
    }
    
    final finalScore = (similarity * lengthPenalty).clamp(0.0, 100.0);
    
    print('🔍 CONTENT SIMILARITY DEBUG:');
    print('🔍 User words: ${userWords.length}');
    print('🔍 Ideal words: ${idealWords.length}');
    print('🔍 Common words: ${commonWords.length}');
    print('🔍 Union words: ${union.length}');
    print('🔍 Jaccard similarity: ${jaccardSimilarity.toStringAsFixed(4)}');
    print('🔍 Raw similarity: ${similarity.toStringAsFixed(1)}%');
    print('🔍 Length penalty: ${lengthPenalty.toStringAsFixed(2)}');
    print('🔍 Final score: ${finalScore.toStringAsFixed(1)}%');
    
    return finalScore;
  }

  static double _calculateBrevityScore(String userNotes, String idealNotes) {
    final userWords = userNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final idealWords = idealNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    
    if (idealWords == 0) return 0.0;
    
    // Minimum content requirement - if too short, penalize heavily
    if (userWords < 3) return 10.0; // Very low score for minimal input
    if (userWords < idealWords * 0.2) return 20.0; // Too short gets low score
    
    // Score is higher when user notes are more concise than ideal
    final ratio = userWords / idealWords;
    if (ratio <= 0.5) return 100.0;
    if (ratio <= 1.0) return 100.0 - ((ratio - 0.5) * 100);
    return 50.0 - ((ratio - 1.0) * 25).clamp(0, 50);
  }

  static double _calculateAbbreviationUsage(String userNotes) {
    final words = userNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return 0.0;
    
    // If very few words, don't give high abbreviation scores
    if (words.length < 3) return 0.0;
    
    int abbreviatedWords = 0;
    for (final word in words) {
      // Only count meaningful abbreviations, not just short words
      if (_isCommonAbbreviation(word) ||
          _isUserDefinedAbbreviation(word) ||
          (word.length >= 3 && word.contains(RegExp(r'[A-Z]{2,}'))) ||
          (word.length >= 3 && word.endsWith('.'))) {
        abbreviatedWords++;
      }
    }
    
    return (abbreviatedWords / words.length) * 100;
  }

  static bool _isCommonAbbreviation(String word) {
    final commonAbbrevs = [
      'mtg', 'proj', 'budg', 'mgr', 'dept', 'qtr', 'yr', 'mo', 'wk',
      'vs', 'etc', 'w/', 'w/o', 'b/c', 'b/w', 'fyi', 'asap', 'rsvp'
    ];
    return commonAbbrevs.contains(word.toLowerCase());
  }

  static bool _isUserDefinedAbbreviation(String word) {
    try {
      // Deferred import avoided; using dynamic lookup via StorageService through a thin indirection
      // to keep model layer light. This function will be swapped if needed.
      // We treat any saved abbreviation value as a match if equals ignoring case.
      // Note: This is a lightweight check and not a hard dependency during unit tests.
      // ignore: avoid_dynamic_calls
      final dynamic storageService = (StorageServiceAccessor.accessor)();
      final List<dynamic> abbrs = storageService.getAllAbbreviations();
      final lower = word.toLowerCase();
      for (final dynamic a in abbrs) {
        // expect fields: abbreviation
        final String abbr = (a.abbreviation as String).toLowerCase();
        if (abbr == lower) return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static double _calculateWPM(String userNotes, int timeSpentSeconds) {
    if (timeSpentSeconds <= 0) return 0.0;
    
    final words = userNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutes = timeSpentSeconds / 60.0;
    
    return words / minutes;
  }

  static List<String> _findMissedKeyPoints(String userNotes, List<String> keyTerms) {
    final userLower = userNotes.toLowerCase();
    return keyTerms.where((term) => !userLower.contains(term.toLowerCase())).toList();
  }

  static List<String> _generateImprovementSuggestions(String userNotes, String idealNotes) {
    final suggestions = <String>[];
    
    // Check for common improvement areas
    if (userNotes.length > idealNotes.length * 1.5) {
      suggestions.add('Try using more abbreviations to make your notes more concise');
    }
    
    if (userNotes.split(' ').length < idealNotes.split(' ').length * 0.3) {
      suggestions.add('Include more key details in your notes');
    }
    
    if (!userNotes.contains(RegExp(r'[A-Z]{2,}')) && !userNotes.contains('.')) {
      suggestions.add('Use abbreviations like "mtg" for meeting or "proj" for project');
    }
    
    return suggestions;
  }

  String get performanceDescription {
    if (score >= 90) return 'Outstanding!';
    if (score >= 80) return 'Excellent work!';
    if (score >= 70) return 'Good job!';
    if (score >= 60) return 'Keep practicing!';
    return 'Room for improvement';
  }
}

