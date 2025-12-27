import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/impls/int_parser.dart';

GameDayTitle parseGameDayTitle(Map<String, dynamic> json) {
  return GameDayTitle(
    gameDayNumber: parseInt(json, 'game_day_number'),
    title: parseString(json, 'title'),
  );
}
