import '../net/rest_client.dart';
import 'period_title.dart';
import 'game_result.dart';
import '../api/models/referee.dart';
import '../api/impls/referee_parser.dart';
import '../api/impls/int_parser.dart';
import 'logo_host.dart';

// Data models for a game in a game day from saisonmanager

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

  Uri? get homeLogoUri => buildLogoUri(homeTeamLogo);
  Uri? get homeLogoSmallUri => buildLogoUri(homeTeamSmallLogo);
  Uri? get guestLogoUri => buildLogoUri(guestTeamLogo);
  Uri? get guestLogoSmallUri => buildLogoUri(guestTeamSmallLogo);

  factory Game.fromJson(Map<String, dynamic> json) {
    var refereesJson = json['referees'] as List;
    var rawTitle = json['current_period_title'] as Map<String, dynamic>?;
    var rawResult = json['result'] as Map<String, dynamic>?;

    return Game(
      gameId: parseInt(json, 'game_id'),
      gameNumber: parseInt(json, 'game_number'),
      gameDay: parseInt(json, 'game_day'),
      arenaId: parseNullableInt(json, 'arena'),
      arenaName: json['arena_name'] as String?,
      arenaAddress: json['arena_address'] as String?,
      arenaShort: json['arena_short'] as String?,
      hostingClub: json['hosting_club'] as String?,
      gameDayId: parseInt(json, 'game_day_id'),
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
      referees: refereesJson.map((referee) => parseReferee(referee)).toList(),
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
      homeTeamFillingParameter: parseNullableInt(
        json,
        'home_team_filling_parameter',
      ),
      guestTeamFillingRule: json['guest_team_filling_rule'] as String?,
      guestTeamFillingTitle: json['guest_team_filling_title'] as String?,
      guestTeamFillingParameter: parseNullableInt(
        json,
        'guest_team_filling_parameter',
      ),
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
