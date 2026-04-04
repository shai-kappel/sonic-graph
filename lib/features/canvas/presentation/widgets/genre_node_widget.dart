import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';
import 'package:sonic_nomad/core/widgets/glassmorphic_container.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';

class GenreNodeWidget extends StatelessWidget {
  const GenreNodeWidget({
    super.key,
    required this.node,
    this.onTap,
    this.isFocused = false,
  });

  final GraphNode node;
  final VoidCallback? onTap;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    // Genre Node Dimensions: 120x120px circular
    const double size = 120.0;
    const double borderRadius = size / 2;

    final isLoading = node.metadata['isLoading'] == true;
    final isExpanded = node.metadata['isExpanded'] == true;

    return Positioned(
      left: node.position.dx - (size / 2),
      top: node.position.dy - (size / 2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap,
            child: GlassmorphicContainer(
              width: size,
              height: size,
              borderRadius: borderRadius,
              padding: const EdgeInsets.all(12),
              showGlow: isFocused || isExpanded,
              useBorder: true,
              borderColor: AppColors.tertiary.withValues(alpha: 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.category_outlined,
                    size: 24,
                    color: AppColors.tertiary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    node.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 14,
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SpaceGrotesk',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (isLoading)
            Positioned.fill(
              child: IgnorePointer(
                child: GlassmorphicContainer(
                  borderRadius: borderRadius,
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Expand Button
          if (!isExpanded && !isLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: _ExpandButton(
                onTap: () {
                  context.read<CanvasBloc>().add(
                    ExpandNodeRequest(nodeId: node.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ExpandButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: 32,
        height: 32,
        borderRadius: 16,
        padding: EdgeInsets.zero,
        useBorder: true,
        borderColor: AppColors.tertiary.withValues(alpha: 0.4),
        child: const Icon(
          Icons.hub_outlined,
          size: 16,
          color: AppColors.tertiary,
        ),
      ),
    );
  }
}
