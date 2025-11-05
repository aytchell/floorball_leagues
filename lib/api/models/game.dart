import 'period_title.dart';
import 'detailed_game.dart';
import 'game_result.dart';
import 'referee.dart';
import 'logo_host.dart';
import 'date_formatter.dart';
import 'package:floorball/utils/date_time_utils.dart';

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

  DateTime? dateTime;

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
  }) : dateTime = parseDateTimeFromStrings(date, time);

  Uri? get homeLogoUri => buildLogoUri(homeTeamLogo);
  Uri? get homeLogoSmallUri => buildLogoUri(homeTeamSmallLogo);
  Uri? get guestLogoUri => buildLogoUri(guestTeamLogo);
  Uri? get guestLogoSmallUri => buildLogoUri(guestTeamSmallLogo);

  String? get beautifiedDate => beautifyDate(date!);
}
