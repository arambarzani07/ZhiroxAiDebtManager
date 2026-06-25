import '../../core/network/api_client.dart';

class DebtService {
  DebtService(this._apiClient);

  final ApiClient _apiClient;
  ApiClient get apiClient => _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['ledger'] ?? data['accounts'] ?? data['cases'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listCustomerDebtAccounts(String customerId) async {
    final data = await _apiClient.getAny([
      '/customers/$customerId/debt-accounts',
      '/debt-accounts?customer_id=$customerId',
      '/debts/accounts?customer_id=$customerId',
    ]);
    return _listFrom(data);
  }

  Future<List<Map<String, dynamic>>> listCustomerDebtCases(String customerId) async {
    final data = await _apiClient.getAny([
      '/customers/$customerId/debt-cases',
      '/debt-cases?customer_id=$customerId',
      '/debts/cases?customer_id=$customerId',
    ]);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getDebtCase(String debtCaseId) {
    return _apiClient.getAny(['/debt-cases/$debtCaseId', '/debts/cases/$debtCaseId']);
  }

  Future<List<Map<String, dynamic>>> listCustomerLedger(String customerId) async {
    final data = await _apiClient.getAny([
      '/customers/$customerId/ledger',
      '/ledger?customer_id=$customerId',
      '/customers/$customerId/ledger-entries',
    ]);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createDebt(String customerId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/debt', body),
      MapEntry('/customers/$customerId/debts', body),
      MapEntry('/debts', {'customer_id': customerId, ...body}),
    ]);
  }

  Future<Map<String, dynamic>> requestCorrection(String debtCaseId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/debt-cases/$debtCaseId/correction-request', body),
      MapEntry('/debt-cases/$debtCaseId/corrections', body),
      MapEntry('/debt-corrections', {'debt_case_id': debtCaseId, ...body}),
    ]);
  }
}
