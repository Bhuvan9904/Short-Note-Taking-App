import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/user_auth.dart';
import '../models/exercise.dart';
import '../models/user_progress.dart';
import '../models/abbreviation.dart';
import '../models/live_session.dart';
import '../models/note.dart';
import '../theme/app_colors.dart';

class StorageService {
  static const String _userBoxName = 'users';
  static const String _userAuthBoxName = 'user_auth';
  static const String _exerciseBoxName = 'exercises';
  static const String _progressBoxName = 'progress';
  static const String _abbreviationBoxName = 'abbreviations';
  static const String _sessionBoxName = 'sessions';
  static const String _noteBoxName = 'notes';

  static late Box<User> _userBox;
  static late Box<UserAuth> _userAuthBox;
  static late Box<Exercise> _exerciseBox;
  static late Box<UserProgress> _progressBox;
  static late Box<Abbreviation> _abbreviationBox;
  static late Box<LiveSession> _sessionBox;
  static late Box<Note> _noteBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Note: Removed automatic box deletion to preserve user data
    
    // Register adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(UserAuthAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(UserProgressAdapter());
    Hive.registerAdapter(AbbreviationAdapter());
    Hive.registerAdapter(LiveSessionAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(ExerciseDifficultyAdapter());
    Hive.registerAdapter(ExerciseCategoryAdapter());
    Hive.registerAdapter(AbbreviationCategoryAdapter());
    Hive.registerAdapter(SessionTypeAdapter());

    // Open boxes
    _userBox = await Hive.openBox<User>(_userBoxName);
    _userAuthBox = await Hive.openBox<UserAuth>(_userAuthBoxName);
    _exerciseBox = await Hive.openBox<Exercise>(_exerciseBoxName);
    _progressBox = await Hive.openBox<UserProgress>(_progressBoxName);
    _abbreviationBox = await Hive.openBox<Abbreviation>(_abbreviationBoxName);
    _sessionBox = await Hive.openBox<LiveSession>(_sessionBoxName);
    _noteBox = await Hive.openBox<Note>(_noteBoxName);
  }

  // User operations
  static Future<void> saveUser(User user) async {
    await _userBox.put('current_user', user);
  }

  static User? getCurrentUser() {
    final user = _userBox.get('current_user');
    if (user != null) {
      print('🔍 DEBUG: getCurrentUser - Before checkStreakOnAppStart: streak=${user.streakDays}');
      // Check and update streak when retrieving user
      user.checkStreakOnAppStart();
      print('🔍 DEBUG: getCurrentUser - After checkStreakOnAppStart: streak=${user.streakDays}');
      // Save updated user data
      saveUser(user);
    }
    return user;
  }

  static Future<void> createTestUser() async {
    // Create a test user who has already completed baseline test
    final user = User.createNew();
    user.baselineWPM = 35.0; // Set a default baseline WPM
    user.currentWPM = 35.0;
    // Don't call updateWPM here as it will trigger streak update
    // user.updateWPM(35.0);
    await saveUser(user);
  }

  static Future<void> createGuestUser() async {
    // Clear any existing user data first to ensure a fresh start
    await deleteUser();
    
    // Clear old progress, notes, and sessions from previous user
    // but keep exercises and abbreviations (system data)
    await _progressBox.clear();
    await _noteBox.clear();
    await _sessionBox.clear();
    
    // Create a fresh guest user without requiring signup
    final guestUser = User.createGuest();
    await saveUser(guestUser);
    print('DEBUG: Fresh guest user created with ID: ${guestUser.id}');
    print('DEBUG: Cleared all previous user progress, notes, and sessions');
  }

  static bool isGuestUser() {
    final user = getCurrentUser();
    return user?.isGuest ?? false;
  }

  static Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }

  static Future<void> deleteUserAuth(String userId) async {
    await _userAuthBox.delete(userId);
  }

  /// Update user streak for daily activities
  static Future<void> updateDailyStreak() async {
    print('⭐ UPDATE DAILY STREAK CALLED');
    final user = getCurrentUser();
    if (user != null) {
      print('⭐ User found - calling incrementDailyStreak()');
      print('⭐ Before increment: streak = ${user.streakDays}, lastActiveAt = ${user.lastActiveAt}');
      user.incrementDailyStreak();
      print('⭐ After increment: streak = ${user.streakDays}, lastActiveAt = ${user.lastActiveAt}');
      await saveUser(user);
      print('⭐ User saved');
    }
  }

  // User Authentication operations
  static Future<void> saveUserAuth(UserAuth userAuth) async {
    await _userAuthBox.put(userAuth.id, userAuth);
  }

  static UserAuth? getCurrentUserAuth() {
    try {
      final allUsers = _userAuthBox.values.toList();
      print('DEBUG: StorageService - Total users in box: ${allUsers.length}');
      for (var user in allUsers) {
        print('DEBUG: StorageService - User: $user');
      }
      
      final currentUser = allUsers.firstWhere(
        (user) => user.isLoggedIn,
      );
      print('DEBUG: StorageService - Found current user: $currentUser');
      return currentUser;
    } catch (e) {
      print('DEBUG: StorageService - No logged in user found: $e');
      return null;
    }
  }

  static Future<void> setCurrentUserAuth(UserAuth userAuth) async {
    // Set all users as logged out first
    for (final user in _userAuthBox.values) {
      user.updateLoginStatus(false);
      await saveUserAuth(user);
    }
    
    // Set the current user as logged in
    userAuth.updateLoginStatus(true);
    await saveUserAuth(userAuth);
  }

  static Future<UserAuth?> getUserByEmail(String email) async {
    try {
      final allUsers = _userAuthBox.values.toList();
      print('DEBUG: StorageService.getUserByEmail - Looking for: $email');
      print('DEBUG: StorageService.getUserByEmail - Total users: ${allUsers.length}');
      
      for (var user in allUsers) {
        print('DEBUG: StorageService.getUserByEmail - User email: ${user.email}');
        print('DEBUG: StorageService.getUserByEmail - Match: ${user.email.toLowerCase() == email.toLowerCase()}');
      }
      
      final foundUser = allUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
      print('DEBUG: StorageService.getUserByEmail - Found user: $foundUser');
      return foundUser;
    } catch (e) {
      print('DEBUG: StorageService.getUserByEmail - No user found: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    final currentUser = getCurrentUserAuth();
    if (currentUser != null) {
      currentUser.updateLoginStatus(false);
      await saveUserAuth(currentUser);
    }
  }

  static bool isUserLoggedIn() {
    return getCurrentUserAuth() != null;
  }

  /// Debug method to check user_auth box status
  static void debugUserAuthBox() {
    try {
      final boxLength = _userAuthBox.length;
      print('DEBUG: UserAuth box length: $boxLength');
      print('DEBUG: UserAuth box keys: ${_userAuthBox.keys.toList()}');
      for (var key in _userAuthBox.keys) {
        final user = _userAuthBox.get(key);
        print('DEBUG: UserAuth box user: $user');
      }
    } catch (e) {
      print('DEBUG: UserAuth box error: $e');
    }
  }

  /// DEBUG: Set lastActiveAt to yesterday for testing streak
  static Future<void> setLastActiveDateToYesterday() async {
    final user = _userBox.get('current_user');
    if (user != null) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      user.lastActiveAt = yesterday;
      await saveUser(user);
      print('🔧 DEBUG: Set lastActiveAt to yesterday: $yesterday');
      print('🔧 DEBUG: Current streak: ${user.streakDays}');
    }
  }

  /// DEBUG: Print current user streak info
  static void debugUserStreak() {
    final user = _userBox.get('current_user');
    if (user != null) {
      print('📊 USER STREAK DEBUG:');
      print('   Streak Days: ${user.streakDays}');
      print('   Last Active: ${user.lastActiveAt}');
      print('   Created At: ${user.createdAt}');
      print('   Total Exercises Completed: ${user.totalExercisesCompleted}');
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastActiveDate = DateTime(user.lastActiveAt.year, user.lastActiveAt.month, user.lastActiveAt.day);
      final daysDiff = today.difference(lastActiveDate).inDays;
      print('   Days Since Last Active: $daysDiff');
    } else {
      print('📊 No user found');
    }
  }

  /// DEBUG: Test streak increment manually
  static void testStreakIncrement() {
    final user = _userBox.get('current_user');
    if (user != null) {
      print('🔧 TEST: Before test - streak: ${user.streakDays}, exercises: ${user.totalExercisesCompleted}');
      user.completeExercise();
      saveUser(user);
      print('🔧 TEST: After test - streak: ${user.streakDays}, exercises: ${user.totalExercisesCompleted}');
    } else {
      print('🔧 TEST: No current user found');
    }
  }

  /// DEBUG: Set lastActiveAt to yesterday to test streak increment
  static void setLastActiveToYesterday() {
    final user = _userBox.get('current_user');
    if (user != null) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      user.lastActiveAt = yesterday;
      saveUser(user);
      print('🔧 DEBUG: Set lastActiveAt to yesterday: $yesterday');
      print('🔧 DEBUG: Current streak: ${user.streakDays}');
      print('🔧 DEBUG: Total exercises: ${user.totalExercisesCompleted}');
    } else {
      print('🔧 DEBUG: No current user found');
    }
  }

  /// DEBUG: Comprehensive streak analysis
  static void analyzeStreakStatus() {
    final user = _userBox.get('current_user');
    if (user != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastActiveDate = DateTime(user.lastActiveAt.year, user.lastActiveAt.month, user.lastActiveAt.day);
      final daysDifference = today.difference(lastActiveDate).inDays;
      
      print('🔍 STREAK ANALYSIS: ==========================================');
      print('🔍 Current time: $now');
      print('🔍 Today (date only): $today');
      print('🔍 Last active (full): ${user.lastActiveAt}');
      print('🔍 Last active (date only): $lastActiveDate');
      print('🔍 Days difference: $daysDifference');
      print('🔍 Current streak: ${user.streakDays}');
      print('🔍 Total exercises completed: ${user.totalExercisesCompleted}');
      print('🔍 Current WPM: ${user.currentWPM}');
      print('🔍 Average accuracy: ${user.averageAccuracy}');
      
      if (daysDifference == 0) {
        print('🔍 ANALYSIS: Same day - streak should NOT increment');
      } else if (daysDifference == 1) {
        print('🔍 ANALYSIS: Next day - streak SHOULD increment from ${user.streakDays} to ${user.streakDays + 1}');
      } else if (daysDifference > 1) {
        print('🔍 ANALYSIS: Gap of $daysDifference days - streak should reset to 1');
      }
      print('🔍 STREAK ANALYSIS: ==========================================');
    } else {
      print('🔍 STREAK ANALYSIS: No current user found');
    }
  }

  // Exercise operations
  static Future<void> saveExercise(Exercise exercise) async {
    await _exerciseBox.put(exercise.id, exercise);
  }

  static Future<void> saveExercises(List<Exercise> exercises) async {
    final Map<String, Exercise> exerciseMap = {
      for (final exercise in exercises) exercise.id: exercise
    };
    await _exerciseBox.putAll(exerciseMap);
  }

  static Exercise? getExercise(String id) {
    return _exerciseBox.get(id);
  }

  static List<Exercise> getAllExercises() {
    return _exerciseBox.values.toList();
  }

  static Future<void> clearAllExercises() async {
    await _exerciseBox.clear();
  }

  static List<Exercise> getExercisesByCategory(ExerciseCategory category) {
    return _exerciseBox.values
        .where((exercise) => exercise.category == category)
        .toList();
  }

  static List<Exercise> getExercisesByDifficulty(ExerciseDifficulty difficulty) {
    return _exerciseBox.values
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  static List<Exercise> getFreeExercises() {
    return _exerciseBox.values
        .where((exercise) => !exercise.isPremium)
        .toList();
  }

  // Progress operations
  static Future<void> saveProgress(UserProgress progress) async {
    await _progressBox.put(progress.id, progress);
  }

  static List<UserProgress> getUserProgress() {
    return _progressBox.values.toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  static List<UserProgress> getProgressForExercise(String exerciseId) {
    return _progressBox.values
        .where((progress) => progress.exerciseId == exerciseId)
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  static UserProgress? getLatestProgress() {
    final allProgress = getUserProgress();
    return allProgress.isNotEmpty ? allProgress.first : null;
  }

  static double getAverageScore() {
    final allProgress = getUserProgress();
    if (allProgress.isEmpty) return 0.0;
    
    final totalScore = allProgress.fold<double>(0.0, (sum, progress) => sum + progress.score);
    return totalScore / allProgress.length;
  }

  static double getAverageWPM() {
    final allProgress = getUserProgress();
    if (allProgress.isEmpty) return 0.0;
    
    final totalWPM = allProgress.fold<double>(0.0, (sum, progress) => sum + progress.wpm);
    return totalWPM / allProgress.length;
  }

  static Future<void> clearAllUserProgress() async {
    await _progressBox.clear();
  }


  // Abbreviation operations
  static Future<void> saveAbbreviation(Abbreviation abbreviation) async {
    await _abbreviationBox.put(abbreviation.id, abbreviation);
  }

  static Future<void> deleteAbbreviation(String abbreviationId) async {
    await _abbreviationBox.delete(abbreviationId);
  }

  static List<Abbreviation> getAllAbbreviations() {
    return _abbreviationBox.values.toList()
      ..sort((a, b) => b.frequency.compareTo(a.frequency));
  }

  static ValueListenable<Box<Abbreviation>> listenableAbbreviations() {
    return _abbreviationBox.listenable();
  }

  static List<Abbreviation> getAbbreviationsByCategory(AbbreviationCategory category) {
    return _abbreviationBox.values
        .where((abbreviation) => abbreviation.category == category)
        .toList()
      ..sort((a, b) => b.frequency.compareTo(a.frequency));
  }

  static List<Abbreviation> getPopularAbbreviations() {
    return _abbreviationBox.values
        .where((abbreviation) => abbreviation.isPopular)
        .toList()
      ..sort((a, b) => b.frequency.compareTo(a.frequency));
  }

  static Abbreviation? findAbbreviation(String fullWord) {
    return _abbreviationBox.values
        .cast<Abbreviation?>()
        .firstWhere(
          (abbreviation) => abbreviation?.fullWord.toLowerCase() == fullWord.toLowerCase(),
          orElse: () => null,
        );
  }

  static Future<void> clearUserAbbreviations() async {
    // Delete only user-created abbreviations
    final userAbbreviations = _abbreviationBox.values
        .where((abbr) => abbr.isUserCreated == true)
        .toList();
    
    for (final abbr in userAbbreviations) {
      await _abbreviationBox.delete(abbr.id);
    }
  }

  // Live session operations
  static Future<void> saveLiveSession(LiveSession session) async {
    await _sessionBox.put(session.id, session);
  }

  static List<LiveSession> getAllLiveSessions() {
    return _sessionBox.values.toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  static List<LiveSession> getSessionsByType(SessionType type) {
    return _sessionBox.values
        .where((session) => session.sessionType == type)
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  static Future<void> clearAllLiveSessions() async {
    await _sessionBox.clear();
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await _userBox.clear();
    await _exerciseBox.clear();
    await _progressBox.clear();
    await _abbreviationBox.clear();
    await _sessionBox.clear();
  }

  static Future<void> close() async {
    await _userBox.close();
    await _userAuthBox.close();
    await _exerciseBox.close();
    await _progressBox.close();
    await _abbreviationBox.close();
    await _sessionBox.close();
    await _noteBox.close();
  }

  // First launch operations
  static Future<void> setFirstLaunch(bool isFirstLaunch) async {
    final prefs = await Hive.openBox('app_preferences');
    await prefs.put('is_first_launch', isFirstLaunch);
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await Hive.openBox('app_preferences');
    return prefs.get('is_first_launch', defaultValue: true);
  }

  // Daily insight operations - based on app usage days
  static Future<void> setFirstLaunchDate(DateTime date) async {
    final prefs = await Hive.openBox('app_preferences');
    await prefs.put('first_launch_date', date.millisecondsSinceEpoch);
  }

  static Future<DateTime?> getFirstLaunchDate() async {
    final prefs = await Hive.openBox('app_preferences');
    final timestamp = prefs.get('first_launch_date');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  static Future<int> getAppUsageDays() async {
    final firstLaunchDate = await getFirstLaunchDate();
    if (firstLaunchDate == null) {
      // First time using the app
      final now = DateTime.now();
      await setFirstLaunchDate(now);
      return 1; // Day 1
    }
    
    final now = DateTime.now();
    final daysDifference = now.difference(firstLaunchDate).inDays;
    return daysDifference + 1; // +1 because day 1 is the first day
  }

  // Statistics
  static Map<String, dynamic> getStatistics() {
    final user = getCurrentUser();
    final allProgress = getUserProgress();
    final allSessions = getAllLiveSessions();
    final allAbbreviations = getAllAbbreviations();

    // Calculate best score
    double bestScore = 0.0;
    if (allProgress.isNotEmpty) {
      bestScore = allProgress.map((p) => p.score).reduce((a, b) => a > b ? a : b);
    }

    // Calculate average accuracy
    double averageAccuracy = 0.0;
    if (allProgress.isNotEmpty) {
      final totalAccuracy = allProgress.fold<double>(0.0, (sum, progress) => sum + progress.accuracyScore);
      averageAccuracy = totalAccuracy / allProgress.length;
    }

    return {
      'totalExercisesCompleted': allProgress.length,
      'totalExercises': allProgress.length, // Alias for compatibility
      'totalLiveSessions': allSessions.length,
      'totalAbbreviations': allAbbreviations.length,
      'averageScore': getAverageScore(),
      'bestScore': bestScore, // Added best score
      'averageAccuracy': averageAccuracy, // Added average accuracy
      'averageWPM': getAverageWPM(),
      'currentStreak': user?.streakDays ?? 0,
      'isPremium': user?.isPremium ?? false,
      'baselineWPM': user?.baselineWPM ?? 0.0,
      'currentWPM': user?.currentWPM ?? 0.0,
      'improvementPercentage': user?.improvementPercentage ?? 0.0,
    };
  }

  // Note operations
  static Future<void> saveNote(Note note) async {
    await _noteBox.put(note.id, note);
  }

  static Future<void> deleteNote(String id) async {
    await _noteBox.delete(id);
  }

  static Note? getNote(String id) {
    return _noteBox.get(id);
  }

  static List<Note> getAllNotes() {
    final notes = _noteBox.values.toList();
    // Sort by creation date (newest first)
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  static ValueListenable<Box<Note>> listenableNotes() {
    return _noteBox.listenable();
  }

  static List<Note> getRecentNotes({int limit = 10}) {
    final allNotes = getAllNotes();
    return allNotes.take(limit).toList();
  }

  static Future<void> clearAllNotes() async {
    await _noteBox.clear();
  }

  // Recent Activity operations - combines all types of activities
  static List<Map<String, dynamic>> getAllRecentActivity({int limit = 10}) {
    final List<Map<String, dynamic>> activities = [];
    
    // Add exercise progress activities
    final recentProgress = getUserProgress();
    for (final progress in recentProgress) {
      activities.add({
        'type': 'exercise',
        'id': progress.id,
        'title': 'Exercise Completed',
        'subtitle': '${progress.wpm.toStringAsFixed(1)} WPM • ${progress.score.toStringAsFixed(0)}%',
        'timestamp': progress.completedAt,
        'icon': Icons.fitness_center,
        'color': AppColors.getScoreColor(progress.score),
        'data': progress,
      });
    }
    
    // Add live session activities
    final recentSessions = getAllLiveSessions();
    for (final session in recentSessions) {
      activities.add({
        'type': 'live_session',
        'id': session.id,
        'title': 'Live Practice Session',
        'subtitle': '${session.duration} min • ${session.score.toStringAsFixed(0)}% accuracy',
        'timestamp': session.completedAt,
        'icon': Icons.mic,
        'color': AppColors.primaryPurple,
        'data': session,
      });
    }
    
    // Add note activities (including live practice notes saved as Note objects)
    final recentNotes = getAllNotes();
    for (final note in recentNotes) {
      activities.add({
        'type': 'note',
        'id': note.id,
        // Show the actual note title
        'title': note.displayTitle,
        // Show a short preview from content in the subheading
        'subtitle': note.previewContent,
        'timestamp': note.createdAt,
        'icon': note.category == 'Live Practice' ? Icons.note_add : Icons.note,
        'color': note.category == 'Live Practice' ? AppColors.primaryPurple : AppColors.successGreen,
        'data': note,
      });
    }
    
    // Sort by timestamp (newest first) and limit results
    activities.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    return activities.take(limit).toList();
  }
}

// Lightweight accessor to allow model-layer checks without direct imports
class StorageServiceAccessor {
  static dynamic Function() accessor = () => StorageService;
}
