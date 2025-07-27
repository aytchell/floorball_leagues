import '../rest_client.dart';

// Data models for a game in a game day from saisonmanager
class Referee {
  String? licenseId;
  String? firstName;
  String? lastName;

  Referee({
    required this.licenseId,
    required this.firstName,
    required this.lastName,
  });

  factory Referee.fromJson(Map<String, dynamic> json) {
    return Referee(
      licenseId: json['license_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}

/* 'period' is a double which looks a bit weird. Here's a real live example:
{
    "period": 2.5,
    "short_title": "PV",
    "title": "Pause vor Verlängerung",
    "status_id": "pause_et",
    "can_end_game": false,
    "optional": true,
    "running": false}
*/

class PeriodTitle {
  double period;
  String shortTitle;
  String title;
  String statusId;
  bool canEndGame;
  bool optional;
  bool running;

  PeriodTitle({
    required this.period,
    required this.shortTitle,
    required this.title,
    required this.statusId,
    required this.canEndGame,
    required this.optional,
    required this.running,
  });

  factory PeriodTitle.fromJson(Map<String, dynamic> json) {
    return PeriodTitle(
      period: (json['period'] as num).toDouble(),
      shortTitle: json['short_title'] as String,
      title: json['title'] as String,
      statusId: json['status_id'] as String,
      canEndGame: json['can_end_game'] as bool,
      optional: json['optional'] as bool,
      running: json['running'] as bool,
    );
  }
}

class GameResultPostfix {
  String short;
  String long;

  GameResultPostfix({required this.short, required this.long});

  factory GameResultPostfix.fromJson(Map<String, dynamic> json) {
    return GameResultPostfix(
      short: json['short'] as String,
      long: json['long'] as String,
    );
  }
}

class GameResult {
  int homeGoals;
  int guestGoals;
  List<int> homeGoalsPeriod;
  List<int> guestGoalsPeriod;
  GameResultPostfix postfix;
  bool forfait;
  bool overtime;

  GameResult({
    required this.homeGoals,
    required this.guestGoals,
    required this.homeGoalsPeriod,
    required this.guestGoalsPeriod,
    required this.postfix,
    required this.forfait,
    required this.overtime,
  });

  factory GameResult.fromJson(Map<String, dynamic> json) {
    var homeGoalsPeriodJson = json['home_goals_period'] as List;
    var guestGoalsPeriodJson = json['guest_goals_period'] as List;

    return GameResult(
      homeGoals: json['home_goals'] as int,
      guestGoals: json['guest_goals'] as int,
      homeGoalsPeriod: homeGoalsPeriodJson
          .map((number) => number as int)
          .toList(),
      guestGoalsPeriod: guestGoalsPeriodJson
          .map((number) => number as int)
          .toList(),
      postfix: GameResultPostfix.fromJson(json['postfix']),
      forfait: json['forfait'] as bool,
      overtime: json['overtime'] as bool,
    );
  }
}

class Game {
  int gameId;
  int gameNumber;
  int gameDay;
  int? arenaId;
  String? arenaName;
  String? arenaAddress;
  String? arenaShort;
  String? hostingClub;
  int gameDayId;
  String? date;
  String? time;
  bool started;
  bool ended;
  String? homeTeamName;
  String? homeTeamLogo;
  String? homeTeamSmallLogo;
  String? guestTeamName;
  String? guestTeamLogo;
  String? guestTeamSmallLogo;
  String? nominatedRefereeString;
  List<Referee> referees;
  String? noticeType;
  String? noticeString;
  String state;
  PeriodTitle? currentPeriodTitle;
  String? groupIdentifier;
  String? seriesTitle;
  String? seriesNumber;
  String? homeTeamFillingRule;
  String? homeTeamFillingTitle;
  int? homeTeamFillingParameter;
  String? guestTeamFillingRule;
  String? guestTeamFillingTitle;
  int? guestTeamFillingParameter;
  String? resultString;
  GameResult? result;

  Game({
    required this.gameId,
    required this.gameNumber,
    required this.gameDay,
    this.arenaId,
    this.arenaName,
    this.arenaAddress,
    this.arenaShort,
    this.hostingClub,
    required this.gameDayId,
    this.date,
    this.time,
    required this.started,
    required this.ended,
    this.homeTeamName,
    this.homeTeamLogo,
    this.homeTeamSmallLogo,
    this.guestTeamName,
    this.guestTeamLogo,
    this.guestTeamSmallLogo,
    this.nominatedRefereeString,
    required this.referees,
    this.noticeType,
    this.noticeString,
    required this.state,
    this.currentPeriodTitle,
    this.groupIdentifier,
    this.seriesTitle,
    this.seriesNumber,
    this.homeTeamFillingRule,
    this.homeTeamFillingTitle,
    this.homeTeamFillingParameter,
    this.guestTeamFillingRule,
    this.guestTeamFillingTitle,
    this.guestTeamFillingParameter,
    this.resultString,
    this.result,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    var refereesJson = json['referees'] as List;
    var rawTitle = json['current_period_title'] as Map<String, dynamic>?;
    var rawResult = json['result'] as Map<String, dynamic>?;

    return Game(
      gameId: json['game_id'] as int,
      gameNumber: json['game_number'] as int,
      gameDay: json['game_day'] as int,
      arenaId: json['arena'] as int?,
      arenaName: json['arena_name'] as String?,
      arenaAddress: json['arena_address'] as String?,
      arenaShort: json['arena_short'] as String?,
      hostingClub: json['hosting_club'] as String?,
      gameDayId: json['game_day_id'] as int,
      date: json['date'] as String?,
      time: json['time'] as String?,
      started: json['started'] as bool,
      ended: json['ended'] as bool,
      homeTeamName: json['home_team_name'] as String?,
      homeTeamLogo: json['home_team_logo'] as String?,
      homeTeamSmallLogo: json['home_team_small_logo'] as String?,
      guestTeamName: json['guest_team_name'] as String?,
      guestTeamLogo: json['guest_team_logo'] as String?,
      guestTeamSmallLogo: json['guest_team_small_logo'] as String?,
      nominatedRefereeString: json['nominated_referee_string'] as String?,
      referees: refereesJson
          .map((referee) => Referee.fromJson(referee))
          .toList(),
      noticeType: json['notice_type'] as String?,
      noticeString: json['notice_string'] as String?,
      state: json['state'] as String,
      currentPeriodTitle: rawTitle != null
          ? PeriodTitle.fromJson(rawTitle)
          : null,
      groupIdentifier: json['group_identifier'] as String?,
      seriesTitle: json['series_title'] as String?,
      seriesNumber: json['series_number'] as String?,
      homeTeamFillingRule: json['home_team_filling_rule'] as String?,
      homeTeamFillingTitle: json['home_team_filling_title'] as String?,
      homeTeamFillingParameter: json['home_team_filling_parameter'] as int?,
      guestTeamFillingRule: json['guest_team_filling_rule'] as String?,
      guestTeamFillingTitle: json['guest_team_filling_title'] as String?,
      guestTeamFillingParameter: json['guest_team_filling_parameter'] as int?,
      resultString: json['result_string'] as String?,
      result: rawResult != null ? GameResult.fromJson(rawResult) : null,
    );
  }
}

class GameDay {
  static Future<List<Game>> fetchFromServer(
    RestClient client,
    int leagueId,
    int gameDayNumber,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/leagues/$leagueId/game_days/$gameDayNumber/schedule.json',
    );

    final jsonData = await client.getJson(uri) as List<dynamic>;
    return jsonData.map((game) => Game.fromJson(game)).toList();
  }
}
