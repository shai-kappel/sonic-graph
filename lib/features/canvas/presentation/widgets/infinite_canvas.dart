import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_graph/core/theme/app_colors.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_state.dart';

class InfiniteCanvas extends StatefulWidget {
  const InfiniteCanvas({super.key});

  @override
  State<InfiniteCanvas> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends State<InfiniteCanvas> {
  final TransformationController _transformController = TransformationController();

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
      buildWhen: (prev, curr) => prev.isInitialized != curr.isInitialized,
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
            child: CustomPaint(
              painter: _CanvasGridPainter(),
              size: const Size(4000, 4000),
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
