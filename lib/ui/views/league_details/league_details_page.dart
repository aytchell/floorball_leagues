import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/models/game_day_title.dart';

import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/views/league_details/league_table_card.dart';
import 'package:floorball/ui/views/league_details/champ_table_card.dart';
import 'package:floorball/ui/views/league_details/scorer_card.dart';
import 'package:floorball/ui/views/league_details/league_info_card.dart';
import 'package:floorball/ui/views/league_details/game_day_card.dart';

final log = Logger('LeagueDetailsPage');

class LeagueDetailsPage extends StatefulWidget {
  final GameOperationLeague league;
  final String leagueType;
  final List<GameDayTitle> gameDayTitles;

  LeagueDetailsPage({super.key, required this.league})
    : leagueType = league.leagueType ?? "league",
      gameDayTitles = league.gameDayTitles;

  @override
  _LeagueDetailsPageState createState() => _LeagueDetailsPageState();
}

class _LeagueDetailsPageState extends State<LeagueDetailsPage> {
  // Track which item is currently expanded (null means none expanded)
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: widget.league.name,
      showBackButton: true,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.gameDayTitles.length + 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildLeagueInfoCard(context, index);
        } else if (index == 1) {
          if (widget.leagueType == 'champ') {
            return _buildChampTableCard(context, index);
          } else {
            return _buildLeagueTableCard(context, index);
          }
        } else if (index == 2) {
          return _buildScorerCard(context, index);
        } else {
          return _buildGameDayCard(context, index, index - 3);
        }
      },
    );
  }

  Widget _buildLeagueInfoCard(BuildContext context, int cardIndex) {
    final isExpanded = expandedIndex == cardIndex;

    return ExpandablLeagueInfoCard(
      title: 'Liga-Infos',
      league: widget.league,
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }

  Widget _buildChampTableCard(BuildContext context, int cardIndex) {
    final isExpanded = expandedIndex == cardIndex;

    return ExpandableChampTableCard(
      title: 'Tabelle',
      league: widget.league,
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }

  Widget _buildLeagueTableCard(BuildContext context, int cardIndex) {
    final isExpanded = expandedIndex == cardIndex;

    return ExpandableLeagueTableCard(
      title: 'Tabelle',
      league: widget.league,
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }

  Widget _buildScorerCard(BuildContext context, int cardIndex) {
    final isExpanded = expandedIndex == cardIndex;

    return ExpandableScorerCard(
      title: 'Scorer',
      league: widget.league,
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }

  Widget _buildGameDayCard(BuildContext context, int cardIndex, int gameIndex) {
    final gameDayTitle = widget.gameDayTitles[gameIndex];
    final isExpanded = expandedIndex == cardIndex;

    return ExpandableGameDayCard(
      league: widget.league,
      gameDayTitle: gameDayTitle,
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }
}
