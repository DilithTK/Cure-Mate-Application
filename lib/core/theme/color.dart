import 'package:flutter/material.dart';

class AppColors {
  /// Main Brand Colors
  static const Color primary = Color(0xFF5F9EA0);

  static const Color primaryDark = Color(0xFF4B7C7E);

  static const Color secondary = Color(0xFFE4F1F2);

  /// Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF6FA5A8), Color(0xFFE4F1F2)],
  );
  

  /// Background Colors
  static const Color background = Color(0xFFF4F7F8);

  static const Color scaffold = Color(0xFFF7FAFB);

  /// Text Colors
  static const Color textDark = Color(0xFF222222);

  static const Color textMedium = Color(0xFF555555);

  static const Color textLight = Color(0xFF888888);

  /// Card Colors
  static const Color cardBackground = Colors.white;

  static const Color cardBorder = Color(0xFFE3E8EA);

  /// Common Colors
  static const Color white = Colors.white;

  static const Color black = Colors.black;

  /// Status Colors
  static const Color success = Color(0xFF22C55E);

  static const Color successLight = Color(0xFFDFF7E8);

  static const Color warning = Color(0xFFF59E0B);

  static const Color warningLight = Color(0xFFFFF4DB);

  static const Color danger = Color(0xFFEF4444);

  static const Color dangerLight = Color(0xFFFDE2E2);

  static const Color info = Color(0xFF3B82F6);

  /// Shadow
  static const Color shadow = Color(0x14000000);

  /// Prescription Status Colors
  static const Color pending = Color(0xFFF59E0B);

  static const Color completed = Color(0xFF22C55E);

  static const Color unavailable = Color(0xFFEF4444);

  /// Radio Button Colors
  static const Color availableRadio = Color(0xFF22C55E);

  static const Color unavailableRadio = Color(0xFFEF4444);

  /// Button Gradients
  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [Color(0xFF5F9EA0), Color(0xFF6FA5A8)],
  );

  /// Input Field
  static const Color inputFill = Colors.white;

  static const Color inputBorder = Color(0xFFD6E0E1);
}
