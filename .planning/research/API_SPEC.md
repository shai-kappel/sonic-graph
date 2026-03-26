# API Specification & Research: MusicBrainz & Wikidata

## MusicBrainz (Artist & Relationship Data)

### Rate Limiting
- **Limit:** 1 request per second per IP address.
- **Requirement:** Must provide a unique and descriptive `User-Agent` header (e.g., `SonicGraph/1.0.0 ( contact@example.com )`).
- **Strategy:**
    - Implement a client-side "leaky bucket" or queue to throttle requests.
    - Handle `503` and `429` errors with exponential backoff.
    - Cache-first strategy: Use local storage (SQLite/Hive) to minimize redundant calls.

### Efficient Lookups
Use the `inc=` parameter to bundle relationship data:
- `GET /ws/2/artist/<MBID>?inc=artist-rels+url-rels+label-rels&fmt=json`
- **artist-rels:** Band members, sub-projects, parent groups.
- **url-rels:** Wikipedia, Discogs, Social Media, Streaming links.
- **label-rels:** Associated record labels.
- **release-groups:** Artist's discography (albums/singles).

## Wikidata (Genre & Evolution Data)

### SPARQL Queries
Wikidata is used for the "macro-evolution" part of the graph (genre hierarchies).

#### 1. Fetching Genre Lineage (Ancestors)
To see where a genre evolved from (e.g., Grunge -> Alternative Rock -> Rock):
```sparql
SELECT ?parentGenre ?parentGenreLabel WHERE {
  wd:<GENRE_ID> wdt:P279+ ?parentGenre.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
```

#### 2. Fetching Genre Descendants (Children)
To see sub-genres or evolution branches:
```sparql
SELECT ?childGenre ?childGenreLabel WHERE {
  ?childGenre wdt:P279 wd:<GENRE_ID>.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
```

#### 3. Influence Connections (Non-Taxonomic)
To see non-strict evolution (e.g., Blues influenced Rock):
- **Influenced by (P737)**
- **Has influence (P1271)**

### Mapping MBID to Wikidata QID
MusicBrainz artists often have a `wikidata` link in their `url-rels`.
- If MBID is known, fetch `url-rels` and look for `https://www.wikidata.org/wiki/Qxxx`.
- Use the QID for SPARQL queries.

---
*Last updated: 2026-03-25*
