import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_nomad/features/wikidata/data/datasources/wikidata_api.dart';
import 'package:sonic_nomad/features/wikidata/data/models/wikidata_response_model.dart';
import 'package:sonic_nomad/features/wikidata/data/repositories/wikidata_repository_impl.dart';
import 'package:sonic_nomad/features/wikidata/domain/models/genre.dart';

class MockWikidataApi extends Mock implements WikidataApi {}

void main() {
  late WikidataRepositoryImpl repository;
  late MockWikidataApi mockApi;

  setUp(() {
    mockApi = MockWikidataApi();
    repository = WikidataRepositoryImpl(api: mockApi);
  });

  group('getArtistGenres', () {
    const tMbid = 'mbid-123';
    final tBinding = WikidataBinding(
      artistUri: 'Q123',
      artistLabel: 'Artist',
      genreUri: 'Q456',
      genreLabel: 'Rock',
      superGenreUri: 'Q789',
      superGenreLabel: 'Music',
    );
    final tResponse = WikidataResponseModel(bindings: [tBinding]);

    test(
      'should return a list of genres when the call to API is successful',
      () async {
        // arrange
        when(
          () => mockApi.fetchArtistGenres(any()),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getArtistGenres(tMbid);

        // assert
        expect(result, isA<List<Genre>>());
        expect(result.length, 1);
        expect(result[0].id, 'Q456');
        expect(result[0].label, 'Rock');
        expect(result[0].parentGenreId, 'Q789');
        expect(result[0].parentGenreLabel, 'Music');
        verify(() => mockApi.fetchArtistGenres(tMbid)).called(1);
      },
    );

    test('should handle missing fields in bindings gracefully', () async {
      // arrange
      final tIncompleteBinding = WikidataBinding(
        artistUri: null,
        artistLabel: null,
        genreUri: null,
        genreLabel: null,
        superGenreUri: null,
        superGenreLabel: null,
      );
      when(() => mockApi.fetchArtistGenres(any())).thenAnswer(
        (_) async => WikidataResponseModel(bindings: [tIncompleteBinding]),
      );

      // act
      final result = await repository.getArtistGenres(tMbid);

      // assert
      expect(result.length, 1);
      expect(result[0].id, 'unknown-genre');
      expect(result[0].label, 'Unknown Genre');
      expect(result[0].parentGenreId, isNull);
    });

    test('should throw an exception when the call to API fails', () async {
      // arrange
      when(
        () => mockApi.fetchArtistGenres(any()),
      ).thenThrow(Exception('API Error'));

      // act
      final call = repository.getArtistGenres;

      // assert
      expect(() => call(tMbid), throwsException);
    });
  });
}
