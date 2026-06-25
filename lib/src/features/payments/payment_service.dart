import '../../core/network/api_client.dart';

class PaymentService {
  PaymentService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['records'] ?? data['allocations'] ?? data['logs'] ?? [];
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

  Future<Map<String, dynamic>> getReceipt(String paymentId) {
    return _apiClient.get('/payments/$paymentId/receipt');
  }

  Future<List<Map<String, dynamic>>> listReceiptDeliveryLogs(String paymentId) async {
    final data = await _apiClient.get('/payments/$paymentId/receipt-delivery-logs');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createReceiptDraft(String paymentId, Map<String, dynamic> body) {
    return _apiClient.post('/payments/$paymentId/receipt-draft', body);
  }

  Future<Map<String, dynamic>> getCustomerStatement(
    String customerId, {
    String? fromDate,
    String? toDate,
    String? currency,
  }) {
    final query = <String>[];
    if (fromDate != null && fromDate.trim().isNotEmpty) query.add('from=${Uri.encodeComponent(fromDate.trim())}');
    if (toDate != null && toDate.trim().isNotEmpty) query.add('to=${Uri.encodeComponent(toDate.trim())}');
    if (currency != null && currency.trim().isNotEmpty) query.add('currency=${Uri.encodeComponent(currency.trim())}');
    final suffix = query.isEmpty ? '' : '?${query.join('&')}';
    return _apiClient.get('/customers/$customerId/statement$suffix');
  }
}
