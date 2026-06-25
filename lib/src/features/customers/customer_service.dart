import '../../core/network/api_client.dart';

class CustomerService {
  CustomerService(this._apiClient);

  final ApiClient _apiClient;
  ApiClient get apiClient => _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    final raw = data['data'] ?? data['items'] ?? data['customers'] ?? data['records'] ?? [];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listCustomers() async {
    final data = await _apiClient.getAny(['/customers', '/customer']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> getProfile(String customerId) {
    return _apiClient.getAny(['/customers/$customerId/profile', '/customers/$customerId', '/customer/$customerId/profile']);
  }

  Future<Map<String, dynamic>> createCustomer({
    required String fullNameKu,
    String? phone,
    String? note,
  }) async {
    final kuBody = <String, dynamic>{
      'full_name_ku': fullNameKu.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'primary_phone': phone.trim(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    };
    final simpleBody = <String, dynamic>{
      'full_name': fullNameKu.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    };
    final nameBody = <String, dynamic>{
      'name': fullNameKu.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone_number': phone.trim(),
      if (note != null && note.trim().isNotEmpty) 'notes': note.trim(),
    };
    return _apiClient.postAny([
      MapEntry('/customers', kuBody),
      MapEntry('/customers', simpleBody),
      MapEntry('/customers', nameBody),
      MapEntry('/customer', kuBody),
      MapEntry('/customer', simpleBody),
    ]);
  }

  Future<Map<String, dynamic>> updateCustomer(String customerId, Map<String, dynamic> body) {
    final simpleBody = <String, dynamic>{
      if (body['full_name_ku'] != null) 'full_name': body['full_name_ku'],
      if (body['primary_phone'] != null) 'phone': body['primary_phone'],
      if (body['note'] != null) 'note': body['note'],
    };
    final nameBody = <String, dynamic>{
      if (body['full_name_ku'] != null) 'name': body['full_name_ku'],
      if (body['primary_phone'] != null) 'phone_number': body['primary_phone'],
      if (body['note'] != null) 'notes': body['note'],
    };
    return _apiClient.patchAny([
      MapEntry('/customers/$customerId', body),
      MapEntry('/customers/$customerId', simpleBody),
      MapEntry('/customers/$customerId', nameBody),
      MapEntry('/customers/$customerId/profile', body),
      MapEntry('/customer/$customerId', body),
    ]);
  }

  Future<Map<String, dynamic>> requestCreditLimitReview(String customerId, Map<String, dynamic> body) {
    final amount = body['requested_limit'];
    final altBody = <String, dynamic>{
      if (amount != null) 'credit_limit': amount,
      if (body['currency'] != null) 'currency': body['currency'],
      if (body['reason'] != null) 'note': body['reason'],
    };
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/credit-limit-review', body),
      MapEntry('/customers/$customerId/credit-limit/review', body),
      MapEntry('/credit-limit-reviews', {'customer_id': customerId, ...body}),
      MapEntry('/credit-limit-reviews', {'customer_id': customerId, ...altBody}),
    ]);
  }

  Future<Map<String, dynamic>> getContactHealth(String customerId) {
    return _apiClient.getAny(['/customers/$customerId/contact-health', '/customers/$customerId/contact/health']);
  }

  Future<List<Map<String, dynamic>>> findDuplicates(String customerId) async {
    final data = await _apiClient.getAny(['/customers/$customerId/duplicates', '/customers/$customerId/duplicate-review']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> requestMerge(String customerId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/merge-request', body),
      MapEntry('/customers/$customerId/duplicate-review', body),
    ]);
  }

  Future<List<Map<String, dynamic>>> listContacts(String customerId) async {
    final data = await _apiClient.getAny(['/customers/$customerId/contacts', '/customer-contacts?customer_id=$customerId']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createContact(String customerId, Map<String, dynamic> body) {
    final altBody = <String, dynamic>{
      if (body['phone'] != null) 'primary_phone': body['phone'],
      if (body['note'] != null) 'note': body['note'],
    };
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/contacts', body),
      MapEntry('/customers/$customerId/contacts', altBody),
      MapEntry('/customers/$customerId/contact', body),
      MapEntry('/customer-contacts', {'customer_id': customerId, ...body}),
      MapEntry('/customer-contacts', {'customer_id': customerId, ...altBody}),
    ]);
  }

  Future<List<Map<String, dynamic>>> listGuarantors(String customerId) async {
    final data = await _apiClient.getAny(['/customers/$customerId/guarantors', '/guarantors?customer_id=$customerId']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createGuarantor(String customerId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/guarantors', body),
      MapEntry('/customers/$customerId/guarantor', body),
      MapEntry('/guarantors', {'customer_id': customerId, ...body}),
    ]);
  }

  Future<List<Map<String, dynamic>>> listEvidence(String customerId) async {
    final data = await _apiClient.getAny(['/customers/$customerId/evidence', '/evidence?customer_id=$customerId']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createEvidence(String customerId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/evidence', body),
      MapEntry('/evidence', {'customer_id': customerId, ...body}),
    ]);
  }

  Future<List<Map<String, dynamic>>> listStatusHistory(String customerId) async {
    final data = await _apiClient.getAny(['/customers/$customerId/status-history', '/customer-status-history?customer_id=$customerId']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createStatus(String customerId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/status-history', body),
      MapEntry('/customers/$customerId/status', body),
      MapEntry('/customer-status-history', {'customer_id': customerId, ...body}),
    ]);
  }

  Future<List<Map<String, dynamic>>> listCreditLocks(String customerId) async {
    final data = await _apiClient.getAny(['/customers/$customerId/credit-locks', '/credit-locks?customer_id=$customerId']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createCreditLock(String customerId, Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/customers/$customerId/credit-locks', body),
      MapEntry('/customers/$customerId/credit-lock', body),
      MapEntry('/credit-locks', {'customer_id': customerId, ...body}),
    ]);
  }
}
