import 'package:floorball/api/blocs/league_table_cubit.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/ui/views/league_details_2/generic_striped_table.dart';
import 'package:floorball/ui/views/league_details_2/panel_title.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_table_view/material_table_view.dart';

ExpansionPanelRadio buildLeagueTablePanel(int identifier, int leagueId) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Tabelle'),
    body: _LeagueTableContent(leagueId: leagueId),
  );
}

class _LeagueTableContent extends GenericStripedTable<LeagueTableRow> {
  final int leagueId;

  const _LeagueTableContent({required this.leagueId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeagueTableCubit>(context).ensureLeagueTableFor(leagueId);

    return BlocBuilder<LeagueTableCubit, LeagueTableState>(
      builder: (_, tableState) => SizedBox(
        height: 300,
        child: buildTable(_tableDefinition, tableState.leagueTableOf(leagueId)),
      ),
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
      column: const TableColumn(width: 35), // wins
      headerBuilder: () => buildHeaderCell('Siege', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.won}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // draws
      headerBuilder: () => buildHeaderCell('Unentsch.', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.draw}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // losses
      headerBuilder: () => buildHeaderCell('Niederl.', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.lost}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // wins overtime
      headerBuilder: () => buildHeaderCell('Siege nV', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.wonOt}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 35), // losses overtime
      headerBuilder: () => buildHeaderCell('Niederl. nV', rotated: true),
      contentBuilder: (row) => buildTextCell('${row.lostOt}'),
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

  /*
  @override
  List<TableColumn> defineColumns() => [
    TableColumn(width: 25), // position
    TableColumn(width: 40), // logo
    TableColumn(width: 180), // team name
    TableColumn(width: 35), // # games
    TableColumn(width: 35), // points
    TableColumn(width: 35), // wins
    TableColumn(width: 35), // draws
    TableColumn(width: 35), // losses
    TableColumn(width: 35), // wins overtime
    TableColumn(width: 35), // losses overtime
    TableColumn(width: 60), // goals
    TableColumn(width: 45), // goal difference
  ];

  @override
  Widget buildHeaderForColumn(int columnId) {
    switch (columnId) {
      case 0:
        return buildHeaderCell('#', align: Alignment.bottomRight);
      case 1:
        return SizedBox.shrink();
      case 2:
        return buildHeaderCell('Mannschaft', align: Alignment.bottomLeft);
      case 3:
        return buildHeaderCell('Spiele', rotated: true);
      case 4:
        return buildHeaderCell('Punkte', rotated: true);
      case 5:
        return buildHeaderCell('Siege', rotated: true);
      case 6:
        return buildHeaderCell('Unentsch.', rotated: true);
      case 7:
        return buildHeaderCell('Niederl.', rotated: true);
      case 8:
        return buildHeaderCell('Siege nV', rotated: true);
      case 9:
        return buildHeaderCell('Niederl. nV', rotated: true);
      case 10:
        return buildHeaderCell('Tore');
      case 11:
        return buildHeaderCell('Tordiff.', rotated: true);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget buildContentForColumn(int columnId, LeagueTableRow row) {
    switch (columnId) {
      case 0:
        return buildTextCell('${row.position}');
      case 1:
        return TeamLogo(uri: row.teamLogoSmallUri, height: 32, width: 32);
      case 2:
        return buildTextCell(row.teamName, align: Alignment.centerLeft);
      case 3:
        return buildTextCell('${row.games}');
      case 4:
        return buildTextCell('${row.points}', weight: FontWeight.bold);
      case 5:
        return buildTextCell('${row.won}');
      case 6:
        return buildTextCell('${row.draw}');
      case 7:
        return buildTextCell('${row.lost}');
      case 8:
        return buildTextCell('${row.wonOt}');
      case 9:
        return buildTextCell('${row.lostOt}');
      case 10:
        return buildTextCell('${row.goalsScored}:${row.goalsReceived}');
      case 11:
        return buildTextCell('${row.goalsDiff}');
      default:
        return const Text('');
    }
  }
   */
}
