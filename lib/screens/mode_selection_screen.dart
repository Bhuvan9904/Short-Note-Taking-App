import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../models/exercise.dart';
import 'note_taking_screen.dart';
import 'audio_playback_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  final Exercise exercise;

  const ModeSelectionScreen({super.key, required this.exercise});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  double _speed = 1.0; // 0.5x - 2.0x

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Select Mode'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildModeCard(
                    icon: Icons.volume_up,
                    title: 'Audio Mode',
                    description: 'Listen and take notes in real-time',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AudioPlaybackScreen(
                            exercise: widget.exercise,
                            speed: _speed,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing3),
                Expanded(
                  child: _buildModeCard(
                    icon: Icons.text_snippet,
                    title: 'Timed Text Mode',
                    description: 'Read timed text and capture key points',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteTakingScreen(exercise: widget.exercise),
                        ),
                      );
                    },
                    isSecondary: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.spacing6),

            Text(
              'Playback Speed ${_speed.toStringAsFixed(1)}x',
              style: AppTypography.callout,
            ),
            Slider(
              value: _speed,
              onChanged: (v) => setState(() => _speed = v),
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: '${_speed.toStringAsFixed(1)}x',
              activeColor: AppColors.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing5),
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.backgroundSecondary : AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSecondary ? AppColors.primaryPurple : Colors.white,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.spacing3),
            Text(
              title,
              style: AppTypography.title3.copyWith(
                color: isSecondary ? AppColors.textPrimary : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTypography.footnote.copyWith(
                color: isSecondary ? AppColors.textSecondary : Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




