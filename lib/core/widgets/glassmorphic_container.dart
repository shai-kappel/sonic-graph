import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sonic_graph/core/theme/app_colors.dart';

class GlassmorphicContainer extends StatelessWidget {
  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.blurSigma = 10.0,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderColor,
  });

  final double? width;
  final double? height;
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceGlass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor ?? AppColors.borderGlass),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowDeep,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 40,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
