import 'package:collection/collection.dart';
import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Item {
  Item({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
  });

  int id;
  String expandedValue;
  String headerValue;
}

List<ExpansionPanelRadio> buildGameDayPanels(
  int firstIdentifier,
  int leagueId,
  List<GameDayTitle> gameDayTitles,
) {
  return gameDayTitles
      .mapIndexed(
        (index, gdt) =>
            _buildSingleGameDayPanel(firstIdentifier + index, leagueId, gdt),
      )
      .toList();
}

ExpansionPanelRadio _buildSingleGameDayPanel(
  int identifier,
  int leagueId,
  GameDayTitle gdt,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) {
      return ListTile(title: Text(gdt.title));
    },
    body: _SingleGameDayContent(
      leagueId: leagueId,
      gameDayNumber: gdt.gameDayNumber,
    ),
  );
}

class _SingleGameDayContent extends StatelessWidget {
  final int leagueId;
  final int gameDayNumber;

  const _SingleGameDayContent({
    required this.leagueId,
    required this.gameDayNumber,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeagueGameDayCubit>(
      context,
    ).ensureGamesFor(leagueId, gameDayNumber);

    return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
      builder: (_, gameDaysState) {
        final games = gameDaysState.gamesOf(leagueId, gameDayNumber);
        return Column(
          children: games.map((g) => Text(g.homeTeamName!)).toList(),
        );
      },
    );
  }
}
