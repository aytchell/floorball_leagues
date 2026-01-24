import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/details/header/date_time_row.dart';
import 'package:floorball/ui/views/game_details/details/header/period_results.dart';
import 'package:floorball/ui/views/game_details/details/header/team_vs_team_row.dart';
import 'package:floorball/ui/widgets/game_result_texts.dart';
import 'package:flutter/material.dart';

class RunningOrPastGameHeader extends StatelessWidget {
  final DetailedGame game;
  final LeagueType leagueType;

  const RunningOrPastGameHeader({
    super.key,
    required this.game,
    required this.leagueType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TeamVsTeamRow(game: game, leagueType: leagueType),
          const SizedBox(height: 16),
          DateTimeRow(game: game, style: TextStyles.gameDetailHeaderDatePast),
          const SizedBox(height: 4),
          Column(children: buildDetailedResultTexts(game)),
          const SizedBox(height: 4),
          PeriodResults(game: game),
        ],
      ),
    );
  }
}
