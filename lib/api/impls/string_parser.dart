import 'package:logging/logging.dart';

final log = Logger('StringParser');

String? _parseDynamic(dynamic value) {
  // the backend sends empty strings when they really should be null
  if (value is String && value.isNotEmpty) return value;
  return null;
}

String? parseNullableString(Map<String, dynamic> json, String key) {
  return _parseDynamic(json[key]);
}

String parseString(Map<String, dynamic> json, String key) {
  final value = parseNullableString(json, key);
  if (value != null) return value;
  log.severe(
    'Expected "$key" to contain "string" but actually contains "$value"',
  );
  throw Exception('Value missing in received json');
}
