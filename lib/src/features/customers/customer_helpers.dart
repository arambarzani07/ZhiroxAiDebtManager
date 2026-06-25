String textValue(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  final wrapped = data['data'];
  if (wrapped is Map) {
    final nested = textValue(Map<String, dynamic>.from(wrapped), keys, fallback: '');
    if (nested.trim().isNotEmpty) return nested;
  }
  return fallback;
}

String customerDisplayName(Map<String, dynamic> customer) {
  return textValue(customer, ['full_name_ku', 'full_name', 'name_ku', 'name', 'display_name', 'customer_name'], fallback: 'کڕیاری بێ ناو');
}

String customerPhone(Map<String, dynamic> customer) {
  return textValue(customer, ['primary_phone', 'phone', 'mobile', 'phone_number', 'customer_phone'], fallback: 'ژمارە نییە');
}

String customerStatus(Map<String, dynamic> customer) {
  return textValue(customer, ['status', 'customer_status', 'risk_status', 'state'], fallback: 'active');
}

String customerId(Map<String, dynamic> customer) {
  return textValue(customer, ['id', 'customer_id', 'uuid', '_id'], fallback: '');
}
