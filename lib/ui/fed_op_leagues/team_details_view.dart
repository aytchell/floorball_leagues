import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/models/league_table_row.dart';
import '../../app_state.dart';
import '../main_app_scaffold.dart';
import '../widgets/team_logo.dart';

class TeamDetailsView extends StatelessWidget {
  final String leagueName;
  final LeagueTableRow teamEntry;

  const TeamDetailsView({
    Key? key,
    required this.leagueName,
    required this.teamEntry,
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
                  const SizedBox(height: 16),
                  _buildStatisticsTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTable() {
    final statistics = [
      _StatisticItem(label: 'Position', value: '${teamEntry.position}.'),
      _StatisticItem(label: 'Spiele', value: '${teamEntry.games}'),
      _StatisticItem(label: 'Punkte', value: '${teamEntry.points}'),
      _StatisticItem(label: 'Siege', value: '${teamEntry.won}'),
      _StatisticItem(label: 'Unentschieden', value: '${teamEntry.draw}'),
      _StatisticItem(label: 'Niederlagen', value: '${teamEntry.lost}'),
      if (teamEntry.wonOt > 0 || teamEntry.lostOt > 0) ...[
        _StatisticItem(label: 'Siege n.V.', value: '${teamEntry.wonOt}'),
        _StatisticItem(label: 'Niederlagen n.V.', value: '${teamEntry.lostOt}'),
      ],
      _StatisticItem(
        label: 'Tore geschossen',
        value: '${teamEntry.goalsScored}',
      ),
      _StatisticItem(
        label: 'Tore erhalten',
        value: '${teamEntry.goalsReceived}',
      ),
      _StatisticItem(
        label: 'Tordifferenz',
        value: teamEntry.goalsDiff >= 0
            ? '+${teamEntry.goalsDiff}'
            : '${teamEntry.goalsDiff}',
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
}

class _StatisticItem {
  final String label;
  final String value;

  _StatisticItem({required this.label, required this.value});
}
