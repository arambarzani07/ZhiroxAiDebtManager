import '../../core/network/api_client.dart';

class ReportService {
  ReportService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['customers'] ?? data['debtors'] ?? data['employees'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getDebtSummary() {
    return _apiClient.getAny(['/reports/debt-summary', '/reports/debts/summary', '/dashboard/debt-summary']);
  }

  Future<List<Map<String, dynamic>>> listTopCustomers() async {
    final data = await _apiClient.getAny(['/reports/top-debtors', '/reports/top-customers', '/reports/customers/top']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getPaymentStatusReport() {
    return _apiClient.getAny(['/reports/paid-unpaid', '/reports/payment-status', '/reports/payments/status']);
  }

  Future<Map<String, dynamic>> getCashReport() {
    return _apiClient.getAny(['/reports/cash', '/reports/cash-summary', '/cash/report']);
  }

  Future<List<Map<String, dynamic>>> listEmployeeActivity() async {
    final data = await _apiClient.getAny(['/reports/employee-activity', '/employee-activity', '/reports/employees/activity']);
    return _listFrom(data);
  }
}
