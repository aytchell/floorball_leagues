import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../api/models/league_table_row.dart';
import '../../api/models/scorer.dart';
import '../../api/models/game.dart';
import '../../app_state.dart';
import '../main_app_scaffold.dart';
import '../widgets/team_logo.dart';
import 'indexed_scorer.dart';
import 'player_statistics_table.dart';
import 'team_statistics_table.dart';
import 'games_overview_table.dart';

final int someSeasonIdWithNewPenalties = 16;

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

class TeamDetailsView extends StatelessWidget {
  final String leagueName;
  final LeagueTableRow teamEntry;
  final List<Scorer> scorers;
  final List<Game> teamGames;
  final List<IndexedScorer> teamScorers;

  TeamDetailsView({
    Key? key,
    required this.leagueName,
    required this.teamEntry,
    required this.scorers,
    required this.teamGames,
  }) : teamScorers = _extractTeamScorers(scorers, teamEntry.teamId),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return MainAppScaffold(
      title: leagueName,
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
          TeamLogo(uri: teamEntry.teamLogoUri, height: 120, width: 120),

          const SizedBox(height: 24),

          // Team Name
          Text(
            teamEntry.teamName,
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
                    team: teamEntry,
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
                  GamesOverviewTable(team: teamEntry, games: teamGames),
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
