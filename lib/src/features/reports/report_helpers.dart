String reportText(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) return value.toString();
  }
  return fallback;
}

String reportTitle(Map<String, dynamic> data) {
  return reportText(data, ['title', 'name', 'customer_name', 'employee_name', 'label', 'id'], fallback: 'Report record');
}

String reportAmount(Map<String, dynamic> data) {
  return reportText(data, ['amount', 'total', 'balance', 'remaining_balance', 'paid_amount', 'cash_amount'], fallback: '0');
}

String reportCurrency(Map<String, dynamic> data) {
  return reportText(data, ['currency'], fallback: 'IQD');
}

String reportStatus(Map<String, dynamic> data) {
  return reportText(data, ['status', 'payment_status', 'risk_status', 'activity_type'], fallback: '-');
}

String reportDate(Map<String, dynamic> data) {
  return reportText(data, ['created_at', 'updated_at', 'date', 'activity_at'], fallback: '-');
}
