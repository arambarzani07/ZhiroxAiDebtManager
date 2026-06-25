import '../../core/network/api_client.dart';

class CashService {
  CashService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['sessions'] ?? data['handovers'] ?? data['discrepancies'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getCurrentSession() {
    return _apiClient.getAny(['/cash/sessions/current', '/cash/current-session', '/cash-session/current']);
  }

  Future<List<Map<String, dynamic>>> listSessions() async {
    final data = await _apiClient.getAny(['/cash/sessions', '/cash-sessions']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> openSession(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/cash/sessions/open', body),
      MapEntry('/cash/sessions', body),
      MapEntry('/cash-sessions/open', body),
    ]);
  }

  Future<Map<String, dynamic>> closeCurrentSession(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/cash/sessions/current/close', body),
      MapEntry('/cash/current-session/close', body),
      MapEntry('/cash-sessions/current/close', body),
    ]);
  }

  Future<List<Map<String, dynamic>>> listHandovers() async {
    final data = await _apiClient.getAny(['/cash/handovers', '/cash-handovers']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createHandover(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/cash/handovers', body),
      MapEntry('/cash-handovers', body),
    ]);
  }

  Future<List<Map<String, dynamic>>> listDiscrepancies() async {
    final data = await _apiClient.getAny(['/cash/discrepancies', '/cash-discrepancies']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createDiscrepancy(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/cash/discrepancies', body),
      MapEntry('/cash-discrepancies', body),
    ]);
  }

  Future<Map<String, dynamic>> reconcileCurrentSession(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/cash/sessions/current/reconcile', body),
      MapEntry('/cash/current-session/reconcile', body),
      MapEntry('/cash-reconciliations', body),
    ]);
  }
}
