import 'package:flutter/material.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';
import 'package:sonic_nomad/core/widgets/glassmorphic_container.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';

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
    const double width = 160.0;
    const double height = 80.0;

    return Positioned(
      left: node.position.dx - (width / 2),
      top: node.position.dy - (height / 2),
      child: GestureDetector(
        onTap: onTap,
        child: GlassmorphicContainer(
          width: width,
          height: height,
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (node.metadata.containsKey('subtitle')) ...[
                const SizedBox(height: 4),
                Text(
                  node.metadata['subtitle'].toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
