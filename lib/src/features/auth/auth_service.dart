import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;
  static const _tokenKey = 'zhirox_auth_token';
  static const _sessionKindKey = 'zhirox_session_kind';

  ApiClient get apiClient => _apiClient;

  Future<String?> restoreToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    _apiClient.token = token;
    return token;
  }

  Future<String> restoreSessionKind() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKindKey) ?? 'tenant';
  }

  Future<void> _storeSession(String token, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_sessionKindKey, kind);
    _apiClient.token = token;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String marketCode,
  }) async {
    final data = await _apiClient.post('/auth/login', {
      'email': email.trim(),
      'password': password,
      'market_code': marketCode.trim(),
    });
    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('Token not returned from server');
    }
    await _storeSession(token, 'tenant');
    return data;
  }

  Future<Map<String, dynamic>> loginSystemOwner({
    required String email,
    required String password,
  }) async {
    final data = await _apiClient.post('/system-owner/auth/login', {
      'email': email.trim(),
      'password': password,
    });
    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('Token not returned from server');
    }
    await _storeSession(token, 'owner');
    return data;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', {});
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_sessionKindKey);
    _apiClient.token = null;
  }

  Future<Map<String, dynamic>> me() => _apiClient.get('/auth/me');
}
