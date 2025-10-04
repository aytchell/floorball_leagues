import 'package:flutter/material.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/award.dart';
import 'package:floorball/ui/views/game_details_view/details/player_table.dart';

class AwardAdapter implements TableContentProvider {
  final Award player;

  AwardAdapter({required this.player});

  String get trikotNumber => '${player.trikotNumber}';
  String get playerName => player.name;
  String? get position => null;
}

class AwardedPlayers extends StatelessWidget {
  final DetailedGame game;

  const AwardedPlayers({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.awards == null || game.awards!.notGiven) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Most valuable players',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Home team table
        _buildListForTeam(game.homeTeamName, game.awards!.home),

        const SizedBox(height: 24),

        // Guest team table
        _buildListForTeam(game.guestTeamName, game.awards!.guest),
      ],
    );
  }

  Widget _buildListForTeam(String teamName, List<Award> players) {
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
          providers: players.map((p) => AwardAdapter(player: p)).toList(),
        ),
      ],
    );
  }
}
