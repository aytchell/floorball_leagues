import 'package:flutter/material.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/expandable_card.dart';
import 'package:floorball/ui/widgets/striped_table_row.dart';

class ExpandablLeagueInfoCard extends StatelessWidget {
  final String title;
  final GameOperationLeague league;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandablLeagueInfoCard({
    Key? key,
    required this.title,
    required this.league,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: title,
      isExpanded: isExpanded,
      onTap: onTap,
      child: _buildLeagueInfoContent(),
    );
  }

  Widget _buildLeagueInfoContent() {
    final infoItems = _getLeagueInfoItems();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: infoItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return StripedTableRow(
            index: index,
            child: Row(
              children: [
                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Value
                SizedBox(
                  width: 120,
                  child: Text(
                    item.value,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _leagueType() {
    if (league.leagueType == null) return 'Nicht angegeben';
    if (league.leagueType! == 'league') return 'Liga';
    if (league.leagueType! == 'champ') return 'Turnier';
    if (league.leagueType! == 'cup') return 'Pokal';
    return league.leagueType!;
  }

  String _fieldSize() {
    if (league.fieldSize == null) return 'Nicht angegeben';
    if (league.fieldSize! == 'KF') return 'Kleinfeld';
    if (league.fieldSize! == 'GF') return 'Großfeld';
    return league.fieldSize!;
  }

  String _periodNumber() {
    if (league.periods == null) return 'Nicht angegeben';
    if (league.periods! == 2) return '2 Hälften';
    if (league.periods! == 3) return '3 Drittel';
    return league.periods!.toString();
  }

  String _femaleOrMixed() {
    if (league.female == null) return 'Nicht angegeben';
    return (league.female!) ? 'Damen' : 'Mixed';
  }

  String _playerAges() {
    if (league.deadline == null || league.beforeDeadline == null)
      return 'Nicht angegeben';

    final youngerOrOlder = (league.beforeDeadline!)
        ? 'und älter'
        : 'und jünger';
    return '${league.beautifiedDeadline!}\n$youngerOrOlder';
  }

  List<LeagueInfoItem> _getLeagueInfoItems() {
    return [
      LeagueInfoItem(label: 'Modus', value: _leagueType()),
      LeagueInfoItem(label: 'Spielfeld', value: _fieldSize()),
      LeagueInfoItem(label: 'Spielabschnitte', value: _periodNumber()),
      LeagueInfoItem(
        label: 'Dauer der Abschnitte (Minuten)',
        value: league.periodLength?.toString() ?? 'Nicht angegeben',
      ),
      LeagueInfoItem(
        label: 'Dauer der Verlängerung (Minuten)',
        value: league.overtimeLength?.toString() ?? 'Nicht angegeben',
      ),
      LeagueInfoItem(label: 'Damen / Mixed', value: _femaleOrMixed()),
      LeagueInfoItem(label: 'Jahrgänge', value: _playerAges()),
    ];
  }
}

class LeagueInfoItem {
  final String label;
  final String value;

  LeagueInfoItem({required this.label, required this.value});
}
