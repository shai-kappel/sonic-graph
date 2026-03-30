import 'dart:ui';

abstract final class AppColors {
  // Nebula Ethereal Base Palette
  static const background = Color(0xFF0A0E1A); // Deep Midnight
  static const surface = Color(0xFF0A0E1A);
  static const surfaceContainer = Color(0xFF141928);
  static const surfaceContainerLow = Color(0xFF0E1320);
  static const surfaceContainerHigh = Color(0xFF1A1F2F);
  static const surfaceContainerHighest = Color(0xFF202537);
  static const surfaceVariant = Color(0xFF202537);

  // Accents (Neon Nebula)
  static const primary = Color(0xFF81ECFF); // Nebula Cyan
  static const primaryDim = Color(0xFF00D4EC);
  static const primaryContainer = Color(0xFF00E3FD);
  static const secondary = Color(0xFFDFE2F3); // Ethereal Blue
  static const tertiary = Color(0xFFAC89FF); // Stellar Purple

  // Opacities & Glass
  static const glassOpacity = 0.40;
  static const glassBlur = 24.0;
  static const ghostBorderOpacity = 0.15;

  // Semantic
  static const error = Color(0xFFFF716C);
  static const onBackground = Color(0xFFE2E4F6);
  static const onSurface = Color(0xFFE2E4F6);
  static const onPrimary = Color(0xFF005762);
  static const outlineVariant = Color(0xFF444756);

  // Shadows & Glows
  static const shadowGlow = Color(0x1481ECFF); // Primary at 8% for ambient glow
  static const shadowDeep = Color(0x66000000);
}
