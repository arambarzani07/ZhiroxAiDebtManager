import '../../core/network/api_client.dart';

class PlatformService {
  PlatformService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['markets'] ?? data['plans'] ?? data['licenses'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getHealth() {
    return _apiClient.getAny(['/system-owner/platform-health', '/system-owner/health', '/platform/health', '/healthz']);
  }

  Future<List<Map<String, dynamic>>> listMarkets() async {
    final data = await _apiClient.getAny(['/system-owner/markets', '/platform/markets', '/owner/markets', '/markets']);
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listPlans() async {
    final data = await _apiClient.getAny(['/system-owner/licenses', '/system-owner/plans', '/platform/licenses', '/platform/plans', '/licenses']);
    return _listFrom(data);
  }
}
