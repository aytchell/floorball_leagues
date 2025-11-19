import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/views/league_details_2/game_day_panels.dart';
import 'package:floorball/ui/views/league_details_2/league_info_panel.dart';
import 'package:floorball/ui/views/league_details_2/league_table_panel.dart';
import 'package:floorball/ui/widgets/scorer_panel.dart';
import 'package:floorball/ui/views/league_details_2/void_table_panel.dart';
import 'package:flutter/material.dart';

import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueDetailsPage2 extends StatelessWidget {
  const LeagueDetailsPage2({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  final int leagueId;
  final String leagueName;

  static const String routePath = '/league_details';

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: leagueName,
      showBackButton: true,
      body: BlocBuilder<LeaguesCubit, LeaguesState>(
        builder: (_, leagues) {
          final league = leagues.byId(leagueId);
          if (league != null) {
            return _LeagueDetailsBody(league: league);
          } else {
            return Center(
              child: Text(
                'Keine Informationen verfügbar',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}

class _LeagueDetailsBody extends StatelessWidget {
  const _LeagueDetailsBody({required this.league});
  final League league;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: null,
        children: _buildPanelItems(context),
      ),
    );
  }

  List<ExpansionPanelRadio> _buildPanelItems(BuildContext context) {
    return [
      buildLeagueInfoPanel(0, league),
      _buildTablePanel(1, league.id, league.leagueType),
      buildScorerPanel(2, league.id),
      ...buildGameDayPanels(3, league.id, league.gameDayTitles),
    ];
  }

  ExpansionPanelRadio _buildTablePanel(
    int identifier,
    int leagueID,
    LeagueType leagueType,
  ) {
    switch (leagueType) {
      case LeagueType.league:
        return buildLeagueTablePanel(identifier, leagueID);
      case LeagueType.champ:
      // TODO
      // return buildChampTablePanel(identifier, leagueID);
      case LeagueType.cup:
        return buildVoidTablePanel(
          identifier,
          'Keine Tabelle für Pokal-Wettbewerbe',
        );
    }
  }
}
