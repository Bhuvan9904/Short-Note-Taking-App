import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../models/exercise.dart';
import 'note_taking_screen.dart';

class AudioPlaybackScreen extends StatefulWidget {
  final Exercise exercise;
  final double speed;

  const AudioPlaybackScreen({super.key, required this.exercise, required this.speed});

  @override
  State<AudioPlaybackScreen> createState() => _AudioPlaybackScreenState();
}

class _AudioPlaybackScreenState extends State<AudioPlaybackScreen> {
  bool _isPlaying = false;
  String? _errorMessage;
  late double _speed;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    _speed = widget.speed;
    // Ensure minimum duration to prevent division by zero
    _duration = Duration(minutes: widget.exercise.duration ~/ 60);
    if (_duration.inSeconds <= 0) {
      _duration = const Duration(minutes: 1); // Default to 1 minute minimum
    }
    _errorMessage = 'Audio simulation mode - Real audio files will be added soon';
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      _pausePlayback();
    } else {
      _startPlayback();
    }
  }

  void _startPlayback() {
    setState(() {
      _isPlaying = true;
    });

    // Start a timer to simulate playback progress
    _playbackTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _position += Duration(seconds: 1);
        
        // Check if we've reached the end
        if (_position >= _duration) {
          _pausePlayback();
        }
      });
    });
  }

  void _pausePlayback() {
    _playbackTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resetPlayback() {
    _pausePlayback();
    setState(() {
      _position = Duration.zero;
    });
  }

  Future<void> _setSpeed(double speed) async {
    setState(() {
      _speed = speed;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Audio Playback'),
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.red.withOpacity(0.3), // Debug background
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Debug text
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.yellow,
                  child: Text(
                    'DEBUG: Screen is loading - ${widget.exercise.title}',
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  widget.exercise.title,
                  style: AppTypography.title2.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  'Duration: ${widget.exercise.durationText}',
                  style: AppTypography.footnote.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  'Audio Path: ${widget.exercise.audioFilePath ?? "None"}',
                  style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: AppSpacing.spacing6),
                
                // Audio player controls
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.spacing6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    border: Border.all(
                      color: AppColors.primaryPurple.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Play/Pause Button
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          size: 64,
                          color: AppColors.primaryPurple,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      const SizedBox(height: AppSpacing.spacing2),
                      
                      // Status Text
                      Text(
                        _isPlaying ? 'Playing... (Simulated)' : 'Ready to Play',
                        style: AppTypography.title3.copyWith(
                          color: _isPlaying ? AppColors.primaryPurple : AppColors.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.spacing3),
                      
                      // Progress Bar
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4.0,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                        ),
                        child: Slider(
                          value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                          max: _duration.inSeconds.toDouble(),
                          min: 0.0,
                          onChanged: (value) {
                            setState(() {
                              _position = Duration(seconds: value.toInt());
                            });
                          },
                          activeColor: AppColors.primaryPurple,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppSpacing.spacing3),
                      
                      // Speed Control
                      Row(
                        children: [
                          Text(
                            'Speed:',
                            style: AppTypography.footnote.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: AppSpacing.spacing2),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3.0,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                              ),
                              child: Slider(
                                value: _speed.clamp(0.5, 2.0),
                                onChanged: _setSpeed,
                                min: 0.5,
                                max: 2.0,
                                divisions: 15,
                                label: '${_speed.toStringAsFixed(1)}x',
                                activeColor: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                          Text(
                            '${_speed.toStringAsFixed(1)}x',
                            style: AppTypography.footnote.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppSpacing.spacing3),
                      
                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _resetPlayback,
                            icon: const Icon(Icons.stop),
                            label: const Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backgroundTertiary,
                              foregroundColor: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppSpacing.spacing3),
                      
                      // Info Box
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
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.infoBlue,
                              size: 20,
                            ),
                            const SizedBox(height: AppSpacing.spacing2),
                            Text(
                              'Simulation Mode',
                              style: AppTypography.footnote.copyWith(
                                color: AppColors.infoBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _errorMessage!,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.spacing2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.spacing2,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                              ),
                              child: Text(
                                'Perfect for practicing note-taking timing and flow',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.spacing8),
                
                // Debug button
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.green,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      print('Debug button pressed!');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Debug button works!')),
                      );
                    },
                    child: const Text(
                      'DEBUG: Test Button',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeightLarge,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteTakingScreen(exercise: widget.exercise),
                        ),
                      );
                    },
                    child: const Text('Start Note-Taking Practice'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}