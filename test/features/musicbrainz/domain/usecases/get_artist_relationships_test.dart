import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/entities/artist.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/repositories/musicbrainz_repository.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/usecases/get_artist_relationships.dart';

class MockMusicBrainzRepository extends Mock implements MusicBrainzRepository {}

void main() {
  late GetArtistRelationships usecase;
  late MockMusicBrainzRepository mockRepository;

  setUp(() {
    mockRepository = MockMusicBrainzRepository();
    usecase = GetArtistRelationships(mockRepository);
  });

  const tMbid = 'a74b1b7f-71a5-4011-9441-d0b5e4122711';
  const tRelatedArtist = Artist(
    id: 'b74b1b7f-71a5-4011-9441-d0b5e4122712',
    name: 'Thom Yorke',
    sortName: 'Yorke, Thom',
  );
  const tRelation = ArtistRelation(
    type: 'member of band',
    direction: 'forward',
    targetType: 'artist',
    artist: tRelatedArtist,
  );
  const tArtistWithRelations = Artist(
    id: tMbid,
    name: 'Radiohead',
    sortName: 'Radiohead',
    relations: [tRelation],
  );

  test('should get artist relationships from the repository', () async {
    // arrange
    when(
      () => mockRepository.getArtist(any(), includes: any(named: 'includes')),
    ).thenAnswer((_) async => tArtistWithRelations);

    // act
    final result = await usecase.execute(tMbid);

    // assert
    expect(result, [tRelation]);
    verify(
      () => mockRepository.getArtist(tMbid, includes: ['artist-rels']),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when artist has no relations', () async {
    // arrange
    when(
      () => mockRepository.getArtist(any(), includes: any(named: 'includes')),
    ).thenAnswer(
      (_) async => const Artist(
        id: tMbid,
        name: 'Radiohead',
        sortName: 'Radiohead',
        relations: null,
      ),
    );

    // act
    final result = await usecase.execute(tMbid);

    // assert
    expect(result, []);
    verify(
      () => mockRepository.getArtist(tMbid, includes: ['artist-rels']),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
