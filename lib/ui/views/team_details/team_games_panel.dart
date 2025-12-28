import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';
import 'package:floorball/ui/widgets/all_game_days_provider.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildTeamGamesPanel(
  int identifier,
  int leagueId,
  String teamName,
) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: 'Spiele',
    body: _TeamGamesListing(leagueId: leagueId, teamName: teamName),
  );
}

class _TeamGamesListing extends AllLeagueGamesProvider {
  final String teamName;

  const _TeamGamesListing({required super.leagueId, required this.teamName});

  @override
  Widget buildWithLeagueGames(List<Game> games) {
    return StripedTeamGamesRowsList(
      teamName,
      games.where((game) => _isTeamInvolved(game, teamName)).toList(),
    );
  }

  static bool _isTeamInvolved(Game game, String teamName) {
    return (teamName == game.homeTeamName) || (teamName == game.guestTeamName);
  }
}

class StripedTeamGamesRowsList extends StripedRowsList<Game> {
  final String teamName;
  const StripedTeamGamesRowsList(this.teamName, super.entries, {super.key});

  @override
  Widget buildRow(BuildContext context, Game entry) {
    return GamesOverviewItem(teamName: teamName, game: entry);
  }
}
