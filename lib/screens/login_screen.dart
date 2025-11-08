import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/user_auth.dart';
import '../models/user.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing6,
            vertical: AppSpacing.spacing4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.spacing8),
              
              // Header
              _buildHeader(),
              
              const SizedBox(height: AppSpacing.spacing10),
              
              // Login Form
              _buildLoginForm(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Sign Up Link
              _buildSignUpLink(),
              
              const SizedBox(height: AppSpacing.spacing4),
              
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.backgroundTertiary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                    child: Text(
                      'OR',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.backgroundTertiary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.spacing4),
              
              // Apple Sign In Button (visible on all platforms, but only works on iOS)
              _buildAppleSignInButton(),
              const SizedBox(height: AppSpacing.spacing3),
              
              // Continue as Guest Button
              _buildGuestButton(),
              
              const SizedBox(height: AppSpacing.spacing4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Logo/Icon with gradient background
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.successGreen,
                AppColors.infoBlue,
                AppColors.primaryPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.successGreen.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.speed,
            color: Colors.white,
            size: 55,
          ),
        ),
        
        const SizedBox(height: AppSpacing.spacing8),
        
        // Welcome Text with animation feel
        Text(
          'Welcome Back!',
          style: AppTypography.largeTitle.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 34,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.spacing2),
        
        // Subtitle
        Text(
          'Continue your note-taking journey',
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!UserAuth.isValidEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Password Field
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textTertiary,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppSpacing.spacing6),
          
          // Login Button
          Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.successGreen,
                  AppColors.infoBlue,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.successGreen.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.login_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sign In',
                          style: AppTypography.buttonPrimary.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundPrimary.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: AppTypography.body.copyWith(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.successGreen.withOpacity(0.1),
                  AppColors.infoBlue.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.successGreen, size: 20),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            borderSide: BorderSide(
              color: AppColors.backgroundTertiary.withOpacity(0.5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            borderSide: const BorderSide(color: AppColors.successGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          ),
          filled: true,
          fillColor: AppColors.backgroundSecondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing4,
            vertical: AppSpacing.spacing4,
          ),
          labelStyle: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          hintStyle: AppTypography.body.copyWith(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
          errorStyle: AppTypography.caption.copyWith(
            color: AppColors.errorRed,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?  ",
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing3,
                vertical: AppSpacing.spacing1,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.successGreen.withOpacity(0.1),
                    AppColors.infoBlue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Text(
                'Sign Up',
                style: AppTypography.body.copyWith(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Debug: Print what we're looking for
      print('DEBUG: Login - Looking for email: ${_emailController.text}');
      
      // Debug: Check user_auth box status
      StorageService.debugUserAuthBox();
      
      // Find user by email
      final userAuth = await StorageService.getUserByEmail(_emailController.text);
      
      print('DEBUG: Login - Found user: $userAuth');
      
      if (userAuth == null) {
        print('DEBUG: Login - No user found with email: ${_emailController.text}');
        _showErrorSnackBar('No account found with this email address.');
        return;
      }

      // Verify password
      if (userAuth.password != _passwordController.text) {
        _showErrorSnackBar('Incorrect password. Please try again.');
        return;
      }

      // Update login status
      userAuth.updateLoginStatus(true);
      await StorageService.saveUserAuth(userAuth);
      await StorageService.setCurrentUserAuth(userAuth);

      // Ensure User object exists for progress tracking
      final currentUser = StorageService.getCurrentUser();
      if (currentUser == null) {
        final user = User.createNew();
        await StorageService.saveUser(user);
        print('DEBUG: Login - Created User object for existing user');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${userAuth.displayName}!'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      _showErrorSnackBar('Login failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  Widget _buildGuestButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleGuestLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundSecondary,
          foregroundColor: AppColors.textPrimary,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Continue as Guest',
              style: AppTypography.buttonPrimary.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGuestLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create guest user
      await StorageService.createGuestUser();
      
      print('DEBUG: Guest user login successful');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome! You\'re using the app as a guest.'),
            backgroundColor: AppColors.successGreen,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      print('ERROR: Guest login failed: $e');
      _showErrorSnackBar('Failed to continue as guest. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildAppleSignInButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleAppleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.apple,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Sign in with Apple',
              style: AppTypography.buttonPrimary.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAppleSignIn() async {
    // Check if running on non-iOS platform
    if (!Platform.isIOS) {
      _showErrorSnackBar('Apple Sign In is only available on iOS devices. Please use Email/Password or Guest mode.');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Request Apple Sign In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.yourcompany.shortnoteapp1.service',
          redirectUri: Uri.parse('https://your-app.com/callbacks/sign_in_with_apple'),
        ),
      );

      print('DEBUG: Apple Sign In - Received credential');
      print('DEBUG: Apple Sign In - User ID: ${credential.userIdentifier}');
      print('DEBUG: Apple Sign In - Email: ${credential.email}');
      print('DEBUG: Apple Sign In - Given Name: ${credential.givenName}');
      print('DEBUG: Apple Sign In - Family Name: ${credential.familyName}');

      // Extract user information
      final String appleUserId = credential.userIdentifier ?? '';
      final String? email = credential.email;
      final String? givenName = credential.givenName;
      final String? familyName = credential.familyName;

      // Build full name
      String fullName = 'Apple User';
      if (givenName != null || familyName != null) {
        fullName = '${givenName ?? ''} ${familyName ?? ''}'.trim();
      }

      // Use Apple user ID as email if email is hidden
      final String userEmail = email ?? '$appleUserId@privaterelay.appleid.com';

      // Check if user already exists
      UserAuth? existingUser = await StorageService.getUserByEmail(userEmail);

      if (existingUser == null) {
        // Create new user with Apple credentials
        final userAuth = UserAuth.create(
          email: userEmail,
          password: appleUserId, // Use Apple ID as password (they won't use it)
          fullName: fullName,
          profilePicturePath: null, // No profile picture from Apple
        );

        await StorageService.saveUserAuth(userAuth);
        await StorageService.setCurrentUserAuth(userAuth);

        // Create corresponding User object for progress tracking
        final user = User.createNew();
        await StorageService.saveUser(user);
        print('DEBUG: Apple Sign In - Created User object for progress tracking');

        print('DEBUG: Apple Sign In - New user created: $fullName');
      } else {
        // User exists, log them in
        await StorageService.setCurrentUserAuth(existingUser);
        
        // Ensure User object exists for progress tracking
        final currentUser = StorageService.getCurrentUser();
        if (currentUser == null) {
          final user = User.createNew();
          await StorageService.saveUser(user);
          print('DEBUG: Apple Sign In - Created User object for existing user');
        }
        
        print('DEBUG: Apple Sign In - Existing user logged in: ${existingUser.fullName}');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome${fullName.isNotEmpty ? ', $fullName' : ''}!'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      print('ERROR: Apple Sign In failed: $e');
      
      // Handle specific errors
      if (e.toString().contains('AuthorizationErrorCode.canceled')) {
        // User canceled - don't show error
        print('DEBUG: User canceled Apple Sign In');
      } else if (e.toString().contains('AuthorizationErrorCode.unknown')) {
        _showErrorSnackBar('Apple Sign In is not available on this device.');
      } else {
        _showErrorSnackBar('Apple Sign In failed. Please try again or use email/password.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
