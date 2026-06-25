import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

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
    throw Exception(data['message']?.toString() ?? data['error']?.toString() ?? 'API error ${res.statusCode}');
  }
}
