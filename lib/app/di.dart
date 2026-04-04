import 'package:get_it/get_it.dart';
import '../features/musicbrainz/data/datasources/musicbrainz_api.dart';
import '../features/musicbrainz/data/repositories/musicbrainz_repository_impl.dart';
import '../features/musicbrainz/domain/repositories/musicbrainz_repository.dart';
import '../features/musicbrainz/domain/usecases/search_artists.dart';
import '../features/musicbrainz/domain/usecases/get_artist_relationships.dart';
import '../features/musicbrainz/presentation/bloc/musicbrainz_bloc.dart';
import '../features/canvas/presentation/bloc/canvas_bloc.dart';
import '../features/wikidata/data/datasources/wikidata_api.dart';
import '../features/wikidata/data/repositories/wikidata_repository_impl.dart';
import '../features/wikidata/domain/repositories/wikidata_repository.dart';
import '../features/wikidata/domain/usecases/get_macro_evolution.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  getIt.registerLazySingleton<MusicBrainzApi>(() => MusicBrainzApi());
  getIt.registerLazySingleton<WikidataApi>(() => WikidataApi());

  // Repositories
  getIt.registerLazySingleton<MusicBrainzRepository>(
    () => MusicBrainzRepositoryImpl(getIt<MusicBrainzApi>()),
  );
  getIt.registerLazySingleton<WikidataRepository>(
    () => WikidataRepositoryImpl(api: getIt<WikidataApi>()),
  );

  // Usecases
  getIt.registerLazySingleton<SearchArtists>(
    () => SearchArtists(getIt<MusicBrainzRepository>()),
  );
  getIt.registerLazySingleton<GetArtistRelationships>(
    () => GetArtistRelationships(getIt<MusicBrainzRepository>()),
  );
  getIt.registerLazySingleton<GetMacroEvolution>(
    () => GetMacroEvolution(getIt<WikidataRepository>()),
  );

  // BLoCs
  getIt.registerFactory<MusicBrainzBloc>(
    () => MusicBrainzBloc(searchArtists: getIt<SearchArtists>()),
  );
  getIt.registerFactory<CanvasBloc>(
    () => CanvasBloc(
      getArtistRelationships: getIt<GetArtistRelationships>(),
      getMacroEvolution: getIt<GetMacroEvolution>(),
    ),
  );
}
