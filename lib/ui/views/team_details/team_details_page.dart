import 'package:floorball/api/models/game_operation_league.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/app_state.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/ui/views/team_details/indexed_scorer.dart';
import 'package:floorball/ui/views/team_details/player_statistics_table.dart';
import 'package:floorball/ui/views/team_details/team_statistics_table.dart';
import 'package:floorball/ui/views/team_details/games_overview_table.dart';

final int someSeasonIdWithNewPenalties = 16;

class TeamDetailsPage extends StatefulWidget {
  final GameOperationLeague league;
  final LeagueTableRow teamEntry;
  final List<Game> teamGames;

  const TeamDetailsPage({
    super.key,
    required this.league,
    required this.teamEntry,
    required this.teamGames,
  });

  @override
  State<StatefulWidget> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetailsPage> {
  List<IndexedScorer> teamScorers = [];

  @override
  void initState() {
    super.initState();

    widget.league.getScorers().forEach((futureList) {
      futureList.then((list) {
        final teamScorers = _extractTeamScorers(list, widget.teamEntry.teamId);
        setState(() {
          this.teamScorers = teamScorers;
        });
      });
    });
  }

  List<IndexedScorer> _extractTeamScorers(List<Scorer> scorers, int teamId) {
    return scorers
        .mapIndexed(
          (index, scorer) => IndexedScorer(
            index: index + 1, // Start ranking from 1
            scorer: scorer,
          ),
        )
        .where((entry) => entry.scorer.teamId == teamId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return MainAppScaffold(
      title: widget.league.name,
      showBackButton: true,
      body: _buildBody(
        appState.selectedSeason?.id ?? someSeasonIdWithNewPenalties,
      ),
      selectedSeason: appState.selectedSeason,
    );
  }

  Widget _buildBody(int seasonId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // Team Logo
          TeamLogo(uri: widget.teamEntry.teamLogoUri, height: 120, width: 120),

          const SizedBox(height: 24),

          // Team Name
          Text(
            widget.teamEntry.teamName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Team Statistics Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mannschaft',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TeamStatisticsTable(
                    team: widget.teamEntry,
                    scorers: teamScorers,
                    seasonId: seasonId,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Spiele',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GamesOverviewTable(
                    team: widget.teamEntry,
                    games: widget.teamGames,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Spieler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  PlayerStatisticsTable(scorers: teamScorers),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
