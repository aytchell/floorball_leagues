import 'package:floorball/api/models/league.dart';
import 'package:floorball/blocs/leagues_cubit.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/views/league_details/game_day/game_day_panels.dart';
import 'package:floorball/ui/views/league_details/league_info_panel.dart';
import 'package:floorball/ui/views/league_details/table/champ_table_panel.dart';
import 'package:floorball/ui/views/league_details/table/league_table_panel.dart';
import 'package:floorball/ui/views/league_details/table/void_table_panel.dart';
import 'package:floorball/ui/widgets/scorer_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueDetailsPage extends StatelessWidget {
  const LeagueDetailsPage({
    super.key,
    required this.federationPath,
    required this.leagueId,
    required this.leagueName,
  });

  final String federationPath;
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
            return _LeagueDetailsBody(
              federationPath: federationPath,
              league: league,
            );
          } else {
            return Center(
              child: Text(
                'Keine Informationen verfügbar',
                style: TextStyles.genericNoData,
              ),
            );
          }
        },
      ),
    );
  }
}

class _LeagueDetailsBody extends StatelessWidget {
  const _LeagueDetailsBody({
    required this.federationPath,
    required this.league,
  });
  final String federationPath;
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
      buildLeagueInfoPanel(0, league, federationPath),
      _buildTablePanel(1, league.id, league.leagueType),
      buildScorerPanel(2, league.id),
      ...buildGameDayPanels(
        3,
        league.id,
        GameLeagueInfo.from(league, federationPath),
        league.gameDayTitles,
      ),
    ];
  }

  ExpansionPanelRadio _buildTablePanel(
    int identifier,
    int leagueID,
    LeagueType leagueType,
  ) {
    switch (leagueType) {
      case LeagueType.league:
        return buildLeagueTablePanel(
          identifier,
          leagueID,
          GameLeagueInfo.from(league, federationPath),
        );
      case LeagueType.champ:
        return buildChampTablePanel(
          identifier,
          leagueID,
          GameLeagueInfo.from(league, federationPath),
        );
      case LeagueType.cup:
        return buildVoidTablePanel(
          identifier,
          'Keine Tabelle für Pokal-Wettbewerbe',
        );
    }
  }
}
