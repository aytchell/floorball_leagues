import 'package:floorball/api/models/game.dart';
import 'package:floorball/blocs/league_game_day_cubit.dart';
import 'package:floorball/blocs/tick_cubit.dart';
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
