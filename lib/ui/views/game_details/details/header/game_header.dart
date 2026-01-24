import 'package:flutter/material.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/views/game_details/details/header/future_game_header.dart';
import 'package:floorball/ui/views/game_details/details/header/notice_game_header.dart';
import 'package:floorball/ui/views/game_details/details/header/running_or_past_game_header.dart';

class DetailedGameHeader extends StatelessWidget {
  final DetailedGame game;
  final LeagueType leagueType;

  const DetailedGameHeader({
    super.key,
    required this.game,
    required this.leagueType,
  });

  @override
  Widget build(BuildContext context) {
    if (game.started) {
      return RunningOrPastGameHeader(game: game, leagueType: leagueType);
    } else {
      if (game.noticeType != null) {
        return NoticeGameHeader(game: game, leagueType: leagueType);
      } else {
        return FutureGameHeader(game: game, leagueType: leagueType);
      }
    }
  }
}
