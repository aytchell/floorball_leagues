import 'package:flutter/material.dart';
import '../../../api_models/detailed_game.dart';

class GameMetaData extends StatelessWidget {
  final DetailedGame game;

  GameMetaData({required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caption
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Spielinfo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Metadata table
        Table(
          columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
          children: [
            _buildTableRow('Liga', game.leagueName),
            _buildTableRow('Spielnummer', game.gameNumber),
            _buildTableRow('Datum', game.date),
            _buildTableRow('Austragungshalle', game.arenaName),
            _buildTableRow('Austragungsort', game.arenaAddress),
            _buildTableRow('Spielbeginn', game.startTime ?? '-'),
            _buildTableRow('Zuschauerzahl', game.audience?.toString() ?? '-'),
            _buildTableRow('Schiedsrichter', game.nominatedReferees ?? '-'),
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
            '$label:',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
