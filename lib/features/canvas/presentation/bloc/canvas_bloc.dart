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
    // Generate 100+ mock nodes for Phase 2 stress testing
    final List<GraphNode> mockNodes = [];
    final List<GraphEdge> mockEdges = [];
    final random = Random(42);

    for (int i = 0; i < 100; i++) {
      final node = GraphNode(
        id: '$i',
        label: 'Artist $i',
        position: Offset(
          random.nextDouble() * 5000,
          random.nextDouble() * 5000,
        ),
      );
      mockNodes.add(node);
    }

    // Create a interconnected graph with 150 edges
    for (int i = 0; i < 150; i++) {
      final fromIndex = random.nextInt(100);
      int toIndex = random.nextInt(100);
      while (fromIndex == toIndex) {
        toIndex = random.nextInt(100);
      }
      mockEdges.add(
        GraphEdge(id: 'e-$i', fromId: '$fromIndex', toId: '$toIndex'),
      );
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
