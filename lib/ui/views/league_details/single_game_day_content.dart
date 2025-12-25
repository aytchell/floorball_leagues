import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/blocs/tick_cubit.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/views/league_details/game_result_texts.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleDefaultGameDayContent extends _SingleGameDayContent {
  const SingleDefaultGameDayContent({
    super.key,
    required super.leagueId,
    required super.gameDayNumber,
  });

  @override
  Widget buildGameDays(List<Game> games) => StripedGamesRowsList(games);
}

class SingleChampGameDayContent extends _SingleGameDayContent {
  const SingleChampGameDayContent({
    super.key,
    required super.leagueId,
    required super.gameDayNumber,
  });

  @override
  Widget buildGameDays(List<Game> games) => StripedGamesRowsList(games);
}

abstract class _SingleGameDayContent extends StatelessWidget {
  final int leagueId;
  final int gameDayNumber;

  const _SingleGameDayContent({
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
  const StripedGamesRowsList(super.entries, {super.key})
    : super(onTap: _goToGame);

  static void _goToGame(BuildContext context, Game game) {
    GameDetailsPageRoute(gameId: game.gameId).push(context);
  }

  @override
  Widget buildRow(BuildContext context, Game game) {
    return Row(
      children: [
        // Left side: Both teams stacked vertically
        _buildBothTeams(game),
        SizedBox(width: 12),
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
          SizedBox(height: 8),
          // Guest Team
          _buildTeamRow(game.guestLogoSmallUri, game.guestTeamName),
        ],
      ),
    );
  }

  Widget _buildTeamRow(Uri? teamLogo, String? teamName) {
    return Row(
      children: [
        TeamLogo(uri: teamLogo, height: 30, width: 30),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            teamName ?? 'N.N.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
        Text(
          game.beautifiedDate ?? 'Datum unbekannt',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 2),
        // Score
        ...buildResultTexts(game),
      ],
    );
  }
}
