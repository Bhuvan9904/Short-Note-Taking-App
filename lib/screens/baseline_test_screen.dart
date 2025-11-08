import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../services/user_state_manager.dart';
import '../models/user.dart';

class BaselineTestScreen extends StatefulWidget {
  const BaselineTestScreen({super.key});

  @override
  State<BaselineTestScreen> createState() => _BaselineTestScreenState();
}

class _BaselineTestScreenState extends State<BaselineTestScreen> {
  final TextEditingController _textController = TextEditingController();
  final String _testText = '''The quick brown fox jumps over the lazy dog. This is a standard typing test to measure your current words per minute. Please type this text as quickly and accurately as possible. The test will help us personalize your training program. Focus on accuracy while maintaining a steady pace. This baseline measurement is crucial for tracking your improvement over time.''';
  
  Timer? _timer;
  int _timeRemaining = 120; // 2 minutes
  bool _isTestActive = false;
  bool _isTestCompleted = false;
  int _startTime = 0;
  int _endTime = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      _isTestActive = true;
      _startTime = DateTime.now().millisecondsSinceEpoch;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
      });

      if (_timeRemaining <= 0) {
        _completeTest();
      }
    });
  }

  void _completeTest() {
    _timer?.cancel();
    _endTime = DateTime.now().millisecondsSinceEpoch;
    
    setState(() {
      _isTestActive = false;
      _isTestCompleted = true;
    });

    _calculateAndSaveResults();
  }

  void _calculateAndSaveResults() {
    final userText = _textController.text;
    final testDuration = (_endTime - _startTime) / 1000.0; // seconds
    final wordsTyped = userText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final wpm = (wordsTyped / (testDuration / 60.0)).clamp(0.0, 200.0);

    // Create user with baseline
    final user = User.createNew();
    user.baselineWPM = wpm;
    user.currentWPM = wpm;
    user.updateWPM(wpm);

    // Save user
    StorageService.saveUser(user);
    // Notify state manager of user data update
    UserStateManager().updateUserData();
    
    // Mark onboarding as completed
    StorageService.setFirstLaunch(false);

    // Navigate to signup screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false, // Remove all previous routes
    );
  }

  void _skipTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: const Text(
          'Skip Baseline Test?',
          style: AppTypography.title2,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.help_outline,
              size: 48,
              color: AppColors.warningAmber,
            ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              'The baseline test helps us personalize your training. You can always take it later from the Progress tab.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.buttonSecondary.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _proceedWithoutBaseline();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningAmber,
              foregroundColor: Colors.white,
            ),
            child: const Text('Skip Test'),
          ),
        ],
      ),
    );
  }

  void _proceedWithoutBaseline() {
    // Create user with default baseline
    final user = User.createNew();
    user.baselineWPM = 0.0; // No baseline set yet
    user.currentWPM = 0.0;
    // Don't call updateWPM to avoid streak issues

    // Save user
    StorageService.saveUser(user);
    // Notify state manager of user data update
    UserStateManager().updateUserData();
    
    // Mark onboarding as completed
    StorageService.setFirstLaunch(false);

    // Navigate to signup screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false, // Remove all previous routes
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Baseline Speed Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_isTestActive && !_isTestCompleted)
            TextButton(
              onPressed: _skipTest,
              child: Text(
                'Skip',
                style: AppTypography.buttonSecondary.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            if (!_isTestActive && !_isTestCompleted) ...[
              const Text(
                "Let's measure your current speed",
                style: AppTypography.title2,
              ),
              const SizedBox(height: AppSpacing.spacing4),
              Text(
                'Type the text below as quickly and accurately as possible. This helps us personalize your training.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing6),
            ],

            // Timer
            if (_isTestActive) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.spacing4),
                decoration: BoxDecoration(
                  color: _timeRemaining <= 30 
                      ? AppColors.errorRed.withOpacity(0.1)
                      : AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  border: Border.all(
                    color: _timeRemaining <= 30 
                        ? AppColors.errorRed
                        : AppColors.primaryPurple,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Time Remaining',
                      style: AppTypography.footnote.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing2),
                    Text(
                      _formatTime(_timeRemaining),
                      style: AppTypography.timerDisplay.copyWith(
                        color: _timeRemaining <= 30 
                            ? AppColors.errorRed
                            : AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacing6),
            ],

            // Test text display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.spacing4),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                border: Border.all(
                  color: AppColors.backgroundTertiary,
                  width: 1,
                ),
              ),
              child: Text(
                _testText,
                style: AppTypography.body.copyWith(
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.spacing6),

            // Input area
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type here:',
                  style: AppTypography.headline,
                ),
                const SizedBox(height: AppSpacing.spacing2),
                SizedBox(
                  height: 200,
                  child: TextField(
                    controller: _textController,
                    enabled: _isTestActive,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: AppTypography.body,
                    decoration: InputDecoration(
                      hintText: _isTestActive 
                          ? 'Start typing...'
                          : 'Tap "Start Test" to begin',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundTertiary,
                      contentPadding: const EdgeInsets.all(AppSpacing.spacing4),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.spacing6),

            // Action button
            if (!_isTestCompleted)
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: _isTestActive ? _completeTest : _startTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTestActive 
                        ? AppColors.errorRed
                        : AppColors.primaryPurple,
                  ),
                  child: Text(
                    _isTestActive ? 'Complete Test' : 'Start Test',
                    style: AppTypography.buttonPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
