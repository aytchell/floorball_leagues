import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../api_models/game_day.dart';
import '../../api_models/detailed_game.dart';
import '../main_app_scaffold.dart';
import '../app_text_styles.dart';
import '../../net/rest_client.dart';

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
          _buildTeamLineups(),
        ],
      ),
    );
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
                      _buildTeamLogo(game.homeTeamLogo),
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
                      _buildTeamLogo(game.guestTeamLogo),
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

  Widget _buildTeamLogo(String? logoPath) {
    final logoHost = 'https://saisonmanager.de';

    if (logoPath != null) {
      return Image.network(
        '${logoHost}${logoPath}',
        width: 48,
        height: 48,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderLogo();
        },
      );
    } else {
      return _buildPlaceholderLogo();
    }
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.sports_soccer, size: 28, color: Colors.grey.shade600),
    );
  }

  Widget _buildTeamLineups() {
    final game = _detailedGame!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aufstellungen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Home team lineup
            Expanded(
              child: _buildTeamLineup(
                game.homeTeamName ?? 'Heim',
                game.players.home,
              ),
            ),

            const SizedBox(width: 16),

            // Guest team lineup
            Expanded(
              child: _buildTeamLineup(
                game.guestTeamName ?? 'Gäste',
                game.players.guest,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamLineup(String teamName, List<Player> players) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (players.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...players.map((player) => _buildPlayerRow(player)),
              const SizedBox(height: 12),
            ],

            if (players.isEmpty)
              const Text(
                'Keine Aufstellung verfügbar',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Player number
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${player.trikotNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Player name and position
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${player.playerFirstname} ${player.playerName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (player.position != null)
                  Text(
                    player.position!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
