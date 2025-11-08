import 'package:flutter/material.dart';

class AppTypography {
  // Large Title - 34pt
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  // Title 1 - 28pt
  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Title 2 - 22pt
  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Title 3 - 20pt
  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Headline - 17pt
  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Body - 17pt
  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Callout - 16pt
  static const TextStyle callout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Subheadline - 15pt
  static const TextStyle subheadline = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Footnote - 13pt
  static const TextStyle footnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // Caption - 12pt
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // Button text styles
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  // Special styles
  static const TextStyle scoreDisplay = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    height: 1.0,
  );

  static const TextStyle timerDisplay = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
    height: 1.0,
  );

  // Helper method to apply color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}

