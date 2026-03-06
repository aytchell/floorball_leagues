import 'package:floorball/api/models/game_base.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/widgets/game_result_texts.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';

class StripedGamesRowsList extends StripedRowsList<GameBase> {
  static const double _teamLogoSize = 30.0;
  static const double _interTeamSpacing = 8.0;

  static const double heightPerRow =
      2 * _teamLogoSize +
      _interTeamSpacing +
      StripedRowsList.defaultPaddingPerRow;

  StripedGamesRowsList(
    super.entries,
    GameLeagueInfo gameLeagueInfo, {
    super.key,
  }) : super(onTap: _createOnTap(gameLeagueInfo));

  static void Function(BuildContext context, GameBase game) _createOnTap(
    GameLeagueInfo gameLeagueInfo,
  ) => (BuildContext context, GameBase game) {
    GameDetailsPageRoute(
      gameId: game.gameId,
      $extra: gameLeagueInfo,
    ).push(context);
  };

  @override
  Widget buildRow(BuildContext context, GameBase game) {
    return Row(
      children: [
        // Left side: Both teams stacked vertically
        _buildBothTeams(game),
        const SizedBox(width: 12),
        _buildDateAndResultOrTime(game),
      ],
    );
  }

  Widget _buildBothTeams(GameBase game) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Home Team
          _buildTeamRow(game.homeLogoSmallUri, game.homeTeamName),
          const SizedBox(height: _interTeamSpacing),
          // Guest Team
          _buildTeamRow(game.guestLogoSmallUri, game.guestTeamName),
        ],
      ),
    );
  }

  Widget _buildTeamRow(Uri? teamLogo, String? teamName) {
    return Row(
      children: [
        TeamLogo(uri: teamLogo, height: _teamLogoSize, width: _teamLogoSize),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            teamName ?? 'N.N.',
            style: TextStyles.gameDayTeamName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDateAndResultOrTime(GameBase game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Date
        Text(game.dateTime.beautifiedDate, style: TextStyles.gameDayDate),
        const SizedBox(height: 2),
        // Score
        ...buildOverviewResultTexts(game),
      ],
    );
  }
}
