import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_graph/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:sonic_graph/features/canvas/presentation/widgets/infinite_canvas.dart';
import 'package:sonic_graph/core/theme/app_colors.dart';
import 'package:sonic_graph/core/theme/app_text_styles.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CanvasBloc()..add(const CanvasInitialized()),
      child: Scaffold(
        backgroundColor: AppColors.canvasBackground,
        body: Stack(
          children: [
            const InfiniteCanvas(),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: BlocBuilder<CanvasBloc, CanvasState>(
                buildWhen: (prev, curr) => prev.zoomLevel != curr.zoomLevel,
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Text(
                      '${(state.zoomLevel * 100).toInt()}%',
                      style: AppTextStyles.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
