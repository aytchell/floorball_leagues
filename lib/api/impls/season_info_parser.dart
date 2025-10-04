import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/models/season_info.dart';

SeasonInfo parseSeasonInfo(Map<String, dynamic> json) {
  return SeasonInfo(
    id: parseInt(json, 'id'),
    name: json['name'] as String,
    current: json['current'] as bool? ?? false,
  );
}
