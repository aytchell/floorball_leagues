import '../api/impls/int_parser.dart';
import '../api/impls/string_parser.dart';

class GameResultPostfix {
  String? short;
  String? long;

  GameResultPostfix({this.short, this.long});

  factory GameResultPostfix.fromJson(Map<String, dynamic> json) {
    return GameResultPostfix(
      short: parseNullableString(json, 'short'),
      long: parseNullableString(json, 'long'),
    );
  }
}

class GameResult {
  int homeGoals;
  int guestGoals;
  List<int> homeGoalsPeriod;
  List<int> guestGoalsPeriod;
  GameResultPostfix? postfix;
  bool forfait;
  bool overtime;

  GameResult({
    required this.homeGoals,
    required this.guestGoals,
    required this.homeGoalsPeriod,
    required this.guestGoalsPeriod,
    this.postfix,
    required this.forfait,
    required this.overtime,
  });

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      homeGoals: parseInt(json, 'home_goals'),
      guestGoals: parseInt(json, 'guest_goals'),
      homeGoalsPeriod: parseListOfInt(json, 'home_goals_period'),
      guestGoalsPeriod: parseListOfInt(json, 'guest_goals_period'),
      postfix: json['postfix'] != null
          ? GameResultPostfix.fromJson(json['postfix'])
          : null,
      forfait: json['forfait'] as bool,
      overtime: json['overtime'] as bool,
    );
  }
}
