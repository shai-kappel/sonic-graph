import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final String id;
  final String name;
  final String sortName;
  final String? type;
  final String? disambiguation;
  final String? country;
  final int? score;
  final List<ArtistRelation>? relations;

  const Artist({
    required this.id,
    required this.name,
    required this.sortName,
    this.type,
    this.disambiguation,
    this.country,
    this.score,
    this.relations,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    sortName,
    type,
    disambiguation,
    country,
    score,
    relations,
  ];
}

class ArtistRelation extends Equatable {
  final String type;
  final String direction;
  final String targetType;
  final Artist artist;

  const ArtistRelation({
    required this.type,
    required this.direction,
    required this.targetType,
    required this.artist,
  });

  @override
  List<Object?> get props => [type, direction, targetType, artist];
}
