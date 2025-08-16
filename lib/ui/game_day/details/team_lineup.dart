import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../api_models/detailed_game.dart';

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

        // Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Table rows
              if (players.isNotEmpty)
                ...players.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  final isEven = index % 2 == 0;

                  return Container(
                    decoration: BoxDecoration(
                      color: isEven ? Colors.grey.shade50 : Colors.white,
                      border: index > 0
                          ? Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Jersey icon
                        SizedBox(
                          width: 30,
                          child: SvgPicture.asset(
                            'assets/images/trikot_small.svg',
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Player number
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${player.trikotNumber}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Player name
                        Expanded(
                          child: Text(
                            player.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Position
                        SizedBox(
                          width: 60,
                          child: Text(
                            player.position,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              // Empty state
              if (players.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Keine Aufstellung verfügbar',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
