import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPurple,
        secondary: AppColors.darkPurple,
        surface: AppColors.backgroundSecondary,
        background: AppColors.backgroundPrimary,
        error: AppColors.errorRed,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.backgroundPrimary,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.title2,
        centerTitle: false,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.largeTitle,
        displayMedium: AppTypography.title1,
        displaySmall: AppTypography.title2,
        headlineLarge: AppTypography.title3,
        headlineMedium: AppTypography.headline,
        headlineSmall: AppTypography.subheadline,
        titleLarge: AppTypography.title3,
        titleMedium: AppTypography.headline,
        titleSmall: AppTypography.subheadline,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.callout,
        bodySmall: AppTypography.footnote,
        labelLarge: AppTypography.callout,
        labelMedium: AppTypography.footnote,
        labelSmall: AppTypography.caption,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.backgroundSecondary,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        margin: const EdgeInsets.all(AppSpacing.spacing2),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.textPrimary,
          elevation: 8,
          shadowColor: AppColors.primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightLarge),
          textStyle: AppTypography.buttonPrimary,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          side: BorderSide(
            color: AppColors.primaryPurple.withOpacity(0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMedium),
          textStyle: AppTypography.buttonSecondary,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          textStyle: AppTypography.buttonSecondary,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.spacing4),
        hintStyle: AppTypography.body.copyWith(
          color: AppColors.textTertiary,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.backgroundTertiary,
        thickness: 1,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppSpacing.iconMedium,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundSecondary,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.textPrimary,
        elevation: 8,
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryPurple,
        linearTrackColor: AppColors.backgroundTertiary,
        circularTrackColor: AppColors.backgroundTertiary,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryPurple;
          }
          return AppColors.textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryPurple.withOpacity(0.3);
          }
          return AppColors.backgroundTertiary;
        }),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryPurple,
        inactiveTrackColor: AppColors.backgroundTertiary,
        thumbColor: AppColors.primaryPurple,
        overlayColor: AppColors.primaryPurple.withOpacity(0.2),
        valueIndicatorColor: AppColors.primaryPurple,
        valueIndicatorTextStyle: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
