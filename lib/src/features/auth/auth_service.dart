import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;
  static const _tokenKey = 'zhirox_auth_token';

  Future<String?> restoreToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    _apiClient.token = token;
    return token;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String marketCode = ApiConfig.defaultMarketCode,
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _apiClient.token = token;
    return data;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', {});
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _apiClient.token = null;
  }

  Future<Map<String, dynamic>> me() => _apiClient.get('/auth/me');
}
