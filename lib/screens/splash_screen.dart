import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/storage_service.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Debug: Check user_auth box status
    print('DEBUG: SplashScreen - Checking user status');
    StorageService.debugUserAuthBox();
    
    // Check if user is already logged in
    final isLoggedIn = StorageService.isUserLoggedIn();
    print('DEBUG: SplashScreen - Is user logged in: $isLoggedIn');
    
    if (isLoggedIn) {
      // User is logged in - go directly to main app
      print('DEBUG: SplashScreen - Navigating to main app');
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      // User is not logged in - check if this is first launch
      final isFirstLaunch = await StorageService.isFirstLaunch();
      print('DEBUG: SplashScreen - Is first launch: $isFirstLaunch');
      
      if (isFirstLaunch) {
        // First launch - show onboarding
        print('DEBUG: SplashScreen - Navigating to onboarding');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        // Not first launch but not logged in - show login screen
        print('DEBUG: SplashScreen - Navigating to login');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF4F46E5),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.speed,
                size: 60,
                color: Colors.white,
              ),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .then()
                .shimmer(
                  duration: 1000.ms,
                  color: Colors.white.withOpacity(0.3),
                ),

            const SizedBox(height: 32),

            // App Title
            const Text(
              'Short Notes Trainer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                .animate()
                .fadeIn(
                  delay: 300.ms,
                  duration: 600.ms,
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Master speed note-taking through abbreviations',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
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

            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              strokeWidth: 2,
            )
                .animate()
                .fadeIn(
                  delay: 900.ms,
                  duration: 400.ms,
                ),
          ],
        ),
      ),
    );
  }
}
