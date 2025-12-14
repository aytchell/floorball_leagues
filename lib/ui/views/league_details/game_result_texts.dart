import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_status.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('GameResultTexts');
final noteColor = Color.fromARGB(255, 239, 68, 68);

final TextStyle bold12 = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
);

const TextStyle bold16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

const TextStyle bold24 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);

List<Widget> buildResultTexts(Game game) {
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

List<Widget> _buildEndResultTexts(game) {
  final result = game.result;
  if (result == null) {
    return _buildUnknownResultText(game);
  }
  final list = _buildResultText('${result.homeGoals}:${result.guestGoals}');
  final postfix = game.result?.postfix?.short;
  if (postfix != null) {
    // list.add(SizedBox(height: 2));
    list.add(Text(postfix, style: bold12));
  }

  return list;
}

List<Widget> _buildUnknownResultText(Game game) {
  log.severe('Unknown result for game ${game.gameId}');
  return _buildResultText('-:-');
}

List<Widget> _buildResultText(String text, {TextStyle style = bold24}) {
  return [Text(text, style: style)];
}

List<Widget> _buildNoRecordTexts(Game game) {
  if (game.noticeType != null && game.noticeType!.isNotEmpty) {
    return _buildNoticeTypeResult(game.noticeType!);
  }

  if (game.time != null) {
    return [Text('${game.time!} Uhr', style: bold16)];
  } else {
    return [Text('Zeit unbekannt', style: bold12)];
  }
}

List<Widget> _buildRecordCreatedTexts(Game game) {
  if (game.time != null) {
    return [Text('${game.time!} Uhr', style: bold16)];
  } else {
    return [Text('Zeit unbekannt', style: bold12)];
  }
}

final runningText = Color.fromARGB(255, 236, 72, 153);
List<Widget> _buildRunningTexts(Game game) {
  final list = _buildResultText(
    '${game.result!.homeGoals}:${game.result!.guestGoals}',
    style: bold24.copyWith(color: runningText),
  );
  list.add(
    Text(
      game.currentPeriodTitle!.title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: runningText,
      ),
    ),
  );
  return list;
}

List<Widget> _buildNoticeTypeResult(String noticeType) {
  final text = (noticeType == 'Canceled') ? 'abgesagt' : noticeType;
  return [Text(text, style: bold16.copyWith(color: noteColor))];
}
