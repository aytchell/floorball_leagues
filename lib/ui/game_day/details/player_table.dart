import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract interface class TableContentProvider {
  String get trikotNumber;
  String get playerName;
  String? get position;
}

class PlayerTable extends StatelessWidget {
  final List<TableContentProvider> providers;

  const PlayerTable({required this.providers});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Table rows
          if (providers.isNotEmpty)
            ...providers.asMap().entries.map((entry) {
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
                        player.trikotNumber,
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
                        player.playerName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    ..._buildPosition(player),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  List<Widget> _buildPosition(TableContentProvider player) {
    if (player.position == null) {
      return [const SizedBox.shrink()];
    }

    return [
      const SizedBox(width: 12),

      // Position
      SizedBox(
        width: 90,
        child: Text(
          player.position!,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.right,
        ),
      ),
    ];
  }
}
