import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/exercise.dart';
import '../models/user_progress.dart';

class FeedbackScreen extends StatefulWidget {
  final Exercise exercise;
  final UserProgress progress;

  const FeedbackScreen({
    super.key,
    required this.exercise,
    required this.progress,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool _animateScore = false;

  @override
  void initState() {
    super.initState();
    // Trigger score animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _animateScore = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return true to indicate exercise was completed when using system back button
        Navigator.of(context).pop(true);
        return false; // Prevent default pop behavior since we handled it
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Return true to indicate exercise was completed
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          child: Column(
            children: [
              // Hero score section
              _buildScoreHero(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Metrics row
              _buildMetricsRow(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Note comparison
              _buildNoteComparison(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Improvement tips
              if (widget.progress.improvementSuggestions.isNotEmpty)
                _buildImprovementTips(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildScoreHero() {
    final scoreColor = AppColors.getScoreColor(widget.progress.score);
    
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scoreColor.withOpacity(0.8),
            scoreColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Donut-style progress indicator (custom painted)
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(
              begin: 0,
              end: _animateScore ? widget.progress.score / 100 : 0,
            ),
            builder: (context, value, child) {
              return SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: _DonutProgressPainter(
                        progress: value,
                        trackColor: Colors.white.withOpacity(0.22),
                        progressColor: Colors.white,
                        strokeWidth: 10,
                      ),
                    ),
                    Text(
                      '${(value * 100).clamp(0, 100).toStringAsFixed(0)}%',
                      style: AppTypography.scoreDisplay.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              .animate(target: _animateScore ? 1 : 0)
              .scale(
                duration: 1000.ms,
                curve: Curves.elasticOut,
              ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Performance description
          Text(
            widget.progress.performanceDescription,
            style: AppTypography.title3.copyWith(
              color: Colors.white,
            ),
          )
              .animate()
              .fadeIn(
                delay: 500.ms,
                duration: 600.ms,
              )
              .slideY(
                begin: 0.3,
                end: 0,
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Accuracy',
            '${widget.progress.accuracyScore.toStringAsFixed(0)}%',
            Icons.gps_fixed,
            AppColors.successGreen,
          ),
        ),
        const SizedBox(width: AppSpacing.spacing3),
        Expanded(
          child: _buildMetricCard(
            'Speed',
            '${widget.progress.wpm.toStringAsFixed(1)}',
            Icons.speed,
            AppColors.infoBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.spacing3),
        Expanded(
          child: _buildMetricCard(
            'Abbreviations',
            '${widget.progress.abbreviationUsage.toStringAsFixed(0)}%',
            Icons.auto_awesome,
            AppColors.warningAmber,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    // Special handling for Speed card to add WPM unit
    final isSpeedCard = title == 'Speed';
    final displayValue = isSpeedCard ? value : value;
    final subtitle = isSpeedCard ? 'WPM' : null;
    
    return Container(
      constraints: const BoxConstraints(
        minHeight: 90,
        maxHeight: 100,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing2,
        vertical: AppSpacing.spacing2,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          // Value
          Flexible(
            child: Text(
              displayValue,
              style: AppTypography.title3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Subtitle (only for Speed card)
          if (subtitle != null)
            Flexible(
              child: Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          // Title
          Flexible(
            child: Text(
              title,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteComparison() {
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
            'Note Comparison',
            style: AppTypography.headline,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          
          // Your notes
          _buildComparisonSection(
            'Your Notes',
            widget.progress.userNotes,
            AppColors.primaryPurple,
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Ideal notes
          _buildComparisonSection(
            'Ideal Notes',
            widget.exercise.idealNotes,
            AppColors.successGreen,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildComparisonSection(String title, String content, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.spacing2),
            Text(
              title,
              style: AppTypography.subheadline.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
            content,
            style: AppTypography.body.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementTips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border(
          left: BorderSide(
            color: AppColors.warningAmber,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.warningAmber,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.spacing2),
              const Text(
                'Improvement Tips',
                style: AppTypography.headline,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          ...widget.progress.improvementSuggestions.map((suggestion) => 
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spacing2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.warningAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing2),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeightLarge,
        child: ElevatedButton(
        onPressed: () {
          // Pop back to ExerciseSelectionScreen with completion result
          // Navigation stack: [Home/LearningHub] -> [ExerciseSelectionScreen] -> [FeedbackScreen]
          // We need to pop once to go back to ExerciseSelectionScreen
          Navigator.of(context).pop(true);
        },
        child: const Text('Next Exercise'),
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

}

// Paints a donut-style progress ring with rounded caps
class _DonutProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _DonutProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [progressColor, progressColor.withOpacity(0.9)],
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw track
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc
    final startAngle = -pi / 2; // start at top
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
