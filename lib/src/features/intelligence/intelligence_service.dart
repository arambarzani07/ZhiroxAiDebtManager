import '../../core/network/api_client.dart';

class IntelligenceService {
  IntelligenceService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    return _apiClient.listFrom(data, ['data', 'items', 'records', 'messages', 'suggestions', 'approvals']);
  }

  Future<List<Map<String, dynamic>>> listBroadcasts() async {
    final data = await _apiClient.getAny(['/notifications/broadcasts', '/broadcasts', '/messages/broadcasts']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createBroadcast(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/notifications/broadcasts', body),
      MapEntry('/broadcasts', body),
      MapEntry('/messages/broadcasts', body),
    ]);
  }

  Future<List<Map<String, dynamic>>> listSuggestions() async {
    final data = await _apiClient.getAny(['/ai/suggestions', '/ai/recommendations', '/suggestions']);
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listPendingApprovals() async {
    final data = await _apiClient.getAny(['/approvals/pending', '/approval-requests/pending', '/approval-requests?status=pending']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> approve(String approvalId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/approvals/$approvalId/approve', body),
      MapEntry('/approval-requests/$approvalId/approve', body),
    ]);
  }

  Future<Map<String, dynamic>> reject(String approvalId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/approvals/$approvalId/reject', body),
      MapEntry('/approval-requests/$approvalId/reject', body),
    ]);
  }
}
