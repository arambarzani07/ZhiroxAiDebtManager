String debtText(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) return value.toString();
  }
  return fallback;
}

String debtAmount(Map<String, dynamic> data) {
  return debtText(data, ['amount', 'principal_amount', 'balance', 'remaining_balance', 'total_amount'], fallback: '0');
}

String debtCurrency(Map<String, dynamic> data) {
  return debtText(data, ['currency'], fallback: 'IQD');
}

String debtStatus(Map<String, dynamic> data) {
  return debtText(data, ['status', 'case_status', 'account_status'], fallback: 'active');
}

String debtTitle(Map<String, dynamic> data) {
  return debtText(data, ['title', 'description', 'note', 'reason'], fallback: 'تۆماری قەرز');
}
