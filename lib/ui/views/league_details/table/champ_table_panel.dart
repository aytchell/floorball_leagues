import 'package:floorball/api/blocs/champ_table_cubit.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/ui/views/league_details/table/champ_result_table.dart';
import 'package:floorball/ui/widgets/generic_striped_table.dart';
import 'package:floorball/ui/widgets/left_labeled_content.dart';
import 'package:floorball/ui/widgets/panel_title.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:material_table_view/material_table_view.dart';

final log = Logger('ChampTableCard');

ExpansionPanelRadio buildChampTablePanel(int identifier, int leagueId) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Tabelle'),
    body: _ChampTableContent(leagueId: leagueId, onTap: () {}),
  );
}

class _ChampTableContent extends StatelessWidget {
  final int leagueId;
  final VoidCallback onTap;

  const _ChampTableContent({required this.leagueId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChampTableCubit>(context).ensureChampTableFor(leagueId);

    return BlocBuilder<ChampTableCubit, ChampTableState>(
      builder: (_, tableState) {
        final table = tableState.champTableOf(leagueId);
        return _buildTablesContent(table);
      },
    );
  }

  Widget _buildTablesContent(List<ChampGroupTable> champTables) {
    if (champTables.isEmpty) {
      return _emptyPlaceholder();
    }

    return Column(
      children: [
        ..._buildGroupTables(champTables),
        ChampResultTable(leagueId: leagueId),
      ],
    );
  }

  Widget _emptyPlaceholder() => Container(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: Text(
        'Keine Tabelle verfügbar',
        style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
      ),
    ),
  );

  List<Widget> _buildGroupTables(List<ChampGroupTable> champTables) =>
      champTables.map((table) => _buildNamedChampGroupTable(table)).toList();

  Widget _buildNamedChampGroupTable(ChampGroupTable group) =>
      NamedChampGroupTable(
        labelText: group.name,
        headerHeight: 60.0,
        rowHeight: 50.0,
        tableRows: group.table,
      );
}

class _ChampGroupTable extends GenericStripedTable<LeagueTableRow> {
  final List<LeagueTableRow> rows;
  final double headerHeight;
  final double rowHeight;

  const _ChampGroupTable({
    required this.rows,
    required this.headerHeight,
    required this.rowHeight,
  });

  @override
  Widget build(BuildContext context) {
    return buildTable(
      _tableDefinition,
      rows,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
    );
  }

  static final List<TableColumnDefinition<LeagueTableRow>> _tableDefinition = [
    TableColumnDefinition(
      column: const TableColumn(width: 25), // position
      headerBuilder: () => buildHeaderCell('#', align: Alignment.bottomRight),
      contentBuilder: (row) => buildTextCell('${row.position}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 40), // logo
      headerBuilder: () => const SizedBox.shrink(),
      contentBuilder: (row) =>
          TeamLogo(uri: row.teamLogoSmallUri, height: 32, width: 32),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 180), // team name
      headerBuilder: () =>
          buildHeaderCell('Mannschaft', align: Alignment.bottomLeft),
      contentBuilder: (row) =>
          buildTextCell(row.teamName, align: Alignment.centerLeft),
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
      column: const TableColumn(width: 60), // goals
      headerBuilder: () => buildHeaderCell('Tore'),
      contentBuilder: (row) =>
          buildTextCell('${row.goalsScored}:${row.goalsReceived}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 45), // goal difference
      headerBuilder: () => buildHeaderCell('Tordiff.', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.goalsDiff}'),
    ),
  ];
}

class NamedChampGroupTable extends LeftLabeledContent {
  final double headerHeight;
  final double rowHeight;
  final List<LeagueTableRow> tableRows;

  NamedChampGroupTable({
    super.key,
    required super.labelText,
    required this.headerHeight,
    required this.rowHeight,
    required this.tableRows,
  }) : super(
         labelHeight: _computeLabelHeight(
           headerHeight,
           rowHeight,
           tableRows.length,
         ),
       );

  static double _computeLabelHeight(
    double headerHeight,
    double rowHeight,
    int rowCount,
  ) {
    return headerHeight + (rowCount * rowHeight);
  }

  @override
  Widget buildContent() {
    return _ChampGroupTable(
      rows: tableRows,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
    );
  }
}
