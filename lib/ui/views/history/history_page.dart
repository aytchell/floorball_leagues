import 'package:floorball/blocs/games_visit_history_cubit.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/widgets/generic_league_name_entry.dart';
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

    return Container(
      color: FloorballColors.gray231,
      padding: EdgeInsetsGeometry.symmetric(vertical: 32.0, horizontal: 8.0),
      child: Column(
        children: visitedGames
            .map((game) => _buildGameEntry(game))
            .expand((i) => i)
            .toList(),
      ),
    );
  }

  List<Widget> _buildGameEntry(VisitedGame game) {
    return [
      GenericLeagueNameEntry(
        leagueId: game.detailedGame.leagueId,
        leagueName: game.leagueName,
        leadingChild: SizedBox(width: 40, height: 40),
      ),
      Text(
        'Game ${game.gameId}: ${game.detailedGame.homeTeamName} vs ${game.detailedGame.guestTeamName}',
      ),
    ];
  }
}
