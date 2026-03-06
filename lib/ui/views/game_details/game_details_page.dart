import 'package:collection/collection.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/game_event.dart';
import 'package:floorball/api/models/period_title.dart';
import 'package:floorball/api/models/player.dart';
import 'package:floorball/blocs/detailed_games_cubit.dart';
import 'package:floorball/blocs/games_visit_history_cubit.dart';
import 'package:floorball/blocs/tick_cubit.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/details/awarded_players.dart';
import 'package:floorball/ui/views/game_details/details/events_of_period.dart';
import 'package:floorball/ui/views/game_details/details/game_meta_data.dart';
import 'package:floorball/ui/views/game_details/details/header/game_header.dart';
import 'package:floorball/ui/views/game_details/details/starting_six.dart';
import 'package:floorball/ui/views/game_details/details/team_lineup.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/widgets/separator.dart';
import 'package:floorball/utils/map_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameDetailsPage extends StatelessWidget {
  final int gameId;
  final GameLeagueInfo gameLeagueInfo;

  static const String routePath = '/game_details';

  const GameDetailsPage({
    super.key,
    required this.gameId,
    required this.gameLeagueInfo,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailedGamesCubit>(context).updateGame(gameId);

    return (gameLeagueInfo.leagueName != null)
        ? _buildBodyWithLeagueName(gameLeagueInfo.leagueName!)
        : _buildBodyWithoutName();
  }

  Widget _buildBodyWithLeagueName(String leagueName) => _PopScopeWrapper(
    child: MainAppScaffold(
      title: leagueName,
      showBackButton: true,
      body: BlocBuilder<DetailedGamesCubit, DetailedGamesState>(
        builder: (context, state) {
          final detailedGame = state.detailedVersionOf(gameId);
          if (detailedGame != null) {
            _addToHistory(context, leagueName, detailedGame);
          }
          return _buildBody(detailedGame);
        },
      ),
    ),
  );

  Widget _buildBodyWithoutName() =>
      BlocBuilder<DetailedGamesCubit, DetailedGamesState>(
        buildWhen: (previous, current) {
          return previous.detailedVersionOf(gameId)?.leagueName !=
              current.detailedVersionOf(gameId)?.leagueName;
        },
        builder: (_, outerState) => _buildBodyWithLeagueName(
          outerState.detailedVersionOf(gameId)?.leagueName ?? '',
        ),
      );

  Widget _buildBody(DetailedGame? game) {
    if (game == null) {
      return const Text(
        'Lade Spieldetails ...',
        style: TextStyles.genericLoadingData,
      );
    }

    return BlocListener<TickCubit, TickState>(
      listener: (context, tickState) {
        if (game.isGameRunning(tickState.timestamp)) {
          BlocProvider.of<DetailedGamesCubit>(context).updateGame(gameId);
        }
      },
      child: _buildUpdatableBody(game),
    );
  }

  Widget _buildUpdatableBody(DetailedGame detailedGame) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailedGameHeader(
            game: detailedGame,
            gameLeagueInfo: gameLeagueInfo,
          ),
          const SizedBox(height: 12),
          Separator(height: 8),
          const SizedBox(height: 12),
          ..._buildGameDetails(detailedGame),
          const SizedBox(height: 24),
          GameMetaData(game: detailedGame),
        ],
      ),
    );
  }

  List<Widget> _buildGameDetails(DetailedGame detailedGame) {
    if (detailedGame.currentPeriodTitle == null) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Keine Spieldaten vorhanden',
              style: TextStyles.gameDetailNoDetails,
            ),
          ],
        ),
      ];
    }
    return [
      _buildGameEvents(detailedGame),
      const SizedBox(height: 24),
      TeamLineup(game: detailedGame),
      const SizedBox(height: 24),
      StartingSix(game: detailedGame, fieldSize: gameLeagueInfo.fieldSize),
      const SizedBox(height: 24),
      AwardedPlayers(game: detailedGame),
    ];
  }

  Map<int, String> _buildPlayerNamesMap(List<Player> players) {
    return groupBy(
      players,
      (player) => player.jerseyNumber,
    ).mapValues((players) => players[0].name);
  }

  Widget _buildGameEvents(DetailedGame game) {
    List<PeriodTitle> sortedPeriods = game.periodTitles;
    sortedPeriods.sort((a, b) => a.period.compareTo(b.period));
    final groupedEvents = groupBy(game.events, (event) => event.period);
    final currentPeriodId = game.currentPeriodTitle?.period;
    final homePlayerNames = _buildPlayerNamesMap(game.players.home);
    final guestPlayerNames = _buildPlayerNamesMap(game.players.guest);
    final bool isRunning = game.isGameRunning(DateTime(2000));

    if (!isRunning) {
      sortedPeriods = _stripUnusedPeriods(sortedPeriods, groupedEvents);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text('Spielverlauf', style: TextStyles.gameDetailsSection),
        ...sortedPeriods
            .map((period) {
              return [
                const SizedBox(height: 16),
                EventsOfPeriod(
                  isRunning: isRunning,
                  period: period,
                  currentPeriodId: currentPeriodId,
                  homePlayerNames: homePlayerNames,
                  guestPlayerNames: guestPlayerNames,
                  homeLogo: game.homeLogoSmallUri,
                  guestLogo: game.guestLogoSmallUri,
                  events: groupedEvents[period.period],
                ),
              ];
            })
            .expand((i) => i),
      ],
    );
  }

  List<PeriodTitle> _stripUnusedPeriods(
    List<PeriodTitle> sortedPeriods,
    Map<double, List<GameEvent>> groupedEvents,
  ) {
    final periods = sortedPeriods.where((p) => !p.isPause).toList();
    while (periods.length > gameLeagueInfo.numPeriods) {
      if (groupedEvents.containsKey(periods.last.period)) {
        return periods;
      } else {
        periods.removeLast();
      }
    }
    return periods;
  }

  void _addToHistory(
    BuildContext context,
    String leagueName,
    DetailedGame detailedGame,
  ) => BlocProvider.of<GamesVisitHistoryCubit>(context).addVisitedGame(
    VisitedGame(
      gameId: gameId,
      leagueId: detailedGame.leagueId,
      gameLeagueInfo: gameLeagueInfo,
      leagueName: leagueName,
      gameData: detailedGame,
    ),
  );
}

// this wrapper takes care, that a possibly opened snackbar (used to
// display referee details) is automatically closed before navigating back
class _PopScopeWrapper extends StatelessWidget {
  final Widget child;

  const _PopScopeWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Always try to hide the current snackbar
        ScaffoldMessenger.of(context).clearSnackBars();

        // Wait a tiny bit to let the snackbar dismiss animation complete
        await Future.delayed(const Duration(milliseconds: 50));

        // Then navigate back
        navigator.pop();
      },
      child: child,
    );
  }
}
