import 'package:floorball/api/models/league.dart';
import 'package:floorball/blocs/league_table_cubit.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/repositories/team_repository.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:floorball/ui/widgets/generic_striped_table.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_table_view/material_table_view.dart';

ExpansionPanelRadio buildLeagueTablePanel(int identifier, int leagueId) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Tabelle',
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
      builder: (_, tableState) {
        final table = tableState.leagueTableOf(leagueId);
        return buildTable(
          _tableDefinition,
          table,
          onTapBuilder: (ctxt, rowId) {
            return () => TeamDetailsFullPageRoute(
              $extra: TeamInfo(
                leagueId: leagueId,
                leagueType: LeagueType.league,
                teamId: table[rowId].teamId,
                teamName: table[rowId].teamName,
                teamLogoUri: table[rowId].teamLogoUri,
              ),
            ).push(context);
          },
        );
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
}
