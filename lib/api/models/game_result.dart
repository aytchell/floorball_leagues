class GameResultPostfix {
  String? short;
  String? long;

  GameResultPostfix({this.short, this.long});
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
}
