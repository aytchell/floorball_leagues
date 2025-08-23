import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../api/models/league_table_row.dart';
import '../../api/models/scorer.dart';
import '../../app_state.dart';
import '../main_app_scaffold.dart';
import '../widgets/team_logo.dart';
import 'player_statistics_table.dart';

class TeamPenalties {
  int penalty2;
  int penalty2and2;
  int penalty10;

  TeamPenalties({this.penalty2 = 0, this.penalty2and2 = 0, this.penalty10 = 0});

  TeamPenalties plus(Scorer scorer) {
    return TeamPenalties(
      penalty2: penalty2 + scorer.penalty2,
      penalty2and2: penalty2and2 + scorer.penalty2and2,
      penalty10: penalty10 + scorer.penalty10,
    );
  }

  String toString() {
    return '${penalty2}, ${penalty2and2}, ${penalty10}';
  }
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

class TeamDetailsView extends StatelessWidget {
  final String leagueName;
  final LeagueTableRow teamEntry;
  final List<Scorer> scorers;
  final List<IndexedScorer> teamScorers;

  TeamDetailsView({
    Key? key,
    required this.leagueName,
    required this.teamEntry,
    required this.scorers,
  }) : teamScorers = _extractTeamScorers(scorers, teamEntry.teamId),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return MainAppScaffold(
      title: leagueName,
      showBackButton: true,
      body: _buildBody(context),
      selectedSeason: appState.selectedSeason,
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  _buildTeamTable(),
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

  String _buildPoints() {
    return '${teamEntry.points} (von ${3 * teamEntry.games})';
  }

  String _buildGameOutcomes() {
    return '${teamEntry.won} | ${teamEntry.draw} | ${teamEntry.lost}';
  }

  String _buildGoals() {
    final diff = (teamEntry.goalsDiff >= 0)
        ? '+${teamEntry.goalsDiff}'
        : '${teamEntry.goalsDiff}';
    return '${teamEntry.goalsScored}:${teamEntry.goalsReceived} | $diff';
  }

  String _buildPenalties() {
    return teamScorers
        .map((idx) => idx.scorer)
        .fold(TeamPenalties(), (penalties, scorer) => penalties.plus(scorer))
        .toString();
  }

  Widget _buildTeamTable() {
    final statistics = [
      _StatisticItem(label: 'Position', value: '${teamEntry.position}.'),
      _StatisticItem(label: 'Spiele', value: '${teamEntry.games}'),
      _StatisticItem(label: 'Punkte', value: _buildPoints()),
      _StatisticItem(label: 'S | U | N', value: _buildGameOutcomes()),
      _StatisticItem(label: 'Tore', value: _buildGoals()),
      _StatisticItem(label: 'Strafen: 2, 2+2, 10)', value: _buildPenalties()),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: statistics.asMap().entries.map((entry) {
          final index = entry.key;
          final statistic = entry.value;
          final isEven = index % 2 == 0;

          return Container(
            decoration: BoxDecoration(
              color: isEven ? Colors.grey.shade50 : Colors.white,
              border: index > 0
                  ? Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 0.5),
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    statistic.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  statistic.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatisticItem {
  final String label;
  final String value;

  _StatisticItem({required this.label, required this.value});
}
