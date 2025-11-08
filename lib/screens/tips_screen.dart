import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'baseline_test_screen.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

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
                    '3 of 4',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Title
              Text(
                'Pro Tips',
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
                'Master these techniques for maximum efficiency',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: AppSpacing.spacing8),
              
              // Tips List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTipCard(
                        icon: Icons.priority_high,
                        title: 'Focus on Key Information',
                        description: 'Capture numbers, decisions, deadlines, and action items first. Details can be added later.',
                        color: AppColors.errorRed,
                        delay: 400.ms,
                      ),
                      const SizedBox(height: AppSpacing.spacing4),
                      _buildTipCard(
                        icon: Icons.auto_awesome,
                        title: 'Use Consistent Abbreviations',
                        description: 'Stick to standard abbreviations like "mtg" for meeting and "proj" for project.',
                        color: AppColors.warningAmber,
                        delay: 600.ms,
                      ),
                      const SizedBox(height: AppSpacing.spacing4),
                      _buildTipCard(
                        icon: Icons.hearing,
                        title: 'Listen for Signal Words',
                        description: 'Pay attention to words like "important", "deadline", "budget" - they indicate priority info.',
                        color: AppColors.infoBlue,
                        delay: 800.ms,
                      ),
                      const SizedBox(height: AppSpacing.spacing4),
                      _buildTipCard(
                        icon: Icons.speed,
                        title: 'Practice Daily',
                        description: 'Even 10 minutes daily practice beats 2 hours once a week. Consistency builds muscle memory.',
                        color: AppColors.successGreen,
                        delay: 1000.ms,
                      ),
                      const SizedBox(height: AppSpacing.spacing4),
                      _buildTipCard(
                        icon: Icons.edit,
                        title: 'Create Personal Shortcuts',
                        description: 'Develop your own abbreviations for words you use frequently in your field.',
                        color: AppColors.primaryPurple,
                        delay: 1200.ms,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.spacing4),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BaselineTestScreen(),
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
                    'Start Your Test',
                    style: AppTypography.buttonPrimary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1400.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
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



