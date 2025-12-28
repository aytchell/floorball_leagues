import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_result.dart';
import 'package:floorball/api/models/game_status.dart';
import 'package:floorball/api/models/period_title.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('GameResultTexts');

List<Widget> buildResultTexts(Game game) {
  return _buildResultTexts(GameAdapter(game));
}

List<Widget> buildDetailedResultTexts(DetailedGame game) {
  return _buildResultTexts(DetailedGameAdapter(game));
}

abstract class _Adapter {
  int get gameId;
  bool get ended;
  GameStatus get state;
  GameResult? get result;
  String? get noticeType;
  String? get time;
  PeriodTitle? get currentPeriodTitle;

  TextStyle get resultStyle;
  TextStyle get postfixStyle;
}

List<Widget> _buildResultTexts(_Adapter game) {
  if (game.ended) {
    return _buildEndResultTexts(game);
  }
  switch (game.state) {
    case GameStatus.ended:
    case GameStatus.aftergame:
    case GameStatus.matchRecordClosed:
      return _buildEndResultTexts(game);
    case GameStatus.noRecord:
      return _buildNoRecordTexts(game);
    case GameStatus.recordCreated:
    case GameStatus.pregame:
      return _buildRecordCreatedTexts(game);
    case GameStatus.ingame:
    case GameStatus.running:
      return _buildRunningTexts(game);
  }
}

List<Widget> _buildEndResultTexts(_Adapter game) {
  final result = game.result;
  if (result == null) {
    return _buildUnknownResultText(game);
  }
  final list = _buildResultText(
    '${result.homeGoals}:${result.guestGoals}',
    style: game.resultStyle,
  );
  final postfix = game.result?.postfix?.short;
  if (postfix != null) {
    list.add(Text(postfix, style: game.postfixStyle));
  }

  return list;
}

List<Widget> _buildUnknownResultText(_Adapter game) {
  log.severe('Unknown result for game ${game.gameId}');
  return _buildResultText('-:-', style: game.resultStyle);
}

List<Widget> _buildResultText(String text, {required TextStyle style}) {
  return [Text(text, style: style)];
}

List<Widget> _buildNoRecordTexts(_Adapter game) {
  if (game.noticeType != null && game.noticeType!.isNotEmpty) {
    return _buildNoticeTypeResult(game.noticeType!);
  }

  if (game.time != null) {
    return [Text('${game.time!} Uhr', style: TextStyles.gameDayTime)];
  } else {
    return [Text('Zeit unbekannt', style: TextStyles.gameDayTimeUnknown)];
  }
}

List<Widget> _buildRecordCreatedTexts(_Adapter game) {
  if (game.time != null) {
    return [Text('${game.time!} Uhr', style: TextStyles.gameDayTime)];
  } else {
    return [Text('Zeit unbekannt', style: TextStyles.gameDayTimeUnknown)];
  }
}

List<Widget> _buildRunningTexts(_Adapter game) {
  final list = _buildResultText(
    '${game.result!.homeGoals}:${game.result!.guestGoals}',
    style: game.resultStyle.copyWith(color: FloorballColors.resultRunningColor),
  );
  list.add(
    Text(
      game.currentPeriodTitle!.title,
      style: TextStyles.gameDayResultCurrentPeriod,
    ),
  );
  return list;
}

String translateNoticeType(String noticeType) {
  log.info('Found noticeType: $noticeType');
  // I peeked these values from the js code
  // I already stumbled upon 'Canceled' and know, how to handle it.
  // For the other two I only know the "translation".
  switch (noticeType) {
    case 'Canceled':
      return 'abgesagt';
    case 'Postponed':
      return 'verschoben';
    case 'NoDateAndTime':
      return 'noch nicht terminiert';
    default:
      return noticeType;
  }
}

List<Widget> _buildNoticeTypeResult(String noticeType) {
  return [
    Text(
      translateNoticeType(noticeType),
      style: TextStyles.gameDayResultNotice,
    ),
  ];
}

class GameAdapter extends _Adapter {
  final Game game;

  GameAdapter(this.game);

  @override
  int get gameId => game.gameId;
  @override
  bool get ended => game.ended;
  @override
  String? get noticeType => game.noticeType;
  @override
  GameResult? get result => game.result;
  @override
  GameStatus get state => game.state;
  @override
  String? get time => game.time;
  @override
  PeriodTitle? get currentPeriodTitle => game.currentPeriodTitle;

  @override
  TextStyle get resultStyle => TextStyles.gameDayResult;
  @override
  TextStyle get postfixStyle => TextStyles.gameDayResultPostfix;
}

class DetailedGameAdapter extends _Adapter {
  final DetailedGame game;

  DetailedGameAdapter(this.game);

  @override
  int get gameId => game.id;
  @override
  bool get ended => game.ended;
  @override
  String? get noticeType => game.noticeType;
  @override
  GameResult? get result => game.result;
  @override
  GameStatus get state => game.gameStatus ?? GameStatus.noRecord;
  @override
  String? get time => game.startTime;
  @override
  PeriodTitle? get currentPeriodTitle => game.currentPeriodTitle;

  @override
  TextStyle get resultStyle => TextStyles.gameDetailHeaderScore;
  @override
  TextStyle get postfixStyle => TextStyles.gameDetailHeaderResultPostfix;
}
