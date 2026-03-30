import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';
import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  CanvasBloc() : super(const CanvasState()) {
    on<CanvasInitialized>(_onInitialized);
    on<CanvasTransformed>(_onTransformed);
    on<CanvasZoomChanged>(_onZoomChanged);
  }

  void _onInitialized(CanvasInitialized event, Emitter<CanvasState> emit) {
    // Generate 50+ mock nodes for Phase 2 stress testing
    final List<GraphNode> mockNodes = [];
    final List<GraphEdge> mockEdges = [];
    final random = Random(42);

    for (int i = 0; i < 60; i++) {
      final node = GraphNode(
        id: '$i',
        label: 'Artist $i',
        position: Offset(
          1000 + random.nextDouble() * 2000,
          1000 + random.nextDouble() * 2000,
        ),
      );
      mockNodes.add(node);

      // Connect to a random previous node to create a tree-like structure
      if (i > 0) {
        final fromIndex = random.nextInt(i);
        mockEdges.add(
          GraphEdge(id: 'e-$fromIndex-$i', fromId: '$fromIndex', toId: '$i'),
        );
      }
    }

    emit(
      state.copyWith(isInitialized: true, nodes: mockNodes, edges: mockEdges),
    );
  }

  void _onTransformed(CanvasTransformed event, Emitter<CanvasState> emit) {
    final matrix = event.matrix;
    final zoom = matrix.getMaxScaleOnAxis();
    final translation = Offset(
      matrix.getTranslation().x,
      matrix.getTranslation().y,
    );
    emit(
      state.copyWith(
        transformMatrix: matrix,
        zoomLevel: zoom,
        panOffset: translation,
      ),
    );
  }

  void _onZoomChanged(CanvasZoomChanged event, Emitter<CanvasState> emit) {
    emit(state.copyWith(zoomLevel: event.zoomLevel));
  }
}
