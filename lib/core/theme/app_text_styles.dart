import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _fontFamily = 'Inter';

  static const headlineLarge = TextStyle(
    fontFamily: _fontFamily, fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );
  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily, fontSize: 22, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: -0.3,
  );
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const labelSmall = TextStyle(
    fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textMuted, letterSpacing: 0.5,
  );
}
