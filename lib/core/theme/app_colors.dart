import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF00838F);
  static const Color secondary = Color(0xFFD4AF37);
  static const Color accent = Color(0xFF00B8D4);
  static const Color darkTeal = Color(0xFF006064);

  // Light Mode
  static const Color background = Color(0xFFF8F9FA);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF212121);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color shadowColor = Color(0x1A000000);
  static const Color cardLight = Colors.white;

  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF3A3A3A);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);

  // Semantic Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);
  static const Color info = Color(0xFF1976D2);

  // Chart Colors
  static const Color chartBlue = Color(0xFF42A5F5);
  static const Color chartOrange = Color(0xFFFFA726);
  static const Color chartGreen = Color(0xFF66BB6A);
  static const Color chartPurple = Color(0xFFAB47BC);
  static const Color chartRed = Color(0xFFEF5350);
  static const Color chartTeal = Color(0xFF26A69A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, darkTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, primary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient appGradient = LinearGradient(
    colors: [primary, darkTeal],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF1A4D4E), Color(0xFF607D8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldenGradient = LinearGradient(
    colors: [
      Color(0xFFBD7C31),
      Color(0xFFF2A13D),
      Color(0xFFBD7C31),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Missing Colors for Attendance Screen
  static const Color darkBg = darkBackground;
  static const Color darkText = darkTextPrimary;
  static const Color darkBorder = darkDivider;
  static const Color darkMuted = darkTextSecondary;
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color danger = error;
  static const Color dangerLight = Color(0xFFFFEBEE);
  static const Color warningLight = Color(0xFFFFF8E1);
}
