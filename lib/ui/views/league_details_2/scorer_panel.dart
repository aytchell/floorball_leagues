import 'package:floorball/ui/views/league_details_2/generic_striped_table.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floorball/api/blocs/scorer_cubit.dart';
import 'package:floorball/ui/views/league_details_2/panel_title.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:material_table_view/material_table_view.dart';

ExpansionPanelRadio buildScorerPanel(int identifier, int leagueId) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Scorer'),
    body: _ScorerTableContent(leagueId: leagueId),
  );
}

class _ScorerTableContent extends GenericStripedTable<Scorer> {
  final int leagueId;

  const _ScorerTableContent({required this.leagueId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScorerCubit>(context).updateScorersFor(leagueId);

    return BlocBuilder<ScorerCubit, ScorerState>(
      builder: (_, scorerState) => SizedBox(
        height: 300,
        child: buildTable(
          scorerState.scorersOf(leagueId),
          headerHeight: 80.0,
          rowHeight: 60.0,
        ),
      ),
    );
  }

  @override
  List<TableColumnDefinition<Scorer>> get tableDefinition => _tableDefinition;

  static final List<TableColumnDefinition<Scorer>> _tableDefinition = [
    TableColumnDefinition(
      column: const TableColumn(width: 25), // position
      headerBuilder: () => buildHeaderCell('#', align: Alignment.bottomRight),
      contentBuilder: (row) => buildTextCell('${row.position}'),
    ),
    /*
    TableColumnDefinition(
      column: const TableColumn(width: 40), // logo
      headerBuilder: () => const SizedBox.shrink(),
      contentBuilder: (row) =>
          TeamLogo(uri: row.teamLogoSmallUri, height: 32, width: 32),
    ),
    */
    TableColumnDefinition(
      column: const TableColumn(width: 180), // player's name
      headerBuilder: () =>
          buildHeaderCell('Spieler:in', align: Alignment.bottomLeft),
      contentBuilder: (row) => buildPlayerCell(row.fullName, row.teamName),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // # games
      headerBuilder: () => buildHeaderCell('Spiele', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.games}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // points
      headerBuilder: () => buildHeaderCell('Punkte', rotated: true),
      contentBuilder: (row) =>
          buildTextCell('${row.points}', weight: FontWeight.bold),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // goals
      headerBuilder: () => buildHeaderCell('Tore', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.goals}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // assists
      headerBuilder: () =>
          withBorderOnRight(buildHeaderCell('Vorlagen', rotated: true)),
      contentBuilder: (row) =>
          withBorderOnRight(buildTextCell('${row.assists}')),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // 2' penalties
      headerBuilder: () => buildHeaderCell("2'", rotated: true),
      contentBuilder: (row) => buildTextCell('${row.penalty2}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // 2'+2' penalties
      headerBuilder: () => buildHeaderCell("2'+2'", rotated: true),
      contentBuilder: (row) => buildTextCell('${row.penalty2and2}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // 10' penalties
      headerBuilder: () => buildHeaderCell("10'", rotated: true),
      contentBuilder: (row) => buildTextCell('${row.penalty10}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // match penalty (technical)
      headerBuilder: () => buildHeaderCell('MS (tech)', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.penaltyMsTech}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // match penalty (full)
      headerBuilder: () => buildHeaderCell('MS', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.penaltyMsFull}'),
    ),
  ];
}

Widget buildPlayerCell(String playerName, String teamName) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playerName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          teamName,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    ),
  );
}

Widget buildTextCell(
  String text, {
  Alignment align = Alignment.center,
  FontWeight weight = FontWeight.normal,
}) {
  return Container(
    alignment: align,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(text, style: TextStyle(fontWeight: weight, fontSize: 14)),
  );
}

Widget withBorderOnRight(
  Widget child, {
  Color color = Colors.black54,
  double width = 1.0,
}) => Container(
  decoration: BoxDecoration(
    border: Border(
      right: BorderSide(color: color, width: width),
    ),
  ),
  child: child,
);
