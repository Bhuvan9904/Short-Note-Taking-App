import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io' show Platform;
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/live_session.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../services/user_state_manager.dart';
import 'live_session_review_screen.dart';

class LivePracticeScreen extends StatefulWidget {
  const LivePracticeScreen({super.key});

  @override
  State<LivePracticeScreen> createState() => _LivePracticeScreenState();
}

class _LivePracticeScreenState extends State<LivePracticeScreen> {
  final TextEditingController _notesController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  
  bool _isRecording = false;
  bool _isInitialized = false;
  String _transcriptText = '';
  String _fullTranscript = '';
  String _userNotes = '';
  DateTime? _sessionStartTime;
  int _sessionDuration = 0;
  Timer? _durationTimer;
  Timer? _watchdogTimer;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  @override
  void dispose() {
    _speechToText.stop();
    _durationTimer?.cancel();
    _watchdogTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    final hasPerm = await _ensurePermissions();
    if (!hasPerm) {
      return;
    }

    final available = await _speechToText.initialize(
      onStatus: (status) async {
        // Keep dictation continuous by restarting when the engine pauses
        if (status == 'notListening' && _isRecording) {
          await Future.delayed(const Duration(milliseconds: 200));
          if (!_speechToText.isListening) {
            _restartListening();
          }
        }
        setState(() {
          _isRecording = status == 'listening' || _speechToText.isListening;
        });
      },
      onError: (error) {
        setState(() {
          _isRecording = false;
        });
        // Try to recover automatically; only show dialog if we can't listen again
        if (_isRecording) {
          _restartListening();
        } else {
          _showErrorDialog('Speech recognition error: ${error.errorMsg}');
        }
      },
      debugLogging: true,
    );

    setState(() {
      _isInitialized = available;
    });
  }

  Future<bool> _ensurePermissions() async {
    // Microphone permission
    var micStatus = await Permission.microphone.status;
    if (micStatus.isDenied) {
      micStatus = await Permission.microphone.request();
    }
    if (micStatus.isPermanentlyDenied || micStatus.isRestricted) {
      _showPermissionDialog();
      return false;
    }
    if (!micStatus.isGranted) {
      _showErrorDialog('Microphone permission is required to record audio.');
      return false;
    }

    // iOS: Speech recognition permission
    if (Platform.isIOS) {
      var speechStatus = await Permission.speech.status;
      if (speechStatus.isDenied) {
        speechStatus = await Permission.speech.request();
      }
      if (speechStatus.isPermanentlyDenied || speechStatus.isRestricted) {
        _showPermissionDialog();
        return false;
      }
      if (!speechStatus.isGranted) {
        _showErrorDialog('Speech recognition permission is required on iOS.');
        return false;
      }
    }
    return true;
  }

  void _startRecording() async {
    if (!_isInitialized) {
      await _initializeSpeech();
      return;
    }

    setState(() {
      _sessionStartTime = DateTime.now();
      _transcriptText = '';
      _fullTranscript = '';
      _userNotes = '';
      _isRecording = true;
    });

    _startDurationTimer();
    _startWatchdog();

    // Determine device locale if available
    // Prefer Indian English if available
    final systemLocale = await _speechToText.systemLocale();
    final locales = await _speechToText.locales();
    const preferredLocale = 'en_IN';
    String localeId = preferredLocale;
    if (!locales.any((l) => l.localeId == preferredLocale)) {
      localeId = systemLocale?.localeId ?? 'en_US';
    }

    await _speechToText.listen(
      onResult: (result) {
        // Accumulate final results to build the full transcript
        if (result.finalResult) {
          _fullTranscript = (_fullTranscript + ' ' + result.recognizedWords).trim();
        }
        setState(() {
          _transcriptText = (_fullTranscript + (result.finalResult ? '' : (' ' + result.recognizedWords))).trim();
        });
      },
      listenFor: const Duration(minutes: 60),
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      localeId: localeId,
      listenMode: ListenMode.dictation,
      onDevice: false,
      cancelOnError: false,
      onSoundLevelChange: (level) {},
    );
  }

  Future<void> _restartListening() async {
    if (!_isRecording) return;
    final systemLocale = await _speechToText.systemLocale();
    final locales = await _speechToText.locales();
    const preferredLocale = 'en_IN';
    String localeId = preferredLocale;
    if (!locales.any((l) => l.localeId == preferredLocale)) {
      localeId = systemLocale?.localeId ?? 'en_US';
    }
    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          _fullTranscript = (_fullTranscript + ' ' + result.recognizedWords).trim();
        }
        setState(() {
          _transcriptText = (_fullTranscript + (result.finalResult ? '' : (' ' + result.recognizedWords))).trim();
        });
      },
      listenFor: const Duration(minutes: 60),
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      localeId: localeId,
      listenMode: ListenMode.dictation,
      onDevice: false,
      cancelOnError: false,
    );
  }

  void _startWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 2), (t) async {
      if (_isRecording && !_speechToText.isListening) {
        await _restartListening();
      }
    });
  }

  void _stopRecording() {
    _speechToText.stop();
    _durationTimer?.cancel();
    _watchdogTimer?.cancel();
    setState(() {
      _isRecording = false;
    });
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sessionStartTime != null) {
        setState(() {
          _sessionDuration = DateTime.now().difference(_sessionStartTime!).inSeconds;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _endSession() {
    if (_isRecording) {
      _stopRecording();
    }

    if (_transcriptText.isNotEmpty || _userNotes.isNotEmpty) {
      final session = _saveSession();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LiveSessionReviewScreen(session: session),
        ),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  LiveSession _saveSession() {
    final session = LiveSession.create(
      transcript: _transcriptText,
      userNotes: _userNotes,
      duration: _sessionDuration ~/ 60, // Convert to minutes
      sessionType: SessionType.practice,
    );

    StorageService.saveLiveSession(session);
    
    // Update user activity and streak
    final user = StorageService.getCurrentUser();
    if (user != null) {
      // Calculate WPM from the session
      if (_userNotes.isNotEmpty && _sessionDuration > 0) {
        final words = _userNotes.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        final minutes = _sessionDuration / 60.0;
        final wpm = words / minutes;
        
        print('🔥 LIVE SESSION WPM: Words: $words, Minutes: $minutes, WPM: $wpm');
        
        // Update user's current WPM
        user.updateWPM(wpm);
        
        // Update user's average accuracy based on session score
        user.updateAccuracy(session.score);
        print('🔥 LIVE SESSION ACCURACY: ${session.score.toStringAsFixed(1)}%');
      }
      
      // Complete exercise and update streak
      user.completeExercise();
      StorageService.saveUser(user);
      // Notify state manager of user data update
      UserStateManager().updateUserData();
    }
    
    // Also save the user notes as a Note object so they appear in My Notes tab
    if (_userNotes.isNotEmpty) {
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Live Practice - ${_formatDuration(_sessionDuration)}',
        content: _userNotes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: 'Live Practice',
        tags: ['live-practice', 'session'],
      );
      StorageService.saveNote(note);
    }
    
    return session;
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'This app needs microphone access to transcribe speech for comparison with your notes. Please enable microphone access in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Live Practice'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isRecording)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing3,
                vertical: AppSpacing.spacing2,
              ),
              margin: const EdgeInsets.only(right: AppSpacing.spacing4),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                border: Border.all(
                  color: AppColors.errorRed,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.errorRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing2),
                  Text(
                    'REC',
                    style: AppTypography.footnote.copyWith(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing2),
                  Text(
                    _formatDuration(_sessionDuration),
                    style: AppTypography.footnote.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Live transcript area
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.spacing4),
              padding: const EdgeInsets.all(AppSpacing.spacing4),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                border: Border.all(
                  color: AppColors.backgroundTertiary,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Live Transcript',
                        style: AppTypography.headline,
                      ),
                      const Spacer(),
                      if (_transcriptText.isEmpty && !_isRecording)
                        Text(
                          'Start recording to see transcript',
                          style: AppTypography.footnote.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacing3),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _transcriptText.isEmpty 
                            ? (_isRecording ? 'Listening...' : 'No transcript yet')
                            : _transcriptText,
                        style: AppTypography.body.copyWith(
                          height: 1.5,
                          color: _transcriptText.isEmpty 
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: AppColors.backgroundTertiary,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
          ),

          // Notes input area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Notes',
                    style: AppTypography.headline,
                  ),
                  const SizedBox(height: AppSpacing.spacing2),
                  Expanded(
                    child: TextField(
                      controller: _notesController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTypography.body,
                      onChanged: (value) {
                        setState(() {
                          _userNotes = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Take notes as you listen to the speech...',
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
            ),
          ),

          // Control buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacing4),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isRecording ? AppColors.errorRed : AppColors.primaryPurple,
                      side: BorderSide(
                        color: _isRecording ? AppColors.errorRed : AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing3),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _endSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                    ),
                    child: const Text('End Session'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
