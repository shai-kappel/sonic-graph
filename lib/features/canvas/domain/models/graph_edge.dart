import 'package:equatable/equatable.dart';

class GraphEdge extends Equatable {
  const GraphEdge({
    required this.id,
    required this.fromId,
    required this.toId,
    this.label,
    this.metadata = const {},
  });

  final String id;
  final String fromId;
  final String toId;
  final String? label;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [id, fromId, toId, label, metadata];
}
