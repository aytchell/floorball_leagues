import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/utils/team_repository.dart';
import 'package:flutter/material.dart';

class TeamVsTeamRow extends StatelessWidget {
  final DetailedGame game;
  final GameLeagueInfo gameLeagueInfo;

  const TeamVsTeamRow({
    super.key,
    required this.game,
    required this.gameLeagueInfo,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Home team
      Expanded(
        child: _buildTeamSection(
          teamName: game.homeTeamName,
          teamId: game.homeTeamId,
          logoUri: game.homeLogoUri,
        ),
      ),
      // -- vs --
      const Text('vs', style: TextStyles.gameDetailHeaderVersus),
      // Guest team
      Expanded(
        child: _buildTeamSection(
          teamName: game.guestTeamName,
          teamId: game.guestTeamId,
          logoUri: game.guestLogoUri,
        ),
      ),
    ],
  );

  Widget _buildTeamSection({
    required String teamName,
    required int teamId,
    required Uri? logoUri,
  }) => Column(
    children: [
      _ClickableTeamLogo(
        TeamInfo(
          leagueId: game.leagueId,
          teamId: teamId,
          teamName: teamName,
          teamLogoUri: logoUri,
          gameLeagueInfo: gameLeagueInfo,
        ),
      ),
      const SizedBox(height: 8),
      // Team name
      Text(
        teamName,
        textAlign: TextAlign.center,
        style: TextStyles.gameDetailHeaderTeamName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

class _ClickableTeamLogo extends StatelessWidget {
  final TeamInfo info;

  const _ClickableTeamLogo(this.info);

  @override
  Widget build(BuildContext context) => InkWell(
    child: TeamLogo(uri: info.teamLogoUri, width: 90, height: 90),
    onTap: () => TeamDetailsFullPageRoute($extra: info).push(context),
  );
}
