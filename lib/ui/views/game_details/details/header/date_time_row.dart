import 'package:floorball/api/models/date_formatter.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:flutter/material.dart';

class DateTimeRow extends StatelessWidget {
  final DetailedGame game;
  final TextStyle style;

  static const enDash = '\u2013';

  const DateTimeRow({super.key, required this.game, required this.style});

  @override
  Widget build(BuildContext context) {
    final dateStr = beautifyDate(game.date);
    final timeStr = '${game.startTime} Uhr';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(dateStr, style: style),
        SizedBox(width: 6),
        Text(enDash, style: style),
        SizedBox(width: 6),
        Text(timeStr, style: style),
      ],
    );
  }
}
