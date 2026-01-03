import 'package:collection/collection.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:floorball/ui/widgets/striped_table_row.dart';

abstract interface class TableContentProvider {
  String get jerseyNumber;
  String get playerName;
  String? get position;
  bool? get captain;
}

class PlayerTable extends StatelessWidget {
  final List<TableContentProvider> providers;

  const PlayerTable({super.key, required this.providers});

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
            ...providers.mapIndexed((index, player) {
              return StripedTableRow(
                index: index,
                child: Row(
                  children: [
                    // Jersey icon
                    SizedBox(
                      width: 22,
                      child: SvgPicture.asset(
                        'assets/images/jersey_small.svg',
                        width: 18,
                        height: 18,
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
                        player.jerseyNumber,
                        style: TextStyles.teamLineupJersey,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Player name
                    Expanded(
                      child: Text(
                        player.playerName,
                        style: TextStyles.teamLineupName,
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
      Text(
        ((player.captain ?? false) ? 'Kapitän, ' : '') + player.position!,
        style: TextStyles.teamLineupType,
        textAlign: TextAlign.right,
      ),
    ];
  }
}
