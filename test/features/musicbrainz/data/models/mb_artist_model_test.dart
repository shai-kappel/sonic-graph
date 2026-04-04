import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/features/musicbrainz/data/models/mb_artist_model.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/entities/artist.dart';

void main() {
  const tMBArtistModel = MBArtistModel(
    id: 'a74b1b7f-71a5-4011-9441-d0b5e4122711',
    name: 'Radiohead',
    sortName: 'Radiohead',
    type: 'Group',
    disambiguation: 'Oxfordshire-based rock band',
    country: 'GB',
    score: 100,
  );

  final tJson = {
    'id': 'a74b1b7f-71a5-4011-9441-d0b5e4122711',
    'name': 'Radiohead',
    'sort-name': 'Radiohead',
    'type': 'Group',
    'disambiguation': 'Oxfordshire-based rock band',
    'country': 'GB',
    'score': 100,
    'relations': null,
  };

  group('MBArtistModel', () {
    test('fromJson should return a valid model when JSON is correct', () {
      final result = MBArtistModel.fromJson(tJson);
      expect(result, tMBArtistModel);
    });

    test('toJson should return a JSON map containing the proper data', () {
      final result = tMBArtistModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a valid domain entity', () {
      final result = tMBArtistModel.toEntity();
      expect(result, isA<Artist>());
      expect(result.id, tMBArtistModel.id);
      expect(result.name, tMBArtistModel.name);
    });
  });
}
