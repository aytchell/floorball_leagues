import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/ui/widgets/panel_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const fallbackText = Text(
  'Keine Spiele bekannt',
  style: TextStyle(fontSize: 16, color: Colors.black54),
);

ExpansionPanelRadio buildTeamGamesPanel(
  int identifier,
  int leagueId,
  int teamId,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: 'Spiele'),
    body: _TeamGamesContent(leagueId: leagueId, teamId: teamId),
  );
}

class _TeamGamesContent extends StatelessWidget {
  final int leagueId;
  final int teamId;

  const _TeamGamesContent({required this.leagueId, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (_, state) {
        final league = state.byId(leagueId);
        if (league == null) {
          return fallbackText;
        }
        return Text("Nothing to see here");
      },
    );
  }
}
