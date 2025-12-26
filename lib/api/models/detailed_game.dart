import 'package:floorball/api/models/date_formatter.dart';
import 'package:floorball/api/models/game_status.dart';
import 'package:floorball/utils/date_time_utils.dart';

import 'logo_host.dart';
import 'game_result.dart';
import 'period_title.dart';
import 'referee.dart';
import 'game_day.dart';
import 'game_event.dart';
import 'player.dart';
import 'starting_player.dart';
import 'award.dart';

class DetailedGame {
  int id;
  int gameNumber;
  String? startTime;
  String? actualStartTime;
  String date;
  GameDay gameDay;
  GameStatus? gameStatus;
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

  DateTime? startDateTime;

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
  }) : startDateTime = parseDateTimeFromStrings(date, startTime);

  Uri? get homeLogoUri => buildLogoUri(homeTeamLogo);
  Uri? get homeLogoSmallUri => buildLogoUri(homeTeamSmallLogo);
  Uri? get guestLogoUri => buildLogoUri(guestTeamLogo);
  Uri? get guestLogoSmallUri => buildLogoUri(guestTeamSmallLogo);

  String get beautifiedDate => beautifyDate(date);

  bool isGameRunning(DateTime timestamp) {
    switch (gameStatus) {
      case GameStatus.running:
      case GameStatus.ingame:
      case GameStatus.aftergame:
        return true;
      case GameStatus.ended:
        return false;
      case GameStatus.matchRecordClosed:
        return false;
      case GameStatus.noRecord:
        return false;
      case GameStatus.recordCreated:
      case GameStatus.pregame:
      case null:
        return (startDateTime?.isBefore(timestamp) ?? false);
    }
  }
}
