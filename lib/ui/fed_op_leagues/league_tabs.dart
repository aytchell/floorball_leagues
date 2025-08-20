import 'dart:collection';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../api/models/game_operation_league.dart';
import '../../api_models/game.dart';
import '../../api_models/table.dart';
import '../../api_models/scorer.dart';
import '../../net/rest_client.dart';
import '../../app_state.dart';
import '../game_day/game_card.dart';
import '../game_day/game_day_table.dart';
import '../app_text_styles.dart';
import '../widgets/nothing_found.dart';
import '../widgets/loading_spinner.dart';
import '../main_app_scaffold.dart';
import 'league_table_card.dart';
import 'champ_table_card.dart';
import 'scorer_card.dart';
import 'date_and_club.dart';

final log = Logger('LeagueTabs');

class GameSubDayInfo {
  final String dateAtClub;
  final String arenaName;
  final String arenaAddress;
  final List<Game> games;

  GameSubDayInfo({
    required this.dateAtClub,
    required this.arenaName,
    required this.arenaAddress,
    required this.games,
  });
}

class LeagueTabs extends StatefulWidget {
  final GameOperationLeague league;
  String leagueType;

  LeagueTabs({required this.league})
    : leagueType = league.leagueType ?? "league";

  @override
  _LeagueTabsState createState() => _LeagueTabsState();
}

class _LeagueTabsState extends State<LeagueTabs> {
  // Track which item is currently expanded (null means none expanded)
  int? expandedIndex;
  bool isLoading = false;

  RestClient? restClient;
  Map<int, List<Game>> gameDays = {};
  List<TeamTableEntry> leagueTable = [];
  List<GroupTable> champTable = [];
  List<ScorerEntry> scorersList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    restClient ??= await RestClient.instance;

    final daysFutures = Map.fromIterable(
      widget.league.gameDayTitles,
      key: (gdt) => gdt.gameDayNumber as int,
      value: (gdt) => widget.league.getGames(gdt.gameDayNumber),
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
        scorersList = [];
        isLoading = false;
      });
    } else {
      final tableEntries = (widget.leagueType == 'league')
          ? await _fetchLeagueTable(restClient!)
          : <TeamTableEntry>[];
      final champEntries = (widget.leagueType == 'champ')
          ? await _fetchChampTable(
              restClient!,
              days.values.expand((games) => games).toList(),
            )
          : <GroupTable>[];
      final scorerEntries = await _fetchScorerList(restClient!);

      setState(() {
        gameDays = days;
        leagueTable = tableEntries;
        champTable = champEntries;
        scorersList = scorerEntries;
        isLoading = false;
      });
    }
  }

  Future<List<TeamTableEntry>> _fetchLeagueTable(RestClient restClient) async {
    return TeamTable.fetchLeagueTableFromServer(restClient, widget.league.id);
  }

  Future<List<GroupTable>> _fetchChampTable(
    RestClient restClient,
    List<Game> games,
  ) async {
    var groupTables = await TeamTable.fetchChampTableFromServer(
      restClient,
      widget.league.id,
    );

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

    groupTables.add(
      GroupTable(
        groupIdentifier: 'final_round',
        name: 'Endstand',
        table: finalTable,
        hidePoints: true,
      ),
    );
    return groupTables;
  }

  Future<List<ScorerEntry>> _fetchScorerList(RestClient restClient) async {
    return Scorers.fetchFromServer(restClient, widget.league.id);
  }

  List<TeamTableEntry> _buildMicroTable(Game game, int position) {
    if (!game.ended) {
      return [
        _buildDummyTeamTableEntry(position, "Noch unbekannt", null, null),
        _buildDummyTeamTableEntry(position + 1, "Noch unbekannt", null, null),
      ];
    }

    if (game.result!.homeGoals > game.result!.guestGoals) {
      return [
        _buildDummyTeamTableEntry(
          position,
          game.homeTeamName!,
          game.homeTeamLogo,
          game.homeTeamSmallLogo,
        ),
        _buildDummyTeamTableEntry(
          position + 1,
          game.guestTeamName!,
          game.guestTeamLogo,
          game.guestTeamSmallLogo,
        ),
      ];
    } else {
      return [
        _buildDummyTeamTableEntry(
          position,
          game.guestTeamName!,
          game.guestTeamLogo,
          game.guestTeamSmallLogo,
        ),
        _buildDummyTeamTableEntry(
          position + 1,
          game.homeTeamName!,
          game.homeTeamLogo,
          game.homeTeamSmallLogo,
        ),
      ];
    }
  }

  TeamTableEntry _buildDummyTeamTableEntry(
    int position,
    String name,
    String? teamLogo,
    String? teamLogoSmall,
  ) {
    return TeamTableEntry(
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
      itemCount: gameDays.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          if (widget.leagueType == 'champ') {
            return _buildChampTableCard(context, index);
          } else {
            return _buildLeagueTableCard(context, index);
          }
        } else if (index == 1) {
          return _buildScorerCard(context, index);
        } else {
          return _buildGameDayCard(context, index, index - 2);
        }
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

  Widget _buildLeagueTableCard(BuildContext context, int cardIndex) {
    final isExpanded = expandedIndex == cardIndex;

    return ExpandableLeagueTableCard(
      title: 'Tabelle',
      teamEntries: this.leagueTable,
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
      scorerEntries: this.scorersList,
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
      title: _computeTitle(gameDayTitle.title, games),
      games: games,
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

// Separate Card widget
class ExpandableGameDayCard extends StatelessWidget {
  final String title;
  final List<Game> games;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableGameDayCard({
    Key? key,
    required this.title,
    required this.games,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  // Define color constants to avoid accessing theme colors in static contexts
  static const Color expandedTextColor = Color(
    0xFF1976D2,
  ); // Colors.blue.shade700
  static const Color expandedBygoneTextColor = Color(
    0xFF90CAF9,
  ); // Colors.blue.shade200
  static const Color expandedBackgroundColor = Color(
    0xFFE3F2FD,
  ); // Colors.blue[50]
  static const Color collapsedIconColor = Color(0xFF757575); // Colors.grey[600]
  static const Color expandedContentBackgroundColor = Color(
    0xFFFAFAFA,
  ); // Colors.grey[50]

  // Text styles as instance getters to access theme if needed
  TextStyle get _expandedDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: expandedTextColor,
  );

  TextStyle get _expandedTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: expandedTextColor,
  );

  TextStyle get _collapsedDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  TextStyle get _collapsedTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: Colors.black87,
  );

  TextStyle get _expandedBygoneDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: expandedTextColor,
  );

  TextStyle get _expandedBygoneTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: expandedTextColor,
  );

  TextStyle get _collapsedBygoneDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black38,
  );

  TextStyle get _collapsedBygoneTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: Colors.black38,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Column(
        children: [_buildButtonLikeHeader(), _buildExpandableContent()],
      ),
    );
  }

  Widget _buildButtonLikeHeader() {
    final List<Row> rows = [];
    rows.add(_buildGameDayTitle());
    rows.addAll(_buildGameDateAndClubs());

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isExpanded ? expandedBackgroundColor : Colors.white,
          borderRadius: isExpanded
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                )
              : BorderRadius.circular(4),
        ),
        child: Column(children: rows),
      ),
    );
  }

  Row _buildGameDayTitle() {
    final expandedStyle = AppTextStyles.gameDayTitleExpanded;
    final collapsedStyle = AppTextStyles.gameDayTitleCollapsed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: isExpanded ? expandedStyle : collapsedStyle),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: isExpanded ? expandedTextColor : collapsedIconColor,
        ),
      ],
    );
  }

  List<Row> _buildGameDateAndClubs() {
    final dateAndClubs = _extractDateAndClubs();
    final dateStyle = isExpanded ? _expandedDateStyle : _collapsedDateStyle;
    final textStyle = isExpanded ? _expandedTextStyle : _collapsedTextStyle;
    final bygoneDateStyle = isExpanded
        ? _expandedBygoneDateStyle
        : _collapsedBygoneDateStyle;
    final bygoneTextStyle = isExpanded
        ? _expandedBygoneTextStyle
        : _collapsedBygoneTextStyle;
    if (dateAndClubs.length <= 3) {
      return dateAndClubs
          .map(
            (dac) => _buildSingleDateAndClubRow(
              dac,
              dateStyle,
              textStyle,
              bygoneDateStyle,
              bygoneTextStyle,
            ),
          )
          .toList();
    } else {
      return [
        _buildCombinedDateAndClubRow(
          dateAndClubs,
          dateStyle,
          textStyle,
          bygoneDateStyle,
          bygoneTextStyle,
        ),
      ];
    }
  }

  Row _buildSingleDateAndClubRow(
    DateAndClub dac,
    TextStyle upcomingDateStyle,
    TextStyle upcomingTextStyle,
    TextStyle bygoneDateStyle,
    TextStyle bygoneTextStyle,
  ) {
    final isBygone = dac.isBygone;
    final textStyle = isBygone ? bygoneTextStyle : upcomingTextStyle;
    final dateStyle = isBygone ? bygoneDateStyle : upcomingDateStyle;
    return Row(
      children: [
        Text('${dac.date}', style: dateStyle),
        Text(' bei ${dac.hostingClub}', style: textStyle),
      ],
    );
  }

  Row _buildCombinedDateAndClubRow(
    List<DateAndClub> dacs,
    TextStyle upcomingDateStyle,
    TextStyle upcomingTextStyle,
    TextStyle bygoneDateStyle,
    TextStyle bygoneTextStyle,
  ) {
    final isBygone = dacs.last.isBygone;
    final textStyle = isBygone ? bygoneTextStyle : upcomingTextStyle;
    final dateStyle = isBygone ? bygoneDateStyle : upcomingDateStyle;

    return Row(
      children: [
        Text('von ', style: textStyle),
        Text('${dacs.first.date}', style: dateStyle),
        Text(' bis ', style: textStyle),
        Text('${dacs.last.date}', style: dateStyle),
      ],
    );
  }

  List<DateAndClub> _extractDateAndClubs() {
    final today = DateTime.now();
    var eventList = games
        .map((game) => DateAndClub.create(game.date!, game.hostingClub!, today))
        .toSet()
        .toList();
    eventList.sort();
    return eventList;
  }

  Widget _buildExpandableContent() {
    // Expandable content
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      child: isExpanded
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: expandedContentBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: _buildGamesTable(),
            )
          : const SizedBox.shrink(),
    );
  }

  Map<String, GameSubDayInfo> _groupBySubday(List<Game> games) {
    // entries in map should be sorted by key
    final groups = SplayTreeMap.from(
      groupBy(games, (game) => "${game.date}\n${game.hostingClub}"),
    );
    return groups.map(
      (key, value) => MapEntry(
        key,
        GameSubDayInfo(
          dateAtClub: key,
          arenaName: value[0].arenaName!,
          arenaAddress: value[0].arenaAddress!,
          games: value,
        ),
      ),
    );
  }

  Widget _buildGamesTable() {
    final gameData = _groupBySubday(games).entries
        .map(
          (sub) => GameSubdayRows(
            info: _buildGameSubDayInfoCard(sub.value),
            games: sub.value.games
                .map((game) => GameResultSlice(game: game))
                .toList(),
          ),
        )
        .toList();
    return SportGamesTable(subdays: gameData);
  }

  Widget _buildGameSubDayInfoCard(GameSubDayInfo info) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(info.dateAtClub, style: AppTextStyles.gameSubDayTitle),
            subtitle: Text(
              info.arenaName,
              style: AppTextStyles.gameSubDaySubTitle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Navigieren'),
                onPressed: () {
                  /* ... */
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
