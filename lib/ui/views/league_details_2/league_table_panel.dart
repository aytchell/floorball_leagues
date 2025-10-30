import 'package:floorball/api/blocs/league_table_cubit.dart';
import 'package:floorball/ui/views/league_details_2/panel_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      builder: (_, tableRows) =>
          Text('Got ${tableRows.leagueTableOf(leagueId).length} entries'),
    );
  }
}
