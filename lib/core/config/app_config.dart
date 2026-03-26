enum Environment { dev, prod }

class AppConfig {
  static late Environment environment;

  static bool get isDev => environment == Environment.dev;
  static bool get isProd => environment == Environment.prod;

  static String get appName => isDev ? 'SonicGraph Dev' : 'SonicGraph';

  // Environment variables via --dart-define-from-file
  // Usage: flutter run --dart-define-from-file=.env
  static const String musicBrainzUserAgent = String.fromEnvironment(
    'MUSICBRAINZ_USER_AGENT',
    defaultValue: 'SonicGraph/1.0 (dev@localhost)',
  );

  static const String wikidataSparqlEndpoint = String.fromEnvironment(
    'WIKIDATA_SPARQL_ENDPOINT',
    defaultValue: 'https://query.wikidata.org/sparql',
  );
}
