import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';

class GlassmorphicContainer extends StatelessWidget {
  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.blurSigma = AppColors.glassBlur,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.useBorder = false, // Mandated "No-Line" rule default
    this.borderColor,
    this.showGlow = false,
  });

  final double? width;
  final double? height;
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final bool useBorder;
  final Color? borderColor;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showGlow
            ? const [
                BoxShadow(
                  color: AppColors.shadowGlow,
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  AppColors.surfaceVariant.withValues(
                    alpha: AppColors.glassOpacity,
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: useBorder
                  ? Border.all(
                      color:
                          borderColor ??
                          AppColors.primary.withValues(
                            alpha: AppColors.ghostBorderOpacity,
                          ),
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
