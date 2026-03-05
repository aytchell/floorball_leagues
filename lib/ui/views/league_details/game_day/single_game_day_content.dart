import 'package:floorball/api/models/game.dart';
import 'package:floorball/blocs/league_game_day_cubit.dart';
import 'package:floorball/blocs/tick_cubit.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/widgets/game_result_texts.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SingleGameDayContent extends StatelessWidget {
  final int leagueId;
  final int gameDayNumber;

  const SingleGameDayContent({
    super.key,
    required this.leagueId,
    required this.gameDayNumber,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeagueGameDayCubit>(
      context,
    ).ensureGamesFor(leagueId, gameDayNumber);

    return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
      builder: (_, gameDaysState) {
        final games = gameDaysState.gamesOf(leagueId, gameDayNumber);
        return BlocListener<TickCubit, TickState>(
          listener: (context, tickState) {
            if (_isAnyGameRunning(games, tickState.timestamp)) {
              BlocProvider.of<LeagueGameDayCubit>(
                context,
              ).refreshGamesOf(leagueId, gameDayNumber);
            }
          },
          child: buildGameDays(games),
        );
      },
    );
  }

  Widget buildGameDays(List<Game> games);

  bool _isAnyGameRunning(List<Game> games, DateTime timestamp) =>
      games.any((game) => game.isGameRunning(timestamp));
}

class StripedGamesRowsList extends StripedRowsList<Game> {
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

  static void Function(BuildContext context, Game game) _createOnTap(
    GameLeagueInfo gameLeagueInfo,
  ) => (BuildContext context, Game game) {
    GameDetailsPageRoute(
      gameId: game.gameId,
      $extra: gameLeagueInfo,
    ).push(context);
  };

  @override
  Widget buildRow(BuildContext context, Game game) {
    return Row(
      children: [
        // Left side: Both teams stacked vertically
        _buildBothTeams(game),
        const SizedBox(width: 12),
        _buildDateAndResultOrTime(game),
      ],
    );
  }

  Widget _buildBothTeams(Game game) {
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

  Widget _buildDateAndResultOrTime(Game game) {
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
