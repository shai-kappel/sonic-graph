import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mb_artist_model.dart';

class MusicBrainzApi {
  static const String baseUrl = 'https://musicbrainz.org/ws/2';
  static const String userAgent = 'SonicNomad/1.0.0 ( contact@sonicnomad.app )';

  final http.Client _client;
  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);
  final _requestQueue = <Completer<void>>[];
  bool _isProcessingQueue = false;

  MusicBrainzApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<MBArtistModel>> searchArtists(String query) async {
    final response = await _get('/artist', queryParams: {'query': query});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final artists = (data['artists'] as List)
          .map((json) => MBArtistModel.fromJson(json))
          .toList();
      return artists;
    } else {
      throw Exception(
        'Failed to search artists: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<MBArtistModel> getArtist(String mbid, {List<String>? includes}) async {
    final queryParams = includes != null
        ? {'inc': includes.join('+')}
        : <String, String>{};
    final response = await _get('/artist/$mbid', queryParams: queryParams);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MBArtistModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to get artist: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<http.Response> _get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    await _waitForSlot();

    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: {...?queryParams, 'fmt': 'json'});

    final response = await _client.get(uri, headers: {'User-Agent': userAgent});

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
      const minInterval = Duration(seconds: 1);

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
