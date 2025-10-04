import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/impls/int_parser.dart';

GameDayTitle parseGameDayTitle(Map<String, dynamic> json) {
  return GameDayTitle(
    gameDayNumber: parseInt(json, 'game_day_number'),
    title: json['title'] as String,
  );
}
