import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double baselineWPM;

  @HiveField(2)
  double currentWPM;

  @HiveField(3)
  double improvementPercentage;

  @HiveField(4)
  bool isPremium;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime lastActiveAt;

  @HiveField(7)
  int streakDays;

  @HiveField(8)
  int totalExercisesCompleted;

  @HiveField(9)
  bool isGuest;

  @HiveField(10)
  double averageAccuracy;

  User({
    required this.id,
    required this.baselineWPM,
    required this.currentWPM,
    required this.improvementPercentage,
    required this.isPremium,
    required this.createdAt,
    required this.lastActiveAt,
    this.streakDays = 0,
    this.totalExercisesCompleted = 0,
    this.isGuest = false,
    this.averageAccuracy = 0.0,
  });

  factory User.createNew() {
    final now = DateTime.now();
    final user = User(
      id: now.millisecondsSinceEpoch.toString(),
      baselineWPM: 0.0,
      currentWPM: 0.0,
      improvementPercentage: 0.0,
      isPremium: false,
      createdAt: now,
      lastActiveAt: now,
      isGuest: false,
      averageAccuracy: 0.0,
    );
    print('🔍 DEBUG: User.createNew - Created user with streak=${user.streakDays}');
    return user;
  }

  factory User.createGuest() {
    final now = DateTime.now();
    return User(
      id: 'guest_${now.millisecondsSinceEpoch}',
      baselineWPM: 0.0,
      currentWPM: 0.0,
      improvementPercentage: 0.0,
      isPremium: false,
      createdAt: now,
      lastActiveAt: now,
      isGuest: true,
      averageAccuracy: 0.0,
    );
  }

  void updateWPM(double newWPM) {
    currentWPM = newWPM;
    if (baselineWPM > 0) {
      improvementPercentage = ((newWPM - baselineWPM) / baselineWPM) * 100;
    }
  }

  void updateAccuracy(double newAccuracy) {
    averageAccuracy = newAccuracy;
  }

  void incrementStreak() {
    streakDays++;
  }

  void resetStreak() {
    streakDays = 0;
  }

  void completeExercise() {
    print('🔥 COMPLETE EXERCISE: Before - totalExercisesCompleted: $totalExercisesCompleted, streakDays: $streakDays');
    totalExercisesCompleted++;
    print('🔥 COMPLETE EXERCISE: After increment - totalExercisesCompleted: $totalExercisesCompleted');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActiveDate = DateTime(lastActiveAt.year, lastActiveAt.month, lastActiveAt.day);
    final daysDifference = today.difference(lastActiveDate).inDays;
    
    print('🔥 COMPLETE EXERCISE: Days difference: $daysDifference');
    print('🔥 COMPLETE EXERCISE: Current streak: $streakDays');
    
    if (daysDifference == 0 && streakDays > 0) {
      // Same day and streak already exists - no change to streak, just update lastActiveAt
      lastActiveAt = now;
      print('🔥 COMPLETE EXERCISE: Same day - no streak change, streak remains $streakDays');
    } else {
      // New day or first time - increment streak
      incrementDailyStreak();
      print('🔥 COMPLETE EXERCISE: New day/first time - streak incremented to $streakDays');
    }
  }

  /// Manually increment streak for daily activities
  void incrementDailyStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActiveDate = DateTime(lastActiveAt.year, lastActiveAt.month, lastActiveAt.day);
    
    final daysDifference = today.difference(lastActiveDate).inDays;
    
    print('🔥 STREAK DEBUG: ========== STREAK CALCULATION ==========');
    print('🔥 STREAK DEBUG: Current time: $now');
    print('🔥 STREAK DEBUG: Today (date only): $today');
    print('🔥 STREAK DEBUG: Last active (full): $lastActiveAt');
    print('🔥 STREAK DEBUG: Last active (date only): $lastActiveDate');
    print('🔥 STREAK DEBUG: Days difference: $daysDifference');
    print('🔥 STREAK DEBUG: Current streak: $streakDays');
    print('🔥 STREAK DEBUG: Total exercises completed: $totalExercisesCompleted');
    
    if (daysDifference == 1) {
      // Next day - increment streak
      if (streakDays == 0) {
        streakDays = 1;
        print('🔥 STREAK DEBUG: First day - streak set to 1');
      } else {
        streakDays++;
        print('🔥 STREAK DEBUG: Consecutive day - streak incremented to $streakDays');
      }
      lastActiveAt = now;
      print('🔥 STREAK DEBUG: Updated lastActiveAt to: $now');
      print('🔥 STREAK DEBUG: Final streak: $streakDays');
    } else if (daysDifference > 1) {
      // More than 1 day gap - restart streak
      print('🔥 STREAK DEBUG: Gap detected ($daysDifference days) - streak reset to 1');
      streakDays = 1;
      lastActiveAt = now;
      print('🔥 STREAK DEBUG: Updated lastActiveAt to: $now');
      print('🔥 STREAK DEBUG: Final streak: $streakDays');
    } else {
      // First time ever (daysDifference == 0 but we're in incrementDailyStreak) - start streak at 1
      print('🔥 STREAK DEBUG: First time - streak set to 1');
      streakDays = 1;
      lastActiveAt = now;
      print('🔥 STREAK DEBUG: Updated lastActiveAt to: $now');
      print('🔥 STREAK DEBUG: Final streak: $streakDays');
    }
  }


  /// Check and update streak when app starts
  void checkStreakOnAppStart() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActiveDate = DateTime(lastActiveAt.year, lastActiveAt.month, lastActiveAt.day);
    
    final daysDifference = today.difference(lastActiveDate).inDays;
    
    print('✅ CHECK STREAK: Days difference: $daysDifference');
    print('✅ CHECK STREAK: Current streak before check: $streakDays');
    print('✅ CHECK STREAK: Total exercises completed: $totalExercisesCompleted');
    
    // If user has no completed exercises, reset streak to 0
    if (totalExercisesCompleted == 0) {
      print('✅ CHECK STREAK: No exercises completed - resetting streak to 0');
      streakDays = 0;
      return;
    }
    
    if (daysDifference == 0) {
      // Same day - no change to streak
      print('✅ CHECK STREAK: Same day - no change');
      return;
    } else if (daysDifference == 1) {
      // New day - do not increment on app start without an activity
      // Streak will be incremented when a valid activity occurs today
      print('✅ CHECK STREAK: Next day - waiting for activity to increment');
      return;
    } else if (daysDifference > 1) {
      // More than 1 day gap - reset streak (no activity yet today)
      print('✅ CHECK STREAK: Gap > 1 day - resetting streak to 0');
      streakDays = 0;
    }
  }
}


