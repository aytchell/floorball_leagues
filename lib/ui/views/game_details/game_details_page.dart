import 'package:collection/collection.dart';
import 'package:floorball/api/blocs/detailed_games_cubit.dart';
import 'package:floorball/api/blocs/tick_cubit.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/player.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/views/game_details/details/awarded_players.dart';
import 'package:floorball/ui/views/game_details/details/events_of_period.dart';
import 'package:floorball/ui/views/game_details/details/game_meta_data.dart';
import 'package:floorball/ui/views/game_details/details/starting_six.dart';
import 'package:floorball/ui/views/game_details/details/team_lineup.dart';
import 'package:floorball/ui/views/game_details/game_header.dart';
import 'package:floorball/ui/widgets/loading_spinner.dart';
import 'package:floorball/ui/widgets/separator.dart';
import 'package:floorball/utils/map_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameDetailsPage extends StatelessWidget {
  final int gameId;
  final String? leagueName;

  static const String routePath = '/game_details';

  const GameDetailsPage({super.key, required this.gameId, this.leagueName});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailedGamesCubit>(context).updateGame(gameId);

    return (leagueName != null)
        ? _buildBodyWithLeagueName(leagueName!)
        : _buildBodyWithoutName();
  }

  Widget _buildBodyWithLeagueName(String leagueName) => MainAppScaffold(
    title: leagueName,
    showBackButton: true,
    body: BlocBuilder<DetailedGamesCubit, DetailedGamesState>(
      builder: (_, state) => _buildBody(state.detailedVersionOf(gameId)),
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
      return const LoadingSpinner(title: 'Lade Spieldetails ...');
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
          DetailedGameHeader(game: detailedGame),
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
              style: TextStyle(fontSize: 16, color: Colors.black54),
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
      StartingSix(game: detailedGame),
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
    final sortedPeriods = game.periodTitles;
    sortedPeriods.sort((a, b) => a.period.compareTo(b.period));
    final groupedEvents = groupBy(game.events, (event) => event.period);
    final currentPeriodId = game.currentPeriodTitle?.period;
    final homePlayerNames = _buildPlayerNamesMap(game.players.home);
    final guestPlayerNames = _buildPlayerNamesMap(game.players.guest);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'Spielverlauf',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...sortedPeriods
            .map((period) {
              return [
                const SizedBox(height: 16),
                EventsOfPeriod(
                  isRunning: game.isGameRunning(DateTime(2000)),
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
}
