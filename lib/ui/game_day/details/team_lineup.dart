import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../api_models/detailed_game.dart';
import 'player_table.dart';

class PlayerAdapter implements TableContentProvider {
  final Player player;

  PlayerAdapter({required this.player});

  String get trikotNumber => '${player.trikotNumber}';
  String get playerName => player.name;
  String? get position => player.position;
}

class TeamLineup extends StatelessWidget {
  final String teamName;
  final List<Player> players;

  const TeamLineup({super.key, required this.teamName, required this.players});

  @override
  Widget build(BuildContext context) {
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
