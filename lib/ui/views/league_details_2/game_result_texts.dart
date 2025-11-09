import 'package:floorball/api/models/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('GameResultTexts');
final noteColor = Color.fromARGB(255, 239, 68, 68);

final TextStyle bold12 = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
);

final TextStyle bold16 = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

final TextStyle bold24 = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

List<Widget> buildResultTexts(Game game) {
  // this method might grow in the future as I don't have a spec on
  // how to interpret the various result types
  if (game.state == 'ended') {
    return _buildEndResultTexts(game);
  }

  if (game.state == 'no_record') {
    return _buildNoRecordTexts(game);
  }

  return _buildUnknownResultText(game);
}

List<Widget> _buildEndResultTexts(game) {
  final result = game.result;
  if (result == null) {
    return _buildUnknownResultText(game);
  }
  final list = _buildResultText('${result.homeGoals}:${result.guestGoals}');
  final postfix = game.result?.postfix?.short;
  if (postfix != null) {
    list.add(SizedBox(height: 2));
    list.add(Text(postfix, style: bold12));
  }

  return list;
}

List<Widget> _buildUnknownResultText(Game game) {
  log.severe('Unknown result for game ${game.gameId}');
  return _buildResultText('-:-');
}

List<Widget> _buildResultText(String text) {
  return [Text(text, style: bold24)];
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

List<Widget> _buildNoticeTypeResult(String noticeType) {
  final text = (noticeType == 'Canceled') ? 'abgesagt' : noticeType;
  return [Text(text, style: bold16.copyWith(color: noteColor))];
}
