import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/models/league_table_row.dart';

import 'package:floorball/app_state.dart';
import 'package:floorball/ui/widgets/nothing_found.dart';
import 'package:floorball/ui/widgets/loading_spinner.dart';
import 'package:floorball/ui/widgets/expandable_card.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/views/league_details/league_table_card.dart';
import 'package:floorball/ui/views/league_details/champ_table_card.dart';
import 'package:floorball/ui/views/league_details/scorer_card.dart';
import 'package:floorball/ui/views/league_details/league_info_card.dart';
import 'package:floorball/ui/views/league_details/game_day_card.dart';

final log = Logger('LeagueDetailsPage');

class LeagueDetailsPage extends StatefulWidget {
  final GameOperationLeague league;

  String leagueType;

  LeagueDetailsPage({required this.league})
    : leagueType = league.leagueType ?? "league";

  @override
  _LeagueDetailsPageState createState() =>
      _LeagueDetailsPageState(league.gameDayTitles);
}

class _LeagueDetailsPageState extends State<LeagueDetailsPage> {
  _LeagueDetailsPageState(this.gameDayTitles);

  // Track which item is currently expanded (null means none expanded)
  int? expandedIndex;
  bool isLoading = true;

  final List<GameDayTitle> gameDayTitles;

  List<LeagueTableRow> leagueTable = [];
  List<Scorer> scorers = [];
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    /*
    final daysFutures = Map.fromIterable(
      gameDayTitles,
      key: (gdt) => gdt.gameDayNumber as int,
      value: (gdt) => widget.league.getGamesTheOldWay(gdt.gameDayNumber),
    );
     */
    final games = (await Future.wait(
      gameDayTitles.map(
        (gdt) => widget.league.getGamesTheOldWay(gdt.gameDayNumber),
      ),
    )).expand((i) => i).toList();

    if (games.isEmpty) {
      setState(() {
        leagueTable = [];
        scorers = [];
        this.games = [];
        isLoading = false;
      });
    } else {
      final tableEntries = (widget.leagueType == 'league')
          ? await _fetchLeagueTable()
          : <LeagueTableRow>[];
      final fetchedScorers = await _fetchScorerList();

      setState(() {
        leagueTable = tableEntries;
        scorers = fetchedScorers;
        this.games = games;
        isLoading = false;
      });
    }
  }

  Future<List<LeagueTableRow>> _fetchLeagueTable() async {
    return widget.league.getLeagueTable();
  }

  Future<List<Scorer>> _fetchScorerList() async {
    return await widget.league.getScorers().first;
  }

  List<LeagueTableRow> _buildMicroTable(Game game, int position) {
    if (!game.ended) {
      return [
        _buildDummyTeamTableEntry(position, "Noch unbekannt", null, null),
        _buildDummyTeamTableEntry(position + 1, "Noch unbekannt", null, null),
      ];
    }

    final homeWin = game.result!.homeGoals > game.result!.guestGoals;

    return [
      _buildDummyTeamTableEntry(
        position + (homeWin ? 0 : 1),
        game.homeTeamName!,
        game.homeTeamLogo!,
        game.homeTeamSmallLogo!,
      ),
      _buildDummyTeamTableEntry(
        position + (homeWin ? 1 : 0),
        game.guestTeamName!,
        game.guestTeamLogo!,
        game.guestTeamSmallLogo!,
      ),
    ];
  }

  LeagueTableRow _buildDummyTeamTableEntry(
    int position,
    String name,
    String? teamLogo,
    String? teamLogoSmall,
  ) {
    return LeagueTableRow(
      games: 0,
      won: 0,
      draw: 0,
      lost: 0,
      wonOt: 0,
      lostOt: 0,
      goalsScored: 0,
      goalsReceived: 0,
      goalsDiff: 0,
      points: 0,
      teamName: name,
      teamId: 0,
      teamLogo: teamLogo,
      teamLogoSmall: teamLogoSmall,
      pointCorrections: null,
      sort: position - 1,
      position: position,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return MainAppScaffold(
      title: widget.league.name,
      showBackButton: true,
      body: _buildBody(context),
      selectedSeason: appState.selectedSeason,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return LoadingSpinner(title: 'Lade Spieltage ...');
    } else {
      return _buildGameDays();
    }
  }

  Widget _buildGameDays() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: gameDayTitles.length + 3,
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
      leagueName: widget.league.name,
      title: 'Tabelle',
      league: widget.league,
      teamEntries: this.leagueTable,
      scorers: this.scorers,
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
    final gameDayTitle = widget.league.gameDayTitles[gameIndex];
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
