import 'package:floorball/blocs/league_game_day_cubit.dart';
import 'package:floorball/blocs/leagues_cubit.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AllGameDaysProvider extends StatelessWidget {
  final int leagueId;

  const AllGameDaysProvider({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeaguesCubit>(context).ensureLeague(leagueId);
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, leagueState) {
        final league = leagueState.byId(leagueId);
        if (league == null) {
          return noLeagueFallback();
        }
        return buildWithGameDays(context, league.gameDayTitles);
      },
    );
  }

  Widget noLeagueFallback() {
    return Text('Keine Daten');
  }

  Widget buildWithGameDays(BuildContext context, List<GameDayTitle> gameDays);
}

abstract class AllLeagueGamesProvider extends AllGameDaysProvider {
  const AllLeagueGamesProvider({super.key, required super.leagueId});

  @override
  Widget buildWithGameDays(BuildContext context, List<GameDayTitle> gameDays) {
    final provider = BlocProvider.of<LeagueGameDayCubit>(context);
    final gameDayNumbers = gameDays.map((gdt) => gdt.gameDayNumber).toList();
    for (var gameDayId in gameDayNumbers) {
      provider.ensureGamesFor(leagueId, gameDayId);
    }

    return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
      builder: (_, state) =>
          buildWithLeagueGames(state.gamesOfDays(leagueId, gameDayNumbers)),
    );
  }

  Widget buildWithLeagueGames(List<Game> games);
}
