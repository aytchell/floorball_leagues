import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/blocs/team_info_cubit.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/team_repository.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/team_details/team_games_panel.dart';
import 'package:floorball/ui/views/team_details/team_statistics_panel.dart';
import 'package:floorball/ui/widgets/scorer_panel.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetailsPage extends StatelessWidget {
  final int leagueId;
  final int teamId;

  static const String routePath = '/team_details';

  const TeamDetailsPage({
    super.key,
    required this.leagueId,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, state) => MainAppScaffold(
        title: state.byId(leagueId)?.name ?? '',
        showBackButton: true,
        body: _buildBody(context, state.byId(leagueId)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, League? league) {
    if (league == null) {
      return Center(
        child: Text(
          'Lade Team-Informationen ...',
          style: TextStyles.genericLoadingData,
        ),
      );
    }

    BlocProvider.of<TeamInfoCubit>(
      context,
    ).ensureInfoFor(league.id, league.leagueType, teamId);

    return BlocBuilder<TeamInfoCubit, TeamInfoState>(
      builder: (_, state) =>
          _buildTeamInfoBody(context, state.infoOf(league.id, teamId)),
    );
  }

  Widget _buildTeamInfoBody(BuildContext context, TeamInfo? teamInfo) {
    if (teamInfo == null) {
      return Center(
        child: Text(
          'Keine Team-Informationen verfügbar',
          style: TextStyles.genericLoadingData,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          _TeamLogoAndName(
            teamLogoUri: teamInfo.teamLogoUri,
            teamName: teamInfo.teamName,
          ),

          const SizedBox(height: 40),

          ExpansionPanelList.radio(
            initialOpenPanelValue: null,
            children: _buildPanelItems(context, teamInfo.teamName),
          ),
        ],
      ),
    );
  }

  List<ExpansionPanelRadio> _buildPanelItems(
    BuildContext context,
    String teamName,
  ) {
    return [
      buildTeamStatisticsPanel(0, leagueId, teamId),
      buildTeamGamesPanel(1, leagueId, teamName),
      buildScorerPanel(
        2,
        leagueId,
        filter: (scorer) => scorer.teamId == teamId,
      ),
    ];
  }
}

class _TeamLogoAndName extends StatelessWidget {
  final Uri? teamLogoUri;
  final String teamName;

  const _TeamLogoAndName({this.teamLogoUri, required this.teamName});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TeamLogo(uri: teamLogoUri, height: 160, width: 160),
      const SizedBox(height: 24),
      Text(
        teamName,
        style: TextStyles.teamDetailsTeamName,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
