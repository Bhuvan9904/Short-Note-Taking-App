import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';

class ProgressAnalyticsScreen extends StatefulWidget {
  const ProgressAnalyticsScreen({super.key});

  @override
  State<ProgressAnalyticsScreen> createState() => _ProgressAnalyticsScreenState();
}

class _ProgressAnalyticsScreenState extends State<ProgressAnalyticsScreen> with WidgetsBindingObserver {
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStats();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh when app resumes
      _loadStats();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when navigating back to this screen
    _loadStats();
  }

  void _loadStats() {
    if (mounted) {
      setState(() {
        _stats = StorageService.getStatistics();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Progress Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadStats();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Overview
              _buildStatsOverview(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Progress Indicators
              _buildProgressIndicators(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Performance Trends
              _buildPerformanceTrends(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Recent Sessions
              _buildRecentSessions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Progress Summary',
            style: AppTypography.title2,
          ),
          const SizedBox(height: AppSpacing.spacing6),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Exercises',
                  '${_stats['totalExercisesCompleted'] ?? 0}',
                  Icons.fitness_center,
                  AppColors.primaryPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing3),
              Expanded(
                child: _buildStatCard(
                  'Average Score',
                  '${(_stats['averageScore'] ?? 0.0).toStringAsFixed(0)}%',
                  Icons.trending_up,
                  AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing3),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Current WPM',
                  '${(_stats['currentWPM'] ?? 0.0).toStringAsFixed(1)}',
                  Icons.speed,
                  AppColors.infoBlue,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing3),
              Expanded(
                child: _buildStatCard(
                  'Streak Days',
                  '${_stats['currentStreak'] ?? 0}',
                  Icons.local_fire_department,
                  AppColors.errorRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            value,
            style: AppTypography.title3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicators() {
    final allProgress = StorageService.getUserProgress();
    final currentWPM = _stats['currentWPM'] ?? 0.0;
    final targetWPM = 80.0; // Set a target WPM
    final wpmProgress = targetWPM > 0 ? (currentWPM / targetWPM).clamp(0.0, 1.0) : 0.0;
    
    // Calculate accuracy trend (compare recent half vs older half)
    double accuracyTrend = 0.0;
    String trendIcon = '➡️';
    Color trendColor = AppColors.infoBlue;
    String trendText = 'stable';
    
    print('DEBUG: Total progress entries: ${allProgress.length}');
    
    if (allProgress.length >= 2) {
      // Split progress into two halves: recent and older
      final halfPoint = (allProgress.length / 2).ceil();
      final recentHalf = allProgress.take(halfPoint).map((p) => p.accuracyScore).toList();
      final olderHalf = allProgress.skip(halfPoint).map((p) => p.accuracyScore).toList();
      
      print('DEBUG: Recent half: $recentHalf');
      print('DEBUG: Older half: $olderHalf');
      
      if (recentHalf.isNotEmpty && olderHalf.isNotEmpty) {
        final recentAvg = recentHalf.reduce((a, b) => a + b) / recentHalf.length;
        final olderAvg = olderHalf.reduce((a, b) => a + b) / olderHalf.length;
        accuracyTrend = recentAvg - olderAvg;
        
        print('DEBUG: Recent avg: $recentAvg, Older avg: $olderAvg, Trend: $accuracyTrend');
        
        if (accuracyTrend > 1.0) {
          trendIcon = '↗️';
          trendColor = AppColors.successGreen;
          trendText = 'improvement';
        } else if (accuracyTrend < -1.0) {
          trendIcon = '↘️';
          trendColor = AppColors.errorRed;
          trendText = 'decline';
        }
      }
    } else if (allProgress.length == 1) {
      // Show current accuracy for single exercise
      accuracyTrend = allProgress.first.accuracyScore;
      trendIcon = '📊';
      trendColor = AppColors.infoBlue;
      trendText = 'current';
      print('DEBUG: Single exercise, accuracy: $accuracyTrend');
    } else {
      print('DEBUG: No progress entries found');
    }
    
    // Calculate weekly goal progress (exercises this week)
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final thisWeekExercises = allProgress.where((p) => 
      p.completedAt.isAfter(weekStart) && p.completedAt.isBefore(now.add(const Duration(days: 1)))
    ).length;
    final weeklyGoal = 5;
    final weeklyProgress = thisWeekExercises / weeklyGoal;
    
    // Calculate completion rate
    final totalStarted = allProgress.length;
    final completedExercises = allProgress.where((p) => p.score > 0).length;
    final completionRate = totalStarted > 0 ? completedExercises / totalStarted : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Indicators',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          
          // WPM Progress
          _buildWPMProgress(currentWPM, targetWPM, wpmProgress),
          const SizedBox(height: AppSpacing.spacing4),
          
          // Accuracy Trend
          _buildAccuracyTrend(accuracyTrend, trendIcon, trendColor, trendText),
          const SizedBox(height: AppSpacing.spacing4),
          
          // Weekly Goal Progress
          _buildWeeklyGoalProgress(thisWeekExercises, weeklyGoal, weeklyProgress),
          const SizedBox(height: AppSpacing.spacing4),
          
          // Exercise Completion Rate
          _buildCompletionRate(completedExercises, totalStarted, completionRate),
        ],
      ),
    );
  }

  Widget _buildWPMProgress(double currentWPM, double targetWPM, double progress) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🎯 WPM Progress',
                style: AppTypography.callout,
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% of target',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target: ${targetWPM.toStringAsFixed(0)} WPM',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Current: ${currentWPM.toStringAsFixed(1)} WPM',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.backgroundSecondary,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.8 ? AppColors.successGreen : 
              progress >= 0.6 ? AppColors.warningAmber : AppColors.errorRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyTrend(double trend, String icon, Color color, String trendText) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        children: [
          const Text(
            '📈 Accuracy Trend',
            style: AppTypography.callout,
          ),
          const Spacer(),
          Text(
            '$icon ${trend.abs().toStringAsFixed(0)}%',
            style: AppTypography.callout.copyWith(
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing2),
          Text(
            trendText,
            style: AppTypography.footnote.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalProgress(int completed, int goal, double progress) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Weekly Goal Progress',
            style: AppTypography.callout,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            'Goal: $goal exercises this week',
            style: AppTypography.footnote.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            children: [
              Text(
                '$completed/$goal completed',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            children: List.generate(goal, (index) {
              return Container(
                margin: const EdgeInsets.only(right: 4),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: index < completed 
                    ? AppColors.successGreen 
                    : AppColors.backgroundSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textTertiary,
                    width: 1,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionRate(int completed, int total, double rate) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 Exercise Completion Rate',
            style: AppTypography.callout,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Started: $total',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Completed: $completed',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: rate,
                  backgroundColor: AppColors.backgroundSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rate >= 0.8 ? AppColors.successGreen : 
                    rate >= 0.6 ? AppColors.warningAmber : AppColors.errorRed,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing2),
              Text(
                '${(rate * 100).toStringAsFixed(0)}%',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrends() {
    final allProgress = StorageService.getUserProgress();
    if (allProgress.isEmpty || allProgress.length < 2) {
      return const SizedBox.shrink();
    }

    // Get last 7 sessions for trend analysis
    final recentProgress = allProgress.take(7).toList();
    
    // Calculate average score safely
    final scores = recentProgress.map((p) => p.score).toList();
    final avgScore = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
    
    // Calculate average WPM safely
    final wpmValues = recentProgress.map((p) => p.wpm).toList();
    final avgWPM = wpmValues.isEmpty ? 0.0 : wpmValues.reduce((a, b) => a + b) / wpmValues.length;
    
    // Calculate trend safely (need at least 4 sessions)
    String trend = 'Stable';
    if (recentProgress.length >= 4) {
      final firstHalfScores = recentProgress.take(4).map((p) => p.score).toList();
      final secondHalfScores = recentProgress.skip(3).take(4).map((p) => p.score).toList();
      
      if (firstHalfScores.isNotEmpty && secondHalfScores.isNotEmpty) {
        final firstHalf = firstHalfScores.reduce((a, b) => a + b) / firstHalfScores.length;
        final secondHalf = secondHalfScores.reduce((a, b) => a + b) / secondHalfScores.length;
        trend = secondHalf > firstHalf ? 'Improving' : 'Needs Work';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Trends',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Row(
            children: [
              Expanded(
                child: _buildTrendCard(
                  '7-Day Average',
                  '${avgScore.toStringAsFixed(0)}%',
                  '${avgWPM.toStringAsFixed(1)} WPM',
                  AppColors.primaryPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing3),
              Expanded(
                child: _buildTrendCard(
                  'Trend',
                  trend,
                  trend == 'Improving' ? '📈' : trend == 'Needs Work' ? '📉' : '➡️',
                  trend == 'Improving' ? AppColors.successGreen : trend == 'Needs Work' ? AppColors.warningAmber : AppColors.infoBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.footnote.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.title3.copyWith(
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions() {
    final recentProgress = StorageService.getUserProgress().take(5).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Sessions',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          if (recentProgress.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing8),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(height: AppSpacing.spacing4),
                    Text(
                      'No exercises completed yet',
                      style: AppTypography.body,
                    ),
                    Text(
                      'Start training to see your progress here',
                      style: AppTypography.footnote,
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentProgress.map((progress) => _buildSessionItem(progress)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(dynamic progress) {
    // Add safety checks for null values
    if (progress == null) {
      return const SizedBox.shrink();
    }
    
    final exercise = StorageService.getExercise(progress.exerciseId);
    final timeAgo = _getTimeAgo(progress.completedAt);
    
    // Safe score access
    final score = progress.score ?? 0.0;
    final wpm = progress.wpm ?? 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing3),
      padding: const EdgeInsets.all(AppSpacing.spacing3),
      decoration: BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.getScoreColor(score).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.getScoreColor(score),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise?.title ?? 'Exercise Completed',
                      style: AppTypography.callout,
                    ),
                    Text(
                      '$timeAgo • ${score.toStringAsFixed(0)}% • ${wpm.toStringAsFixed(1)} WPM',
                      style: AppTypography.footnote.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Unknown';
    }
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}



