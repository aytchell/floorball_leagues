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

  Map<int, List<Game>> gameDays = {};
  List<LeagueTableRow> leagueTable = [];
  List<ChampGroupTable> champTable = [];
  List<Scorer> scorers = [];
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final daysFutures = Map.fromIterable(
      gameDayTitles,
      key: (gdt) => gdt.gameDayNumber as int,
      value: (gdt) => widget.league.getGamesTheOldWay(gdt.gameDayNumber),
    );

    final Map<int, List<Game>> days = Map.fromEntries(
      await Future.wait(
        daysFutures.entries.map(
          (entry) async => MapEntry(entry.key, await entry.value),
        ),
      ),
    );

    if (days.isEmpty) {
      setState(() {
        gameDays = {};
        leagueTable = [];
        champTable = [];
        scorers = [];
        games = [];
        isLoading = false;
      });
    } else {
      final tableEntries = (widget.leagueType == 'league')
          ? await _fetchLeagueTable()
          : <LeagueTableRow>[];
      final champEntries = (widget.leagueType == 'champ')
          ? await _fetchChampTable(
              days.values.expand((games) => games).toList(),
            )
          : <ChampGroupTable>[];
      final fetchedScorers = await _fetchScorerList();

      setState(() {
        gameDays = days;
        leagueTable = tableEntries;
        champTable = champEntries;
        scorers = fetchedScorers;
        isLoading = false;
      });
    }
  }

  Future<List<LeagueTableRow>> _fetchLeagueTable() async {
    return widget.league.getLeagueTable();
  }

  Future<List<ChampGroupTable>> _fetchChampTable(List<Game> games) async {
    var champTable = await widget.league.getChampTable();

    final finalGame = games.where((game) => game.seriesTitle == 'Finale').first;
    final placements = games
        .where(
          (game) =>
              game.seriesTitle != null &&
              game.seriesTitle!.startsWith('Spiel '),
        )
        .toList();
    placements.sort(
      (Game a, Game b) => a.seriesTitle!.compareTo(b.seriesTitle!),
    );
    var endRound = [finalGame];
    endRound.addAll(placements);
    final finalTable = endRound
        .asMap()
        .map(
          (index, game) =>
              MapEntry.new(index, _buildMicroTable(game, 2 * index + 1)),
        )
        .values
        .expand((i) => i)
        .toList();

    finalTable.sort((a, b) => a.position.compareTo(b.position));

    champTable.add(
      ChampGroupTable(
        groupIdentifier: 'final_round',
        name: 'Endstand',
        table: finalTable,
        hidePoints: true,
      ),
    );
    return champTable;
  }

  Future<List<Scorer>> _fetchScorerList() async {
    return widget.league.getScorers();
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
      groupTables: this.champTable,
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }

  List<Game> _getFlattenedGames() {
    return this.gameDays.values.expand((i) => i).toList();
  }

  Widget _buildLeagueTableCard(BuildContext context, int cardIndex) {
    final isExpanded = expandedIndex == cardIndex;

    return ExpandableLeagueTableCard(
      leagueName: widget.league.name,
      title: 'Tabelle',
      teamEntries: this.leagueTable,
      scorers: this.scorers,
      games: _getFlattenedGames(),
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

  Widget _buildGameDayCard(BuildContext context, int cardIndex, int gameIndex) {
    final gameDayTitle = widget.league.gameDayTitles[gameIndex];
    final isExpanded = expandedIndex == cardIndex;
    final games = gameDays[gameDayTitle.gameDayNumber]!;

    return ExpandableGameDayCard(
      league: widget.league,
      gameDayTitle: gameDayTitle,
      title: _computeTitle(gameDayTitle.title, games),
      isExpanded: isExpanded,
      onTap: () {
        setState(() {
          // Toggle expansion: if already expanded, collapse it, otherwise expand it
          expandedIndex = isExpanded ? null : cardIndex;
        });
      },
    );
  }

  String _computeTitle(final String title, final List<Game> games) {
    if (widget.leagueType == "champ") {
      final groups = games
          .map((game) => [_groupIdentifier(game), _seriesTitle(game)].nonNulls)
          .expand((i) => i)
          .toSet();
      var type = "";
      if (groups.length == 1) {
        type = '(${groups.first})';
      } else if (groups.length == 2) {
        type = '(Gruppen/Platzierung)';
      }

      return '$title $type';
      // } else if (widget.leagueType == "cup") {
      // TODO
    } else {
      return title;
    }
  }

  String? _groupIdentifier(Game game) {
    final ident = game.groupIdentifier;
    return (ident != null) ? "Gruppenphase" : null;
  }

  String? _seriesTitle(Game game) {
    final title = game.seriesTitle;
    return (title != null) ? "Platzierungsphase" : null;
  }
}
