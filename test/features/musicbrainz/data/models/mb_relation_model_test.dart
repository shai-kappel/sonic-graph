import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/features/musicbrainz/data/models/mb_artist_model.dart';
import 'package:sonic_nomad/features/musicbrainz/data/models/mb_relation_model.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/entities/artist.dart';

void main() {
  const tMBArtistModel = MBArtistModel(
    id: '1',
    name: 'Test Artist',
    sortName: 'Artist, Test',
  );

  const tMBRelationModel = MBRelationModel(
    type: 'member of band',
    direction: 'forward',
    targetType: 'artist',
    artist: tMBArtistModel,
  );

  final tJson = {
    'type': 'member of band',
    'direction': 'forward',
    'target-type': 'artist',
    'artist': tMBArtistModel.toJson(),
  };

  group('MBRelationModel', () {
    test('fromJson should return a valid model when JSON is correct', () {
      final result = MBRelationModel.fromJson(tJson);
      expect(result, tMBRelationModel);
    });

    test('toJson should return a JSON map containing the proper data', () {
      final result = tMBRelationModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a valid domain entity', () {
      final result = tMBRelationModel.toEntity();
      expect(result, isA<ArtistRelation>());
      expect(result.type, tMBRelationModel.type);
      expect(result.artist.id, tMBArtistModel.id);
    });
  });
}
