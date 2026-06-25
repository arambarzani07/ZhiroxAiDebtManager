import '../../core/network/api_client.dart';

class DebtService {
  DebtService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['ledger'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listCustomerDebtAccounts(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/debt-accounts');
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listCustomerDebtCases(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/debt-cases');
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listCustomerLedger(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/ledger');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createDebt(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/debt', body);
  }
}
