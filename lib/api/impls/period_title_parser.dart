import 'package:floorball/api/impls/double_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/period_title.dart';

PeriodTitle parsePeriodTitle(Map<String, dynamic> json) {
  return PeriodTitle(
    period: parseDouble(json, 'period'),
    shortTitle: parseString(json, 'short_title'),
    title: parseString(json, 'title'),
    statusId: parseString(json, 'status_id'),
    canEndGame: json['can_end_game'] as bool,
    optional: json['optional'] as bool,
    running: json['running'] as bool,
  );
}
