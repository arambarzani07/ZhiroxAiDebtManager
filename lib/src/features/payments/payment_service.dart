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
    final amount = body['amount'];
    final currency = body['currency'];
    final note = body['note'];
    final altBody = <String, dynamic>{
      if (amount != null) 'paid_amount': amount,
      if (currency != null) 'currency': currency,
      if (note != null) 'description': note,
    };
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/payment', body),
      MapEntry('/customers/$customerId/payment', altBody),
      MapEntry('/customers/$customerId/payments', body),
      MapEntry('/payments', {'customer_id': customerId, ...body}),
      MapEntry('/payments', {'customer_id': customerId, ...altBody}),
    ]);
  }

  Future<List<Map<String, dynamic>>> listAllocations(String paymentId) async {
    final data = await _apiClient.getAny([
      '/payments/$paymentId/allocations',
      '/payment-allocations?payment_id=$paymentId',
      '/payments/$paymentId/allocation',
    ]);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getReceipt(String paymentId) {
    return _apiClient.getAny(['/payments/$paymentId/receipt', '/receipts/$paymentId', '/receipt?payment_id=$paymentId']);
  }

  Future<List<Map<String, dynamic>>> listReceiptDeliveryLogs(String paymentId) async {
    final data = await _apiClient.getAny([
      '/payments/$paymentId/receipt-delivery-logs',
      '/receipt-delivery-logs?payment_id=$paymentId',
      '/receipts/$paymentId/delivery-logs',
    ]);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getCustomerStatement(
    String customerId, {
    String? fromDate,
    String? toDate,
    String? currency,
  }) {
    final query = <String>['customer_id=${Uri.encodeComponent(customerId)}'];
    if (fromDate != null && fromDate.trim().isNotEmpty) query.add('from=${Uri.encodeComponent(fromDate.trim())}');
    if (toDate != null && toDate.trim().isNotEmpty) query.add('to=${Uri.encodeComponent(toDate.trim())}');
    if (currency != null && currency.trim().isNotEmpty) query.add('currency=${Uri.encodeComponent(currency.trim())}');
    final suffix = query.join('&');
    return _apiClient.getAny([
      '/customers/$customerId/statement?${suffix.replaceFirst('customer_id=${Uri.encodeComponent(customerId)}&', '')}',
      '/statements/customer?$suffix',
      '/customer-statements?$suffix',
    ]);
  }
}
