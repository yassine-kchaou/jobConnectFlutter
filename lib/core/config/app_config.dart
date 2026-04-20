// Configuration d'environnement pour JobConnect
// À utiliser dans l'application pour gérer différents environnements

enum AppEnvironment { development, staging, production }

class AppConfig {
  static const AppEnvironment environment = AppEnvironment.development;

  // URLs API par environnement
  static const Map<AppEnvironment, String> apiBaseUrls = {
    AppEnvironment.development: 'http://localhost:3000/',
    AppEnvironment.staging: 'https://api-staging.jobconnect.com/api',
    AppEnvironment.production: 'https://api.jobconnect.com/api',
  };

  // Firebase Config (si utilisé)
  static const Map<AppEnvironment, Map<String, String>> firebaseConfig = {
    AppEnvironment.development: {
      'apiKey': 'YOUR_DEV_API_KEY',
      'projectId': 'jobconnect-dev',
      'appId': 'YOUR_DEV_APP_ID',
    },
    AppEnvironment.staging: {
      'apiKey': 'YOUR_STAGING_API_KEY',
      'projectId': 'jobconnect-staging',
      'appId': 'YOUR_STAGING_APP_ID',
    },
    AppEnvironment.production: {
      'apiKey': 'YOUR_PROD_API_KEY',
      'projectId': 'jobconnect-prod',
      'appId': 'YOUR_PROD_APP_ID',
    },
  };

  // Logging activé ?
  static const Map<AppEnvironment, bool> enableLogging = {
    AppEnvironment.development: true,
    AppEnvironment.staging: true,
    AppEnvironment.production: false,
  };

  // Cache enabled ?
  static const Map<AppEnvironment, bool> enableCache = {
    AppEnvironment.development: true,
    AppEnvironment.staging: true,
    AppEnvironment.production: true,
  };

  // Erreurs détaillées ?
  static const Map<AppEnvironment, bool> showDetailedErrors = {
    AppEnvironment.development: true,
    AppEnvironment.staging: true,
    AppEnvironment.production: false,
  };

  // Getters pour l'environnement courant
  static String get apiBaseUrl =>
      apiBaseUrls[environment] ?? apiBaseUrls[AppEnvironment.development]!;
  static bool get isLoggingEnabled => enableLogging[environment] ?? false;
  static bool get isCacheEnabled => enableCache[environment] ?? true;
  static bool get showDetailedErrorsEnabled =>
      showDetailedErrors[environment] ?? false;

  static bool get isDevelopment => environment == AppEnvironment.development;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isProduction => environment == AppEnvironment.production;

  // Version de l'app
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;

  // Fichiers
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedFileExtensions = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png',
  ];
}

// Logger simple pour différencier les logs par environnement
class AppLogger {
  static void log(String message, {String? tag}) {
    if (!AppConfig.isLoggingEnabled) return;

    final prefix = tag != null ? '[$tag]' : '[APP]';
    print('$prefix $message');
  }

  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!AppConfig.isLoggingEnabled) return;

    final prefix = tag != null ? '[$tag]' : '[ERROR]';
    print('$prefix $message');
    if (error != null) print('  Error: $error');
    if (stackTrace != null && AppConfig.isDevelopment) {
      print('  StackTrace: $stackTrace');
    }
  }

  static void info(String message, {String? tag}) {
    log('[INFO] $message', tag: tag);
  }

  static void debug(String message, {String? tag}) {
    if (!AppConfig.isDevelopment) return;
    log('[DEBUG] $message', tag: tag);
  }
}
