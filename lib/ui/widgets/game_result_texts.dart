import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_result.dart';
import 'package:floorball/api/models/period_title.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('GameResultTexts');

List<Widget> buildResultTexts(Game game) {
  return _buildResultTexts(
    GameAdapter(game),
    resultStyle: TextStyles.gameDayResult,
    postfixStyle: TextStyles.gameDayResultPostfix,
  );
}

List<Widget> buildDetailedResultTexts(DetailedGame game) {
  return _buildResultTexts(
    DetailedGameAdapter(game),
    resultStyle: TextStyles.gameDetailHeaderScore,
    postfixStyle: TextStyles.gameDetailHeaderResultPostfix,
  );
}

abstract class _Adapter {
  int get gameId;
  bool get ended;
  GameState get state;
  GameResult? get result;
  String? get noticeType;
  String? get noticeString;
  String? get time;
  PeriodTitle? get currentPeriodTitle;
}

List<Widget> _buildResultTexts(
  _Adapter game, {
  required TextStyle resultStyle,
  required TextStyle postfixStyle,
}) {
  if (game.ended) {
    return _buildEndResultTexts(
      game,
      resultStyle: resultStyle,
      postfixStyle: postfixStyle,
    );
  }
  switch (game.state) {
    case GameState.ended:
    case GameState.matchRecordClosed:
      return _buildEndResultTexts(
        game,
        resultStyle: resultStyle,
        postfixStyle: postfixStyle,
      );
    case GameState.noRecord:
      return _buildNoRecordTexts(game);
    case GameState.recordCreated:
      return _buildRecordCreatedTexts(game);
    case GameState.running:
      return _buildRunningTexts(game, resultStyle: resultStyle);
  }
}

List<Widget> _buildEndResultTexts(
  _Adapter game, {
  required TextStyle resultStyle,
  required TextStyle postfixStyle,
}) {
  final result = game.result;
  if (result == null) {
    return _buildUnknownResultText(game, resultStyle: resultStyle);
  }
  final list = _buildResultText(
    '${result.homeGoals}:${result.guestGoals}',
    style: resultStyle,
  );
  final postfix = game.result?.postfix?.short;
  if (postfix != null) {
    list.add(Text(postfix, style: postfixStyle));
  }

  return list;
}

List<Widget> _buildUnknownResultText(
  _Adapter game, {
  required TextStyle resultStyle,
}) {
  log.severe('Unknown result for game ${game.gameId}');
  return _buildResultText('-:-', style: resultStyle);
}

List<Widget> _buildResultText(String text, {required TextStyle style}) {
  return [Text(text, style: style)];
}

List<Widget> _buildNoRecordTexts(_Adapter game) {
  if (game.noticeType != null && game.noticeType!.isNotEmpty) {
    return _buildNoticeTypeResult(game.noticeType!, game.noticeString);
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

List<Widget> _buildRunningTexts(
  _Adapter game, {
  required TextStyle resultStyle,
}) {
  final list = _buildResultText(
    '${game.result!.homeGoals}:${game.result!.guestGoals}',
    style: resultStyle.copyWith(color: FloorballColors.resultRunningColor),
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

List<Widget> _buildNoticeTypeResult(String noticeType, String? noticeString) {
  final List<Widget> texts = [
    Text(
      translateNoticeType(noticeType),
      style: TextStyles.gameDayResultNoticeType,
    ),
  ];
  if (noticeString != null) {
    texts.add(
      SizedBox(
        width: 120,
        child: Text(
          noticeString,
          textAlign: TextAlign.center,
          style: TextStyles.gameDayResultNoticeString,
          maxLines: 4,
        ),
      ),
    );
  }
  return texts;
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
  String? get noticeString => game.noticeString;
  @override
  GameResult? get result => game.result;
  @override
  GameState get state => game.state;
  @override
  String? get time => game.time;
  @override
  PeriodTitle? get currentPeriodTitle => game.currentPeriodTitle;
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
  String? get noticeString => game.noticeString;
  @override
  GameResult? get result => game.result;
  @override
  GameState get state => _convertState(game.gameStatus);
  @override
  String? get time => game.startTime;
  @override
  PeriodTitle? get currentPeriodTitle => game.currentPeriodTitle;

  GameState _convertState(DetailedGameStatus? gameStatus) {
    // this mapping is just for the purpose of printing the
    // game results (or 'not yet' results)
    switch (gameStatus) {
      case null:
        return GameState.recordCreated;
      case DetailedGameStatus.pregame:
        return GameState.recordCreated;
      case DetailedGameStatus.ingame:
        return GameState.running;
      case DetailedGameStatus.aftergame:
        return GameState.ended;
      case DetailedGameStatus.matchRecordClosed:
        return GameState.matchRecordClosed;
    }
  }
}
