import '../../domain/models/genre.dart';
import '../../domain/repositories/wikidata_repository.dart';
import '../datasources/wikidata_api.dart';

class WikidataRepositoryImpl implements WikidataRepository {
  final WikidataApi _api;

  WikidataRepositoryImpl({required WikidataApi api}) : _api = api;

  @override
  Future<List<Genre>> getArtistGenres(String mbid) async {
    final response = await _api.fetchArtistGenres(mbid);

    return response.bindings.map((b) {
      return Genre(
        id: b.genreUri ?? 'unknown-genre',
        label: b.genreLabel ?? 'Unknown Genre',
        parentGenreId: b.superGenreUri,
        parentGenreLabel: b.superGenreLabel,
      );
    }).toList();
  }
}
