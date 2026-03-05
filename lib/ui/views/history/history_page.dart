import 'package:floorball/blocs/games_visit_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatelessWidget {
  static const routePath = '/history';

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: 'Zuletzt angesehen',
      isHistoryPage: true,
      body: BlocBuilder<GamesVisitHistoryCubit, GamesVisitHistory>(
        builder: (_, state) =>
            _GamesVisitHistoryList(visitedGames: state.visitedGames),
      ),
    );
  }
}

class _GamesVisitHistoryList extends StatelessWidget {
  final List<VisitedGame> visitedGames;

  const _GamesVisitHistoryList({required this.visitedGames});

  @override
  Widget build(BuildContext context) {
    if (visitedGames.isEmpty) {
      return Center(child: Text('History Page - Coming Soon'));
    }

    return Column(
      children: visitedGames
          .map(
            (game) => Text(
              'Game ${game.gameId}: ${game.detailedGame.homeTeamName} vs ${game.detailedGame.guestTeamName}',
            ),
          )
          .toList(),
    );
  }
}
