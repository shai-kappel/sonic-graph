import 'dart:ui';

abstract final class AppColors {
  // Canvas
  static const canvasBackground = Color(0xFF0A0E27);
  static const canvasBackgroundLight = Color(0xFF111638);

  // Glassmorphic surfaces
  static const surfaceGlass = Color(0x14FFFFFF);       // white 8%
  static const surfaceGlassHover = Color(0x1FFFFFFF);  // white 12%
  static const borderGlass = Color(0x26FFFFFF);         // white 15%
  static const borderGlassSubtle = Color(0x0DFFFFFF);  // white 5%

  // Accents
  static const accentPrimary = Color(0xFF6C63FF);
  static const accentGlow = Color(0xFF00D4FF);
  static const accentWarm = Color(0xFFFF6B6B);

  // Text
  static const textPrimary = Color(0xFFE8EAED);
  static const textSecondary = Color(0xFF9AA0A6);
  static const textMuted = Color(0xFF5F6368);

  // Shadows
  static const shadowDeep = Color(0x66000000);
  static const shadowMedium = Color(0x330A0E27);
}
