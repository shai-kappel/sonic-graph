import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/infinite_canvas.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';
import 'package:sonic_nomad/core/widgets/glassmorphic_container.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CanvasBloc()..add(const CanvasInitialized()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            const InfiniteCanvas(),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: BlocBuilder<CanvasBloc, CanvasState>(
                buildWhen: (prev, curr) => prev.zoomLevel != curr.zoomLevel,
                builder: (context, state) {
                  return GlassmorphicContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    borderRadius: 20,
                    child: Text(
                      '${(state.zoomLevel * 100).toInt()}%',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
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
