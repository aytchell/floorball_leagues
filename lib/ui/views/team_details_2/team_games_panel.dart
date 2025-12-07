import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/league_details_2/striped_rows_list.dart';
import 'package:floorball/ui/views/team_details/games_overview_item.dart';
import 'package:floorball/ui/widgets/panel_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ExpansionPanelRadio buildTeamGamesPanel(
  int identifier,
  int leagueId,
  String teamName,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Spiele'),
    body: TeamGamesProvider(leagueId: leagueId, teamName: teamName),
  );
}

class TeamGamesProvider extends StatelessWidget {
  final int leagueId;
  final String teamName;

  const TeamGamesProvider({
    super.key,
    required this.leagueId,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeaguesCubit>(context).ensureLeague(leagueId);
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, leagueState) {
        final league = leagueState.byId(leagueId);
        if (league == null) {
          return Text('Keine Daten');
        }
        return _GameDaysProvider(
          leagueId: leagueId,
          teamName: teamName,
          gameDayNumbers: league.gameDayTitles
              .map((gdt) => gdt.gameDayNumber)
              .toList(),
        );
      },
    );
  }
}

class _GameDaysProvider extends StatelessWidget {
  final int leagueId;
  final String teamName;
  final List<int> gameDayNumbers;

  const _GameDaysProvider({
    required this.leagueId,
    required this.teamName,
    required this.gameDayNumbers,
  });

  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<LeagueGameDayCubit>(context);
    for (var gameDayId in gameDayNumbers) {
      provider.ensureGamesFor(leagueId, gameDayId);
    }

    return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
      builder: (_, state) {
        final games = state
            .gamesOfDays(leagueId, gameDayNumbers)
            .where((game) => _isTeamInvolved(game, teamName))
            .toList();
        return StripedTeamGamesRowsList(teamName, games);
      },
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
