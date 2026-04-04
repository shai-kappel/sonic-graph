import 'package:equatable/equatable.dart';
import '../../domain/entities/artist.dart';
import 'mb_artist_model.dart';

class MBRelationModel extends Equatable {
  final String type;
  final String direction;
  final String targetType;
  final MBArtistModel artist;

  const MBRelationModel({
    required this.type,
    required this.direction,
    required this.targetType,
    required this.artist,
  });

  factory MBRelationModel.fromJson(Map<String, dynamic> json) {
    return MBRelationModel(
      type: json['type'] as String,
      direction: json['direction'] as String,
      targetType: json['target-type'] as String,
      artist: MBArtistModel.fromJson(json['artist'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'direction': direction,
      'target-type': targetType,
      'artist': artist.toJson(),
    };
  }

  ArtistRelation toEntity() {
    return ArtistRelation(
      type: type,
      direction: direction,
      targetType: targetType,
      artist: artist.toEntity(),
    );
  }

  @override
  List<Object?> get props => [type, direction, targetType, artist];
}
