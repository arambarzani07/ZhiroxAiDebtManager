import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  bool get canTryNextEndpoint => statusCode == 404 || statusCode == 405;
  bool get canTryNextWrite => statusCode == 400 || statusCode == 404 || statusCode == 405 || statusCode == 422;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  String? token;

  Map<String, String> headers({bool hasBody = true}) {
    final map = <String, String>{'Accept': 'application/json'};
    if (hasBody) map['Content-Type'] = 'application/json';
    if (token != null && token!.isNotEmpty) map['Authorization'] = 'Bearer $token';
    return map;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final res = await _httpClient.get(ApiConfig.apiUri(path), headers: headers(hasBody: false));
    return decode(res);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await _httpClient.post(ApiConfig.apiUri(path), headers: headers(), body: jsonEncode(body));
    return decode(res);
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) async {
    final res = await _httpClient.patch(ApiConfig.apiUri(path), headers: headers(), body: jsonEncode(body));
    return decode(res);
  }

  Future<Map<String, dynamic>> getAny(List<String> paths) async {
    ApiException? lastError;
    for (final path in paths) {
      try {
        return await get(path);
      } on ApiException catch (e) {
        if (!e.canTryNextEndpoint) rethrow;
        lastError = e;
      }
    }
    throw lastError ?? const ApiException(404, 'No backend endpoint matched');
  }

  Future<Map<String, dynamic>> postAny(List<MapEntry<String, Map<String, dynamic>>> attempts) async {
    ApiException? lastError;
    for (final attempt in attempts) {
      try {
        return await post(attempt.key, attempt.value);
      } on ApiException catch (e) {
        if (!e.canTryNextWrite) rethrow;
        lastError = e;
      }
    }
    throw lastError ?? const ApiException(404, 'No backend endpoint matched');
  }

  Future<Map<String, dynamic>> patchAny(List<MapEntry<String, Map<String, dynamic>>> attempts) async {
    ApiException? lastError;
    for (final attempt in attempts) {
      try {
        return await patch(attempt.key, attempt.value);
      } on ApiException catch (e) {
        if (!e.canTryNextWrite) rethrow;
        lastError = e;
      }
    }
    throw lastError ?? const ApiException(404, 'No backend endpoint matched');
  }

  List<Map<String, dynamic>> listFrom(Map<String, dynamic> data, List<String> keys) {
    final raw = _findList(data, keys);
    if (raw == null) return [];
    return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  List<dynamic>? _findList(dynamic value, List<String> keys) {
    if (value is List) return value;
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      for (final key in keys) {
        final nested = map[key];
        if (nested is List) return nested;
        if (nested is Map) {
          final found = _findList(nested, keys);
          if (found != null) return found;
        }
      }
      for (final key in const ['data', 'result', 'payload']) {
        final nested = map[key];
        if (nested is List) return nested;
        if (nested is Map) {
          final found = _findList(nested, keys);
          if (found != null) return found;
        }
      }
    }
    return null;
  }

  Map<String, dynamic> decode(http.Response res) {
    final text = res.body.trim();
    final decoded = text.isEmpty ? <String, dynamic>{} : jsonDecode(text);
    final data = decoded is Map<String, dynamic>
        ? decoded
        : decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : decoded is List
                ? <String, dynamic>{'data': decoded}
                : <String, dynamic>{'data': decoded};

    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw ApiException(res.statusCode, data['message']?.toString() ?? data['error']?.toString() ?? 'API error ${res.statusCode}');
  }
}
