import '../entities/artist.dart';
import '../repositories/musicbrainz_repository.dart';

class GetArtistRelationships {
  final MusicBrainzRepository repository;

  GetArtistRelationships(this.repository);

  Future<List<ArtistRelation>> execute(String mbid) async {
    final artist = await repository.getArtist(mbid, includes: ['artist-rels']);
    return artist.relations ?? [];
  }
}
