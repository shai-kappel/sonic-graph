class WikidataResponseModel {
  final List<WikidataBinding> bindings;

  WikidataResponseModel({required this.bindings});

  factory WikidataResponseModel.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>?;
    final bindingsJson = results?['bindings'] as List<dynamic>?;

    return WikidataResponseModel(
      bindings:
          bindingsJson
              ?.map((b) => WikidataBinding.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WikidataBinding {
  final String? artistUri;
  final String? artistLabel;
  final String? genreUri;
  final String? genreLabel;
  final String? superGenreUri;
  final String? superGenreLabel;

  WikidataBinding({
    this.artistUri,
    this.artistLabel,
    this.genreUri,
    this.genreLabel,
    this.superGenreUri,
    this.superGenreLabel,
  });

  factory WikidataBinding.fromJson(Map<String, dynamic> json) {
    return WikidataBinding(
      artistUri: _getValue(json['artist']),
      artistLabel: _getValue(json['artistLabel']),
      genreUri: _getValue(json['genre']),
      genreLabel: _getValue(json['genreLabel']),
      superGenreUri: _getValue(json['superGenre']),
      superGenreLabel: _getValue(json['superGenreLabel']),
    );
  }

  static String? _getValue(dynamic field) {
    if (field is Map<String, dynamic>) {
      return field['value'] as String?;
    }
    return null;
  }
}
