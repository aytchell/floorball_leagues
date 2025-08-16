import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

import '../../app_state.dart';
import '../../api_models/game_day.dart';
import '../../api_models/detailed_game.dart';
import '../../api_models/period_title.dart';
import '../main_app_scaffold.dart';
import '../app_text_styles.dart';
import '../../net/rest_client.dart';
import 'details/team_lineup.dart';
import 'details/events_of_period.dart';
import 'details/team_logo.dart';

class GameDetailPage extends StatefulWidget {
  final int gameId;

  const GameDetailPage({super.key, required this.gameId});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  DetailedGame? _detailedGame;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final restClient = await RestClient.instance;

      final detailedGame = await DetailedGame.fetchFromServer(
        restClient,
        widget.gameId,
      );

      setState(() {
        _detailedGame = detailedGame;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return MainAppScaffold(
      title: 'Spieldetails',
      showBackButton: true,
      body: _buildBody(),
      selectedSeason: appState.selectedSeason,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Fehler beim Laden der Spieldetails',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
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
      _buildTeamLineups(),
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
                Expanded(
                  child: Column(
                    children: [
                      TeamLogo(
                        logoPath: game.homeTeamLogo,
                        height: 48,
                        width: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.homeTeamName ?? 'Unbekannt',
                        style: AppTextStyles.gameCardTeamFont,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

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
                Expanded(
                  child: Column(
                    children: [
                      TeamLogo(
                        logoPath: game.guestTeamLogo,
                        height: 48,
                        width: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.guestTeamName ?? 'Unbekannt',
                        style: AppTextStyles.gameCardTeamFont,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
                  homeLogo: game.homeTeamSmallLogo,
                  guestLogo: game.guestTeamSmallLogo,
                  events: groupedEvents[period.period],
                ),
              ];
            })
            .expand((i) => i)
            .toList(),
      ],
    );
  }

  Widget _buildTeamLineups() {
    final game = _detailedGame!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aufstellung',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Home team table
        TeamLineup(teamName: game.homeTeamName, players: game.players.home),

        const SizedBox(height: 24),

        // Guest team table
        TeamLineup(teamName: game.guestTeamName, players: game.players.guest),
      ],
    );
  }
}
