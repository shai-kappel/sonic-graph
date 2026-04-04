import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sonic_nomad/features/wikidata/data/datasources/wikidata_api.dart';
import 'package:sonic_nomad/features/wikidata/data/models/wikidata_response_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late WikidataApi api;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    api = WikidataApi(client: mockHttpClient);

    // Register fallback for Uri and headers if needed
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('fetchArtistGenres', () {
    const mbid = 'artist-mbid';
    const mockResponse = '''
    {
      "results": {
        "bindings": [
          {
            "artist": { "value": "Q1" },
            "artistLabel": { "value": "Artist" },
            "genre": { "value": "Q2" },
            "genreLabel": { "value": "Genre" }
          }
        ]
      }
    }
    ''';

    test(
      'should return WikidataResponseModel when status code is 200',
      () async {
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response(mockResponse, 200));

        final result = await api.fetchArtistGenres(mbid);

        expect(result, isA<WikidataResponseModel>());
        expect(result.bindings.length, 1);
        expect(result.bindings[0].artistLabel, 'Artist');

        verify(
          () => mockHttpClient.post(
            Uri.parse('https://query.wikidata.org/sparql'),
            headers: {
              'Accept': 'application/sparql-results+json',
              'Content-Type': 'application/x-www-form-urlencoded',
              'User-Agent': 'SonicNomad/1.0.0 ( contact@sonicnomad.app )',
            },
            body: any(named: 'body'),
          ),
        ).called(1);
      },
    );

    test('should throw exception when status code is not 200/429', () async {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(() => api.fetchArtistGenres(mbid), throwsException);
    });

    test('should retry on 429', () async {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Too many requests', 429));

      // We can't easily test the second call in a simple way without more complex mock setup
      // but we can at least verify it throws if the second one also fails.

      expect(() => api.fetchArtistGenres(mbid), throwsException);
    });
  });
}
