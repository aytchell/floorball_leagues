import 'package:flutter/material.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/starting_player.dart';
import 'package:floorball/ui/views/game_details/details/player_table.dart';

class StartingPlayerAdapter implements TableContentProvider {
  final StartingPlayer player;

  StartingPlayerAdapter({required this.player});

  @override
  String get jerseyNumber => '${player.jerseyNumber}';

  @override
  String get playerName => player.name;

  @override
  String? get position {
    if (player.position == 'goal') return 'Tor';
    if (player.position == 'center') return 'Center';
    if (player.position.startsWith('defender')) return 'Verteidigung';
    if (player.position.startsWith('forward')) return 'Angriff';
    return null;
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
