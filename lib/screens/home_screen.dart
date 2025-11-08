import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../services/user_state_manager.dart';
import 'exercise_selection_screen.dart';
import 'splash_screen.dart';
// import 'notes_screen.dart';
import 'note_editor_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<int>? refreshNotifier;
  
  const HomeScreen({super.key, this.refreshNotifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final UserStateManager _userStateManager = UserStateManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userStateManager.loadUserData();
    _userStateManager.addListener(_onUserDataChanged);
    
    // Listen to refresh notifier
    widget.refreshNotifier?.addListener(_onRefreshRequested);
  }
  
  void _onRefreshRequested() {
    _userStateManager.updateUserData();
  }

  void _onUserDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app resumes
      _userStateManager.updateUserData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when dependencies change (e.g., when returning from another screen)
    _userStateManager.updateUserData();
  }

  // Public method for external refresh requests
  void refreshData() {
    _userStateManager.updateUserData();
  }

  @override
  void dispose() {
    widget.refreshNotifier?.removeListener(_onRefreshRequested);
    _userStateManager.removeListener(_onUserDataChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Short Notes Trainer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _userStateManager.updateUserData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spacing4,
              AppSpacing.spacing4,
              AppSpacing.spacing4,
              AppSpacing.spacing8, // Extra bottom padding
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Create Note Card
                _buildCreateNoteCard(),
                
                const SizedBox(height: AppSpacing.spacing6),
                
                // Small Stat Cards Row (Exercises, Streak, Accuracy)
                _buildSmallStatsRow(),
                
                const SizedBox(height: AppSpacing.spacing6),
                
                // Progress Summary Card
                _buildProgressCard(),
                
                const SizedBox(height: AppSpacing.spacing6),
                
                // Daily Streak Card
                _buildStreakCard(),
                
                const SizedBox(height: AppSpacing.spacing6),
                
                
                
                // Recent Activity
                _buildRecentActivity(),
                
                // Extra bottom spacing to prevent overflow
                const SizedBox(height: AppSpacing.spacing8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    final int streakDays = _userStateManager.currentUser?.streakDays ?? 0;
    // Display a 7-day visual; cap filled flames to 7
    final int filledCount = streakDays.clamp(0, 7);
    final Color streakColor = AppColors.warningAmber;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.backgroundTertiary,
          width: 3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Streak',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing3),
          LayoutBuilder(
            builder: (context, constraints) {
              final double gap = AppSpacing.spacing2.toDouble();
              // Compute icon size based on available width: 7 icons and 6 gaps
              final double computed = (constraints.maxWidth - (gap * 6)) / 7;
              final double iconSize = computed.clamp(20.0, 40.0);
              return Row(
                children: List.generate(7, (index) {
                  final bool isFilled = index < filledCount;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == 6 ? 0 : gap,
                    ),
                    child: Icon(
                      isFilled
                          ? Icons.local_fire_department
                          : Icons.local_fire_department_outlined,
                      color: streakColor,
                      size: iconSize,
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: AppSpacing.spacing3),
          Text(
            '$streakDays Days streak',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildCreateNoteCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NoteEditorScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180, // Set height to display image properly
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              image: const DecorationImage(
                image: AssetImage('assets/mystake145.png'),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: Colors.white30,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA78BFA).withOpacity(0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          // Button overlay positioned at bottom right to match image design
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 140,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NoteEditorScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  'Start',
                  style: AppTypography.buttonPrimary.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSmallStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallStatCard(
            title: 'Exercises',
            value: '${_userStateManager.stats['totalExercises'] ?? 0}',
            color: AppColors.infoBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.spacing4),
        Expanded(
          child: _buildSmallStatCard(
            title: 'Streak',
            value: '${_userStateManager.currentUser?.streakDays ?? 0}',
            color: AppColors.warningAmber,
          ),
        ),
        const SizedBox(width: AppSpacing.spacing4),
        Expanded(
          child: _buildSmallStatCard(
            title: 'Accuracy',
            value: '${(_userStateManager.stats['averageAccuracy'] ?? 0).toStringAsFixed(0)}%',
            color: AppColors.successGreen,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.backgroundTertiary,
          width: 3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              const Text(
            'Your Progress',
                style: AppTypography.headline,
              ),
          const SizedBox(height: AppSpacing.spacing4),
          Row(
            children: [
              Expanded(
                child: _buildLargeStatCard(
                  title: 'Current WPM',
                  value: '${(_userStateManager.currentUser?.currentWPM ?? 0).toStringAsFixed(1)}',
                  icon: Icons.speed,
                    color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: _buildLargeStatCard(
                  title: 'Best Score',
                  value: '${(_userStateManager.stats['bestScore'] ?? 0).toStringAsFixed(0)}%',
                  icon: Icons.emoji_events,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExerciseSelectionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.primaryPurple.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing6,
                  vertical: AppSpacing.spacing4,
                ),
              ),
              child: const Text(
                'Start Training',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildLargeStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          Icon(
              icon,
              color: color,
              size: 24,
            ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            value,
            style: AppTypography.title1.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing1),
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

  Widget _buildSmallStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 3,
        ),
      ),
            child: Column(
              children: [
                Text(
                  value,
            style: AppTypography.title3.copyWith(
              color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: AppSpacing.spacing1),
                Text(
            title,
            style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildRecentActivity() {
    return ValueListenableBuilder(
      valueListenable: StorageService.listenableNotes(),
      builder: (context, box, _) {
        // Only show actual notes, not exercise completions
        final recentNotes = StorageService.getRecentNotes(limit: 6);
        
        // Color palette for note cards (cycling through)
        final cardColors = [
          const Color(0xFF8B2635), // Dark red (maroon)
          const Color(0xFF1B3A4B), // Dark blue
          const Color(0xFF2D5016), // Dark green
          const Color(0xFF6B2C91), // Dark purple/magenta
          const Color(0xFF8B2635), // Repeat colors for 5th and 6th
          const Color(0xFF1B3A4B),
        ];
        
        // Convert notes to activity format
        final recentActivities = recentNotes.asMap().entries.map((entry) {
          final index = entry.key;
          final note = entry.value;
          return {
            'type': 'note',
            'id': note.id,
            'title': note.displayTitle,
            'subtitle': note.category ?? 'Exercise',
            'timestamp': note.createdAt,
            'color': cardColors[index % cardColors.length],
            'data': note,
          };
        }).toList();

        if (recentActivities.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.backgroundTertiary,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.spacing3),
                Text(
                  'No Recent Notes',
                  style: AppTypography.title3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  'Create a note or complete a live practice session!',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.spacing6),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(
              color: AppColors.backgroundTertiary,
              width: 3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Notes',
                style: AppTypography.headline,
              ),
              const SizedBox(height: AppSpacing.spacing4),
              // Grid layout: 2 columns
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.spacing4,
                  mainAxisSpacing: AppSpacing.spacing4,
                  childAspectRatio: 1.2, // Slightly wider than tall
                ),
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  return _buildGridNoteCard(recentActivities[index]);
                },
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildGridNoteCard(Map<String, dynamic> activity) {
    final title = activity['title'] as String;
    final subtitle = activity['subtitle'] as String;
    final timestamp = activity['timestamp'] as DateTime;
    final color = activity['color'] as Color;
    final note = activity['data']; // Get the note object for navigation

    // Format timestamp
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      timeAgo = 'Yesterday';
    } else if (difference.inDays < 7) {
      timeAgo = '${difference.inDays}d ago';
    } else {
      timeAgo = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }

    return InkWell(
      onTap: () {
        // Navigate to note detail screen
        if (note != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(note: note),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Stack(
          children: [
            // Timestamp in top-right corner
            Positioned(
              top: AppSpacing.spacing3,
              right: AppSpacing.spacing3,
              child: Text(
                timeAgo,
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
            // Title and description at bottom-left
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spacing4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.title3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.spacing1),
                    Text(
                      subtitle,
                      style: AppTypography.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Keep old method for potential future use or reference
  // ignore: unused_element
  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final title = activity['title'] as String;
    final subtitle = activity['subtitle'] as String;
    final timestamp = activity['timestamp'] as DateTime;
    final icon = activity['icon'] as IconData;
    final color = activity['color'] as Color;
    final note = activity['data']; // Get the note object for navigation
    
    // Format timestamp
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours}h ago';
    } else {
      timeAgo = '${difference.inDays}d ago';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing3),
      child: InkWell(
        onTap: () {
          // Navigate to note detail screen
          if (note != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteDetailScreen(note: note),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacing3),
          decoration: BoxDecoration(
            color: AppColors.backgroundTertiary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.callout.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          timeAgo,
                          style: AppTypography.caption.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacing1),
                      Text(
                    subtitle,
                        style: AppTypography.footnote.copyWith(
                          color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }



  // ignore: unused_element
  void _showResetOnboardingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        ),
        title: Row(
          children: [
            Icon(
              Icons.refresh,
              color: AppColors.infoBlue,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.spacing2),
            const Text('Reset Onboarding'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will reset the onboarding status and show the welcome screens again. All your notes, progress, and exercises will be preserved.',
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing3),
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing3),
              decoration: BoxDecoration(
                color: AppColors.infoBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                border: Border.all(
                  color: AppColors.infoBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.infoBlue,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.spacing2),
                  Expanded(
                    child: Text(
                      'Developer Feature',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.infoBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.callout.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // Logout the user first
              await StorageService.logout();
              
              // Reset the first launch flag
              await StorageService.setFirstLaunch(true);
              
              // Show loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Resetting onboarding...'),
                  duration: Duration(seconds: 1),
                ),
              );
              
              // Navigate to splash screen which will show onboarding
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.infoBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
