import 'package:flutter/material.dart';
import "package:collection/collection.dart";

import 'package:floorball/api/models/game.dart';
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

class GameDetailPage extends StatefulWidget {
  final String leagueName;
  final Game game;

  const GameDetailPage({
    super.key,
    required this.leagueName,
    required this.game,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  DetailedGame? _detailedGame;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _setStateFromDetailedGame(DetailedGame detailedGame) {
    setState(() {
      _detailedGame = detailedGame;
      _isLoading = false;
    });
  }

  Future<void> _loadData() async {
    widget.game.getDetailedVersion().forEach((futureGame) {
      futureGame.then((game) => _setStateFromDetailedGame(game));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: widget.leagueName,
      showBackButton: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingSpinner(title: 'Lade Spieldetails ...');
    }

    if (_detailedGame == null) {
      return const Center(child: Text('Keine Spieldetails gefunden'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameHeader(),
          const SizedBox(height: 24),
          ..._buildGameDetails(),
          const SizedBox(height: 24),
          GameMetaData(game: _detailedGame!),
        ],
      ),
    );
  }

  List<Widget> _buildGameDetails() {
    if (_detailedGame!.currentPeriodTitle == null) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Noch keine Spieldaten vorhanden',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ];
    }
    return [
      _buildGameEvents(),
      const SizedBox(height: 24),
      TeamLineup(game: _detailedGame!),
      const SizedBox(height: 24),
      StartingSix(game: _detailedGame!),
      const SizedBox(height: 24),
      AwardedPlayers(game: _detailedGame!),
    ];
  }

  Widget _buildGameHeader() {
    final game = _detailedGame!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Home team
                _buildTeam(game.homeLogoUri, game.homeTeamName),

                // Score/Time
                Expanded(
                  child: Column(
                    children: [
                      if (game.ended || game.started)
                        Text(
                          game.resultString ?? '- : -',
                          style: AppTextStyles.gameCardResultFont.copyWith(
                            fontSize: 24,
                            color: game.started && !game.ended
                                ? Colors.pink
                                : Colors.black,
                          ),
                        )
                      else
                        Text(
                          '${game.startTime ?? '??:??'} Uhr',
                          style: AppTextStyles.gameCardResultFont,
                        ),

                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getGameStatusColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getGameStatusText(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Guest team
                _buildTeam(game.guestLogoUri, game.guestTeamName),
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

  Color _getGameStatusColor() {
    final game = _detailedGame!;
    if (game.ended) return Colors.green;
    if (game.started) return Colors.orange;
    return Colors.blue;
  }

  String _getGameStatusText() {
    final game = _detailedGame!;
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

  Widget _buildGameEvents() {
    final game = _detailedGame!;
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
