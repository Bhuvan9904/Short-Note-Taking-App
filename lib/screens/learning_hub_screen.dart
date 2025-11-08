import 'package:flutter/material.dart';
import 'package:short_note_app1/screens/abbreviations_learning_screen.dart';
import 'abbreviation_detail_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/user.dart';
import '../models/abbreviation.dart';
import 'exercise_selection_screen.dart';
import 'progress_analytics_screen.dart';

class LearningHubScreen extends StatefulWidget {
  final ValueNotifier<int>? refreshNotifier;
  
  const LearningHubScreen({super.key, this.refreshNotifier});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  User? _user;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Listen to refresh notifier
    widget.refreshNotifier?.addListener(_onRefreshRequested);
  }
  
  void _onRefreshRequested() {
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when screen becomes visible
    _loadUserData();
  }

  void _loadUserData() {
    if (mounted) {
      setState(() {
        _user = StorageService.getCurrentUser();
        _stats = StorageService.getStatistics();
      });
    }
  }
  
  @override
  void dispose() {
    widget.refreshNotifier?.removeListener(_onRefreshRequested);
    super.dispose();
  }


  List<Abbreviation> _getRecentAbbreviations() {
    final allAbbreviations = StorageService.getAllAbbreviations();
    
    // Debug: Print all abbreviations to see what we have
    print('Total abbreviations: ${allAbbreviations.length}');
    for (var abbr in allAbbreviations) {
      print('Abbreviation: ${abbr.fullWord} - isUserCreated: ${abbr.isUserCreated} - createdAt: ${abbr.createdAt}');
    }
    
    // Filter for only user-created abbreviations and sort by creation date (most recent first)
    final userCreatedAbbreviations = allAbbreviations
        .where((abbreviation) => abbreviation.isUserCreated == true)
        .toList();
    
    print('User created abbreviations: ${userCreatedAbbreviations.length}');
    
    // Sort by creation date (most recent first)
    userCreatedAbbreviations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Return the 3 most recent user-created abbreviations
    final result = userCreatedAbbreviations.take(3).toList();
    print('Returning ${result.length} recent abbreviations');
    
    // Temporary: If no user-created abbreviations, show all abbreviations for debugging
    if (result.isEmpty && allAbbreviations.isNotEmpty) {
      print('No user-created abbreviations found, showing all abbreviations for debugging');
      final allSorted = List<Abbreviation>.from(allAbbreviations)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allSorted.take(3).toList();
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Learning Hub'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadUserData();
        },
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section (content only, improved typography)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Your Learning Hub',
                  style: AppTypography.title2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing1),
                Container(
                  width: 48,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  'Access all your learning tools and track your progress in one place',
                  style: AppTypography.subheadline.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.spacing6),

            // Main learning sections
            Text(
              'Learning Tools',
              style: AppTypography.title2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing4),

            // Training Section
            _buildHubCard(
              context: context,
              title: 'Training & Exercises',
              description: 'Practice your note-taking skills with various exercises and training modules',
              icon: Icons.fitness_center,
              iconColor: AppColors.primaryPurple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExerciseSelectionScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.spacing4),

            // Abbreviations Section
            _buildHubCard(
              context: context,
              title: 'Abbreviation Learning',
              description: 'Learn and practice medical abbreviations to improve your note-taking speed',
              icon: Icons.medical_services,
              iconColor: AppColors.successGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AbbreviationsLearningScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.spacing6),

            // Progress Summary Card
            _buildProgressCard(),

            const SizedBox(height: AppSpacing.spacing6),

            // Recent Abbreviations Section
            _buildRecentAbbreviationsSection(),

          ],
        ),
        ),
      ),
    );
  }

  Widget _buildHubCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundPrimary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing5),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.title3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing1),
                      Text(
                        description,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: AppTypography.headline,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProgressAnalyticsScreen(),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: AppTypography.callout.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Row(
            children: [
              Expanded(
                child: _buildLargeStatCard(
                  title: 'Current WPM',
                  value: '${(_user?.currentWPM ?? 0).toStringAsFixed(1)}',
                  icon: Icons.speed,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: _buildLargeStatCard(
                  title: 'Best Score',
                  value: '${(_stats['bestScore'] ?? 0).toStringAsFixed(0)}%',
                  icon: Icons.emoji_events,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Row(
            children: [
              Expanded(
                child: _buildSmallStatCard(
                  title: 'Exercises',
                  value: '${_stats['totalExercises'] ?? 0}',
                  color: AppColors.infoBlue,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: _buildSmallStatCard(
                  title: 'Streak',
                  value: '${_user?.streakDays ?? 0}',
                  color: AppColors.warningAmber,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: _buildSmallStatCard(
                  title: 'Accuracy',
                  value: '${(_stats['averageAccuracy'] ?? 0).toStringAsFixed(0)}%',
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          width: 1,
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
          width: 1,
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

  Widget _buildRecentAbbreviationsSection() {
    final recentAbbreviations = _getRecentAbbreviations();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.backgroundTertiary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recently Added Abbreviations',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          if (recentAbbreviations.isEmpty)
            _buildEmptyAbbreviationsState()
          else
            ...recentAbbreviations.map((abbreviation) => _buildAbbreviationItem(abbreviation)),
        ],
      ),
    );
  }

  Widget _buildEmptyAbbreviationsState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.successGreen.withOpacity(0.05),
            AppColors.primaryPurple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.successGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.successGreen.withOpacity(0.1),
                  AppColors.primaryPurple.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppColors.successGreen.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.quiz_outlined,
              size: 40,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            'No Recently Added Abbreviations',
            style: AppTypography.title2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            'Add custom abbreviations to see them here!',
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAbbreviationItem(Abbreviation abbreviation) {
    return GestureDetector(
      onTap: () {
        // Navigate to specific abbreviation detail screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AbbreviationDetailScreen(
              abbreviation: abbreviation,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacing3),
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: AppColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(
            color: _getCategoryColor(abbreviation.category).withOpacity(0.3),
            width: 1,
          ),
        ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(abbreviation.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.medical_services,
              color: _getCategoryColor(abbreviation.category),
              size: 20,
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
                      abbreviation.fullWord,
                      style: AppTypography.callout.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(abbreviation.category).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        abbreviation.categoryText,
                        style: AppTypography.caption.copyWith(
                          color: _getCategoryColor(abbreviation.category),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacing1),
                Text(
                  abbreviation.abbreviation,
                  style: AppTypography.body.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (abbreviation.description != null) ...[
                  const SizedBox(height: AppSpacing.spacing1),
                  Text(
                    abbreviation.description!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Add arrow icon to indicate clickability
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textTertiary,
            size: 16,
          ),
        ],
      ),
    ),
    );
  }

  Color _getCategoryColor(AbbreviationCategory category) {
    switch (category) {
      case AbbreviationCategory.business:
        return AppColors.infoBlue;
      case AbbreviationCategory.common:
        return AppColors.successGreen;
      case AbbreviationCategory.custom:
        return AppColors.primaryPurple;
    }
  }

}
