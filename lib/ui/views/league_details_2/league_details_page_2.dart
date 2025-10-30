import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/views/league_details_2/league_info_panel.dart';
import 'package:floorball/ui/views/league_details_2/league_table_panel.dart';
import 'package:floorball/ui/views/league_details_2/void_table_panel.dart';
import 'package:flutter/material.dart';

import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueDetailsPage2 extends StatelessWidget {
  const LeagueDetailsPage2({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  final int leagueId;
  final String leagueName;

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: leagueName,
      showBackButton: true,
      body: BlocBuilder<LeaguesCubit, LeaguesState>(
        builder: (_, leagues) {
          final league = leagues.byId(leagueId);
          if (league != null) {
            return _LeagueDetailsBody(league: league);
          } else {
            return Center(
              child: Text(
                'Keine Informationen verfügbar',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}

// stores ExpansionPanel state information
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

List<ExpansionPanelRadio> generateItems(int numberOfItems) {
  final list = [
    Item(id: 2, headerValue: 'Scorer', expandedValue: 'Here be Scorer-Liste'),
  ];
  list.addAll(
    List<Item>.generate(numberOfItems - 3, (int index) {
      return Item(
        id: index + 3,
        headerValue: 'Panel $index',
        expandedValue: 'This is item number $index',
      );
    }),
  );
  return list
      .map(
        (item) => ExpansionPanelRadio(
          value: item.id,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(item.headerValue));
          },
          body: ListTile(title: Text(item.expandedValue)),
        ),
      )
      .toList();
}

class _LeagueDetailsBody extends StatelessWidget {
  const _LeagueDetailsBody({required this.league});
  final GameOperationLeague league;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: null,
        children: _buildPanelItems(context),
      ),
    );
  }

  List<ExpansionPanelRadio> _buildPanelItems(BuildContext context) {
    return [
      buildLeagueInfoPanel(0, league),
      _buildTablePanel(1, league.id, league.leagueType),
      ...generateItems(7),
    ];
  }

  ExpansionPanelRadio _buildTablePanel(
    int identifier,
    int leagueID,
    String? leagueType,
  ) {
    if (leagueType == 'league') {
      return buildLeagueTablePanel(identifier, leagueID);
    }
    /*
    if (leagueType == 'champ') {
      return buildChampTablePanel(identifier, leagueID);
    }
*/
    if (leagueType == 'cup') {
      return buildVoidTablePanel(
        identifier,
        'Keine Tabelle für Pokal-Wettbewerbe',
      );
    }
    return buildVoidTablePanel(identifier, 'Keine Tabelle verfügbar');
  }
}
