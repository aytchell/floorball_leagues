import '../net/rest_client.dart';
import 'period_title.dart';
import 'game_result.dart';
import '../api/impls/int_parser.dart';
import '../api/impls/string_parser.dart';
import 'logo_host.dart';
import 'referee.dart';
import '../api/models/game_day.dart';
import '../api/impls/game_day_parser.dart';
import '../api/models/game_event.dart';
import '../api/impls/game_event_parser.dart';
import '../api/models/player.dart';
import '../api/impls/player_parser.dart';
import '../api/models/starting_player.dart';
import '../api/impls/starting_player_parser.dart';
import '../api/models/award.dart';
import '../api/impls/award_parser.dart';

class Players {
  List<Player> home;
  List<Player> guest;

  Players({required this.home, required this.guest});

  factory Players.fromJson(Map<String, dynamic> json) {
    var homeJson = json['home'] as List? ?? [];
    var guestJson = json['guest'] as List? ?? [];

    return Players(
      home: homeJson.map((player) => parsePlayer(player)).toList(),
      guest: guestJson.map((player) => parsePlayer(player)).toList(),
    );
  }
}

class DetailedGame {
  int id;
  String gameNumber;
  String? startTime;
  String? actualStartTime;
  String date;
  GameDay gameDay;
  String? gameStatus;
  String? ingameStatus;
  int? audience;
  String homeTeamName;
  String guestTeamName;
  int homeTeamId;
  int guestTeamId;
  String homeTeamLogo;
  String homeTeamSmallLogo;
  String guestTeamLogo;
  String guestTeamSmallLogo;
  String? liveStreamLink;
  String? vodLink;
  List<GameEvent> events;
  Players players;
  StartingPlayers? startingPlayers;
  Awards? awards;
  bool started;
  bool ended;
  String? resultString;
  GameResult? result;
  int leagueId;
  String leagueName;
  String leagueShortName;
  int gameOperationId;
  String gameOperationName;
  String gameOperationShortName;
  String gameOperationSlug;
  List<PeriodTitle> periodTitles;
  PeriodTitle? currentPeriodTitle;
  int arena;
  String arenaName;
  String arenaAddress;
  String arenaShort;
  String? nominatedReferees;
  bool deletable;
  String? noticeType;
  String? noticeString;
  List<Referee> referees;

  DetailedGame({
    required this.id,
    required this.gameNumber,
    this.startTime,
    this.actualStartTime,
    required this.date,
    required this.gameDay,
    this.gameStatus,
    this.ingameStatus,
    this.audience,
    required this.homeTeamName,
    required this.guestTeamName,
    required this.homeTeamId,
    required this.guestTeamId,
    required this.homeTeamLogo,
    required this.homeTeamSmallLogo,
    required this.guestTeamLogo,
    required this.guestTeamSmallLogo,
    this.liveStreamLink,
    this.vodLink,
    required this.events,
    required this.players,
    this.startingPlayers,
    this.awards,
    required this.started,
    required this.ended,
    this.resultString,
    this.result,
    required this.leagueId,
    required this.leagueName,
    required this.leagueShortName,
    required this.gameOperationId,
    required this.gameOperationName,
    required this.gameOperationShortName,
    required this.gameOperationSlug,
    required this.periodTitles,
    this.currentPeriodTitle,
    required this.arena,
    required this.arenaName,
    required this.arenaAddress,
    required this.arenaShort,
    this.nominatedReferees,
    required this.deletable,
    this.noticeType,
    this.noticeString,
    required this.referees,
  });

  Uri? get homeLogoUri => buildLogoUri(homeTeamLogo);
  Uri? get homeLogoSmallUri => buildLogoUri(homeTeamSmallLogo);
  Uri? get guestLogoUri => buildLogoUri(guestTeamLogo);
  Uri? get guestLogoSmallUri => buildLogoUri(guestTeamSmallLogo);

  factory DetailedGame.fromJson(Map<String, dynamic> json) {
    var eventsJson = json['events'] as List;
    var periodTitlesJson = json['period_titles'] as List;
    var refereesJson = json['referees'] as List;
    var startingPlayers = (json['starting_players'] == null)
        ? null
        : parseStartingPlayers(json['starting_players']);
    final awards = (json['awards'] == null)
        ? null
        : parseAwards(json['awards']);

    return DetailedGame(
      id: parseInt(json, 'id'),
      gameNumber: parseString(json, 'game_number'),
      startTime: parseNullableString(json, 'start_time'),
      actualStartTime: parseNullableString(json, 'actual_start_time'),
      date: parseString(json, 'date'),
      gameDay: parseGameDay(json['game_day']),
      gameStatus: parseNullableString(json, 'game_status'),
      ingameStatus: parseNullableString(json, 'ingame_status'),
      audience: parseNullableInt(json, 'audience'),
      homeTeamName: parseString(json, 'home_team_name'),
      guestTeamName: parseString(json, 'guest_team_name'),
      homeTeamId: parseInt(json, 'home_team_id'),
      guestTeamId: parseInt(json, 'guest_team_id'),
      homeTeamLogo: parseString(json, 'home_team_logo'),
      homeTeamSmallLogo: parseString(json, 'home_team_small_logo'),
      guestTeamLogo: parseString(json, 'guest_team_logo'),
      guestTeamSmallLogo: parseString(json, 'guest_team_small_logo'),
      liveStreamLink: parseNullableString(json, 'live_stream_link'),
      vodLink: parseNullableString(json, 'vod_link'),
      events: eventsJson.map((event) => parseGameEvent(event)).toList(),
      players: Players.fromJson(json['players'] ?? {}),
      startingPlayers: startingPlayers,
      awards: awards,
      started: json['started'] as bool,
      ended: json['ended'] as bool,
      resultString: parseNullableString(json, 'result_string'),
      result: json['result'] != null
          ? GameResult.fromJson(json['result'])
          : null,
      leagueId: parseInt(json, 'league_id'),
      leagueName: parseString(json, 'league_name'),
      leagueShortName: parseString(json, 'league_short_name'),
      gameOperationId: parseInt(json, 'game_operation_id'),
      gameOperationName: parseString(json, 'game_operation_name'),
      gameOperationShortName: parseString(json, 'game_operation_short_name'),
      gameOperationSlug: parseString(json, 'game_operation_slug'),
      periodTitles: periodTitlesJson
          .map((title) => PeriodTitle.fromJson(title))
          .toList(),
      currentPeriodTitle: json['current_period_title'] != null
          ? PeriodTitle.fromJson(json['current_period_title'])
          : null,
      arena: parseInt(json, 'arena'),
      arenaName: parseString(json, 'arena_name'),
      arenaAddress: parseString(json, 'arena_address'),
      arenaShort: parseString(json, 'arena_short'),
      nominatedReferees: parseNullableString(json, 'nominated_referees'),
      deletable: json['deletable'] as bool,
      noticeType: parseNullableString(json, 'notice_type'),
      noticeString: parseNullableString(json, 'notice_string'),
      referees: refereesJson
          .map((referee) => Referee.fromJson(referee))
          .toList(),
    );
  }

  // Static method to fetch game data from server
  static Future<DetailedGame> fetchFromServer(
    RestClient client,
    int gameId,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/games/$gameId.json',
    );

    final jsonData = await client.getJson(uri) as Map<String, dynamic>;
    return DetailedGame.fromJson(jsonData);
  }

  bool get isFinished => ended;

  bool get isUpcoming => !started && !ended;

  String get displayResult {
    if (resultString != null) {
      return resultString!;
    } else if (result != null) {
      return '${result!.homeGoals}:${result!.guestGoals}';
    } else {
      return '-:-';
    }
  }

  DateTime get gameDateTime {
    return DateTime.parse('$date $startTime:00');
  }
}
