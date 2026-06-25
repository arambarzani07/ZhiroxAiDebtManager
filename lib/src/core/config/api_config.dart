class ApiConfig {
  const ApiConfig._();

  static const String productionRootUrl = 'https://database-builder-arambarzani152.replit.app';
  static const String productionApiBaseUrl = '$productionRootUrl/api';
  static const String healthCheckPath = '/healthz';

  static Uri apiUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$productionApiBaseUrl$normalizedPath');
  }
}
