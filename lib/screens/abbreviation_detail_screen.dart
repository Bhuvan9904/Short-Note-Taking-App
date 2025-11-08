import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/abbreviation.dart';

class AbbreviationDetailScreen extends StatelessWidget {
  final Abbreviation abbreviation;

  const AbbreviationDetailScreen({
    super.key,
    required this.abbreviation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Abbreviation Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.spacing6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(abbreviation.category).withOpacity(0.1),
                    _getCategoryColor(abbreviation.category).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                border: Border.all(
                  color: _getCategoryColor(abbreviation.category).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(abbreviation.category).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getCategoryColor(abbreviation.category).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _getCategoryIcon(abbreviation.category),
                      color: _getCategoryColor(abbreviation.category),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  Text(
                    abbreviation.fullWord,
                    style: AppTypography.title1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.spacing2),
                  Text(
                    abbreviation.abbreviation,
                    style: AppTypography.headline.copyWith(
                      color: _getCategoryColor(abbreviation.category),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing3,
                      vertical: AppSpacing.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(abbreviation.category).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      abbreviation.categoryText,
                      style: AppTypography.caption.copyWith(
                        color: _getCategoryColor(abbreviation.category),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.spacing6),
            
            // Description Section
            if (abbreviation.description != null && abbreviation.description!.isNotEmpty) ...[
              _buildSection(
                title: 'Description',
                icon: Icons.description,
                color: AppColors.infoBlue,
                child: Text(
                  abbreviation.description!,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing6),
            ],
            
            // Usage Examples Section
            _buildSection(
              title: 'Usage Examples',
              icon: Icons.lightbulb_outline,
              color: AppColors.warningAmber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExampleCard(
                    'Before (Full Word)',
                    'The ${abbreviation.fullWord.toLowerCase()} department will review the proposal.',
                    AppColors.errorRed.withOpacity(0.1),
                  ),
                  const SizedBox(height: AppSpacing.spacing3),
                  _buildExampleCard(
                    'After (Abbreviation)',
                    'The ${abbreviation.abbreviation} dept will review the proposal.',
                    AppColors.successGreen.withOpacity(0.1),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.spacing6),
            
            // Tips Section
            _buildSection(
              title: 'Tips for Usage',
              icon: Icons.tips_and_updates,
              color: AppColors.primaryPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTipItem('Use in formal documents and reports'),
                  _buildTipItem('Perfect for meeting notes and minutes'),
                  _buildTipItem('Saves time while maintaining clarity'),
                  _buildTipItem('Ensure context makes the abbreviation clear'),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing5),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.spacing2),
              Text(
                title,
                style: AppTypography.title3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          child,
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, String example, Color backgroundColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(
          color: backgroundColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            example,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: AppSpacing.spacing3),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
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

  IconData _getCategoryIcon(AbbreviationCategory category) {
    switch (category) {
      case AbbreviationCategory.business:
        return Icons.business;
      case AbbreviationCategory.common:
        return Icons.star;
      case AbbreviationCategory.custom:
        return Icons.edit;
    }
  }
}
