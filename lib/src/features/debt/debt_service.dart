import '../../core/network/api_client.dart';

class DebtService {
  DebtService(this._apiClient);

  final ApiClient _apiClient;
  ApiClient get apiClient => _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    return _apiClient.listFrom(data, ['data', 'items', 'records', 'ledger', 'accounts', 'cases']);
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
    final amount = body['amount'];
    final currency = body['currency'];
    final dueDate = body['due_date'];
    final note = body['note'];
    final debtCaseBody = <String, dynamic>{
      if (amount != null) 'principal_amount': amount,
      if (currency != null) 'currency': currency,
      if (dueDate != null) 'due_at': dueDate,
      if (note != null) 'description': note,
    };
    final loanBody = <String, dynamic>{
      if (amount != null) 'total_amount': amount,
      if (currency != null) 'currency': currency,
      if (dueDate != null) 'due_date': dueDate,
      if (note != null) 'notes': note,
    };
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/debt', body),
      MapEntry('/customers/$customerId/debt', debtCaseBody),
      MapEntry('/customers/$customerId/debts', body),
      MapEntry('/customers/$customerId/debts', loanBody),
      MapEntry('/debts', {'customer_id': customerId, ...body}),
      MapEntry('/debts', {'customer_id': customerId, ...loanBody}),
    ]);
  }

  Future<Map<String, dynamic>> requestCorrection(String debtCaseId, Map<String, dynamic> body) {
    final generic = <String, dynamic>{
      if (body['reason'] != null) 'note': body['reason'],
      if (body['note'] != null) 'description': body['note'],
    };
    return _apiClient.postAny([
      MapEntry('/debt-cases/$debtCaseId/correction-request', body),
      MapEntry('/debt-cases/$debtCaseId/correction-request', generic),
      MapEntry('/debt-cases/$debtCaseId/corrections', body),
      MapEntry('/debt-corrections', {'debt_case_id': debtCaseId, ...body}),
      MapEntry('/debt-corrections', {'debt_case_id': debtCaseId, ...generic}),
    ]);
  }
}
