import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/season_info.dart';

SeasonInfo parseSeasonInfo(Map<String, dynamic> json) {
  return SeasonInfo(
    id: parseInt(json, 'id'),
    name: parseString(json, 'name'),
    current: json['current'] as bool,
  );
}
