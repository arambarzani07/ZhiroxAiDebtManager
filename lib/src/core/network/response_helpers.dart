Map<String, dynamic> mapFromPayload(Map<String, dynamic> data, {List<String> keys = const []}) {
  final candidates = <dynamic>[data['data'], data['item'], data['record'], data['result'], ...keys.map((key) => data[key]), data];
  for (final candidate in candidates) {
    if (candidate is Map<String, dynamic>) return candidate;
    if (candidate is Map) return Map<String, dynamic>.from(candidate);
  }
  return data;
}

List<Map<String, dynamic>> listFromPayload(Map<String, dynamic> data, {List<String> keys = const []}) {
  final candidates = <dynamic>[
    data['data'],
    data['items'],
    data['records'],
    data['results'],
    data['rows'],
    ...keys.map((key) => data[key]),
  ];
  for (final candidate in candidates) {
    final list = _asList(candidate, keys: keys);
    if (list.isNotEmpty) return list;
  }
  return [];
}

List<Map<String, dynamic>> _asList(dynamic value, {required List<String> keys}) {
  if (value is List) {
    return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    final nestedCandidates = <dynamic>[
      map['items'],
      map['records'],
      map['results'],
      map['rows'],
      map['data'],
      ...keys.map((key) => map[key]),
    ];
    for (final nested in nestedCandidates) {
      final list = _asList(nested, keys: keys);
      if (list.isNotEmpty) return list;
    }
  }
  return [];
}
