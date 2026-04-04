import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/features/wikidata/data/models/wikidata_response_model.dart';

void main() {
  group('WikidataResponseModel', () {
    test('should parse correctly from standard SPARQL JSON', () {
      const jsonString = '''
      {
        "head": {
          "vars": ["artist", "artistLabel", "genre", "genreLabel", "superGenre", "superGenreLabel"]
        },
        "results": {
          "bindings": [
            {
              "artist": { "type": "uri", "value": "http://www.wikidata.org/entity/Q123" },
              "artistLabel": { "type": "literal", "value": "Artist Name" },
              "genre": { "type": "uri", "value": "http://www.wikidata.org/entity/Q456" },
              "genreLabel": { "type": "literal", "value": "Genre Name" },
              "superGenre": { "type": "uri", "value": "http://www.wikidata.org/entity/Q789" },
              "superGenreLabel": { "type": "literal", "value": "Super Genre Name" }
            },
            {
              "artist": { "type": "uri", "value": "http://www.wikidata.org/entity/Q123" },
              "artistLabel": { "type": "literal", "value": "Artist Name" },
              "genre": { "type": "uri", "value": "http://www.wikidata.org/entity/Q456" },
              "genreLabel": { "type": "literal", "value": "Genre Name" }
            }
          ]
        }
      }
      ''';

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final model = WikidataResponseModel.fromJson(jsonMap);

      expect(model.bindings.length, 2);

      final first = model.bindings[0];
      expect(first.artistUri, 'http://www.wikidata.org/entity/Q123');
      expect(first.artistLabel, 'Artist Name');
      expect(first.genreUri, 'http://www.wikidata.org/entity/Q456');
      expect(first.genreLabel, 'Genre Name');
      expect(first.superGenreUri, 'http://www.wikidata.org/entity/Q789');
      expect(first.superGenreLabel, 'Super Genre Name');

      final second = model.bindings[1];
      expect(second.superGenreUri, isNull);
      expect(second.superGenreLabel, isNull);
    });

    test('should return empty list when bindings are missing', () {
      const jsonString = '{"results": {}}';
      final model = WikidataResponseModel.fromJson(json.decode(jsonString));
      expect(model.bindings, isEmpty);
    });
  });
}
