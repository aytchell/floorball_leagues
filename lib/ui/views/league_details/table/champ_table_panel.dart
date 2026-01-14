import 'package:floorball/blocs/champ_table_cubit.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/league_details/table/champ_result_table.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:floorball/ui/widgets/generic_striped_table.dart';
import 'package:floorball/ui/widgets/left_labeled_content.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:material_table_view/material_table_view.dart';

final log = Logger('ChampTableCard');

ExpansionPanelRadio buildChampTablePanel(int identifier, int leagueId) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Tabelle',
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
    final teamMapping = _mapTeamNameToTeamId(champTables);

    return Column(
      children: [
        ..._buildGroupTables(champTables),
        ChampResultTable(leagueId: leagueId, teamNameToId: teamMapping),
      ],
    );
  }

  Widget _emptyPlaceholder() => Container(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: Text('Keine Tabelle verfügbar', style: TextStyles.genericNoData),
    ),
  );

  Map<String, int> _mapTeamNameToTeamId(List<ChampGroupTable> champTables) =>
      champTables
          .expand((cgt) => cgt.table)
          .map((row) => MapEntry(row.teamName, row.teamId))
          .toMap();

  List<Widget> _buildGroupTables(List<ChampGroupTable> champTables) =>
      champTables.map((table) => _buildNamedChampGroupTable(table)).toList();

  Widget _buildNamedChampGroupTable(ChampGroupTable group) =>
      NamedChampGroupTable(
        labelText: group.name,
        leagueId: leagueId,
        tableRows: group.table,
        headerHeight: 60.0,
        rowHeight: 50.0,
      );
}

class _ChampGroupTable extends GenericStripedTable<LeagueTableRow> {
  final int leagueId;
  final List<LeagueTableRow> rows;
  final double headerHeight;
  final double rowHeight;

  const _ChampGroupTable({
    required this.leagueId,
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
      onTapBuilder: (ctxt, rowId) {
        return () => TeamDetailsPageRoute(
          leagueId: leagueId,
          teamId: rows[rowId].teamId,
        ).push(context);
      },
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
      contentBuilder: (row) => buildTextCell(
        '${row.points}',
        textStyle: TextStyles.leagueTablePointsCell,
      ),
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
  final int leagueId;
  final List<LeagueTableRow> tableRows;
  final double headerHeight;
  final double rowHeight;

  NamedChampGroupTable({
    super.key,
    required super.labelText,
    required this.leagueId,
    required this.tableRows,
    required this.headerHeight,
    required this.rowHeight,
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
      leagueId: leagueId,
      rows: tableRows,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
    );
  }
}
