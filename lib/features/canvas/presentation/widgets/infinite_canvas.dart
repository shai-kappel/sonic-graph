import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_graph/core/theme/app_colors.dart';
import 'package:sonic_graph/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_graph/features/canvas/domain/models/graph_node.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:sonic_graph/features/canvas/presentation/widgets/node_widget.dart';

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
            width: 4000,
            height: 4000,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Grid Background
                CustomPaint(
                  painter: _CanvasGridPainter(),
                  size: const Size(4000, 4000),
                ),
                // 2. Edges (Bezier Curves)
                CustomPaint(
                  painter: _GraphEdgePainter(
                    nodes: state.nodes,
                    edges: state.edges,
                  ),
                  size: const Size(4000, 4000),
                ),
                // 3. Nodes (Widgets)
                ...state.nodes.map((node) => NodeWidget(node: node)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CanvasGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderGlassSubtle
      ..strokeWidth = 0.5;

    const gridSpacing = 60.0;
    for (var x = 0.0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GraphEdgePainter extends CustomPainter {
  _GraphEdgePainter({required this.nodes, required this.edges});

  final List<GraphNode> nodes;
  final List<GraphEdge> edges;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGlow.withOpacity(0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      final fromNode = nodes.firstWhere((n) => n.id == edge.fromId);
      final toNode = nodes.firstWhere((n) => n.id == edge.toId);

      final start = fromNode.position;
      final end = toNode.position;

      final path = Path();
      path.moveTo(start.dx, start.dy);

      // Control points for a smooth bezier curve
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

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphEdgePainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.edges != edges;
  }
}
