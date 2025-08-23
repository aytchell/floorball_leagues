import 'package:flutter/material.dart';
import '../../api/models/league_table_row.dart';
import '../../api/models/game.dart';

class GamesOverviewTable extends StatelessWidget {
  final LeagueTableRow team;
  final List<Game> games;

  GamesOverviewTable({required this.team, required this.games});

  @override
  Widget build(BuildContext context) {
    return Text('Es sind ${games.length} Spiele');
  }
}
