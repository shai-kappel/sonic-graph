import '../models/genre.dart';

abstract class WikidataRepository {
  Future<List<Genre>> getArtistGenres(String mbid);
}
