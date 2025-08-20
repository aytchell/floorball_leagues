import '../models/game_result.dart';

import 'int_parser.dart';
import 'string_parser.dart';

GameResultPostfix parseGameResultPostfix(Map<String, dynamic> json) {
  return GameResultPostfix(
    short: parseNullableString(json, 'short'),
    long: parseNullableString(json, 'long'),
  );
}

GameResult parseGameResult(Map<String, dynamic> json) {
  return GameResult(
    homeGoals: parseInt(json, 'home_goals'),
    guestGoals: parseInt(json, 'guest_goals'),
    homeGoalsPeriod: parseListOfInt(json, 'home_goals_period'),
    guestGoalsPeriod: parseListOfInt(json, 'guest_goals_period'),
    postfix: json['postfix'] != null
        ? parseGameResultPostfix(json['postfix'])
        : null,
    forfait: json['forfait'] as bool,
    overtime: json['overtime'] as bool,
  );
}
