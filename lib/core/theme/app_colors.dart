// Core color constants for SilentGuard+
import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryPurple = Color(0xFF7B5EA7);
  static const Color primaryDeepPurple = Color(0xFF5C35A0);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF7B5EA7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF3A7BD5), Color(0xFF6B46C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status colors
  static const Color activeGreen = Color(0xFF4CAF50);
  static const Color inactiveGrey = Color(0xFF9E9E9E);
  static const Color silentRed = Color(0xFFE53935);
  static const Color vibrateOrange = Color(0xFFFF6F00);
  static const Color normalBlue = Color(0xFF1E88E5);

  // Surface colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E2E);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF1A1A2E);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
}
