import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/selected_season_cubit.dart';
import 'package:floorball/ui/widgets/generic_striped_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floorball/api/blocs/scorer_cubit.dart';
import 'package:floorball/ui/widgets/panel_title.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:material_table_view/material_table_view.dart';

ExpansionPanelRadio buildScorerPanel(
  int identifier,
  int leagueId, {
  double headerHeight = 70.0,
  double? rowHeight,
  bool Function(Scorer)? filter,
}) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Scorer'),
    body: _ScorerTableContent(
      leagueId: leagueId,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
      filter: filter,
    ),
  );
}

class _ScorerTableContent extends GenericStripedTable<Scorer> {
  final int leagueId;
  final double headerHeight;
  final double? rowHeight;
  final bool Function(Scorer)? filter;

  const _ScorerTableContent({
    required this.leagueId,
    required this.headerHeight,
    required this.rowHeight,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScorerCubit>(context).updateScorersFor(leagueId);

    return BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
      builder: (_, season) => BlocBuilder<ScorerCubit, ScorerState>(
        builder: (_, scorerState) => buildTable(
          (season != null && season.id >= firstSeasonIdWithNewPenalties)
              ? _tableDefinitionPenalty2and2
              : _tableDefinitionPenalty5,
          (filter == null)
              ? scorerState.scorersOf(leagueId)
              : scorerState.scorersOf(leagueId).where(filter!).toList(),
          headerHeight: headerHeight,
          rowHeight: rowHeight,
        ),
      ),
    );
  }

  static final _position = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 25),
    headerBuilder: () => buildHeaderCell('#', align: Alignment.bottomRight),
    contentBuilder: (row) => buildTextCell('${row.position}'),
  );

  static final _playersName = TableColumnDefinition<Scorer>(
    column: const TableColumn(
      width: 180,
      minResizeWidth: 180,
      maxResizeWidth: 350,
      freezePriority: 300,
    ),
    headerBuilder: () =>
        buildHeaderCell('Spieler:in', align: Alignment.bottomLeft),
    contentBuilder: (row) => buildPlayerCell(row.fullName, row.teamName),
  );

  static final _numGames = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('Spiele', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.games}'),
  );

  static final _points = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('Punkte', rotated: true),
    contentBuilder: (row) =>
        buildTextCell('${row.points}', weight: FontWeight.bold),
  );

  static final _numGoals = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('Tore', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.goals}'),
  );

  static final _numAssists = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () =>
        withBorderOnRight(buildHeaderCell('Vorlagen', rotated: true)),
    contentBuilder: (row) => withBorderOnRight(buildTextCell('${row.assists}')),
  );

  static final _penalty2 = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell("2'", rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penalty2}'),
  );

  static final _penalty5 = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell("5'", rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penalty5}'),
  );

  static final _penalty2and2 = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell("2'+2'", rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penalty2and2}'),
  );

  static final _penalty10 = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell("10'", rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penalty10}'),
  );

  static final _penaltyMatchOne = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('MS 1', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penaltyMs1}'),
  );

  static final _penaltyMatchTwo = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('MS 2', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penaltyMs2}'),
  );

  static final _penaltyMatchThree = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('MS 3', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penaltyMs3}'),
  );

  static final _penaltyMatchTechnical = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('MS (tech)', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penaltyMsTech}'),
  );

  static final _penaltyMatchFull = TableColumnDefinition<Scorer>(
    column: const TableColumn(width: 35),
    headerBuilder: () => buildHeaderCell('MS', rotated: true),
    contentBuilder: (row) => buildTextCell('${row.penaltyMsFull}'),
  );

  static final List<TableColumnDefinition<Scorer>> _tableDefinitionPenalty5 = [
    _position,
    _playersName,
    _numGames,
    _points,
    _numGoals,
    _numAssists,
    _penalty2,
    _penalty5,
    _penalty10,
    _penaltyMatchOne,
    _penaltyMatchTwo,
    _penaltyMatchThree,
  ];

  static final List<TableColumnDefinition<Scorer>>
  _tableDefinitionPenalty2and2 = [
    _position,
    _playersName,
    _numGames,
    _points,
    _numGoals,
    _numAssists,
    _penalty2,
    _penalty2and2,
    _penalty10,
    _penaltyMatchTechnical,
    _penaltyMatchFull,
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
