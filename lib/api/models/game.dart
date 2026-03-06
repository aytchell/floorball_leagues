import 'package:floorball/api/models/game_base.dart';
import 'package:floorball/api/models/game_date_time.dart';

import 'logo_host.dart';
import 'referee.dart';

enum GameState { noRecord, recordCreated, running, ended, matchRecordClosed }

class Game extends GameBase {
  int gameNumber;
  int gameDay;
  int? arenaId;
  String? arenaName;
  String? arenaAddress;
  String? arenaShort;
  String? hostingClub;
  int gameDayId;
  String date;
  bool started;
  String? homeTeamLogo;
  String? homeTeamSmallLogo;
  String? guestTeamLogo;
  String? guestTeamSmallLogo;
  String? nominatedRefereeString;
  List<Referee> referees;
  GameState state;
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

  late final _dateTime = GameDateTime(date, time);

  Game({
    required super.gameId,
    required this.gameNumber,
    required this.gameDay,
    this.arenaId,
    this.arenaName,
    this.arenaAddress,
    this.arenaShort,
    this.hostingClub,
    required this.gameDayId,
    required this.date,
    super.time,
    required this.started,
    required super.ended,
    required super.homeTeamName,
    this.homeTeamLogo,
    this.homeTeamSmallLogo,
    required super.guestTeamName,
    this.guestTeamLogo,
    this.guestTeamSmallLogo,
    this.nominatedRefereeString,
    required this.referees,
    super.noticeType,
    super.noticeString,
    required this.state,
    super.currentPeriodTitle,
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
    super.result,
  });

  @override
  GameDateTime get dateTime => _dateTime;
  Uri? get homeLogoUri => buildLogoUri(homeTeamLogo);
  @override
  Uri? get homeLogoSmallUri => buildLogoUri(homeTeamSmallLogo);
  Uri? get guestLogoUri => buildLogoUri(guestTeamLogo);
  @override
  Uri? get guestLogoSmallUri => buildLogoUri(guestTeamSmallLogo);

  @override
  ResultState get resultState {
    switch (state) {
      case GameState.noRecord:
        return ResultState.noRecord;
      case GameState.recordCreated:
        return ResultState.recordCreated;
      case GameState.running:
        return ResultState.running;
      case GameState.matchRecordClosed:
        return ResultState.ended;
      case GameState.ended:
        return ResultState.ended;
    }
  }

  @override
  bool isGameRunning(DateTime timestamp) {
    if (ended == true) {
      return false;
    }
    switch (state) {
      case GameState.running:
        return true;
      case GameState.ended:
      case GameState.matchRecordClosed:
        return false;
      case GameState.noRecord:
      case GameState.recordCreated:
        return _dateTime.isBefore(timestamp);
    }
  }
}
