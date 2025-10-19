import 'package:floorball/api/models/game_day_title.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';

class GamesOverviewTable extends StatefulWidget {
  final GameOperationLeague league;
  final String teamName;
  final List<GameDayTitle> gameDayTitles;

  GamesOverviewTable({super.key, required this.league, required this.teamName})
    : gameDayTitles = league.gameDayTitles;

  @override
  State<GamesOverviewTable> createState() => _GamesOverviewTableState();
}

class _GamesOverviewTableState extends State<GamesOverviewTable> {
  final List<Game> games = [];

  @override
  void initState() {
    super.initState();

    final loaders = widget.gameDayTitles.map(
      (gdt) => widget.league.getGames(gdt.gameDayNumber),
    );
    loaders.forEach((stream) {
      stream.forEach((futureList) {
        futureList.then((list) {
          final involved = list.where(
            (g) => _isTeamInvolved(g, widget.teamName),
          );
          setState(() {
            games.addAll(involved);
            // TODO: make sure we have no duplicates
            // TODO: sort games according to datetime
          });
        });
      });
    });
  }

  bool _isTeamInvolved(Game game, String teamName) {
    return (teamName == game.homeTeamName) || (teamName == game.guestTeamName);
  }

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
              return GamesOverviewItem(teamName: widget.teamName, game: game);
            },
          ),
        ],
      ),
    );
  }
}
