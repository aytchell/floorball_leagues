import '../net/rest_client.dart';

// Data models for game details from saisonmanager
class GameDay {
  int gameDayNumber;
  String title;

  GameDay({required this.gameDayNumber, required this.title});

  factory GameDay.fromJson(Map<String, dynamic> json) {
    return GameDay(
      gameDayNumber: json['game_day_number'] as int,
      title: json['title'] as String,
    );
  }
}

class GameEvent {
  int eventId;
  String eventType;
  String eventTeam;
  int period;
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
      eventId: json['event_id'] as int,
      eventType: json['event_type'] as String,
      eventTeam: json['event_team'] as String,
      period: json['period'] as int,
      homeGoals: json['home_goals'] as int?,
      guestGoals: json['guest_goals'] as int?,
      time: json['time'] as String,
      sortkey: json['sortkey'] as String,
      number: json['number'] as int?,
      assist: json['assist'] as int?,
      goalType: json['goal_type'] as String?,
      goalTypeString: json['goal_type_string'] as String?,
      penaltyType: json['penalty_type'] as String?,
      penaltyTypeString: json['penalty_type_string'] as String?,
      penaltyReason: json['penalty_reason'] as int?,
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

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerId: json['player_id'] as int,
      playerName: json['player_name'] as String,
      trikotNumber: json['trikot_number'] as int,
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
  String playerId;
  String playerFirstname;
  String playerName;
  String trikotNumber;

  StartingPlayer({
    required this.position,
    required this.team,
    required this.playerId,
    required this.playerFirstname,
    required this.playerName,
    required this.trikotNumber,
  });

  factory StartingPlayer.fromJson(Map<String, dynamic> json) {
    return StartingPlayer(
      position: json['position'] as String,
      team: json['team'] as String,
      playerId: json['player_id'] as String,
      playerFirstname: json['player_firstname'] as String,
      playerName: json['player_name'] as String,
      trikotNumber: json['trikot_number'] as String,
    );
  }
}

class Award {
  String award;
  String team;
  String playerId;
  String playerFirstname;
  String playerName;
  String trikotNumber;

  Award({
    required this.award,
    required this.team,
    required this.playerId,
    required this.playerFirstname,
    required this.playerName,
    required this.trikotNumber,
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      award: json['award'] as String,
      team: json['team'] as String,
      playerId: json['player_id'] as String,
      playerFirstname: json['player_firstname'] as String,
      playerName: json['player_name'] as String,
      trikotNumber: json['trikot_number'] as String,
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
    var homeGoalsPeriodJson = json['home_goals_period'] as List;
    var guestGoalsPeriodJson = json['guest_goals_period'] as List;

    return GameResult(
      homeGoals: json['home_goals'] as int,
      guestGoals: json['guest_goals'] as int,
      homeGoalsPeriod: homeGoalsPeriodJson
          .map((goals) => goals as int)
          .toList(),
      guestGoalsPeriod: guestGoalsPeriodJson
          .map((goals) => goals as int)
          .toList(),
      postfix: json['postfix'] != null
          ? GameResultPostfix.fromJson(json['postfix'])
          : null,
      forfait: json['forfait'] as bool,
      overtime: json['overtime'] as bool,
    );
  }
}

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
      id: json['id'] as int,
      gameNumber: json['game_number'] as String,
      startTime: json['start_time'] as String,
      actualStartTime: json['actual_start_time'] as String?,
      date: json['date'] as String,
      gameDay: GameDay.fromJson(json['game_day']),
      gameStatus: json['game_status'] as String?,
      ingameStatus: json['ingame_status'] as String?,
      audience: json['audience'] as int?,
      homeTeamName: json['home_team_name'] as String,
      guestTeamName: json['guest_team_name'] as String,
      homeTeamId: json['home_team_id'] as int,
      guestTeamId: json['guest_team_id'] as int,
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
      leagueId: json['league_id'] as int,
      leagueName: json['league_name'] as String,
      leagueShortName: json['league_short_name'] as String,
      gameOperationId: json['game_operation_id'] as int,
      gameOperationName: json['game_operation_name'] as String,
      gameOperationShortName: json['game_operation_short_name'] as String,
      gameOperationSlug: json['game_operation_slug'] as String,
      periodTitles: periodTitlesJson
          .map((title) => PeriodTitle.fromJson(title))
          .toList(),
      currentPeriodTitle: json['current_period_title'] != null
          ? PeriodTitle.fromJson(json['current_period_title'])
          : null,
      arena: json['arena'] as int,
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
    final uri = Uri.parse('https://saisonmanager.de/api/v2/games/$gameId.json');

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
