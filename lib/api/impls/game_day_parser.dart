import 'package:floorball/api/models/game_day.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

GameDay parseGameDay(Map<String, dynamic> json) {
  return GameDay(
    gameDayNumber: parseInt(json, 'game_day_number'),
    title: parseString(json, 'title'),
  );
}
