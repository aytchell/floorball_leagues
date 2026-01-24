import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:flutter/material.dart';

class ArenaInfo extends StatelessWidget {
  final DetailedGame game;

  const ArenaInfo({super.key, required this.game});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            game.arenaName,
            style: TextStyles.gameDetailHeaderArenaInfo,
            textAlign: TextAlign.center,
          ),
          ...maybeRenderNavigationArrow(
            address: game.arenaAddress,
            locationName: game.arenaName,
            prepend: SizedBox(width: 12),
          ),
        ],
      ),
      const SizedBox(height: 2),
      Text(
        game.arenaAddress,
        style: TextStyles.gameDetailHeaderArenaInfo,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
