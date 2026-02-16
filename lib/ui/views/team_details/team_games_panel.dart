import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';
import 'package:floorball/ui/widgets/all_game_days_provider.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildTeamGamesPanel(
  int identifier,
  int leagueId,
  GameLeagueInfo gameLeagueInfo,
  String teamName,
) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Spiele',
    body: _TeamGamesListing(
      leagueId: leagueId,
      teamName: teamName,
      gameLeagueInfo: gameLeagueInfo,
    ),
  );
}

class _TeamGamesListing extends AllLeagueGamesProvider {
  final String teamName;
  final GameLeagueInfo gameLeagueInfo;

  const _TeamGamesListing({
    required super.leagueId,
    required this.teamName,
    required this.gameLeagueInfo,
  });

  @override
  Widget buildWithLeagueGames(List<Game> games) {
    return StripedTeamGamesRowsList(
      teamName,
      games.where((game) => _isTeamInvolved(game, teamName)).toList(),
      gameLeagueInfo,
    );
  }

  static bool _isTeamInvolved(Game game, String teamName) {
    return (teamName == game.homeTeamName) || (teamName == game.guestTeamName);
  }
}

class StripedTeamGamesRowsList extends StripedRowsList<Game> {
  final String teamName;
  final GameLeagueInfo gameLeagueInfo;

  const StripedTeamGamesRowsList(
    this.teamName,
    super.entries,
    this.gameLeagueInfo, {
    super.key,
  }) : super(
         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20.0),
         cellBorderColor: FloorballColors.gray97,
       );

  @override
  Widget buildRow(BuildContext context, Game entry) {
    return GamesOverviewItem(
      teamName: teamName,
      gameLeagueInfo: gameLeagueInfo,
      game: entry,
    );
  }
}
