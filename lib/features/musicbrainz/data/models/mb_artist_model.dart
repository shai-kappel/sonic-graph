import 'package:equatable/equatable.dart';

class MBArtistModel extends Equatable {
  final String id;
  final String name;
  final String sortName;
  final String? type;
  final String? disambiguation;
  final String? country;
  final int? score;

  const MBArtistModel({
    required this.id,
    required this.name,
    required this.sortName,
    this.type,
    this.disambiguation,
    this.country,
    this.score,
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
    };
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
  ];
}
