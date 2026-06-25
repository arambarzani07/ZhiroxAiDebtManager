import '../../core/network/api_client.dart';

class CustomerService {
  CustomerService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> listCustomers() async {
    final data = await _apiClient.get('/customers');
    final raw = data['data'] ?? data['customers'] ?? data['items'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getProfile(String customerId) async {
    return _apiClient.get('/customers/$customerId/profile');
  }

  Future<Map<String, dynamic>> createCustomer({
    required String fullNameKu,
    String? phone,
    String? note,
  }) async {
    final body = <String, dynamic>{
      'full_name_ku': fullNameKu.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'primary_phone': phone.trim(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    };
    return _apiClient.post('/customers', body);
  }
}
