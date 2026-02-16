import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/details/header/team_vs_team_row.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/widgets/game_result_texts.dart';
import 'package:flutter/material.dart';

class NoticeGameHeader extends StatelessWidget {
  final DetailedGame game;
  final GameLeagueInfo gameLeagueInfo;

  const NoticeGameHeader({
    super.key,
    required this.game,
    required this.gameLeagueInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TeamVsTeamRow(game: game, gameLeagueInfo: gameLeagueInfo),
          const SizedBox(height: 16),
          _printNoticeType(),
          _printNoticeString(),
        ],
      ),
    );
  }

  Widget _printNoticeType() => Text(
    translateNoticeType(game.noticeType!),
    style: TextStyles.gameDetailHeaderScore.copyWith(
      color: FloorballColors.resultNoticeColor,
    ),
  );

  Widget _printNoticeString() {
    if (game.noticeString == null) {
      return SizedBox();
    }

    return Text(
      game.noticeString!,
      maxLines: 3,
      textAlign: TextAlign.center,
      style: TextStyles.gameDetailHeaderNoticeString,
    );
  }
}
