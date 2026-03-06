import 'package:floorball/blocs/games_visit_history_cubit.dart';
import 'package:floorball/blocs/tick_cubit.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/generic_league_name_entry.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:floorball/ui/widgets/striped_games_row_list.dart';
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
      page: MenuPage.history,
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
    return Container(
      color: FloorballColors.gray231,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 32.0,
                horizontal: 8.0,
              ),
              child: _buildBody(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (visitedGames.isEmpty) {
      return _buildEmptyPage();
    }

    return BlocListener<TickCubit, TickState>(
      listener: (_, state) =>
          BlocProvider.of<GamesVisitHistoryCubit>(context).checkForUpdates(),
      child: Column(
        children: visitedGames
            .map((game) => _buildGameEntry(game))
            .expand((i) => i)
            .toList(),
      ),
    );
  }

  Widget _buildEmptyPage() => Container(
    padding: EdgeInsetsGeometry.symmetric(vertical: 32.0, horizontal: 40.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Hier erscheinen die zuletzt angeschauten Spiele.',
          style: TextStyles.leaguesListLight,
        ),
        SizedBox(height: 12),
        Text(
          '(Rufe die Detailseite eines Spieles auf.)',
          style: TextStyles.leaguesListLight,
        ),
      ],
    ),
  );

  List<Widget> _buildGameEntry(VisitedGame game) {
    return [
      GenericLeagueNameEntry(
        leagueId: game.detailedGame.leagueId,
        leagueName: game.leagueName,
        leadingChild: _HistoryPinIndicator(game: game, isPinned: game.isPinned),
        trailingChild: game.isPinned
            ? null
            : HistoryTrashBin(
          onPressedFactory: (context) {
            return () => BlocProvider.of<GamesVisitHistoryCubit>(
              context,
            ).remove(game.gameId);
          },
        ),
      ),
      StripedGamesRowsList([game.detailedGame], game.gameLeagueInfo),
    ];
  }
}

class _HistoryPinIndicator extends HistoryPinIndicator {
  final VisitedGame game;

  _HistoryPinIndicator({required this.game, required super.isPinned})
    : super(
        onPressedFactory: (context) {
          return () =>
              BlocProvider.of<GamesVisitHistoryCubit>(context).toggle(game);
        },
      );
}
