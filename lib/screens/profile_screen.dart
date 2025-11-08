import 'package:flutter/material.dart';
import 'dart:io';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../services/user_state_manager.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver {
  final UserStateManager _userStateManager = UserStateManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userStateManager.loadUserData();
    _userStateManager.addListener(_onUserDataChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStateManager.updateUserData();
  }

  void _onUserDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh when app comes back to foreground
      _userStateManager.updateUserData();
    }
  }

  String _getUserLevelText() {
    final exercisesCompleted = _userStateManager.currentUser?.totalExercisesCompleted ?? 0;
    if (exercisesCompleted == 0) return 'Beginner';
    if (exercisesCompleted < 10) return 'Beginner';
    if (exercisesCompleted < 25) return 'Intermediate';
    if (exercisesCompleted < 50) return 'Advanced';
    if (exercisesCompleted < 100) return 'Expert';
    return 'Master';
  }





  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Perform logout
      await StorageService.logout();
      
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    // Show beautiful warning dialog with excellent UX
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundSecondary,
                AppColors.backgroundSecondary.withOpacity(0.95),
              ],
            ),
            border: Border.all(
              color: AppColors.errorRed.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon with Animation
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.errorRed.withOpacity(0.2),
                      AppColors.errorRed.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 40,
                  color: AppColors.errorRed,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Delete Account?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Warning Message
              Text(
                'This action cannot be undone!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                'All your data, progress, and settings will be permanently deleted. You will lose access to all your notes, exercises, and achievements.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: AppColors.errorRed.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldDelete == true) {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Perform account deletion
      await _performAccountDeletion();
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }


  Future<void> _performAccountDeletion() async {
    try {
      // Get current user ID before deletion
      final userId = _userStateManager.currentUserAuth?.id;
      
      // Delete user authentication data
      if (userId != null) {
        await StorageService.deleteUserAuth(userId);
      }
      
      // Delete user profile data
      await StorageService.deleteUser();
      
      // Delete all user notes
      await StorageService.clearAllNotes();
      
      // Delete all user progress
      await StorageService.clearAllUserProgress();
      
      // Delete all user's custom abbreviations
      await StorageService.clearUserAbbreviations();
      
      // Delete all live sessions
      await StorageService.clearAllLiveSessions();
      
      print('DEBUG: Account deleted successfully');
    } catch (e) {
      print('ERROR: Failed to delete account: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: ProfileScreen build() called');
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: RefreshIndicator(
        onRefresh: () async {
          _userStateManager.updateUserData();
        },
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Profile Header
            _buildSliverAppBar(),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spacing4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.spacing4),
                    
                    // User Stats
                    _buildUserStats(),
                    
                    const SizedBox(height: AppSpacing.spacing6),
                    
                    // Settings Section
                    _buildSettingsSection(),
                    
                    const SizedBox(height: AppSpacing.spacing4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userStateManager.removeListener(_onUserDataChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.backgroundPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurple.withOpacity(0.3),
                AppColors.backgroundPrimary.withOpacity(0.5),
                AppColors.backgroundPrimary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.spacing8),
                
                // Profile Picture
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _userStateManager.currentUser?.isGuest != true ? () async {
                        // Navigate to edit profile
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        
                        // Reload user data if changes were saved
                        if (result == true) {
                          _userStateManager.updateUserData();
                        }
                      } : null,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.infoBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPurple.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 4,
                          ),
                        ),
                        child: _userStateManager.currentUserAuth != null && _userStateManager.currentUserAuth!.profilePicturePath != null
                            ? ClipOval(
                                child: Image.file(
                                  File(_userStateManager.currentUserAuth!.profilePicturePath!),
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildInitialsAvatar(120);
                                  },
                                ),
                              )
                            : _buildInitialsAvatar(120),
                      ),
                    ),
                    
                    // Edit Button (only for non-guest users)
                    if (_userStateManager.currentUser?.isGuest != true)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            // Navigate to edit profile
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                            
                            // Reload user data if changes were saved
                            if (result == true) {
                              _userStateManager.updateUserData();
                            }
                          },
                          child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primaryPurple, AppColors.infoBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.backgroundPrimary,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.spacing4),
                
                // User Name
                Text(
                  _userStateManager.currentUser?.isGuest == true 
                      ? 'Guest User'
                      : (_userStateManager.currentUserAuth?.fullName ?? 'User'),
                  style: AppTypography.title2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.spacing1),
                
                // Email
                Text(
                  _userStateManager.currentUser?.isGuest == true 
                      ? 'Using without account' 
                      : (_userStateManager.currentUserAuth?.email ?? 'email@example.com'),
                  style: AppTypography.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.spacing3),
                
                // Level Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacing4,
                    vertical: AppSpacing.spacing2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getUserLevelText(),
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(double size) {
    // Show guest icon for guest users
    if (_userStateManager.currentUser?.isGuest == true) {
      return Center(
        child: Icon(
          Icons.person_outline,
          color: Colors.white,
          size: size * 0.5,
        ),
      );
    }
    
    return Center(
      child: Text(
        _userStateManager.currentUserAuth?.initials ?? 'U',
        style: AppTypography.largeTitle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing6),
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
          Text(
            'Your Progress',
            style: AppTypography.headline.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  title: 'Current WPM',
                  value: '${(_userStateManager.currentUser?.currentWPM ?? 0).toStringAsFixed(1)}',
                  icon: Icons.speed,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: _buildStatItem(
                  title: 'Baseline WPM',
                  value: '${(_userStateManager.currentUser?.baselineWPM ?? 0).toStringAsFixed(1)}',
                  icon: Icons.trending_up,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  title: 'Streak',
                  value: '${_userStateManager.currentUser?.streakDays ?? 0} days',
                  icon: Icons.local_fire_department,
                  color: AppColors.warningAmber,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: _buildStatItem(
                  title: 'Level',
                  value: _getUserLevelText(),
                  icon: Icons.star,
                  color: AppColors.infoBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            value,
            style: AppTypography.title3.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing1),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upgrade to Account Card (for guest users only)
        if (_userStateManager.currentUser?.isGuest == true) ...[
          _buildUpgradeCard(),
          const SizedBox(height: AppSpacing.spacing4),
        ],
        
        // Upgrade to Premium Card (for non-premium users)
        if (!(_userStateManager.currentUser?.isPremium ?? false))
          _buildSettingsCard(
            icon: Icons.star_rounded,
            title: 'Upgrade to Premium',
            subtitle: 'Remove ads and unlock premium features',
            gradient: LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.infoBlue],
            ),
            onTap: _handlePremiumPurchase,
          ),
        
        if (!(_userStateManager.currentUser?.isPremium ?? false))
          const SizedBox(height: AppSpacing.spacing4),
        
        // Restore Purchases Card (for all users)
        _buildSettingsCard(
          icon: Icons.restore_rounded,
          title: 'Restore Purchases',
          subtitle: 'Restore your previous premium purchases',
          gradient: LinearGradient(
            colors: [AppColors.infoBlue, AppColors.successGreen],
          ),
          onTap: _handleRestorePurchases,
        ),
        
        const SizedBox(height: AppSpacing.spacing4),
        
        // Logout Card
        _buildSettingsCard(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          gradient: LinearGradient(
            colors: [AppColors.errorRed, Colors.red.shade400],
          ),
          onTap: _handleLogout,
          isDestructive: true,
        ),
        
        const SizedBox(height: AppSpacing.spacing4),
        
        // Delete Account Card
        _buildSettingsCard(
          icon: Icons.delete_forever_rounded,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account and all data',
          gradient: LinearGradient(
            colors: [Colors.red.shade900, AppColors.errorRed],
          ),
          onTap: _handleDeleteAccount,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildUpgradeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF667eea), // Blue-purple
            Color(0xFF764ba2), // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You\'re using as Guest',
                      style: AppTypography.title3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create an account to secure your progress',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Benefits list
          _buildBenefitItem('Secure your progress with an account'),
          _buildBenefitItem('Sync across devices (future feature)'),
          _buildBenefitItem('Never lose your notes and achievements'),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Upgrade Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _handleUpgradeToAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.rocket_launch_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Create Account',
                    style: AppTypography.buttonPrimary.copyWith(
                      color: const Color(0xFF667eea),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: Colors.white.withOpacity(0.95),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpgradeToAccount() {
    // Navigate to signup screen
    Navigator.of(context).pushNamed('/signup');
  }



  void _handlePremiumPurchase() {
    // Navigate to premium purchase screen
    Navigator.of(context).pushNamed('/premium');
  }

  void _handleRestorePurchases() {
    // Navigate to premium purchase screen for restore functionality
    Navigator.of(context).pushNamed('/premium');
  }


  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.backgroundTertiary.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundPrimary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing4),
            child: Row(
              children: [
                // Icon with Gradient Background
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                
                const SizedBox(width: AppSpacing.spacing4),
                
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.callout.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing1),
                      Text(
                        subtitle,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundTertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textTertiary,
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
