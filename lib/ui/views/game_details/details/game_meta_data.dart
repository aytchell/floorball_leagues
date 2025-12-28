import 'package:floorball/api/models/date_formatter.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/detailed_game.dart';

class GameMetaData extends StatelessWidget {
  final DetailedGame game;

  const GameMetaData({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final entries = [
      LabeledValue('Liga', game.leagueName),
      LabeledValue('Spielnummer', game.gameNumber),
      LabeledValue('Datum', beautifyNullableDate(game.date) ?? game.date),
      LabeledValue('Spielbeginn', _printStartTime(game)),
      LabeledValue('Austragungshalle', game.arenaName),
      LabeledValue('Austragungsort', game.arenaAddress),
      LabeledValue('Zuschauerzahl', game.audience?.toString() ?? '-'),
      LabeledValue('Schiedsrichter', _printReferees(game)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text('Spielinfo', style: TextStyles.gameDetailsSection),
        ),
        StripedLabeledValueTable(entries),
      ],
    );
  }

  String _printStartTime(DetailedGame game) =>
      game.actualStartTime ?? game.startTime ?? '-';

  String _printReferees(DetailedGame game) {
    if (game.referees.isNotEmpty) {
      return game.referees
          .map((ref) => '${ref.firstName} ${ref.lastName}')
          .reduce((acc, element) => '$acc / $element');
    } else {
      return game.nominatedReferees ?? '-';
    }
  }
}
