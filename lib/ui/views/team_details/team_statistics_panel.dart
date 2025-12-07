import 'package:floorball/api/blocs/league_table_cubit.dart';
import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/blocs/scorer_cubit.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/ui/views/team_details/team_statistics_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/panel_title.dart';

const fallbackText = Text(
  'Keine Informationen verfügbar',
  style: TextStyle(fontSize: 16, color: Colors.black54),
);

ExpansionPanelRadio buildTeamStatisticsPanel(
  int identifier,
  int leagueId,
  int teamId,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Team-Überblick'),
    body: _TeamStatisticsContent(leagueId: leagueId, teamId: teamId),
  );
}

class _TeamStatisticsContent extends StatelessWidget {
  final int leagueId;
  final int teamId;

  const _TeamStatisticsContent({required this.leagueId, required this.teamId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeaguesCubit>(context).ensureLeague(leagueId);
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, leagueState) {
        final league = leagueState.byId(leagueId);
        if (league == null) {
          return fallbackText;
        }
        if (league.leagueType == LeagueType.league) {
          return _buildLeagueTeamDetails(context);
        }

        return fallbackText;
      },
    );
  }

  Widget _buildLeagueTeamDetails(BuildContext context) {
    BlocProvider.of<ScorerCubit>(context).updateScorersFor(leagueId);
    BlocProvider.of<LeagueTableCubit>(context).ensureLeagueTableFor(leagueId);

    return BlocBuilder<ScorerCubit, ScorerState>(
      builder: (_, scorerState) {
        final scorers = scorerState.scorersOf(leagueId);
        return BlocBuilder<LeagueTableCubit, LeagueTableState>(
          builder: (_, tableState) {
            final table = tableState.leagueTableOf(leagueId);
            final teamRows = table
                .where((row) => row.teamId == teamId)
                .toList();
            if (teamRows.isEmpty) {
              return fallbackText;
            } else {
              return TeamStatisticsTable(
                team: teamRows.first,
                scorers: scorers
                    .where((scorer) => scorer.teamId == teamId)
                    .toList(),
                seasonId: firstSeasonIdWithNewPenalties,
              );
            }
          },
        );
      },
    );
  }
}
