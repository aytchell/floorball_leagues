import 'package:flutter/material.dart';
import '../../../api_models/detailed_game.dart';
import '../../../api/models/starting_player.dart';
import 'player_table.dart';

class StartingPlayerAdapter implements TableContentProvider {
  final StartingPlayer player;

  StartingPlayerAdapter({required this.player});

  String get trikotNumber => '${player.trikotNumber}';
  String get playerName => player.name;

  String? get position {
    if (player.position == 'goal') return 'Tor';
    if (player.position == 'center') return 'Center';
    if (player.position.startsWith('defender')) return 'Verteidigung';
    if (player.position.startsWith('forward')) return 'Angriff';
  }
}

class StartingSix extends StatelessWidget {
  final DetailedGame game;

  const StartingSix({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.startingPlayers == null || game.startingPlayers!.notGiven) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Starting six',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Home team table
        _buildListForTeam(game.homeTeamName, game.startingPlayers!.home),

        const SizedBox(height: 24),

        // Guest team table
        _buildListForTeam(game.guestTeamName, game.startingPlayers!.guest),
      ],
    );
  }

  Widget _buildListForTeam(String teamName, List<StartingPlayer> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team name header
        Text(
          teamName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        PlayerTable(
          providers: players
              .map((p) => StartingPlayerAdapter(player: p))
              .toList(),
        ),
      ],
    );
  }
}
