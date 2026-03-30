import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/node_widget.dart';

class InfiniteCanvas extends StatefulWidget {
  const InfiniteCanvas({super.key});

  @override
  State<InfiniteCanvas> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends State<InfiniteCanvas> {
  final TransformationController _transformController =
      TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    context.read<CanvasBloc>().add(
      CanvasTransformed(matrix: _transformController.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasBloc, CanvasState>(
      builder: (context, state) {
        return InteractiveViewer(
          transformationController: _transformController,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.1,
          maxScale: 4.0,
          constrained: false,
          onInteractionUpdate: (details) => _onInteractionUpdate(details),
          child: SizedBox(
            width: 5000,
            height: 5000,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Nebula Background (Atmospheric Light) - Isolated with RepaintBoundary
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _NebulaBackgroundPainter(),
                    size: const Size(5000, 5000),
                  ),
                ),
                // 2. Edges (Bezier Curves) - Isolated with RepaintBoundary
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _GraphEdgePainter(
                      nodePositions: {
                        for (final node in state.nodes) node.id: node.position,
                      },
                      edges: state.edges,
                    ),
                    size: const Size(5000, 5000),
                  ),
                ),
                // 3. Nodes (Discovery Tiles)
                ...state.nodes.map((node) => NodeWidget(node: node)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NebulaBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Deterministic "random" for the background

    // Paint blurred "Nebula Blobs"
    void drawBlob(Color color, Offset offset, double radius) {
      final paint = Paint()
        ..color = color.withValues(alpha: 0.05)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.5);
      canvas.drawCircle(offset, radius, paint);
    }

    // Distribute blobs across the canvas
    for (var i = 0; i < 20; i++) {
      final color = i % 2 == 0 ? AppColors.primary : AppColors.tertiary;
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = 200.0 + random.nextDouble() * 400.0;
      drawBlob(color, offset, radius);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GraphEdgePainter extends CustomPainter {
  _GraphEdgePainter({required this.nodePositions, required this.edges});

  final Map<String, Offset> nodePositions;
  final List<GraphEdge> edges;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    for (final edge in edges) {
      final rawStart = nodePositions[edge.fromId];
      final rawEnd = nodePositions[edge.toId];

      if (rawStart == null || rawEnd == null) continue;

      // Calculate intersection with 160x80 Discovery Tile boundaries
      // Tiles are centered on the node position.
      final dx = rawEnd.dx - rawStart.dx;
      final dy = rawEnd.dy - rawStart.dy;

      // Offset by half-width (80) or half-height (40) depending on dominant direction
      final double offsetX;
      final double offsetY;

      if (dx.abs() > dy.abs()) {
        offsetX = 80.0 * (dx > 0 ? 1 : -1);
        offsetY = 0.0;
      } else {
        offsetX = 0.0;
        offsetY = 40.0 * (dy > 0 ? 1 : -1);
      }

      final start = Offset(rawStart.dx + offsetX, rawStart.dy + offsetY);
      final end = Offset(rawEnd.dx - offsetX, rawEnd.dy - offsetY);

      final path = Path();
      path.moveTo(start.dx, start.dy);

      final controlPoint1 = Offset(
        start.dx + (end.dx - start.dx) / 2,
        start.dy,
      );
      final controlPoint2 = Offset(start.dx + (end.dx - start.dx) / 2, end.dy);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphEdgePainter oldDelegate) {
    return oldDelegate.nodePositions != nodePositions ||
        oldDelegate.edges != edges;
  }
}
