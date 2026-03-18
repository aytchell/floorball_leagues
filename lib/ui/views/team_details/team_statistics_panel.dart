import 'package:floorball/blocs/league_table_cubit.dart';
import 'package:floorball/blocs/scorer_cubit.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/team_details/team_statistics_table.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _fallbackText = Text(
  'Keine Informationen verfügbar',
  style: TextStyles.genericNoData,
);

ExpansionPanelRadio buildTeamStatisticsPanel(
  int identifier,
  int leagueId,
  int teamId,
) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Team-Überblick',
    body: _TeamStatisticsContent(leagueId: leagueId, teamId: teamId),
  );
}

class _TeamStatisticsContent extends StatelessWidget {
  final int leagueId;
  final int teamId;

  const _TeamStatisticsContent({required this.leagueId, required this.teamId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScorerCubit>(context).updateScorersFor(leagueId);
    BlocProvider.of<LeagueTableCubit>(context).refreshLeagueTableFor(leagueId);

    return BlocBuilder<ScorerCubit, ScorerState>(
      builder: (_, scorerState) {
        final scorers = scorerState.scorersOf(leagueId);
        return BlocBuilder<LeagueTableCubit, LeagueTableState>(
          builder: (_, tableState) {
            final table = tableState.leagueTableOf(leagueId);
            return _buildTable(scorers, table);
          },
        );
      },
    );
  }

  Widget _buildTable(List<Scorer> scorers, List<LeagueTableRow> table) {
    final teamRows = table.where((row) => row.teamId == teamId).toList();
    if (teamRows.isEmpty) {
      return _fallbackText;
    }
    return TeamStatisticsTable(
      team: teamRows.first,
      scorers: scorers.where((scorer) => scorer.teamId == teamId).toList(),
      seasonId: firstSeasonIdWithNewPenalties,
    );
  }
}
