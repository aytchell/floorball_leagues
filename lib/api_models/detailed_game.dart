import '../net/rest_client.dart';
import 'period_title.dart';
import 'int_parser.dart';

// Data models for game details from saisonmanager
class GameDay {
  int gameDayNumber;
  String title;

  GameDay({required this.gameDayNumber, required this.title});

  factory GameDay.fromJson(Map<String, dynamic> json) {
    return GameDay(
      gameDayNumber: parseInt(json, 'game_day_number'),
      title: json['title'] as String,
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
      eventType: json['event_type'] as String,
      eventTeam: json['event_team'] as String,
      period: (json['period'] as num).toDouble(),
      homeGoals: parseNullableInt(json, 'home_goals'),
      guestGoals: parseNullableInt(json, 'guest_goals'),
      time: json['time'] as String,
      sortkey: json['sortkey'] as String,
      number: parseNullableInt(json, 'number'),
      assist: parseNullableInt(json, 'assist'),
      goalType: json['goal_type'] as String?,
      goalTypeString: json['goal_type_string'] as String?,
      penaltyType: json['penalty_type'] as String?,
      penaltyTypeString: json['penalty_type_string'] as String?,
      penaltyReason: parseNullableInt(json, 'penalty_reason'),
      penaltyReasonString: json['penalty_reason_string'] as String?,
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
      playerName: json['player_name'] as String,
      trikotNumber: parseInt(json, 'trikot_number'),
      playerFirstname: json['player_firstname'] as String,
      position: json['position'] as String,
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
      position: json['position'] as String,
      team: json['team'] as String,
      playerId: parseNullableInt(json, 'player_id'),
      playerFirstname: json['player_firstname'] as String,
      playerName: json['player_name'] as String,
      trikotNumber: parseNullableInt(json, 'trikot_number'),
    );
  }
}

class Award {
  String award;
  String team;
  int? playerId;
  String playerFirstname;
  String playerName;
  int? trikotNumber;

  Award({
    required this.award,
    required this.team,
    required this.playerId,
    required this.playerFirstname,
    required this.playerName,
    required this.trikotNumber,
  });

  String get name => '$playerFirstname $playerName';

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      award: json['award'] as String,
      team: json['team'] as String,
      playerId: parseNullableInt(json, 'player_id'),
      playerFirstname: json['player_firstname'] as String,
      playerName: json['player_name'] as String,
      trikotNumber: parseNullableInt(json, 'trikot_number'),
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
  String noticeType;
  String noticeString;
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
    required this.noticeType,
    required this.noticeString,
    required this.referees,
  });

  factory DetailedGame.fromJson(Map<String, dynamic> json) {
    var eventsJson = json['events'] as List;
    var periodTitlesJson = json['period_titles'] as List;
    var refereesJson = json['referees'] as List;

    return DetailedGame(
      id: parseInt(json, 'id'),
      gameNumber: json['game_number'] as String,
      startTime: json['start_time'] as String,
      actualStartTime: json['actual_start_time'] as String?,
      date: json['date'] as String,
      gameDay: GameDay.fromJson(json['game_day']),
      gameStatus: json['game_status'] as String?,
      ingameStatus: json['ingame_status'] as String?,
      audience: parseNullableInt(json, 'audience'),
      homeTeamName: json['home_team_name'] as String,
      guestTeamName: json['guest_team_name'] as String,
      homeTeamId: parseInt(json, 'home_team_id'),
      guestTeamId: parseInt(json, 'guest_team_id'),
      homeTeamLogo: json['home_team_logo'] as String,
      homeTeamSmallLogo: json['home_team_small_logo'] as String,
      guestTeamLogo: json['guest_team_logo'] as String,
      guestTeamSmallLogo: json['guest_team_small_logo'] as String,
      liveStreamLink: json['live_stream_link'] as String?,
      vodLink: json['vod_link'] as String?,
      events: eventsJson.map((event) => GameEvent.fromJson(event)).toList(),
      players: Players.fromJson(json['players'] ?? {}),
      startingPlayers: StartingPlayers.fromJson(json['starting_players'] ?? {}),
      awards: Awards.fromJson(json['awards'] ?? {}),
      started: json['started'] as bool,
      ended: json['ended'] as bool,
      resultString: json['result_string'] as String?,
      result: json['result'] != null
          ? GameResult.fromJson(json['result'])
          : null,
      leagueId: parseInt(json, 'league_id'),
      leagueName: json['league_name'] as String,
      leagueShortName: json['league_short_name'] as String,
      gameOperationId: parseInt(json, 'game_operation_id'),
      gameOperationName: json['game_operation_name'] as String,
      gameOperationShortName: json['game_operation_short_name'] as String,
      gameOperationSlug: json['game_operation_slug'] as String,
      periodTitles: periodTitlesJson
          .map((title) => PeriodTitle.fromJson(title))
          .toList(),
      currentPeriodTitle: json['current_period_title'] != null
          ? PeriodTitle.fromJson(json['current_period_title'])
          : null,
      arena: parseInt(json, 'arena'),
      arenaName: json['arena_name'] as String,
      arenaAddress: json['arena_address'] as String,
      arenaShort: json['arena_short'] as String,
      nominatedReferees: json['nominated_referees'] as String,
      deletable: json['deletable'] as bool,
      noticeType: json['notice_type'] as String,
      noticeString: json['notice_string'] as String,
      referees: refereesJson,
    );
  }

  // Static method to fetch game data from server
  static Future<DetailedGame> fetchFromServer(
    RestClient client,
    int gameId,
  ) async {
    final uri = Uri.parse('https://www.saisonmanager.de/api/v2/games/$gameId.json');

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
