import '../../core/network/api_client.dart';

class ReportService {
  ReportService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getDebtSummary() {
    return _apiClient.get('/reports/debt-summary');
  }

  Future<List<Map<String, dynamic>>> listTopCustomers() async {
    final data = await _apiClient.get('/reports/top-customers');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getPaymentStatusReport() {
    return _apiClient.get('/reports/payment-status');
  }

  Future<Map<String, dynamic>> getCashReport() {
    return _apiClient.get('/reports/cash');
  }

  Future<List<Map<String, dynamic>>> listEmployeeActivity() async {
    final data = await _apiClient.get('/reports/employee-activity');
    return _listFrom(data);
  }
}
