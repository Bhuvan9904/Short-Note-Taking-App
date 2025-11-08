import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/user_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  
  UserAuth? _userAuth;
  File? _selectedImage;
  String? _currentImagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _userAuth = StorageService.getCurrentUserAuth();
    if (_userAuth != null) {
      _fullNameController.text = _userAuth!.fullName;
      _currentImagePath = _userAuth!.profilePicturePath;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing6),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.spacing4),
              
              // Profile Picture Section
              _buildProfilePictureSection(),
              
              const SizedBox(height: AppSpacing.spacing8),
              
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
              
              // Email Field (Read-only)
              _buildReadOnlyField(
                label: 'Email',
                value: _userAuth?.email ?? '',
                icon: Icons.email_outlined,
              ),
              
              const SizedBox(height: AppSpacing.spacing8),
              
              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    final displayImage = _selectedImage ?? (_currentImagePath != null ? File(_currentImagePath!) : null);
    
    return Column(
      children: [
        Stack(
          children: [
            // Profile Picture Container
            GestureDetector(
              onTap: _selectProfilePicture,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: displayImage == null
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
                child: displayImage != null
                    ? ClipOval(
                        child: Image.file(
                          displayImage,
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildInitialsPlaceholder();
                          },
                        ),
                      )
                    : _buildInitialsPlaceholder(),
              ),
            ),
            
            // Camera Button Overlay
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _selectProfilePicture,
                child: Container(
                  width: 44,
                  height: 44,
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
                    Icons.camera_alt_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.spacing3),
        
        Text(
          'Tap to change photo',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialsPlaceholder() {
    return Center(
      child: Text(
        _userAuth?.initials ?? 'U',
        style: AppTypography.largeTitle.copyWith(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.bold,
          fontSize: 56,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.backgroundTertiary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.textTertiary.withOpacity(0.1),
                  AppColors.textTertiary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.textTertiary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
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
        onPressed: _isLoading ? null : _handleSave,
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
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Save Changes',
                    style: AppTypography.buttonPrimary.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _selectProfilePicture() async {
    // Show dialog to choose between camera and gallery
    final dynamic source = await showDialog<dynamic>(
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
              
              if (_currentImagePath != null || _selectedImage != null) ...[
                const SizedBox(height: AppSpacing.spacing2),
                
                // Remove Photo Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.errorRed.withOpacity(0.1),
                          AppColors.errorRed.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.errorRed,
                    ),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: AppTypography.body.copyWith(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Use initials instead',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop('remove'),
                ),
              ],
            ],
          ),
        );
      },
    );

    if (source == null) return;

    // Handle remove photo option
    if (source == 'remove') {
      setState(() {
        _selectedImage = null;
        _currentImagePath = null;
      });
      return;
    }

    // Handle camera and gallery options
    if (source is ImageSource) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${source == ImageSource.camera ? 'take photo' : 'select image'}. Please try again.'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_userAuth != null) {
        // Update user data
        _userAuth!.fullName = _fullNameController.text.trim();
        
        // Update profile picture path
        if (_selectedImage != null) {
          _userAuth!.profilePicturePath = _selectedImage!.path;
        } else if (_currentImagePath == null) {
          // User removed the photo
          _userAuth!.profilePicturePath = null;
        }

        // Save to storage
        await StorageService.saveUserAuth(_userAuth!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.successGreen,
            ),
          );

          // Navigate back to profile
          Navigator.of(context).pop(true); // Pass true to indicate changes were saved
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
