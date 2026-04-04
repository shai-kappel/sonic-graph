import '../entities/artist.dart';
import '../repositories/musicbrainz_repository.dart';

class SearchArtists {
  final MusicBrainzRepository repository;

  SearchArtists(this.repository);

  Future<List<Artist>> execute(String query) async {
    return repository.searchArtists(query);
  }
}
