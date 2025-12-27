import 'package:floorball/api/models/date_formatter.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/detailed_game.dart';

class GameMetaData extends StatelessWidget {
  final DetailedGame game;

  const GameMetaData({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caption
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text('Spielinfo', style: TextStyles.gameDetailsSection),
        ),

        // Metadata table
        Table(
          columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
          children: [
            _buildTableRow('Liga', game.leagueName),
            _buildTableRow('Spielnummer', game.gameNumber),
            _buildTableRow(
              'Datum',
              beautifyNullableDate(game.date) ?? game.date,
            ),
            _buildTableRow(
              'Spielbeginn',
              game.actualStartTime ?? game.startTime ?? '-',
            ),
            _buildTableRow('Austragungshalle', game.arenaName),
            _buildTableRow('Austragungsort', game.arenaAddress),
            _buildTableRow('Zuschauerzahl', game.audience?.toString() ?? '-'),
            _buildTableRow('Schiedsrichter', _printReferees(game)),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
          child: Text(
            label,
            style: TextStyles.gameMetadataKey,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            value,
            style: TextStyles.gameMetadataValue,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

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
