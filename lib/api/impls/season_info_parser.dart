import 'int_parser.dart';
import '../models/season_info.dart';

SeasonInfo parseSeasonInfo(Map<String, dynamic> json) {
  return SeasonInfo(
    id: parseInt(json, 'id'),
    name: json['name'] as String,
    current: json['current'] as bool? ?? false,
  );
}
