import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';
import 'package:floorball/ui/widgets/all_game_days_provider.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildTeamGamesPanel(
  int identifier,
  int leagueId,
  LeagueType leagueType,
  String teamName,
) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Spiele',
    body: _TeamGamesListing(
      leagueId: leagueId,
      teamName: teamName,
      leagueType: leagueType,
    ),
  );
}

class _TeamGamesListing extends AllLeagueGamesProvider {
  final String teamName;
  final LeagueType leagueType;

  const _TeamGamesListing({
    required super.leagueId,
    required this.teamName,
    required this.leagueType,
  });

  @override
  Widget buildWithLeagueGames(List<Game> games) {
    return StripedTeamGamesRowsList(
      teamName,
      games.where((game) => _isTeamInvolved(game, teamName)).toList(),
      leagueType,
    );
  }

  static bool _isTeamInvolved(Game game, String teamName) {
    return (teamName == game.homeTeamName) || (teamName == game.guestTeamName);
  }
}

class StripedTeamGamesRowsList extends StripedRowsList<Game> {
  final String teamName;
  final LeagueType leagueType;

  const StripedTeamGamesRowsList(
    this.teamName,
    super.entries,
    this.leagueType, {
    super.key,
  }) : super(
         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20.0),
         cellBorderColor: FloorballColors.gray97,
       );

  @override
  Widget buildRow(BuildContext context, Game entry) {
    return GamesOverviewItem(
      teamName: teamName,
      leagueType: leagueType,
      game: entry,
    );
  }
}
