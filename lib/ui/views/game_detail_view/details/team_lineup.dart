import 'package:flutter/material.dart';
import 'package:floorball/api/models/player.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/views/game_detail_view/details/player_table.dart';

class PlayerAdapter implements TableContentProvider {
  final Player player;

  PlayerAdapter({required this.player});

  String get trikotNumber => '${player.trikotNumber}';
  String get playerName => player.name;
  String? get position => player.position;
}

class TeamLineup extends StatelessWidget {
  final DetailedGame game;

  const TeamLineup({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aufstellung',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Home team table
        _buildListForTeam(game.homeTeamName, game.players.home),

        const SizedBox(height: 24),

        // Guest team table
        _buildListForTeam(game.guestTeamName, game.players.guest),
      ],
    );
  }

  Widget _buildListForTeam(final String teamName, final List<Player> players) {
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
          providers: players.map((p) => PlayerAdapter(player: p)).toList(),
        ),
      ],
    );
  }
}
