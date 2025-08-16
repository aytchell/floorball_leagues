import '../net/rest_client.dart';
import 'period_title.dart';
import 'int_parser.dart';
import 'string_parser.dart';

// Data models for game details from saisonmanager
class GameDay {
  int gameDayNumber;
  String title;

  GameDay({required this.gameDayNumber, required this.title});

  factory GameDay.fromJson(Map<String, dynamic> json) {
    return GameDay(
      gameDayNumber: parseInt(json, 'game_day_number'),
      title: parseString(json, 'title'),
    );
  }
}

class GameEvent {
  int eventId;
  String eventType;
  String eventTeam;
  double period;
  int? homeGoals;
  int? guestGoals;
  String time;
  String sortkey;
  int? number;
  int? assist;
  String? goalType;
  String? goalTypeString;
  String? penaltyType;
  String? penaltyTypeString;
  int? penaltyReason;
  String? penaltyReasonString;

  GameEvent({
    required this.eventId,
    required this.eventType,
    required this.eventTeam,
    required this.period,
    this.homeGoals,
    this.guestGoals,
    required this.time,
    required this.sortkey,
    this.number,
    this.assist,
    this.goalType,
    this.goalTypeString,
    this.penaltyType,
    this.penaltyTypeString,
    this.penaltyReason,
    this.penaltyReasonString,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      eventId: parseInt(json, 'event_id'),
      eventType: parseString(json, 'event_type'),
      eventTeam: parseString(json, 'event_team'),
      period: (json['period'] as num).toDouble(),
      homeGoals: parseNullableInt(json, 'home_goals'),
      guestGoals: parseNullableInt(json, 'guest_goals'),
      time: parseString(json, 'time'),
      sortkey: parseString(json, 'sortkey'),
      number: parseNullableInt(json, 'number'),
      assist: parseNullableInt(json, 'assist'),
      goalType: parseNullableString(json, 'goal_type'),
      goalTypeString: parseNullableString(json, 'goal_type_string'),
      penaltyType: parseNullableString(json, 'penalty_type'),
      penaltyTypeString: parseNullableString(json, 'penalty_type_string'),
      penaltyReason: parseNullableInt(json, 'penalty_reason'),
      penaltyReasonString: parseNullableString(json, 'penalty_reason_string'),
    );
  }
}

class Player {
  int playerId;
  String playerName;
  int trikotNumber;
  String playerFirstname;
  String position;
  bool? goalkeeper;
  bool? captain;

  Player({
    required this.playerId,
    required this.playerName,
    required this.trikotNumber,
    required this.playerFirstname,
    required this.position,
    this.goalkeeper,
    this.captain,
  });

  String get name => '$playerFirstname $playerName';

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerId: parseInt(json, 'player_id'),
      playerName: parseString(json, 'player_name'),
      trikotNumber: parseInt(json, 'trikot_number'),
      playerFirstname: parseString(json, 'player_firstname'),
      position: parseString(json, 'position'),
      goalkeeper: json['goalkeeper'] as bool?,
      captain: json['captain'] as bool?,
    );
  }
}

class StartingPlayer {
  String position;
  String team;
  int? playerId;
  String playerFirstname;
  String playerName;
  int? trikotNumber;

  StartingPlayer({
    required this.position,
    required this.team,
    required this.playerId,
    required this.playerFirstname,
    required this.playerName,
    required this.trikotNumber,
  });

  String get name => '$playerFirstname $playerName';

  factory StartingPlayer.fromJson(Map<String, dynamic> json) {
    return StartingPlayer(
      position: parseString(json, 'position'),
      team: parseString(json, 'team'),
      playerId: parseNullableInt(json, 'player_id'),
      playerFirstname: parseString(json, 'player_firstname'),
      playerName: parseString(json, 'player_name'),
      trikotNumber: parseNullableInt(json, 'trikot_number'),
    );
  }
}

class Award {
  String award;
  String team;
  int? playerId;
  String? playerFirstname;
  String? playerName;
  int? trikotNumber;

  Award({
    required this.award,
    required this.team,
    this.playerId,
    this.playerFirstname,
    this.playerName,
    this.trikotNumber,
  });

  String get name => '$playerFirstname $playerName';

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      award: parseString(json, 'award'),
      team: parseString(json, 'team'),
      playerId: parseNullableInt(json, 'player_id'),
      playerFirstname: parseNullableString(json, 'player_firstname'),
      playerName: parseNullableString(json, 'player_name'),
      trikotNumber: parseNullableInt(json, 'trikot_number'),
    );
  }
}

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

class Players {
  List<Player> home;
  List<Player> guest;

  Players({required this.home, required this.guest});

  factory Players.fromJson(Map<String, dynamic> json) {
    var homeJson = json['home'] as List? ?? [];
    var guestJson = json['guest'] as List? ?? [];

    return Players(
      home: homeJson.map((player) => Player.fromJson(player)).toList(),
      guest: guestJson.map((player) => Player.fromJson(player)).toList(),
    );
  }
}

class StartingPlayers {
  List<StartingPlayer> home;
  List<StartingPlayer> guest;

  StartingPlayers({required this.home, required this.guest});

  factory StartingPlayers.fromJson(Map<String, dynamic> json) {
    var homeJson = json['home'] as List? ?? [];
    var guestJson = json['guest'] as List? ?? [];

    return StartingPlayers(
      home: homeJson.map((player) => StartingPlayer.fromJson(player)).toList(),
      guest: guestJson
          .map((player) => StartingPlayer.fromJson(player))
          .toList(),
    );
  }
}

class Awards {
  List<Award> home;
  List<Award> guest;

  Awards({required this.home, required this.guest});

  factory Awards.fromJson(Map<String, dynamic> json) {
    var homeJson = json['home'] as List? ?? [];
    var guestJson = json['guest'] as List? ?? [];

    return Awards(
      home: homeJson.map((award) => Award.fromJson(award)).toList(),
      guest: guestJson.map((award) => Award.fromJson(award)).toList(),
    );
  }
}

class DetailedGame {
  int id;
  String gameNumber;
  String startTime;
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
  StartingPlayers startingPlayers;
  Awards awards;
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
  String nominatedReferees;
  bool deletable;
  String? noticeType;
  String? noticeString;
  List<dynamic> referees;

  DetailedGame({
    required this.id,
    required this.gameNumber,
    required this.startTime,
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
    required this.startingPlayers,
    required this.awards,
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
    required this.nominatedReferees,
    required this.deletable,
    this.noticeType,
    this.noticeString,
    required this.referees,
  });

  factory DetailedGame.fromJson(Map<String, dynamic> json) {
    var eventsJson = json['events'] as List;
    var periodTitlesJson = json['period_titles'] as List;
    var refereesJson = json['referees'] as List;

    return DetailedGame(
      id: parseInt(json, 'id'),
      gameNumber: parseString(json, 'game_number'),
      startTime: parseString(json, 'start_time'),
      actualStartTime: parseNullableString(json, 'actual_start_time'),
      date: parseString(json, 'date'),
      gameDay: GameDay.fromJson(json['game_day']),
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
      events: eventsJson.map((event) => GameEvent.fromJson(event)).toList(),
      players: Players.fromJson(json['players'] ?? {}),
      startingPlayers: StartingPlayers.fromJson(json['starting_players'] ?? {}),
      awards: Awards.fromJson(json['awards'] ?? {}),
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
      nominatedReferees: parseString(json, 'nominated_referees'),
      deletable: json['deletable'] as bool,
      noticeType: parseNullableString(json, 'notice_type'),
      noticeString: parseNullableString(json, 'notice_string'),
      referees: refereesJson,
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
