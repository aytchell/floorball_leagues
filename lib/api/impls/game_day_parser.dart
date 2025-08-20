import '../models/game_day.dart';
import 'int_parser.dart';
import 'string_parser.dart';

GameDay parseGameDay(Map<String, dynamic> json) {
  return GameDay(
    gameDayNumber: parseInt(json, 'game_day_number'),
    title: parseString(json, 'title'),
  );
}
