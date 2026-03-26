enum Environment { dev, prod }

class AppConfig {
  static late Environment environment;

  static bool get isDev => environment == Environment.dev;
  static bool get isProd => environment == Environment.prod;

  static String get appName => isDev ? 'SonicGraph Dev' : 'SonicGraph';
}
