import '../../core/network/api_client.dart';

class CashService {
  CashService(this._apiClient);

  final ApiClient _apiClient;

  List<Map<String, dynamic>> _listFrom(Map<String, dynamic> data) {
    return _apiClient.listFrom(data, ['data', 'items', 'records', 'sessions', 'handovers', 'discrepancies']);
  }

  Future<Map<String, dynamic>> getCurrentSession() {
    return _apiClient.getAny(['/cash/sessions/current', '/cash/current-session', '/cash-session/current']);
  }

  Future<List<Map<String, dynamic>>> listSessions() async {
    final data = await _apiClient.getAny(['/cash/sessions', '/cash-sessions']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> openSession(Map<String, dynamic> body) {
    final amount = body['opening_balance'];
    final currency = body['currency'];
    final note = body['note'];
    final altBody = <String, dynamic>{
      if (amount != null) 'initial_balance': amount,
      if (currency != null) 'currency': currency,
      if (note != null) 'description': note,
    };
    return _apiClient.postAny([
      MapEntry('/cash/sessions/open', body),
      MapEntry('/cash/sessions/open', altBody),
      MapEntry('/cash/sessions', body),
      MapEntry('/cash-sessions/open', body),
    ]);
  }

  Future<Map<String, dynamic>> closeCurrentSession(Map<String, dynamic> body) {
    final amount = body['closing_balance'];
    final note = body['note'];
    final altBody = <String, dynamic>{
      if (amount != null) 'counted_cash': amount,
      if (note != null) 'description': note,
    };
    return _apiClient.postAny([
      MapEntry('/cash/sessions/current/close', body),
      MapEntry('/cash/sessions/current/close', altBody),
      MapEntry('/cash/current-session/close', body),
      MapEntry('/cash-sessions/current/close', body),
    ]);
  }

  Future<List<Map<String, dynamic>>> listHandovers() async {
    final data = await _apiClient.getAny(['/cash/handovers', '/cash-handovers']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createHandover(Map<String, dynamic> body) {
    final altBody = <String, dynamic>{
      if (body['amount'] != null) 'cash_amount': body['amount'],
      if (body['currency'] != null) 'currency': body['currency'],
      if (body['receiver_user_id'] != null) 'to_user_id': body['receiver_user_id'],
      if (body['note'] != null) 'description': body['note'],
    };
    return _apiClient.postAny([
      MapEntry('/cash/handovers', body),
      MapEntry('/cash/handovers', altBody),
      MapEntry('/cash-handovers', body),
    ]);
  }

  Future<List<Map<String, dynamic>>> listDiscrepancies() async {
    final data = await _apiClient.getAny(['/cash/discrepancies', '/cash-discrepancies']);
    return _listFrom(data);
  }

  Future<Map<String, dynamic>> createDiscrepancy(Map<String, dynamic> body) {
    final altBody = <String, dynamic>{
      if (body['amount'] != null) 'difference_amount': body['amount'],
      if (body['currency'] != null) 'currency': body['currency'],
      if (body['reason'] != null) 'note': body['reason'],
    };
    return _apiClient.postAny([
      MapEntry('/cash/discrepancies', body),
      MapEntry('/cash/discrepancies', altBody),
      MapEntry('/cash-discrepancies', body),
    ]);
  }

  Future<Map<String, dynamic>> reconcileCurrentSession(Map<String, dynamic> body) {
    return _apiClient.postAny([
      MapEntry('/cash/sessions/current/reconcile', body),
      MapEntry('/cash/current-session/reconcile', body),
      MapEntry('/cash-reconciliations', body),
    ]);
  }
}
