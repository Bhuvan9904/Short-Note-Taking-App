import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'tutorial_screen.dart';

class FeaturesOverviewScreen extends StatelessWidget {
  const FeaturesOverviewScreen({super.key});

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
                  const Spacer(),
                  Text(
                    '1 of 4',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Title
              Text(
                'What You\'ll Master',
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
                'Transform your note-taking with these powerful features',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: AppSpacing.spacing8),
              
              // Features List
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacing4),
                  child: Column(
                    children: [
                    _buildFeatureCard(
                      icon: Icons.speed,
                      title: 'Speed Training',
                      description: 'Practice with timed exercises to improve your typing speed and efficiency',
                      color: AppColors.successGreen,
                      delay: 400.ms,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    _buildFeatureCard(
                      icon: Icons.auto_awesome,
                      title: 'Smart Abbreviations',
                      description: 'Learn 40+ professional abbreviations to save time and capture more',
                      color: AppColors.infoBlue,
                      delay: 600.ms,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    _buildFeatureCard(
                      icon: Icons.analytics,
                      title: 'Progress Tracking',
                      description: 'Monitor your improvement with detailed analytics and performance metrics',
                      color: AppColors.warningAmber,
                      delay: 800.ms,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    _buildFeatureCard(
                      icon: Icons.psychology,
                      title: 'Intelligent Scoring',
                      description: 'Get feedback on accuracy, brevity, and abbreviation usage',
                      color: AppColors.primaryPurple,
                      delay: 1000.ms,
                    ),
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
                        builder: (context) => const TutorialScreen(),
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

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
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
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing1),
                Text(
                  description,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
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
