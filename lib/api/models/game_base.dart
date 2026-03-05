import 'package:floorball/api/models/game_result.dart';
import 'package:floorball/api/models/period_title.dart';

enum ResultState { noRecord, recordCreated, running, ended }

abstract class GameBase {
  final int gameId;
  final String? time;
  final bool ended;
  final GameResult? result;
  final String? noticeType;
  final String? noticeString;
  final PeriodTitle? currentPeriodTitle;

  GameBase({
    required this.gameId,
    required this.time,
    required this.ended,
    required this.result,
    required this.noticeType,
    required this.noticeString,
    required this.currentPeriodTitle,
  });

  ResultState get resultState;
}
