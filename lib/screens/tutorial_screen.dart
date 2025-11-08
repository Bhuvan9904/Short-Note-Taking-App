import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'tips_screen.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing6),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.textPrimary,
                  ),
                  const Spacer(),
                  Text(
                    '2 of 4',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Title
              Text(
                'How Abbreviations Work',
                style: AppTypography.headline.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: AppSpacing.spacing2),
              
              Text(
                'Learn the secret to faster note-taking',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: AppSpacing.spacing8),
              
              // Example Section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacing4),
                  child: Column(
                    children: [
                    // Example 1
                    _buildExampleCard(
                      title: 'Before: Long Notes',
                      content: 'The quarterly budget meeting will be scheduled for next Monday at 2:00 PM in the conference room.',
                      characterCount: 108,
                      color: AppColors.errorRed,
                      delay: 400.ms,
                    ),
                    
                    const SizedBox(height: AppSpacing.spacing4),
                    
                    // Arrow
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.spacing2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms)
                        .scale(duration: 400.ms),
                    
                    const SizedBox(height: AppSpacing.spacing4),
                    
                    // Example 2
                    _buildExampleCard(
                      title: 'After: Smart Notes',
                      content: 'Q3 budg mtg Mon 2PM conf rm',
                      characterCount: 28,
                      color: AppColors.successGreen,
                      delay: 800.ms,
                    ),
                    
                    const SizedBox(height: AppSpacing.spacing6),
                    
                    // Benefits
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.spacing4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.successGreen.withOpacity(0.1),
                            AppColors.successGreen.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                        border: Border.all(
                          color: AppColors.successGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.speed,
                                color: AppColors.successGreen,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.spacing2),
                              Text(
                                '74% Time Saved!',
                                style: AppTypography.title3.copyWith(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.spacing2),
                          Text(
                            'From 108 to 28 characters - you\'ll capture the same information in a fraction of the time!',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TipsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: AppColors.primaryPurple.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: AppTypography.buttonPrimary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required String content,
    required int characterCount,
    required Color color,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing2,
                  vertical: AppSpacing.spacing1,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$characterCount chars',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing3),
          Text(
            content,
            style: AppTypography.body.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 600.ms)
        .slideX(begin: 0.3, end: 0);
  }
}
