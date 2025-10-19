import 'package:flutter/material.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';

class GamesOverviewTable extends StatelessWidget {
  final LeagueTableRow team;
  final List<Game> games;

  GamesOverviewTable({required this.team, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Keine Spiele verfügbar',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Insgesamt: ${games.length}',
              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final game = games[index];
              return GamesOverviewItem(teamName: team.teamName, game: game);
            },
          ),
        ],
      ),
    );
  }
}

