import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildLeagueInfoPanel(int identifier, League league) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Liga-Infos',
    body: _LeagueInfoContent(league: league),
  );
}

class _LeagueInfoContent extends StatelessWidget {
  final League league;

  const _LeagueInfoContent({required this.league});

  @override
  Widget build(BuildContext context) {
    final entries = [
      LabeledString('Modus', _leagueType()),
      LabeledString('Spielfeld', _fieldSize()),
      LabeledString('Spielabschnitte', _periodNumber()),
      LabeledString(_periodDurationLabel(), _minutes(league.periodLength)),
      LabeledString('Dauer der Verlängerung', _minutes(league.overtimeLength)),
      LabeledString('Damen / Mixed', _femaleOrMixed()),
      LabeledString('Jahrgänge', _playerAges()),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: StripedLabeledValueTable(entries),
    );
  }

  String _leagueType() {
    switch (league.leagueType) {
      case LeagueType.league:
        return 'Liga';
      case LeagueType.champ:
        return 'Turnier';
      case LeagueType.cup:
        return 'Pokal';
    }
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

  String _periodDurationLabel() {
    if (league.periods != null) {
      if (league.periods == 2) return 'Dauer jeder Halbzeit';
      if (league.periods == 3) return 'Dauer jedes Drittels';
    }
    return 'Dauer jedes Abschnitts';
  }

  String _minutes(int? value) {
    if (value != null) {
      return '$value min';
    }
    return 'Nicht angegeben';
  }

  String _femaleOrMixed() {
    if (league.female == null) return 'Nicht angegeben';
    return (league.female!) ? 'Damen' : 'Mixed';
  }

  String _playerAges() {
    if (league.deadline == null || league.beforeDeadline == null) {
      return 'unbeschränkt';
    }

    final youngerOrOlder = (league.beforeDeadline!)
        ? 'und älter'
        : 'und jünger';
    return '${league.beautifiedDeadline!}\n$youngerOrOlder';
  }
}
