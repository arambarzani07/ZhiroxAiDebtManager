import '../../core/network/api_client.dart';

class PlatformService {
  PlatformService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    return _apiClient.listFrom(data, ['data', 'items', 'records', 'markets', 'plans', 'licenses']);
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
