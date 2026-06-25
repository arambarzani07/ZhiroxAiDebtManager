String debtText(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) return value.toString();
  }
  final wrapped = data['data'];
  if (wrapped is Map) {
    final nested = debtText(Map<String, dynamic>.from(wrapped), keys, fallback: '');
    if (nested.trim().isNotEmpty) return nested;
  }
  return fallback;
}

String debtAmount(Map<String, dynamic> data) {
  return debtText(data, ['amount', 'principal_amount', 'balance', 'remaining_balance', 'total_amount', 'debt_amount'], fallback: '0');
}

String debtCurrency(Map<String, dynamic> data) {
  return debtText(data, ['currency', 'debt_currency'], fallback: 'IQD');
}

String debtStatus(Map<String, dynamic> data) {
  return debtText(data, ['status', 'case_status', 'account_status', 'debt_status', 'state'], fallback: 'active');
}

String debtTitle(Map<String, dynamic> data) {
  return debtText(data, ['title', 'description', 'note', 'reason', 'name'], fallback: 'تۆماری قەرز');
}

String debtRecordId(Map<String, dynamic> data) {
  return debtText(data, ['id', 'debt_case_id', 'case_id', 'debt_id', 'uuid', '_id'], fallback: '');
}
