import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/user.dart';
import '../providers/in_app_purchase_provider.dart';

class PremiumPurchaseScreen extends StatefulWidget {
  const PremiumPurchaseScreen({super.key});

  @override
  State<PremiumPurchaseScreen> createState() => _PremiumPurchaseScreenState();
}

class _PremiumPurchaseScreenState extends State<PremiumPurchaseScreen> {
  User? _user;
  bool _isLoading = false;
  late InAppPurchaseProvider _purchaseProvider;

  @override
  void initState() {
    super.initState();
    _purchaseProvider = InAppPurchaseProvider();
    _loadUserData();
  }

  @override
  void dispose() {
    _purchaseProvider.dispose();
    super.dispose();
  }

  void _loadUserData() {
    setState(() {
      _user = StorageService.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = _user?.isPremium ?? false;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isPremium ? _buildPremiumActiveView() : _buildPurchaseView(),
    );
  }

  Widget _buildPremiumActiveView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      child: Column(
        children: [
          // Premium Active Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacing6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.successGreen, AppColors.successGreen.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.successGreen.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing4),
                const Text(
                  'Premium Active',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  'You have full access to all premium features',
                  style: AppTypography.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.spacing6),
          
          // Premium Features List
          _buildFeaturesList(),
          
          const SizedBox(height: AppSpacing.spacing6),
          
          // Restore Purchases Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacing5),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.textSecondary.withOpacity(0.2),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.infoBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.restore_rounded,
                        color: AppColors.infoBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restore Purchases',
                            style: AppTypography.callout.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Restore your previous premium purchases',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.spacing4),
                
                // Restore Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _handleRestorePurchases,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      backgroundColor: AppColors.backgroundSecondary,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.textPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_rounded,
                                color: AppColors.infoBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Restore Purchases',
                                style: AppTypography.buttonSecondary.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacing6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.infoBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing4),
                const Text(
                  'Go Premium',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  'Unlock all features and remove advertisements',
                  style: AppTypography.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.spacing6),
          
          // Features List
          _buildFeaturesList(),
          
          const SizedBox(height: AppSpacing.spacing6),
          
          // Purchase Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, size: 24),
                        const SizedBox(width: AppSpacing.spacing2),
                        Text(
                          'Upgrade to Premium - \$0.99',
                          style: AppTypography.buttonPrimary.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Restore Purchases Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _handleRestorePurchases,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(
                  color: AppColors.textSecondary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                backgroundColor: AppColors.backgroundSecondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restore,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Restore Purchases',
                    style: AppTypography.buttonSecondary.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.block,
        'title': 'Remove All Ads',
        'description': 'Enjoy an ad-free experience while training',
        'color': AppColors.errorRed,
      },
      {
        'icon': Icons.lock_open,
        'title': 'Unlock Premium Exercises',
        'description': 'Access advanced training exercises and content',
        'color': AppColors.primaryPurple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Premium Features',
          style: AppTypography.headline,
        ),
        const SizedBox(height: AppSpacing.spacing4),
        ...features.map((feature) => _buildFeatureItem(
          icon: feature['icon'] as IconData,
          title: feature['title'] as String,
          description: feature['description'] as String,
          color: feature['color'] as Color,
        )),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing3),
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.backgroundTertiary,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.callout.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Use the InAppPurchaseProvider to make the purchase
      await _purchaseProvider.buyNONConsumableInAppPurchase();
      
      // Listen for purchase completion
      _purchaseProvider.addListener(_onPurchaseUpdate);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase failed: ${e.toString()}'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onPurchaseUpdate() {
    if (_purchaseProvider.isPremiumMember) {
      setState(() {
        _isLoading = false;
      });
      
      // Update user premium status
      if (_user != null) {
        _user!.isPremium = true;
        StorageService.saveUser(_user!);
        _loadUserData();
      }
      
      // Remove listener
      _purchaseProvider.removeListener(_onPurchaseUpdate);
    }
  }

  void _handleRestorePurchases() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Use the InAppPurchaseProvider to restore purchases
      await _purchaseProvider.restorePurchases();
      
      // Wait a bit for the restore to complete
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Check if restore was successful
      if (_purchaseProvider.isPremiumMember) {
        // Update user premium status
        if (_user != null) {
          _user!.isPremium = true;
          StorageService.saveUser(_user!);
          _loadUserData();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Purchases restored successfully!'),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No previous purchases found to restore.'),
            backgroundColor: AppColors.backgroundSecondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Restore failed: ${e.toString()}'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


}
