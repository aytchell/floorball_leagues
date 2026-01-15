import 'package:floorball/api/models/league.dart';
import 'package:floorball/blocs/leagues_cubit.dart';
import 'package:floorball/utils/team_repository.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/team_details/team_games_panel.dart';
import 'package:floorball/ui/views/team_details/team_statistics_panel.dart';
import 'package:floorball/ui/widgets/scorer_panel.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetailsFullPage extends StatelessWidget {
  final TeamInfo data;

  static const String routePath = '/team_details_full';

  const TeamDetailsFullPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, state) => MainAppScaffold(
        title: state.byId(data.leagueId)?.name ?? '',
        showBackButton: true,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),

        _TeamLogoAndName(
          teamLogoUri: data.teamLogoUri,
          teamName: data.teamName,
        ),

        const SizedBox(height: 40),

        ExpansionPanelList.radio(
          initialOpenPanelValue: null,
          children: _buildPanelItems(context),
        ),
      ],
    ),
  );

  List<ExpansionPanelRadio> _buildPanelItems(BuildContext context) {
    final gamesPanel = buildTeamGamesPanel(
      1,
      data.leagueId,
      data.leagueType,
      data.teamName,
    );
    final scorerPanel = buildScorerPanel(
      2,
      data.leagueId,
      filter: (scorer) => scorer.teamId == data.teamId,
    );

    if (data.leagueType == LeagueType.league) {
      return [
        buildTeamStatisticsPanel(0, data.leagueId, data.teamId),
        gamesPanel,
        scorerPanel,
      ];
    } else {
      return [gamesPanel, scorerPanel];
    }
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
