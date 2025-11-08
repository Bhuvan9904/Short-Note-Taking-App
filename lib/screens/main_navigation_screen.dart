import 'package:flutter/material.dart';
// Removed Practice screen
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';
import 'notes_screen.dart';
import 'learning_hub_screen.dart';
import 'profile_screen.dart';
// import 'new_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final ValueNotifier<int> _homeRefreshNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _learningHubRefreshNotifier = ValueNotifier<int>(0);

  List<Widget> get _screens => [
    HomeScreen(refreshNotifier: _homeRefreshNotifier),
    const NotesScreen(),
    LearningHubScreen(refreshNotifier: _learningHubRefreshNotifier),
    const ProfileScreen(),
    // const NewScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _updateDailyStreak();
  }

  void _updateDailyStreak() async {
    // Update daily streak when app starts
    await StorageService.updateDailyStreak();
    
    // Notify home screen to refresh after streak update
    if (mounted) {
      _homeRefreshNotifier.value++;
    }
  }

  @override
  void dispose() {
    _homeRefreshNotifier.dispose();
    _learningHubRefreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          print('DEBUG: Navigation tapped - Index: $index');
          setState(() {
            _currentIndex = index;
          });
          // Refresh screens when switching to them
          if (index == 0) {
            // Home screen
            _homeRefreshNotifier.value++;
          } else if (index == 2) {
            // Learning Hub screen
            _learningHubRefreshNotifier.value++;
          }
        },
        backgroundColor: AppColors.backgroundSecondary,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTypography.footnote.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.footnote,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined),
            activeIcon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
