import 'package:flutter/material.dart';
import 'dart:async';
import '../models/exercise.dart';
import '../models/user_progress.dart';
import '../services/storage_service.dart';
import '../services/user_state_manager.dart';
import 'feedback_screen.dart';

class NoteTakingScreen extends StatefulWidget {
  final Exercise exercise;

  const NoteTakingScreen({super.key, required this.exercise});

  @override
  State<NoteTakingScreen> createState() => _NoteTakingScreenState();
}

class _NoteTakingScreenState extends State<NoteTakingScreen> {
  final TextEditingController _controller = TextEditingController();
  int _timeElapsed = 0; // Changed to count up from 0
  Timer? _timer;
  bool _hasStartedTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Listen for text changes to start timer on first keystroke
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasStartedTyping && _controller.text.isNotEmpty) {
      setState(() {
        _hasStartedTyping = true;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeElapsed += 1;
      });
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _buildResponsiveAppBarTitle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final title = widget.exercise.title;
        final timer = _formatTime(_timeElapsed);
        
        // For very small screens (< 300px), show title and timer on separate lines
        if (screenWidth < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: title,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timer,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
            ],
          );
        }
        
        // For small screens (300-400px), show title and timer in a row with flexible title
        if (screenWidth < 400) {
          return Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: title,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  timer,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }
        
        // For medium screens (400-500px), show title and timer with bullet separator
        if (screenWidth < 500) {
          return Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: title,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timer,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
        
        // For larger screens (500px+), show title and timer with bullet separator and full styling
        return Row(
          children: [
            Expanded(
              child: Tooltip(
                message: title,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '•',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              timer,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildResponsiveAppBarTitle(),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded content area - takes up most of the screen
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.exercise.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Fixed height input area at the bottom
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TextField with fixed height
                  SizedBox(
                    height: 100, // Further reduced height to prevent overflow
                    child: TextField(
                      controller: _controller,
                      maxLines: null, // Allow unlimited lines
                      expands: true, // Fill available space
                      textAlignVertical: TextAlignVertical.top, // Start text from top
                      decoration: const InputDecoration(
                        hintText: 'Type your abbreviated notes here...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced spacing
                  SizedBox(
                    width: double.infinity,
                    height: 48, // Fixed height for button
                    child: ElevatedButton(
                      onPressed: _hasStartedTyping ? _onSubmit : null,
                      child: Text(_hasStartedTyping ? 'Submit' : 'Start typing to begin...'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    // Stop the timer
    _timer?.cancel();
    
    final userNotes = _controller.text.trim();
    final timeSpent = _timeElapsed; // Use actual time elapsed

    final progress = UserProgress.create(
      exerciseId: widget.exercise.id,
      userNotes: userNotes,
      idealNotes: widget.exercise.idealNotes,
      timeSpent: timeSpent,
      keyTerms: widget.exercise.keyTerms,
    );

    await StorageService.saveProgress(progress);
    
    // Update user streak, exercise count, and WPM
    final user = StorageService.getCurrentUser();
    if (user != null) {
      print('DEBUG: Before update - User WPM: ${user.currentWPM}, Exercises: ${user.totalExercisesCompleted}');
      user.completeExercise();
      user.updateWPM(progress.wpm); // Update user's current WPM with the new progress
      
      // Update user's average accuracy
      final allProgress = StorageService.getUserProgress();
      if (allProgress.isNotEmpty) {
        final totalAccuracy = allProgress.fold<double>(0.0, (sum, p) => sum + p.accuracyScore);
        final avgAccuracy = totalAccuracy / allProgress.length;
        user.updateAccuracy(avgAccuracy);
        print('🔍 ACCURACY UPDATE: Progress count: ${allProgress.length}');
        print('🔍 ACCURACY UPDATE: Latest progress accuracy: ${progress.accuracyScore.toStringAsFixed(1)}%');
        print('🔍 ACCURACY UPDATE: Updated average accuracy: ${avgAccuracy.toStringAsFixed(1)}%');
      }
      
      await StorageService.saveUser(user);
      // Notify state manager of user data update
      UserStateManager().updateUserData();
      print('DEBUG: After update - User WPM: ${user.currentWPM}, Exercises: ${user.totalExercisesCompleted}, Progress WPM: ${progress.wpm}');
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FeedbackScreen(
          exercise: widget.exercise,
          progress: progress,
        ),
      ),
    );
  }
}


