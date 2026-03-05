import 'package:floorball/api/models/game_base.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('GameResultTexts');

List<Widget> buildOverviewResultTexts(GameBase game) {
  return _buildResultTexts(
    game,
    resultStyle: TextStyles.gameDayResult,
    postfixStyle: TextStyles.gameDayResultPostfix,
  );
}

List<Widget> buildDetailedResultTexts(GameBase game) {
  return _buildResultTexts(
    game,
    resultStyle: TextStyles.gameDetailHeaderScore,
    postfixStyle: TextStyles.gameDetailHeaderResultPostfix,
  );
}

List<Widget> _buildResultTexts(
  GameBase game, {
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
  switch (game.resultState) {
    case ResultState.ended:
      return _buildEndResultTexts(
        game,
        resultStyle: resultStyle,
        postfixStyle: postfixStyle,
      );
    case ResultState.noRecord:
      return _buildNoRecordTexts(game);
    case ResultState.recordCreated:
      return _buildRecordCreatedTexts(game);
    case ResultState.running:
      return _buildRunningTexts(game, resultStyle: resultStyle);
  }
}

List<Widget> _buildEndResultTexts(
  GameBase game, {
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
  GameBase game, {
  required TextStyle resultStyle,
}) {
  log.severe('Unknown result for game ${game.gameId}');
  return _buildResultText('-:-', style: resultStyle);
}

List<Widget> _buildResultText(String text, {required TextStyle style}) {
  return [Text(text, style: style)];
}

List<Widget> _buildNoRecordTexts(GameBase game) {
  if (game.noticeType != null && game.noticeType!.isNotEmpty) {
    return _buildNoticeTypeResult(game.noticeType!, game.noticeString);
  }

  if (game.time != null) {
    return [Text('${game.time!} Uhr', style: TextStyles.gameDayTime)];
  } else {
    return [Text('Zeit unbekannt', style: TextStyles.gameDayTimeUnknown)];
  }
}

List<Widget> _buildRecordCreatedTexts(GameBase game) {
  if (game.time != null) {
    return [Text('${game.time!} Uhr', style: TextStyles.gameDayTime)];
  } else {
    return [Text('Zeit unbekannt', style: TextStyles.gameDayTimeUnknown)];
  }
}

List<Widget> _buildRunningTexts(
  GameBase game, {
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
