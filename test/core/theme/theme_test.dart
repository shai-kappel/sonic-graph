import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_graph/core/theme/app_colors.dart';
import 'package:sonic_graph/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('dark theme has correct brightness', () {
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    test('dark theme has correct scaffold background color', () {
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.canvasBackground);
    });

    test('dark theme primary color is accentPrimary', () {
      expect(AppTheme.dark.colorScheme.primary, AppColors.accentPrimary);
    });
  });
}
