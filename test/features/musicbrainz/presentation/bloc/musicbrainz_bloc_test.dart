import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/entities/artist.dart';
import 'package:sonic_nomad/features/musicbrainz/domain/usecases/search_artists.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/bloc/musicbrainz_bloc.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/bloc/musicbrainz_event.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/bloc/musicbrainz_state.dart';

class MockSearchArtists extends Mock implements SearchArtists {}

void main() {
  late MusicBrainzBloc bloc;
  late MockSearchArtists mockSearchArtists;

  setUp(() {
    mockSearchArtists = MockSearchArtists();
    bloc = MusicBrainzBloc(searchArtists: mockSearchArtists);
  });

  tearDown(() {
    bloc.close();
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

  test('initial state should be MusicBrainzInitial', () {
    expect(bloc.state, MusicBrainzInitial());
  });

  blocTest<MusicBrainzBloc, MusicBrainzState>(
    'emits [Loading, Loaded] when search is successful',
    build: () {
      when(
        () => mockSearchArtists.execute(any()),
      ).thenAnswer((_) async => tArtists);
      return bloc;
    },
    act: (bloc) => bloc.add(const SearchArtistsEvent('test')),
    wait: const Duration(milliseconds: 600), // Account for debounce
    expect: () => [MusicBrainzLoading(), MusicBrainzLoaded(tArtists)],
    verify: (_) {
      verify(() => mockSearchArtists.execute('test')).called(1);
    },
  );

  blocTest<MusicBrainzBloc, MusicBrainzState>(
    'emits [Loading, Error] when search fails',
    build: () {
      when(
        () => mockSearchArtists.execute(any()),
      ).thenThrow(Exception('failure'));
      return bloc;
    },
    act: (bloc) => bloc.add(const SearchArtistsEvent('test')),
    wait: const Duration(milliseconds: 600), // Account for debounce
    expect: () => [
      MusicBrainzLoading(),
      const MusicBrainzError('Exception: failure'),
    ],
  );

  blocTest<MusicBrainzBloc, MusicBrainzState>(
    'emits [MusicBrainzInitial] when query is empty',
    build: () {
      return bloc;
    },
    act: (bloc) => bloc.add(const SearchArtistsEvent('')),
    wait: const Duration(milliseconds: 600), // Account for debounce
    expect: () => [MusicBrainzInitial()],
  );

  blocTest<MusicBrainzBloc, MusicBrainzState>(
    'emits [MusicBrainzInitial] when ClearSearchEvent is added',
    build: () {
      return bloc;
    },
    act: (bloc) => bloc.add(ClearSearchEvent()),
    expect: () => [MusicBrainzInitial()],
  );
}
