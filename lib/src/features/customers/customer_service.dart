import '../../core/network/api_client.dart';

class CustomerService {
  CustomerService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['customers'] ?? data['records'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listCustomers() async {
    final data = await _apiClient.get('/customers');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getProfile(String customerId) {
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

  Future<Map<String, dynamic>> updateCustomer(String customerId, Map<String, dynamic> body) {
    return _apiClient.patch('/customers/$customerId', body);
  }

  Future<Map<String, dynamic>> requestCreditLimitReview(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/credit-limit-review', body);
  }

  Future<Map<String, dynamic>> getContactHealth(String customerId) {
    return _apiClient.get('/customers/$customerId/contact-health');
  }

  Future<List<Map<String, dynamic>>> findDuplicates(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/duplicates');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> requestMerge(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/merge-request', body);
  }

  Future<List<Map<String, dynamic>>> listContacts(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/contacts');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createContact(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/contact', body);
  }

  Future<List<Map<String, dynamic>>> listGuarantors(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/guarantors');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createGuarantor(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/guarantor', body);
  }

  Future<List<Map<String, dynamic>>> listEvidence(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/evidence');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createEvidence(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/evidence', body);
  }

  Future<List<Map<String, dynamic>>> listStatusHistory(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/status-history');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createStatus(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/status', body);
  }

  Future<List<Map<String, dynamic>>> listCreditLocks(String customerId) async {
    final data = await _apiClient.get('/customers/$customerId/credit-locks');
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createCreditLock(String customerId, Map<String, dynamic> body) {
    return _apiClient.post('/customers/$customerId/credit-lock', body);
  }
}
