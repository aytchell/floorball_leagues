import 'package:logging/logging.dart';

final log = Logger('IntParser');

int? _parseDynamic(dynamic value) {
  if (value is int) return value;
  if (value is String && value.isNotEmpty) return int.tryParse(value);
  return null;
}

int? parseNullableInt(Map<String, dynamic> json, String key) {
  return _parseDynamic(json[key]);
}

int parseInt(Map<String, dynamic> json, String key) {
  final value = parseNullableInt(json, key);
  if (value != null) return value;
  log.severe('Expected "$key" to contain "int" but actually contains "$value"');
  throw Exception('Value missing in received json');
}

List<int> parseListOfInt(Map<String, dynamic> json, String key) {
  var intList = json[key] as List;
  return intList.map((value) {
    final parsed = _parseDynamic(value);
    if (parsed != null) return parsed;
    log.severe(
      'Expected "$key" to contain "List<int>" but list contains "$intList"',
    );
    throw Exception('Value missing in received json');
  }).toList();
}
