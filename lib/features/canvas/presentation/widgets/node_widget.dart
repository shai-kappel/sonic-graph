import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';
import 'package:sonic_nomad/core/widgets/glassmorphic_container.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget({
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
    // Discovery Tile Dimensions
    const double width = 180.0;
    const double height = 90.0;

    final isLoading = node.metadata['isLoading'] == true;
    final isExpanded = node.metadata['isExpanded'] == true;

    return Positioned(
      left: node.position.dx - (width / 2),
      top: node.position.dy - (height / 2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap,
            child: GlassmorphicContainer(
              width: width,
              height: height,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              showGlow: isFocused,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    node.label.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (node.metadata['type'] != null)
                        _NodeTag(
                          label: node.metadata['type'].toString(),
                          color: AppColors.tertiary,
                        ),
                      if (node.metadata['country'] != null) ...[
                        const SizedBox(width: 4),
                        _NodeTag(
                          label: node.metadata['country'].toString(),
                          color: AppColors.primary,
                        ),
                      ],
                    ],
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
                  borderRadius: 12,
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Expand Button
          if (!isExpanded && !isLoading)
            Positioned(
              bottom: -12,
              right: -12,
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

class _NodeTag extends StatelessWidget {
  final String label;
  final Color color;

  const _NodeTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
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
        borderColor: AppColors.primary.withValues(alpha: 0.4),
        child: const Icon(
          Icons.hub_outlined,
          size: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
