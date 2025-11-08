import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'features_overview_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing6),
          child: Column(
            children: [
              const Spacer(),
              
              // Hero section
              Column(
                children: [
                  // App icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.speed,
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: AppSpacing.spacing6),

                  // Title
                  const Text(
                    'Master Speed\nNote-Taking',
                    style: AppTypography.largeTitle,
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(
                        delay: 200.ms,
                        duration: 600.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: AppSpacing.spacing4),

                  // Subtitle
                  Text(
                    'Learn professional abbreviation techniques to capture information 10x faster',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(
                        delay: 400.ms,
                        duration: 600.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOut,
                      ),
                ],
              ),

              const SizedBox(height: AppSpacing.spacing12),

              // Features list
              Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.timer,
                    title: 'Speed Training',
                    description: 'Practice with timed exercises',
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  _buildFeatureItem(
                    icon: Icons.auto_awesome,
                    title: 'Smart Abbreviations',
                    description: 'Learn proven shorthand techniques',
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  _buildFeatureItem(
                    icon: Icons.analytics,
                    title: 'Progress Tracking',
                    description: 'See your improvement over time',
                  ),
                ],
              )
                  .animate()
                  .fadeIn(
                    delay: 600.ms,
                    duration: 600.ms,
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOut,
                  ),

              const Spacer(),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to features overview screen (next onboarding screen)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FeaturesOverviewScreen(),
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
                    'Get Started',
                    style: AppTypography.buttonPrimary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: 800.ms,
                    duration: 600.ms,
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOut,
                  ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryPurple,
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
                style: AppTypography.headline.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

