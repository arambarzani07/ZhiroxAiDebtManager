import '../../core/network/api_client.dart';

class PlatformService {
  PlatformService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['markets'] ?? data['plans'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getHealth() {
    return _apiClient.get('/system-owner/platform-health');
  }

  Future<List<Map<String, dynamic>>> listMarkets() async {
    final data = await _apiClient.get('/system-owner/markets');
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listPlans() async {
    final data = await _apiClient.get('/system-owner/licenses');
    return _listFrom(data);
  }
}
