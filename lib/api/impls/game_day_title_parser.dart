import '../models/game_day_title.dart';
import '../../api_models/int_parser.dart';

GameDayTitle parseGameDayTitle(Map<String, dynamic> json) {
  return GameDayTitle(
    gameDayNumber: parseInt(json, 'game_day_number'),
    title: json['title'] as String,
  );
}
