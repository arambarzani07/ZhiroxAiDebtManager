String cashText(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) return value.toString();
  }
  return fallback;
}

String cashAmount(Map<String, dynamic> data) {
  return cashText(data, ['amount', 'balance', 'opening_balance', 'closing_balance', 'expected_balance', 'actual_balance'], fallback: '0');
}

String cashCurrency(Map<String, dynamic> data) {
  return cashText(data, ['currency'], fallback: 'IQD');
}

String cashStatus(Map<String, dynamic> data) {
  return cashText(data, ['status', 'session_status', 'handover_status'], fallback: 'active');
}

String cashTitle(Map<String, dynamic> data) {
  return cashText(data, ['title', 'type', 'reason', 'note', 'id'], fallback: 'Cash record');
}

String cashDate(Map<String, dynamic> data) {
  return cashText(data, ['created_at', 'opened_at', 'closed_at', 'handover_at'], fallback: '-');
}
