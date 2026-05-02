import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Color
  static const Color primary = Color(0xFF5F9EA0);

  // Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6FA5A8), // Top
      Color(0xFFE4F1F2), // Bottom
    ],
  );

  // Background Solid Color
  static const Color background = Color(0xFFE4F1F2);

  // Text Colors
  static const Color textDark = Color(0xFF222222);
  static const Color textLight = Color(0xFF888888);

  // Card Background
  static const Color cardBackground = Color(0xFFF5F5F5);

  // White
  static const Color white = Colors.white;
}