import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sonic_nomad/features/musicbrainz/data/datasources/musicbrainz_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MusicBrainzApi api;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    api = MusicBrainzApi(client: mockHttpClient);
  });

  const tSearchResponse = {
    'artists': [
      {
        'id': 'a74b1b7f-71a5-4011-9441-d0b5e4122711',
        'name': 'Radiohead',
        'sort-name': 'Radiohead',
        'type': 'Group',
        'disambiguation': 'Oxfordshire-based rock band',
        'country': 'GB',
        'score': 100,
      },
    ],
  };

  group('MusicBrainzApi', () {
    test(
      'should search artists with correct headers and query params',
      () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(json.encode(tSearchResponse), 200),
        );

        await api.searchArtists('Radiohead');

        verify(
          () => mockHttpClient.get(
            any(
              that: predicate<Uri>((uri) {
                return uri.path == '/ws/2/artist' &&
                    uri.queryParameters['query'] == 'Radiohead' &&
                    uri.queryParameters['fmt'] == 'json';
              }),
            ),
            headers: any(
              named: 'headers',
              that: containsPair('User-Agent', MusicBrainzApi.userAgent),
            ),
          ),
        ).called(1);
      },
    );

    test('should enforce rate limiting (approx 1s between requests)', () async {
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(json.encode(tSearchResponse), 200),
      );

      final startTime = DateTime.now();

      // Start two requests
      final f1 = api.searchArtists('Radiohead 1');
      final f2 = api.searchArtists('Radiohead 2');

      await Future.wait([f1, f2]);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // First request can start immediately, but the second one must wait at least 1s
      expect(duration.inMilliseconds, greaterThanOrEqualTo(1000));
    });

    test(
      'should throw an exception when the response code is not 200',
      () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('Something went wrong', 404));

        final call = api.searchArtists('Radiohead');

        expect(() => call, throwsException);
      },
    );

    group('internal queue management', () {
      test('should process multiple requests in order', () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((invocation) async {
          final uri = invocation.positionalArguments[0] as Uri;
          return http.Response(
            json.encode({
              'artists': [
                {
                  'id': uri.queryParameters['query']!,
                  'name': 'N',
                  'sort-name': 'S',
                },
              ],
            }),
            200,
          );
        });

        final f1 = api.searchArtists('q1');
        final f2 = api.searchArtists('q2');
        final f3 = api.searchArtists('q3');

        final results = await Future.wait([f1, f2, f3]);

        expect(results[0][0].id, 'q1');
        expect(results[1][0].id, 'q2');
        expect(results[2][0].id, 'q3');
      });
    });
  });
}
