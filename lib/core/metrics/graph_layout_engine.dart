import 'dart:math';
import 'package:flutter/material.dart';

class GraphLayoutEngine {
  static const double artistRadius = 300.0;
  static const double genreRadius = 450.0;

  static Offset calculateRadialPosition(
    Offset center,
    int index,
    int total, {
    double radius = artistRadius,
    double startAngle = 0.0,
    double sweepAngle = 2 * pi,
  }) {
    if (total == 0) return center;

    final angleStep = total == 1 ? 0 : sweepAngle / total;
    final angle = startAngle + (index * angleStep);

    return Offset(
      center.dx + (cos(angle) * radius),
      center.dy + (sin(angle) * radius),
    );
  }

  static const double artistWidth = 180.0;
  static const double artistHeight = 90.0;
  static const double genreSize = 120.0;

  static Size getNodeSize(String? type) {
    if (type == 'genre') {
      return const Size(genreSize, genreSize);
    }
    return const Size(artistWidth, artistHeight);
  }
}
