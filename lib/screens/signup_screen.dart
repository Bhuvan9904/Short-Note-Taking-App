import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/user_auth.dart';
import '../models/user.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
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
              const SizedBox(height: AppSpacing.spacing4),
              
              // Header
              _buildHeader(),
              
              const SizedBox(height: AppSpacing.spacing8),
              
              // Profile Picture Selection
              _buildProfilePictureSection(),
              
              const SizedBox(height: AppSpacing.spacing8),
              
              // Sign Up Form
              _buildSignUpForm(),
              
              const SizedBox(height: AppSpacing.spacing6),
              
              // Login Link
              _buildLoginLink(),
              
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
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primaryPurple,
                AppColors.infoBlue,
                AppColors.successGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.speed,
            color: Colors.white,
            size: 50,
          ),
        ),
        
        const SizedBox(height: AppSpacing.spacing6),
        
        // Welcome Text
        Text(
          'Create Account',
          style: AppTypography.largeTitle.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.spacing2),
        
        // Subtitle
        Text(
          'Join us and master speed note-taking',
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Stack(
          children: [
            // Profile Picture Container
            GestureDetector(
              onTap: _selectProfilePicture,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _selectedImage == null
                      ? LinearGradient(
                          colors: [
                            AppColors.primaryPurple.withOpacity(0.15),
                            AppColors.infoBlue.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  border: Border.all(
                    color: AppColors.primaryPurple.withOpacity(0.3),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: 130,
                          height: 130,
                        ),
                      )
                    : const Icon(
                        Icons.person_outline,
                        size: 60,
                        color: AppColors.primaryPurple,
                      ),
              ),
            ),
            
            // Camera Button Overlay
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _selectProfilePicture,
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.spacing3),
        
        Text(
          _selectedImage != null ? 'Tap to change' : 'Add your photo',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name Field
          _buildTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              if (!UserAuth.isValidFullName(value)) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
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
            hint: 'Create a strong password',
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
                return 'Please enter a password';
              }
              if (!UserAuth.isValidPassword(value)) {
                return 'Password must be at least 6 characters with letters and numbers';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppSpacing.spacing4),
          
          // Confirm Password Field
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            icon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textTertiary,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppSpacing.spacing8),
          
          // Sign Up Button
          Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryPurple,
                  AppColors.infoBlue,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
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
                        Text(
                          'Create Account',
                          style: AppTypography.buttonPrimary.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
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
                  AppColors.primaryPurple.withOpacity(0.1),
                  AppColors.infoBlue.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 20),
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
            borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
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

  Widget _buildLoginLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?  ',
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
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
                    AppColors.primaryPurple.withOpacity(0.1),
                    AppColors.infoBlue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Text(
                'Sign In',
                style: AppTypography.body.copyWith(
                  color: AppColors.primaryPurple,
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if email already exists
      final existingUser = await StorageService.getUserByEmail(_emailController.text);
      if (existingUser != null) {
        _showErrorSnackBar('Email already exists. Please use a different email.');
        return;
      }

      // Create new user
      final userAuth = UserAuth.create(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        profilePicturePath: _selectedImage?.path,
      );

      // Debug: Print what we're saving
      print('DEBUG: SignUp - Creating user with:');
      print('DEBUG: SignUp - Full Name: ${_fullNameController.text}');
      print('DEBUG: SignUp - Email: ${_emailController.text}');
      print('DEBUG: SignUp - UserAuth created: ${userAuth.toString()}');

      // Save user to storage
      await StorageService.saveUserAuth(userAuth);
      
      // Set as current user
      await StorageService.setCurrentUserAuth(userAuth);
      
      // Create corresponding User object for progress tracking
      final user = User.createNew();
      await StorageService.saveUser(user);
      print('DEBUG: SignUp - Created User object for progress tracking');
      
      // Debug: Verify what was saved
      final savedUser = StorageService.getCurrentUserAuth();
      print('DEBUG: SignUp - Saved user retrieved: ${savedUser?.toString()}');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully! Welcome ${userAuth.displayName}!'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to create account. Please try again.');
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

  Future<void> _selectProfilePicture() async {
    // Show dialog to choose between camera and gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          title: Text(
            'Choose Photo Source',
            style: AppTypography.title3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Camera Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryPurple.withOpacity(0.1),
                        AppColors.infoBlue.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primaryPurple,
                  ),
                ),
                title: Text(
                  'Camera',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Take a new photo',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              
              const SizedBox(height: AppSpacing.spacing2),
              
              // Gallery Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.successGreen.withOpacity(0.1),
                        AppColors.infoBlue.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppColors.successGreen,
                  ),
                ),
                title: Text(
                  'Gallery',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Choose from gallery',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to ${source == ImageSource.camera ? 'take photo' : 'select image'}. Please try again.');
    }
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
        onPressed: _isLoading ? null : _handleGuestSignup,
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

  Future<void> _handleGuestSignup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create guest user
      await StorageService.createGuestUser();
      
      print('DEBUG: Guest user signup successful');

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
      print('ERROR: Guest signup failed: $e');
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
              'Sign up with Apple',
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created successfully! Welcome $fullName!'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      } else {
        // User exists, log them in
        await StorageService.setCurrentUserAuth(existingUser);
        print('DEBUG: Apple Sign In - Existing user logged in: ${existingUser.fullName}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${existingUser.displayName}!'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      }

      // Navigate to main app
      if (mounted) {
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
