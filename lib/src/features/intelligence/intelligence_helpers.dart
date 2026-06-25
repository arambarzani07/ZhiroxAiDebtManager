String intelligenceText(Map<String, dynamic> data, List<String> keys, {String fallback = '-'}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) return value.toString();
  }
  return fallback;
}

String intelligenceTitle(Map<String, dynamic> data) {
  return intelligenceText(data, ['title', 'subject', 'name', 'type', 'id'], fallback: 'Record');
}

String intelligenceBody(Map<String, dynamic> data) {
  return intelligenceText(data, ['body', 'message', 'content', 'recommendation', 'note'], fallback: '-');
}

String intelligenceStatus(Map<String, dynamic> data) {
  return intelligenceText(data, ['status', 'approval_status', 'risk_status'], fallback: '-');
}

String intelligenceDate(Map<String, dynamic> data) {
  return intelligenceText(data, ['created_at', 'updated_at', 'sent_at', 'reviewed_at'], fallback: '-');
}

String intelligenceId(Map<String, dynamic> data) {
  return intelligenceText(data, ['id', 'approval_id', 'suggestion_id', 'message_id'], fallback: '');
}
