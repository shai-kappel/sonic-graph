import 'dart:ui';
import 'package:sonic_nomad/features/canvas/domain/models/graph_edge.dart';
import 'package:sonic_nomad/features/canvas/domain/models/graph_node.dart';
import 'package:sonic_nomad/features/wikidata/domain/repositories/wikidata_repository.dart';

class MacroEvolution {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;

  const MacroEvolution({required this.nodes, required this.edges});
}

class GetMacroEvolution {
  final WikidataRepository repository;

  GetMacroEvolution(this.repository);

  Future<MacroEvolution> execute(String artistId) async {
    final genres = await repository.getArtistGenres(artistId);

    final Map<String, GraphNode> genreNodes = {};
    final List<GraphEdge> graphEdges = [];
    final Set<String> edgeIds = {};

    for (final genre in genres) {
      // 1. Ensure the genre node itself exists
      if (!genreNodes.containsKey(genre.id)) {
        genreNodes[genre.id] = GraphNode(
          id: genre.id,
          label: genre.label,
          position: Offset.zero,
          metadata: const {'type': 'genre'},
        );
      }

      // 2. Add an edge from the Artist to the Genre
      final artistToGenreEdgeId = 'e-$artistId-${genre.id}';
      if (!edgeIds.contains(artistToGenreEdgeId)) {
        graphEdges.add(
          GraphEdge(
            id: artistToGenreEdgeId,
            fromId: artistId,
            toId: genre.id,
            label: 'genre',
          ),
        );
        edgeIds.add(artistToGenreEdgeId);
      }

      // 3. Handle the superGenre (parentGenre) if it exists
      if (genre.parentGenreId != null) {
        if (!genreNodes.containsKey(genre.parentGenreId!)) {
          genreNodes[genre.parentGenreId!] = GraphNode(
            id: genre.parentGenreId!,
            label: genre.parentGenreLabel ?? 'Unknown Genre',
            position: Offset.zero,
            metadata: const {'type': 'genre'},
          );
        }

        // Add edge from the Genre to its SuperGenre
        final genreToParentEdgeId = 'e-${genre.id}-${genre.parentGenreId!}';
        if (!edgeIds.contains(genreToParentEdgeId)) {
          graphEdges.add(
            GraphEdge(
              id: genreToParentEdgeId,
              fromId: genre.id,
              toId: genre.parentGenreId!,
              label: 'subclass of',
            ),
          );
          edgeIds.add(genreToParentEdgeId);
        }
      }
    }

    return MacroEvolution(nodes: genreNodes.values.toList(), edges: graphEdges);
  }
}
