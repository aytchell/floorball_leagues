import 'package:floorball/api/blocs/detailed_games_cubit.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/player.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/loading_spinner.dart';
import 'package:floorball/ui/views/game_details/details/team_lineup.dart';
import 'package:floorball/ui/views/game_details/details/starting_six.dart';
import 'package:floorball/ui/views/game_details/details/awarded_players.dart';
import 'package:floorball/ui/views/game_details/details/events_of_period.dart';
import 'package:floorball/ui/views/game_details/details/game_meta_data.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
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

  Widget _buildBody(DetailedGame? detailedGame) {
    if (detailedGame == null) {
      return const LoadingSpinner(title: 'Lade Spieldetails ...');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameHeader(detailedGame),
          const SizedBox(height: 24),
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

  Widget _buildGameHeader(DetailedGame detailedGame) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Home team
                _buildTeam(detailedGame.homeLogoUri, detailedGame.homeTeamName),

                // Score/Time
                Expanded(
                  child: Column(
                    children: [
                      if (detailedGame.ended || detailedGame.started)
                        Text(
                          detailedGame.resultString ?? '- : -',
                          style: AppTextStyles.gameCardResultFont.copyWith(
                            fontSize: 24,
                            color: detailedGame.started && !detailedGame.ended
                                ? Colors.pink
                                : Colors.black,
                          ),
                        )
                      else
                        Text(
                          '${detailedGame.startTime ?? '??:??'} Uhr',
                          style: AppTextStyles.gameCardResultFont,
                        ),

                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getGameStatusColor(detailedGame),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getGameStatusText(detailedGame),
                          style: TextStyle(
                            color: Colors.grey[50],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Guest team
                _buildTeam(
                  detailedGame.guestLogoUri,
                  detailedGame.guestTeamName,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildTeam(Uri? logoUri, String teamName) {
    return Expanded(
      child: Column(
        children: [
          TeamLogo(uri: logoUri, height: 48, width: 48),
          const SizedBox(height: 8),
          Text(
            teamName,
            style: AppTextStyles.gameCardTeamFont,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getGameStatusColor(DetailedGame game) {
    if (game.ended) return Colors.green;
    if (game.started) return Colors.orange;
    return Colors.blue;
  }

  String _getGameStatusText(DetailedGame game) {
    if (game.ended) return 'Beendet';
    if (game.started) return 'Läuft';
    return 'Geplant';
  }

  Map<int, String> _buildPlayerNamesMap(List<Player> players) {
    return groupBy(
      players,
      (player) => player.trikotNumber,
    ).map((k, v) => MapEntry(k, v[0].name));
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
