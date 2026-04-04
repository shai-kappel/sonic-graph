import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_nomad/features/wikidata/domain/models/genre.dart';
import 'package:sonic_nomad/features/wikidata/domain/repositories/wikidata_repository.dart';
import 'package:sonic_nomad/features/wikidata/domain/usecases/get_macro_evolution.dart';

class MockWikidataRepository extends Mock implements WikidataRepository {}

void main() {
  late GetMacroEvolution usecase;
  late MockWikidataRepository mockRepository;

  setUp(() {
    mockRepository = MockWikidataRepository();
    usecase = GetMacroEvolution(mockRepository);
  });

  const tArtistId = 'artist-123';
  const tGenres = [
    Genre(
      id: 'g1',
      label: 'Rock',
      parentGenreId: 'p1',
      parentGenreLabel: 'Music',
    ),
    Genre(
      id: 'g2',
      label: 'Jazz',
      parentGenreId: 'p1',
      parentGenreLabel: 'Music',
    ),
  ];

  test(
    'should return nodes and edges for artist genres and their parents',
    () async {
      // arrange
      when(
        () => mockRepository.getArtistGenres(any()),
      ).thenAnswer((_) async => tGenres);

      // act
      final result = await usecase.execute(tArtistId);

      // assert
      expect(result.nodes.length, 3); // Rock, Jazz, Music
      expect(
        result.edges.length,
        4,
      ); // Artist->Rock, Rock->Music, Artist->Jazz, Jazz->Music

      final nodeIds = result.nodes.map((n) => n.id).toSet();
      expect(nodeIds, containsAll(['g1', 'g2', 'p1']));

      final edgeToIds = result.edges.map((e) => e.toId).toList();
      expect(edgeToIds, containsAll(['g1', 'p1', 'g2', 'p1']));

      verify(() => mockRepository.getArtistGenres(tArtistId)).called(1);
    },
  );

  test(
    'should deduplicate nodes and edges when multiple genres share a parent',
    () async {
      final tDuplicateGenres = [
        const Genre(
          id: 'g1',
          label: 'Rock',
          parentGenreId: 'p1',
          parentGenreLabel: 'Music',
        ),
        const Genre(
          id: 'g1',
          label: 'Rock',
          parentGenreId: 'p1',
          parentGenreLabel: 'Music',
        ),
      ];

      when(
        () => mockRepository.getArtistGenres(any()),
      ).thenAnswer((_) async => tDuplicateGenres);

      final result = await usecase.execute(tArtistId);

      expect(result.nodes.length, 2); // Rock, Music
      expect(result.edges.length, 2); // Artist->Rock, Rock->Music
    },
  );
}
