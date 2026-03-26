import 'package:flutter/material.dart';
import 'package:sonic_graph/core/widgets/glassmorphic_container.dart';
import 'package:sonic_graph/features/canvas/domain/models/graph_node.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget({super.key, required this.node, this.onTap});

  final GraphNode node;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.position.dx - 60, // Centering (width/2)
      top: node.position.dy - 30, // Centering (height/2)
      child: GestureDetector(
        onTap: onTap,
        child: GlassmorphicContainer(
          width: 120,
          height: 60,
          borderRadius: 12,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                node.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
