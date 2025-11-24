import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/ui/views/team_details_2/team_penalties_2.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/ui/widgets/striped_table_row.dart';

class _StatisticItem {
  final String label;
  final String value;

  _StatisticItem({required this.label, required this.value});
}

class TeamStatisticsTable2 extends StatelessWidget {
  final LeagueTableRow team;
  final List<Scorer> scorers;
  final int seasonId;

  const TeamStatisticsTable2({
    super.key,
    required this.team,
    required this.scorers,
    required this.seasonId,
  });

  @override
  Widget build(BuildContext context) {
    final TeamPenalties2 penalties = TeamPenalties2.extract(scorers, seasonId);

    final statistics = [
      _StatisticItem(label: 'Position', value: '${team.position}.'),
      _StatisticItem(label: 'Spiele', value: '${team.games}'),
      _StatisticItem(label: 'Punkte', value: _buildPoints()),
      _StatisticItem(
        label: 'S | S(OT) | U | N(OT) | N',
        value: _buildGameOutcomes(),
      ),
      _StatisticItem(label: 'Tore', value: _buildGoals()),
      _StatisticItem(
        label: penalties.expiringTitle(),
        value: penalties.expiringPenaltiesAsString(),
      ),
      _StatisticItem(
        label: penalties.matchTitle(),
        value: penalties.matchPenaltiesAsString(),
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

          return StripedTableRow(
            index: index,
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
    return '${team.won} | ${team.wonOt} | ${team.draw} | ${team.lostOt} | ${team.lost}';
  }

  String _buildGoals() {
    final diff = (team.goalsDiff >= 0)
        ? '+${team.goalsDiff}'
        : '${team.goalsDiff}';
    return '${team.goalsScored}:${team.goalsReceived} | $diff';
  }
}
