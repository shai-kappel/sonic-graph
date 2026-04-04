import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wikidata_response_model.dart';

class WikidataApi {
  static const String sparqlUrl = 'https://query.wikidata.org/sparql';
  static const String userAgent = 'SonicNomad/1.0.0 ( contact@sonicnomad.app )';

  final http.Client _client;
  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);
  final _requestQueue = <Completer<void>>[];
  bool _isProcessingQueue = false;

  WikidataApi({http.Client? client}) : _client = client ?? http.Client();

  Future<WikidataResponseModel> fetchArtistGenres(String mbid) async {
    final query = '''
SELECT ?artist ?artistLabel ?genre ?genreLabel ?superGenre ?superGenreLabel WHERE {
  ?artist wdt:P434 "$mbid" .
  ?artist wdt:P136 ?genre .
  OPTIONAL { ?genre wdt:P279 ?superGenre . }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
''';

    final response = await _post(query);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WikidataResponseModel.fromJson(data);
    } else if (response.statusCode == 429) {
      // Local throttling should handle this, but if it leaks, we retry once.
      await Future.delayed(const Duration(seconds: 5));
      final retryResponse = await _post(query);
      if (retryResponse.statusCode == 200) {
        return WikidataResponseModel.fromJson(json.decode(retryResponse.body));
      }
      throw Exception('Failed to fetch artist genres after retry (429)');
    } else {
      throw Exception(
        'Failed to fetch artist genres: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<http.Response> _post(String query) async {
    await _waitForSlot();

    final response = await _client.post(
      Uri.parse(sparqlUrl),
      headers: {
        'Accept': 'application/sparql-results+json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': userAgent,
      },
      body: {
        'query': query,
      },
    );

    return response;
  }

  Future<void> _waitForSlot() async {
    final completer = Completer<void>();
    _requestQueue.add(completer);

    if (!_isProcessingQueue) {
      _processQueue();
    }

    return completer.future;
  }

  Future<void> _processQueue() async {
    _isProcessingQueue = true;

    while (_requestQueue.isNotEmpty) {
      final now = DateTime.now();
      final timeSinceLastRequest = now.difference(_lastRequestTime);
      const minInterval = Duration(seconds: 1); // Respectful 1s between requests

      if (timeSinceLastRequest < minInterval) {
        await Future.delayed(minInterval - timeSinceLastRequest);
      }

      _lastRequestTime = DateTime.now();
      final completer = _requestQueue.removeAt(0);
      completer.complete();
    }

    _isProcessingQueue = false;
  }
}
