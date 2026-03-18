import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:flutter/material.dart';

class ArenaInfo extends StatelessWidget {
  final DetailedGame game;
  final _ArenaAddress _arenaAddress;

  ArenaInfo({super.key, required this.game})
    : _arenaAddress = _ArenaAddress.from(game.arenaAddress);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(game.arenaName, style: TextStyles.gameDetailHeaderArenaInfo),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _arenaAddress.street,
                style: TextStyles.gameDetailHeaderArenaInfo,
                maxLines: 2,
              ),
              Text(
                _arenaAddress.town,
                style: TextStyles.gameDetailHeaderArenaInfo,
              ),
            ],
          ),
          ...maybeRenderNavigationArrow(
            address: game.arenaAddress,
            locationName: game.arenaName,
            prepend: SizedBox(width: 12),
          ),
        ],
      ),
    ],
  );
}

class _ArenaAddress {
  final String street;
  final String town;

  static final _zipRegExp = RegExp(r'\d{5}');

  _ArenaAddress(this.street, this.town);

  factory _ArenaAddress.from(String address) {
    final zipCodeMatch = _zipRegExp.firstMatch(address);

    if (zipCodeMatch == null) {
      // No zip code found, return the whole address as street
      return _ArenaAddress(address, '');
    }

    final zipCodeStart = zipCodeMatch.start;
    final street = address.substring(0, zipCodeStart).trim();
    final town = address.substring(zipCodeStart).trim();

    return _ArenaAddress(street, town);
  }
}
