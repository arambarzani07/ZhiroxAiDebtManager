import '../../core/network/api_client.dart';

class PaymentService {
  PaymentService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['allocations'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> receivePayment(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/payment', body);
  }

  Future<List<Map<String, dynamic>>> listAllocations(String paymentId) async {
    final data = await _apiClient.get('/payments/$paymentId/allocations');
    return _listFrom(data);
  }
}
