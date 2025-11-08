import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6366F1);
  static const Color darkPurple = Color(0xFF4F46E5);

  // Background Hierarchy
  static const Color backgroundPrimary = Color(0xFF0F0F0F);
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color backgroundTertiary = Color(0xFF2A2A2A);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA3A3A3);
  static const Color textTertiary = Color(0xFF737373);

  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, darkPurple],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundPrimary, backgroundSecondary],
  );

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color getScoreColor(double score) {
    if (score >= 80) return successGreen;
    if (score >= 60) return warningAmber;
    return errorRed;
  }

  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return successGreen;
      case 'intermediate':
        return warningAmber;
      case 'advanced':
        return errorRed;
      default:
        return textSecondary;
    }
  }
}

