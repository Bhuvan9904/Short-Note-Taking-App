import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/live_session.dart';

class LiveSessionReviewScreen extends StatelessWidget {
  final LiveSession session;
  const LiveSessionReviewScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Session Review'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreCard(),
            const SizedBox(height: AppSpacing.spacing6),
            _buildComparison(),
            const SizedBox(height: AppSpacing.spacing6),
            _buildImprovementTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
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
          Text(
            'Match Score: ${session.score.toStringAsFixed(0)}% ',
            style: AppTypography.title2.copyWith(
              color: AppColors.getScoreColor(session.score),
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            session.performanceDescription,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparison() {
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
            'Transcript vs Your Notes',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          _buildSideBySide('Transcript', session.transcript),
          const SizedBox(height: AppSpacing.spacing4),
          _buildSideBySide('Your Notes', session.userNotes),
        ],
      ),
    );
  }

  Widget _buildSideBySide(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.subheadline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.spacing3),
          decoration: BoxDecoration(
            color: AppColors.backgroundTertiary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Text(
            content.isEmpty ? 'No content' : content,
            style: AppTypography.body.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementTips() {
    final missed = session.missedPoints;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: const Border(
          left: BorderSide(color: AppColors.warningAmber, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.warningAmber),
              const SizedBox(width: AppSpacing.spacing2),
              const Text('Improvement Tips', style: AppTypography.headline),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          if (missed.isEmpty)
            const Text('Great coverage. Keep practicing!', style: AppTypography.body)
          else
            ...missed.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacing2),
                  child: Text('- Include key term: $m', style: AppTypography.body),
                )),
        ],
      ),
    );
  }
}



