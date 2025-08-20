import '../../api_models/period_title.dart';
import '../../api_models/game_result.dart';
import '../../api_models/logo_host.dart';

import 'referee.dart';
import 'game_day.dart';
import 'game_event.dart';
import 'player.dart';
import 'starting_player.dart';
import 'award.dart';

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
}
