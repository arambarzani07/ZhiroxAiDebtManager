String platformText(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) return value.toString();
  }
  return fallback;
}

String platformTitle(Map<String, dynamic> data) {
  return platformText(data, ['name', 'market_name', 'plan_name', 'title', 'code', 'id'], fallback: 'Record');
}

String platformStatus(Map<String, dynamic> data) {
  return platformText(data, ['status', 'market_status', 'health_status'], fallback: '-');
}

String platformDate(Map<String, dynamic> data) {
  return platformText(data, ['created_at', 'updated_at', 'expires_at', 'last_seen_at'], fallback: '-');
}

String platformMetric(Map<String, dynamic> data, List<String> keys) {
  return platformText(data, keys, fallback: '0');
}
