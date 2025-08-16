import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../api_models/detailed_game.dart';
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
  final String teamName;
  final List<StartingPlayer> players;

  const StartingSix({super.key, required this.teamName, required this.players});

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
          providers: players
              .map((p) => StartingPlayerAdapter(player: p))
              .toList(),
        ),
      ],
    );
  }
}
