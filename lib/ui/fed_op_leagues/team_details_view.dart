import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_table_view/material_table_view.dart';

import '../../api/models/league_table_row.dart';
import '../../api/models/scorer.dart';
import '../../app_state.dart';
import '../main_app_scaffold.dart';
import '../widgets/team_logo.dart';

class IndexedScorer {
  final int index;
  final Scorer scorer;

  IndexedScorer({required this.index, required this.scorer});
}

class TeamDetailsView extends StatelessWidget {
  final String leagueName;
  final LeagueTableRow teamEntry;
  final List<Scorer> scorers;

  const TeamDetailsView({
    Key? key,
    required this.leagueName,
    required this.teamEntry,
    required this.scorers,
  }) : super(key: key);

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
                    'Tabellenplatz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatisticsTable(),
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
                    'Scorer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildScorerTable(),
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

  Widget _buildStatisticsTable() {
    final statistics = [
      _StatisticItem(label: 'Position', value: '${teamEntry.position}.'),
      _StatisticItem(label: 'Spiele', value: '${teamEntry.games}'),
      _StatisticItem(label: 'Punkte', value: _buildPoints()),
      _StatisticItem(label: 'S | U | N', value: _buildGameOutcomes()),
      _StatisticItem(label: 'Tore', value: _buildGoals()),
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

  Widget _buildScorerTable() {
    // Handle empty scorers list
    if (scorers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Keine TorschÃ¼tzen verfÃ¼gbar',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    final teamScorers = scorers
        .mapIndexed(
          (index, scorer) => IndexedScorer(
            index: index + 1, // Start ranking from 1
            scorer: scorer,
          ),
        )
        .where((entry) => entry.scorer.teamId == teamEntry.teamId)
        .toList();

    final rankColumnWidth = (scorers.length >= 100) ? 30.0 : 20.0;

    return Container(
      height: 300, // Set a fixed height for the table
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TableView.builder(
        columns: [
          TableColumn(width: rankColumnWidth), // ranking column
          const TableColumn(
            width: 150.0,
            freezePriority: 100,
          ), // Player name column
          const TableColumn(width: 30.0), // games column
          const TableColumn(width: 40.0), // points column
          const TableColumn(width: 40.0), // goals column
          const TableColumn(width: 40.0), // assists column
        ],
        rowCount: teamScorers.length,
        rowHeight: 34.0,
        headerHeight: 60.0, // Increased height for rotated text
        headerBuilder: (context, contentBuilder) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: contentBuilder(context, (context, column) {
              switch (column) {
                case 0:
                  return Container(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Platz',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                case 1:
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                  );
                case 2:
                  return Container(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Spiele',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                case 3:
                  return Container(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Punkte',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                case 4:
                  return Container(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Tore',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                case 5:
                  return Container(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Assists',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            }),
          );
        },
        rowBuilder: (context, row, contentBuilder) {
          final rank = teamScorers[row].index;
          final scorer = teamScorers[row].scorer;

          return Material(
            type: MaterialType.transparency,
            child: InkWell(
              child: contentBuilder(context, (context, column) {
                switch (column) {
                  case 0:
                    return Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$rank',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  case 1:
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        scorer.fullName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  case 2:
                    return _scorerData('${scorer.games}');
                  case 3:
                    return _scorerData('${scorer.points}');
                  case 4:
                    return _scorerData('${scorer.goals}');
                  case 5:
                    return _scorerData('${scorer.assists}');
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _scorerData(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

class _StatisticItem {
  final String label;
  final String value;

  _StatisticItem({required this.label, required this.value});
}
