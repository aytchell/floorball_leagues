import 'package:logging/logging.dart';

final log = Logger('DoubleParser');

double? parseNullableDouble(Map<String, dynamic> json, String key) {
  final raw = (json[key] as num?);
  return (raw == null) ? null : (raw.toDouble());
}

double parseDouble(Map<String, dynamic> json, String key) {
  final value = parseNullableDouble(json, key);
  if (value != null) return value;
  log.severe(
    'Expected "$key" to contain "double" but actually contains "$value"',
  );
  throw Exception('Value missing in received json');
}
