import 'dart:ui';
import 'package:equatable/equatable.dart';

class GraphNode extends Equatable {
  const GraphNode({
    required this.id,
    required this.label,
    required this.position,
    this.metadata = const {},
  });

  final String id;
  final String label;
  final Offset position;
  final Map<String, dynamic> metadata;

  GraphNode copyWith({
    String? id,
    String? label,
    Offset? position,
    Map<String, dynamic>? metadata,
  }) {
    return GraphNode(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [id, label, position, metadata];
}
