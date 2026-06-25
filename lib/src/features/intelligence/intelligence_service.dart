import '../../core/network/api_client.dart';

class IntelligenceService {
  IntelligenceService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['messages'] ?? data['suggestions'] ?? data['approvals'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listBroadcasts() async {
    final data = await _apiClient.get('/notifications/broadcasts');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createBroadcast(Map<String, dynamic> body) {
    return _apiClient.post('/notifications/broadcasts', body);
  }

  Future<List<Map<String, dynamic>>> listSuggestions() async {
    final data = await _apiClient.get('/ai/suggestions');
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listPendingApprovals() async {
    final data = await _apiClient.get('/approvals/pending');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> approve(String approvalId, Map<String, dynamic> body) {
    return _apiClient.post('/approvals/$approvalId/approve', body);
  }

  Future<Map<String, dynamic>> reject(String approvalId, Map<String, dynamic> body) {
    return _apiClient.post('/approvals/$approvalId/reject', body);
  }
}
