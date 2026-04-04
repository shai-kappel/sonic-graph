import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/core/metrics/graph_layout_engine.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/usecases/get_artist_relationships.dart';
import 'package:sonic_nomad/features/wikidata/domain/usecases/get_macro_evolution.dart';
import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  final GetArtistRelationships getArtistRelationships;
  final GetMacroEvolution getMacroEvolution;

  CanvasBloc({
    required this.getArtistRelationships,
    required this.getMacroEvolution,
  }) : super(const CanvasState()) {
    on<CanvasInitialized>(_onInitialized);
    on<CanvasTransformed>(_onTransformed);
    on<CanvasZoomChanged>(_onZoomChanged);
    on<AddNodeEvent>(_onAddNode);
    on<ExpandNodeRequest>(_onExpandNode);
    on<LoadMacroEvolution>(_onLoadMacroEvolution);
  }

  Future<void> _onExpandNode(
    ExpandNodeRequest event,
    Emitter<CanvasState> emit,
  ) async {
    final nodeId = event.nodeId;
    final node = state.nodes[nodeId];
    if (node == null) return;

    // Set node to loading state
    final nodes = Map<String, GraphNode>.from(state.nodes);
    nodes[nodeId] = node.copyWith(
      metadata: {...node.metadata, 'isLoading': true},
    );
    emit(state.copyWith(nodes: nodes));

    try {
      final relations = await getArtistRelationships.execute(nodeId);

      final Map<String, GraphNode> newNodes = {};
      final Map<String, GraphEdge> newEdges = {};

      for (int i = 0; i < relations.length; i++) {
        final rel = relations[i];
        final artist = rel.artist;

        final edgeId = 'e-$nodeId-${artist.id}';

        // Skip if node already exists on canvas
        if (state.nodes.containsKey(artist.id) ||
            newNodes.containsKey(artist.id)) {
          newEdges[edgeId] = GraphEdge(
            id: edgeId,
            fromId: nodeId,
            toId: artist.id,
            label: rel.type,
          );
          continue;
        }

        final position = GraphLayoutEngine.calculateRadialPosition(
          node.position,
          i,
          relations.length,
          radius: GraphLayoutEngine.artistRadius,
        );

        final newNode = GraphNode(
          id: artist.id,
          label: artist.name,
          position: position,
          metadata: {
            'type': artist.type,
            'country': artist.country,
            'disambiguation': artist.disambiguation,
          },
        );

        newNodes[artist.id] = newNode;
        newEdges[edgeId] = GraphEdge(
          id: edgeId,
          fromId: nodeId,
          toId: artist.id,
          label: rel.type,
        );
      }

      // Update source node to not loading
      final finalNodes = Map<String, GraphNode>.from(state.nodes);
      finalNodes[nodeId] = node.copyWith(
        metadata: {...node.metadata, 'isLoading': false, 'isExpanded': true},
      );

      emit(
        state.copyWith(
          nodes: {...finalNodes, ...newNodes},
          edges: {...state.edges, ...newEdges},
        ),
      );

      // Auto-trigger Wikidata macro-evolution if MBID exists
      if (node.metadata.containsKey('mbid')) {
        add(LoadMacroEvolution(nodeId: nodeId));
      }
    } catch (e) {
      // Revert loading state
      final errorNodes = Map<String, GraphNode>.from(state.nodes);
      final originalNode = state.nodes[nodeId];
      if (originalNode != null) {
        errorNodes[nodeId] = originalNode.copyWith(
          metadata: {...originalNode.metadata, 'isLoading': false},
        );
      }
      emit(state.copyWith(nodes: errorNodes));
    }
  }

  Future<void> _onLoadMacroEvolution(
    LoadMacroEvolution event,
    Emitter<CanvasState> emit,
  ) async {
    final nodeId = event.nodeId;
    final node = state.nodes[nodeId];
    if (node == null) return;

    final mbid = node.metadata['mbid'] as String?;
    if (mbid == null) return;

    try {
      final evolution = await getMacroEvolution.execute(mbid);

      final Map<String, GraphNode> newNodes = {};
      final Map<String, GraphEdge> newEdges = {};

      int i = 0;
      for (final genreNode in evolution.nodes) {
        if (!state.nodes.containsKey(genreNode.id)) {
          final position = GraphLayoutEngine.calculateRadialPosition(
            node.position,
            i,
            evolution.nodes.length,
            radius: GraphLayoutEngine.genreRadius,
            startAngle: pi,
            sweepAngle: pi / 2,
          );
          newNodes[genreNode.id] = genreNode.copyWith(position: position);
          i++;
        }
      }

      for (final edge in evolution.edges) {
        newEdges[edge.id] = edge;
      }

      emit(
        state.copyWith(
          nodes: {...state.nodes, ...newNodes},
          edges: {...state.edges, ...newEdges},
        ),
      );
    } catch (e) {
      // Silent fail for macro-evolution for now
    }
  }

  void _onAddNode(AddNodeEvent event, Emitter<CanvasState> emit) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newNode = GraphNode(
      id: id,
      label: event.label,
      position: event.position,
      metadata: event.metadata,
    );
    final nodes = Map<String, GraphNode>.from(state.nodes);
    nodes[id] = newNode;
    emit(state.copyWith(nodes: nodes));
  }

  void _onInitialized(CanvasInitialized event, Emitter<CanvasState> emit) {
    // Generate 100+ mock nodes for Phase 2 stress testing
    final Map<String, GraphNode> mockNodes = {};
    final Map<String, GraphEdge> mockEdges = {};
    final random = Random(42);

    for (int i = 0; i < 100; i++) {
      final id = '$i';
      final node = GraphNode(
        id: id,
        label: 'Artist $i',
        position: Offset(
          random.nextDouble() * 5000,
          random.nextDouble() * 5000,
        ),
      );
      mockNodes[id] = node;
    }

    // Create a interconnected graph with 150 edges
    for (int i = 0; i < 150; i++) {
      final fromIndex = random.nextInt(100);
      int toIndex = random.nextInt(100);
      while (fromIndex == toIndex) {
        toIndex = random.nextInt(100);
      }
      final edgeId = 'e-$i';
      mockEdges[edgeId] = GraphEdge(
        id: edgeId,
        fromId: '$fromIndex',
        toId: '$toIndex',
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
