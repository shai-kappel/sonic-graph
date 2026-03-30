import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/core/theme/app_theme.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';

void main() {
  setUpAll(() {
    AppTextStyles.isTest = true;
  });

  group('AppTheme', () {
    test('dark theme has correct brightness', () {
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    test('dark theme has correct scaffold background color', () {
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.background);
    });

    test('dark theme primary color is primary', () {
      expect(AppTheme.dark.colorScheme.primary, AppColors.primary);
    });
  });
}
