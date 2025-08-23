import 'package:flutter/material.dart';
import '../../api/models/league_table_row.dart';
import '../../api/models/scorer.dart';
import 'indexed_scorer.dart';

class TeamPenalties {
  int penalty2;
  int penalty2and2;
  int penalty10;

  TeamPenalties({this.penalty2 = 0, this.penalty2and2 = 0, this.penalty10 = 0});

  factory TeamPenalties.extract(List<IndexedScorer> scorers) {
    return scorers
        .map((idx) => idx.scorer)
        .fold(TeamPenalties(), (penalties, scorer) => penalties.plus(scorer));
  }

  TeamPenalties plus(Scorer scorer) {
    penalty2 = penalty2 + scorer.penalty2;
    penalty2and2 = penalty2and2 + scorer.penalty2and2;
    penalty10 = penalty10 + scorer.penalty10;
    return this;
  }

  String toString() {
    return '${penalty2}, ${penalty2and2}, ${penalty10}';
  }
}

class _StatisticItem {
  final String label;
  final String value;

  _StatisticItem({required this.label, required this.value});
}

class TeamStatisticsTable extends StatelessWidget {
  final LeagueTableRow team;
  final List<IndexedScorer> scorers;

  TeamStatisticsTable({required this.team, required this.scorers});

  @override
  Widget build(BuildContext context) {
    final statistics = [
      _StatisticItem(label: 'Position', value: '${team.position}.'),
      _StatisticItem(label: 'Spiele', value: '${team.games}'),
      _StatisticItem(label: 'Punkte', value: _buildPoints()),
      _StatisticItem(label: 'S | U | N', value: _buildGameOutcomes()),
      _StatisticItem(label: 'Tore', value: _buildGoals()),
      _StatisticItem(
        label: 'Strafen (2, 2+2, 10)',
        value: TeamPenalties.extract(scorers).toString(),
      ),
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

  String _buildPoints() {
    return '${team.points} (von ${3 * team.games})';
  }

  String _buildGameOutcomes() {
    return '${team.won} | ${team.draw} | ${team.lost}';
  }

  String _buildGoals() {
    final diff = (team.goalsDiff >= 0)
        ? '+${team.goalsDiff}'
        : '${team.goalsDiff}';
    return '${team.goalsScored}:${team.goalsReceived} | $diff';
  }
}
