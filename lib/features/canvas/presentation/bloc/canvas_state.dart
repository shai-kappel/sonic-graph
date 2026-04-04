import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';

class CanvasState extends Equatable {
  const CanvasState({
    this.zoomLevel = 1.0,
    this.panOffset = Offset.zero,
    this.transformMatrix,
    this.isInitialized = false,
    this.nodes = const {},
    this.edges = const {},
  });

  final double zoomLevel;
  final Offset panOffset;
  final Matrix4? transformMatrix;
  final bool isInitialized;
  final Map<String, GraphNode> nodes;
  final Map<String, GraphEdge> edges;

  CanvasState copyWith({
    double? zoomLevel,
    Offset? panOffset,
    Matrix4? transformMatrix,
    bool? isInitialized,
    Map<String, GraphNode>? nodes,
    Map<String, GraphEdge>? edges,
  }) {
    return CanvasState(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      panOffset: panOffset ?? this.panOffset,
      transformMatrix: transformMatrix ?? this.transformMatrix,
      isInitialized: isInitialized ?? this.isInitialized,
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
    );
  }

  @override
  List<Object?> get props => [
    zoomLevel,
    panOffset,
    isInitialized,
    nodes,
    edges,
  ];
}
