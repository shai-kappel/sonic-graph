import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static bool isTest = false;

  // Headlines: Space Grotesk
  static TextStyle get headlineLarge => isTest
      ? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
      : GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.onBackground,
          height: 1.1,
        );

  static TextStyle get headlineMedium => isTest
      ? const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)
      : GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
          height: 1.1,
        );

  // Body: Manrope
  static TextStyle get bodyLarge => isTest
      ? const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
      : GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onBackground,
        );

  static TextStyle get bodyMedium => isTest
      ? const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
      : GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        );

  // Labels: Space Grotesk
  static TextStyle get labelSmall => isTest
      ? const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)
      : GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
          letterSpacing: 1.2,
        );

  static TextStyle get labelMedium => isTest
      ? const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
      : GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 1.4,
        );
}
