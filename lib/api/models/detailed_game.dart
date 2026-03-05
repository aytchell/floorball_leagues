import 'package:floorball/api/models/game_base.dart';
import 'package:floorball/api/models/game_date_time.dart';

import 'award.dart';
import 'game_day.dart';
import 'game_event.dart';
import 'logo_host.dart';
import 'period_title.dart';
import 'player.dart';
import 'referee.dart';
import 'starting_player.dart';

enum DetailedGameStatus { pregame, ingame, aftergame, matchRecordClosed }

// to be used someday ...
enum DetailedIngameStatus {
  periodOne,
  pauseOne,
  periodTwo,
  pauseTwo,
  periodThree,
  pauseBeforeOvertime,
  overtime,
  pauseBeforePenaltyShots,
  penaltyShots,
}

class DetailedGame extends GameBase {
  int id;
  String gameNumber;
  String? startTime;
  String? actualStartTime;
  String date;
  GameDay gameDay;
  DetailedGameStatus? gameStatus;
  DetailedIngameStatus? ingameStatus;
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
  String? resultString;
  int leagueId;
  String leagueName;
  String leagueShortName;
  int federationId;
  String federationName;
  String federationShortName;
  String federationSlug;
  List<PeriodTitle> periodTitles;
  int arena;
  String arenaName;
  String arenaAddress;
  String arenaShort;
  String? nominatedReferees;
  bool deletable;
  List<Referee> referees;

  late final dateTime = GameDateTime(date, startTime);

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
    required super.ended,
    this.resultString,
    super.result,
    required this.leagueId,
    required this.leagueName,
    required this.leagueShortName,
    required this.federationId,
    required this.federationName,
    required this.federationShortName,
    required this.federationSlug,
    required this.periodTitles,
    super.currentPeriodTitle,
    required this.arena,
    required this.arenaName,
    required this.arenaAddress,
    required this.arenaShort,
    this.nominatedReferees,
    required this.deletable,
    super.noticeType,
    super.noticeString,
    required this.referees,
  }) : super(gameId: id, time: startTime);

  Uri? get homeLogoUri => buildLogoUri(homeTeamLogo);
  Uri? get homeLogoSmallUri => buildLogoUri(homeTeamSmallLogo);
  Uri? get guestLogoUri => buildLogoUri(guestTeamLogo);
  Uri? get guestLogoSmallUri => buildLogoUri(guestTeamSmallLogo);

  @override
  ResultState get resultState {
    switch (gameStatus) {
      case null:
        return ResultState.recordCreated;
      case DetailedGameStatus.pregame:
        return ResultState.recordCreated;
      case DetailedGameStatus.ingame:
        return ResultState.running;
      case DetailedGameStatus.aftergame:
        return ResultState.ended;
      case DetailedGameStatus.matchRecordClosed:
        return ResultState.ended;
    }
  }

  bool isGameRunning(DateTime timestamp) {
    if (ended == true) {
      return false;
    }
    switch (gameStatus) {
      case DetailedGameStatus.ingame:
        return true;
      case DetailedGameStatus.aftergame:
      case DetailedGameStatus.matchRecordClosed:
        return false;
      case DetailedGameStatus.pregame:
      case null:
        return dateTime.isBefore(timestamp);
    }
  }
}
