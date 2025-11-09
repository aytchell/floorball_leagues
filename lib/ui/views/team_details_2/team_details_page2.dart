import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/blocs/team_info_cubit.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/team_repository.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetailsPage2 extends StatelessWidget {
  final int leagueId;
  final int teamId;

  static const String routePath = '/team_details_2';

  const TeamDetailsPage2({
    super.key,
    required this.leagueId,
    required this.teamId,
  });

  /*
  List<IndexedScorer> _extractTeamScorers(List<Scorer> scorers, int teamId) {
    return scorers
        .mapIndexed(
          (index, scorer) => IndexedScorer(
        index: index + 1, // Start ranking from 1
        scorer: scorer,
      ),
    )
        .where((entry) => entry.scorer.teamId == teamId)
        .toList();
  }
 */

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, state) => MainAppScaffold(
        title: state.byId(leagueId)?.name ?? '',
        showBackButton: true,
        body: _buildBody(state.byId(leagueId)),
      ),
    );
  }

  Widget _buildBody(League? league) {
    if (league == null) {
      return Center(
        child: Text(
          'Lade Team-Informationen ...',
          style: AppTextStyles.federationLoadingError,
        ),
      );
    }

    return BlocBuilder<TeamInfoCubit, TeamInfoState>(
      builder: (_, state) =>
          _buildTeamInfoBody(state.infoOf(league.id, teamId)),
    );
  }

  Widget _buildTeamInfoBody(TeamInfo? teamInfo) {
    if (teamInfo == null) {
      return Center(
        child: Text(
          'Keine Team-Informationen verfügbar',
          style: AppTextStyles.federationLoadingError,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // Team Logo
          TeamLogo(uri: teamInfo.teamLogoUri, height: 120, width: 120),

          const SizedBox(height: 24),

          // Team Name
          Text(
            teamInfo.teamName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
