import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/ui/views/league_details_2/panel_title.dart';
import 'package:flutter/material.dart';

import '../../widgets/striped_table_row.dart';

ExpansionPanelRadio buildLeagueInfoPanel(
  int identifier,
  GameOperationLeague league,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Liga-Infos'),
    body: _LeagueInfoContent(league: league),
  );
}

class _LeagueInfoContent extends StatelessWidget {
  final GameOperationLeague league;

  const _LeagueInfoContent({required this.league});

  @override
  Widget build(BuildContext context) {
    final infoItems = _getLeagueInfoItems();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
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
    if (league.deadline == null || league.beforeDeadline == null) {
      return 'Nicht angegeben';
    }

    final youngerOrOlder = (league.beforeDeadline!)
        ? 'und älter'
        : 'und jünger';
    return '${league.beautifiedDeadline!}\n$youngerOrOlder';
  }

  List<_LeagueInfoItem> _getLeagueInfoItems() {
    return [
      _LeagueInfoItem(label: 'Modus', value: _leagueType()),
      _LeagueInfoItem(label: 'Spielfeld', value: _fieldSize()),
      _LeagueInfoItem(label: 'Spielabschnitte', value: _periodNumber()),
      _LeagueInfoItem(
        label: 'Dauer der Abschnitte (Minuten)',
        value: league.periodLength?.toString() ?? 'Nicht angegeben',
      ),
      _LeagueInfoItem(
        label: 'Dauer der Verlängerung (Minuten)',
        value: league.overtimeLength?.toString() ?? 'Nicht angegeben',
      ),
      _LeagueInfoItem(label: 'Damen / Mixed', value: _femaleOrMixed()),
      _LeagueInfoItem(label: 'Jahrgänge', value: _playerAges()),
    ];
  }
}

class _LeagueInfoItem {
  final String label;
  final String value;

  _LeagueInfoItem({required this.label, required this.value});
}
