import '../entities/artist.dart';

abstract class MusicBrainzRepository {
  Future<List<Artist>> searchArtists(String query);
  Future<Artist> getArtist(String mbid, {List<String> includes = const []});
}
