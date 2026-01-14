import 'package:floorball/api/models/game_date_time.dart';

import 'award.dart';
import 'game_day.dart';
import 'game_event.dart';
import 'game_result.dart';
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

class DetailedGame {
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
  bool ended;
  String? resultString;
  GameResult? result;
  int leagueId;
  String leagueName;
  String leagueShortName;
  int federationId;
  String federationName;
  String federationShortName;
  String federationSlug;
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
    required this.ended,
    this.resultString,
    this.result,
    required this.leagueId,
    required this.leagueName,
    required this.leagueShortName,
    required this.federationId,
    required this.federationName,
    required this.federationShortName,
    required this.federationSlug,
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
