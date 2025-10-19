import 'package:floorball/api/models/game_day_title.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';

class GamesOverviewTable extends StatefulWidget {
  final GameOperationLeague league;
  final LeagueTableRow team;
  final List<Game> games;
  final List<GameDayTitle> gameDayTitles;

  GamesOverviewTable({
    super.key,
    required this.league,
    required this.team,
    required this.games,
  }) : gameDayTitles = league.gameDayTitles;

  @override
  State<GamesOverviewTable> createState() => _GamesOverviewTableState();
}

class _GamesOverviewTableState extends State<GamesOverviewTable> {
  @override
  Widget build(BuildContext context) {
    if (widget.games.isEmpty) {
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
              'Insgesamt: ${widget.games.length}',
              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.games.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final game = widget.games[index];
              return GamesOverviewItem(
                teamName: widget.team.teamName,
                game: game,
              );
            },
          ),
        ],
      ),
    );
  }
}
