import '../../domain/entities/artist.dart';
import '../../domain/repositories/musicbrainz_repository.dart';
import '../datasources/musicbrainz_api.dart';

class MusicBrainzRepositoryImpl implements MusicBrainzRepository {
  final MusicBrainzApi _api;

  MusicBrainzRepositoryImpl(this._api);

  @override
  Future<List<Artist>> searchArtists(String query) async {
    final models = await _api.searchArtists(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Artist> getArtist(
    String mbid, {
    List<String> includes = const [],
  }) async {
    final model = await _api.getArtist(mbid, includes: includes);
    return model.toEntity();
  }
}
