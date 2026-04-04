import 'package:equatable/equatable.dart';
import '../../domain/entities/artist.dart';
import 'mb_relation_model.dart';

class MBArtistModel extends Equatable {
  final String id;
  final String name;
  final String sortName;
  final String? type;
  final String? disambiguation;
  final String? country;
  final int? score;
  final List<MBRelationModel>? relations;

  const MBArtistModel({
    required this.id,
    required this.name,
    required this.sortName,
    this.type,
    this.disambiguation,
    this.country,
    this.score,
    this.relations,
  });

  factory MBArtistModel.fromJson(Map<String, dynamic> json) {
    return MBArtistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sortName: json['sort-name'] as String,
      type: json['type'] as String?,
      disambiguation: json['disambiguation'] as String?,
      country: json['country'] as String?,
      score: json['score'] as int?,
      relations: (json['relations'] as List?)
          ?.where((rel) => rel['artist'] != null)
          .map((rel) => MBRelationModel.fromJson(rel as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sort-name': sortName,
      'type': type,
      'disambiguation': disambiguation,
      'country': country,
      'score': score,
      'relations': relations?.map((rel) => rel.toJson()).toList(),
    };
  }

  Artist toEntity() {
    return Artist(
      id: id,
      name: name,
      sortName: sortName,
      type: type,
      disambiguation: disambiguation,
      country: country,
      score: score,
      relations: relations?.map((r) => r.toEntity()).toList(),
    );
  }

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
