import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/entities/artist.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/repositories/musicbrainz_repository.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/usecases/search_artists.dart';

class MockMusicBrainzRepository extends Mock implements MusicBrainzRepository {}

void main() {
  late SearchArtists usecase;
  late MockMusicBrainzRepository mockRepository;

  setUp(() {
    mockRepository = MockMusicBrainzRepository();
    usecase = SearchArtists(mockRepository);
  });

  final List<Artist> tArtists = [
    const Artist(
      id: '1',
      name: 'Test Artist',
      sortName: 'Artist, Test',
      type: 'Person',
      country: 'US',
      disambiguation: 'Test',
      score: 100,
    ),
  ];

  test('should get artists from the repository', () async {
    // arrange
    when(
      () => mockRepository.searchArtists(any()),
    ).thenAnswer((_) async => tArtists);

    // act
    final result = await usecase.execute('test');

    // assert
    expect(result, tArtists);
    verify(() => mockRepository.searchArtists('test'));
    verifyNoMoreInteractions(mockRepository);
  });
}
