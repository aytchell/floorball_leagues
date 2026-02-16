import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/views/game_details/details/header/future_game_header.dart';
import 'package:floorball/ui/views/game_details/details/header/notice_game_header.dart';
import 'package:floorball/ui/views/game_details/details/header/running_or_past_game_header.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:flutter/material.dart';

class DetailedGameHeader extends StatelessWidget {
  final DetailedGame game;
  final GameLeagueInfo gameLeagueInfo;

  const DetailedGameHeader({
    super.key,
    required this.game,
    required this.gameLeagueInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (game.started) {
      return RunningOrPastGameHeader(
        game: game,
        gameLeagueInfo: gameLeagueInfo,
      );
    } else {
      if (game.noticeType != null) {
        return NoticeGameHeader(game: game, gameLeagueInfo: gameLeagueInfo);
      } else {
        return FutureGameHeader(game: game, gameLeagueInfo: gameLeagueInfo);
      }
    }
  }
}
