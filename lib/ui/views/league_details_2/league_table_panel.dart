import 'package:floorball/api/blocs/league_table_cubit.dart';
import 'package:floorball/api/models/league_table_row.dart';
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

class _LeagueTableContent extends StatelessWidget {
  final int leagueId;

  _LeagueTableContent({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeagueTableCubit>(context).ensureLeagueTableFor(leagueId);

    return BlocBuilder<LeagueTableCubit, LeagueTableState>(
      builder: (_, tableRows) => SizedBox(
        height: 300,
        child: _buildTable(tableRows.leagueTableOf(leagueId)),
      ),
    );
  }

  // column TableColumn
  // heaader text, rotated, align
  // row text, bold, align

  Widget _buildTable(List<LeagueTableRow> tableRows) => TableView.builder(
    columns: [
      TableColumn(width: 25), // position
      TableColumn(width: 35), // logo
      TableColumn(width: 215), // team name
      TableColumn(width: 35), // # games
      TableColumn(width: 35), // points
      TableColumn(width: 35), // wins
      TableColumn(width: 35), // draws
      TableColumn(width: 35), // losses
      TableColumn(width: 35), // wins overtime
      TableColumn(width: 35), // losses overtime
      TableColumn(width: 60), // goals
      TableColumn(width: 45), // goal difference
    ],
    rowCount: tableRows.length,
    rowHeight: 40.0,
    headerHeight: 85.0,
    headerBuilder: (context, contentBuilder) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: contentBuilder(context, (context, column) {
          switch (column) {
            case 0:
              return _buildHeaderCell('#');
            case 1:
              return SizedBox.shrink();
            case 2:
              return _buildHeaderCell('Mannschaft');
            case 3:
              return _buildHeaderCell('Spiele', rotated: true);
            case 4:
              return _buildHeaderCell('Punkte', rotated: true);
            case 5:
              return _buildHeaderCell('Siege', rotated: true);
            case 6:
              return _buildHeaderCell('Unentsch.', rotated: true);
            case 7:
              return _buildHeaderCell('Niederl.', rotated: true);
            case 8:
              return _buildHeaderCell('Siege nV', rotated: true);
            case 9:
              return _buildHeaderCell('Niederl. nV', rotated: true);
            case 10:
              return _buildHeaderCell('Tore');
            case 11:
              return _buildHeaderCell('Tordiff.', rotated: true);
            default:
              return const SizedBox.shrink();
          }
        }),
      );
    },
    rowBuilder: (context, rowId, contentBuilder) {
      final row = tableRows[rowId];
      return Material(
        type: MaterialType.transparency,
        child: contentBuilder(context, (context, column) {
          if (column == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TeamLogo(uri: row.teamLogoSmallUri, height: 32, width: 32),
            );
          } else {
            final text = _cellText(column, row);
            final align = (column == 2)
                ? Alignment.centerLeft
                : Alignment.centerRight;
            final weight = (column == 4) ? FontWeight.bold : FontWeight.normal;
            return Container(
              alignment: align,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                text,
                style: TextStyle(fontWeight: weight, fontSize: 14),
              ),
            );
          }
        }),
      );
    },
  );

  String _cellText(int columnId, LeagueTableRow row) {
    switch (columnId) {
      case 0:
        return '${row.position}';
      case 1:
        return 'X';
      case 2:
        return row.teamName;
      case 3:
        return '${row.games}';
      case 4:
        return '${row.points}';
      case 5:
        return '${row.won}';
      case 6:
        return '${row.draw}';
      case 7:
        return '${row.lost}';
      case 8:
        return '${row.wonOt}';
      case 9:
        return '${row.lostOt}';
      case 10:
        return '${row.goalsScored}:${row.goalsReceived}';
      case 11:
        return '${row.goalsDiff}';
      default:
        return '';
    }
    ;
  }

  Widget _scorerData(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {bool rotated = false}) {
    final textColor = Colors.grey[800];

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: rotated
          ? RotatedBox(
              quarterTurns: 3,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 4),
                  _tableHeaderText(text, textColor),
                  const SizedBox(width: 4),
                ],
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tableHeaderText(text, textColor),
                const SizedBox(width: 4),
              ],
            ),
    );
  }

  Widget _tableHeaderText(String text, Color? color) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: color ?? Colors.grey[800],
      ),
    );
  }
}
