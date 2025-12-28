import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/ui/views/team_details/team_penalties.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';

class TeamStatisticsTable extends StatelessWidget {
  final LeagueTableRow team;
  final List<Scorer> scorers;
  final int seasonId;

  const TeamStatisticsTable({
    super.key,
    required this.team,
    required this.scorers,
    required this.seasonId,
  });

  @override
  Widget build(BuildContext context) {
    final TeamPenalties penalties = TeamPenalties.extract(scorers, seasonId);

    final statistics = [
      LabeledValue(label: 'Position', value: '${team.position}.'),
      LabeledValue(label: 'Spiele', value: '${team.games}'),
      LabeledValue(label: 'Punkte', value: _buildPoints()),
      LabeledValue(
        label: 'S | S(nV) | U | N(nV) | N',
        value: _buildGameOutcomes(),
      ),
      LabeledValue(label: 'Tore', value: _buildGoals()),
      LabeledValue(
        label: penalties.expiringTitle(),
        value: penalties.expiringPenaltiesAsString(),
      ),
      LabeledValue(
        label: penalties.matchTitle(),
        value: penalties.matchPenaltiesAsString(),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: StripedLabeledValueTable(statistics),
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
