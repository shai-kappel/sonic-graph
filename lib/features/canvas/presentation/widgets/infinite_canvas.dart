import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/core/metrics/graph_layout_engine.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/node_widget.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/genre_node_widget.dart';

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
                // 1. Nebula Background
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _NebulaBackgroundPainter(),
                    size: const Size(5000, 5000),
                  ),
                ),
                // 2. Edges
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _GraphEdgePainter(
                      nodes: state.nodes,
                      edges: state.edges.values.toList(),
                    ),
                    size: const Size(5000, 5000),
                  ),
                ),
                // 3. Nodes
                ...state.nodes.values.map((node) {
                  final isGenre = node.metadata['type'] == 'genre';
                  if (isGenre) {
                    return GenreNodeWidget(node: node);
                  }
                  return NodeWidget(node: node);
                }),
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
    final random = Random(42);
    void drawBlob(Color color, Offset offset, double radius) {
      final paint = Paint()
        ..color = color.withValues(alpha: 0.05)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.5);
      canvas.drawCircle(offset, radius, paint);
    }

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
  _GraphEdgePainter({required this.nodes, required this.edges});

  final Map<String, GraphNode> nodes;
  final List<GraphEdge> edges;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final nodeFrom = nodes[edge.fromId];
      final nodeTo = nodes[edge.toId];

      if (nodeFrom == null || nodeTo == null) continue;

      final rawStart = nodeFrom.position;
      final rawEnd = nodeTo.position;

      final isMacroEvolution =
          edge.metadata['isMacroEvolution'] == true ||
          edge.label == 'subgenre of' ||
          edge.label == 'subclass of';

      final paint = Paint()
        ..color = isMacroEvolution
            ? AppColors.primary.withValues(alpha: 0.5)
            : AppColors.primary.withValues(alpha: 0.2)
        ..strokeWidth = isMacroEvolution ? 2.5 : 1.5
        ..style = PaintingStyle.stroke;

      final glowPaint = Paint()
        ..color = AppColors.primary.withValues(alpha: 0.05)
        ..strokeWidth = isMacroEvolution ? 6.0 : 4.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      final fromSize = GraphLayoutEngine.getNodeSize(
        nodeFrom.metadata['type']?.toString(),
      );
      final toSize = GraphLayoutEngine.getNodeSize(
        nodeTo.metadata['type']?.toString(),
      );

      final dx = rawEnd.dx - rawStart.dx;
      final dy = rawEnd.dy - rawStart.dy;

      final double offsetX;
      final double offsetY;

      if (dx.abs() > dy.abs()) {
        offsetX = (fromSize.width / 2) * (dx > 0 ? 1 : -1);
        offsetY = 0.0;
      } else {
        offsetX = 0.0;
        offsetY = (fromSize.height / 2) * (dy > 0 ? 1 : -1);
      }

      final double endOffsetX;
      final double endOffsetY;
      if (dx.abs() > dy.abs()) {
        endOffsetX = (toSize.width / 2) * (dx > 0 ? 1 : -1);
        endOffsetY = 0.0;
      } else {
        endOffsetX = 0.0;
        endOffsetY = (toSize.height / 2) * (dy > 0 ? 1 : -1);
      }

      final start = Offset(rawStart.dx + offsetX, rawStart.dy + offsetY);
      final end = Offset(rawEnd.dx - endOffsetX, rawEnd.dy - endOffsetY);

      final path = Path();
      path.moveTo(start.dx, start.dy);

      final midX = start.dx + (end.dx - start.dx) / 2;
      final controlPoint1 = Offset(midX, start.dy);
      final controlPoint2 = Offset(midX, end.dy);

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

      if (edge.label != null && edge.label!.isNotEmpty) {
        _drawEdgeLabel(canvas, edge.label!, start, end, midX, isMacroEvolution);
      }
    }
  }

  void _drawEdgeLabel(
    Canvas canvas,
    String label,
    Offset start,
    Offset end,
    double midX,
    bool isMacroEvolution,
  ) {
    final midY = start.dy + (end.dy - start.dy) / 2;
    final center = Offset(midX, midY);

    final textSpan = TextSpan(
      text: label.toUpperCase(),
      style: AppTextStyles.labelSmall.copyWith(
        fontSize: 10,
        color: isMacroEvolution ? Colors.white : AppColors.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final bgWidth = textPainter.width + 12;
    final bgHeight = textPainter.height + 6;
    final bgRect = Rect.fromCenter(
      center: center,
      width: bgWidth,
      height: bgHeight,
    );

    final bgPaint = Paint()
      ..color = isMacroEvolution
          ? AppColors.tertiary
          : AppColors.surfaceContainerHigh
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isMacroEvolution
          ? AppColors.tertiary.withValues(alpha: 0.5)
          : AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      bgPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      borderPaint,
    );

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _GraphEdgePainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.edges != edges;
  }
}
