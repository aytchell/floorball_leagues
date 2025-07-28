import 'package:flutter/material.dart';
import 'api_models/game_operations.dart';
import 'api_models/game_day.dart';
import 'rest_client.dart';
import 'game_day_table.dart';

class LeagueTabs extends StatefulWidget {
  final GameOperationLeague league;

  const LeagueTabs({Key? key, required this.league}) : super(key: key);

  @override
  _LeagueTabsState createState() => _LeagueTabsState();
}

class _LeagueTabsState extends State<LeagueTabs> {
  // Track which item is currently expanded (null means none expanded)
  int? expandedIndex;

  RestClient? restClient;
  Map<int, List<Game>> gameDays = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    restClient ??= await RestClient.instance;

    final daysFutures = Map.fromIterable(
      widget.league.gameDayTitles,
      key: (gdt) => gdt.gameDayNumber as int,
      value: (gdt) => GameDay.fetchFromServer(
        restClient!,
        widget.league.id,
        gdt.gameDayNumber,
      ),
    );

    final Map<int, List<Game>> days = Map.fromEntries(
      await Future.wait(
        daysFutures.entries.map(
          (entry) async => MapEntry(entry.key, await entry.value),
        ),
      ),
    );

    setState(() {
      gameDays = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league.name, maxLines: 2),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: gameDays.length,
        itemBuilder: (context, index) {
          final gameDayTitle = widget.league.gameDayTitles[index];
          final isExpanded = expandedIndex == index;

          return ExpandableCard(
            gameDayTitle: gameDayTitle,
            games: gameDays[gameDayTitle.gameDayNumber]!,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                // Toggle expansion: if already expanded, collapse it, otherwise expand it
                expandedIndex = isExpanded ? null : index;
              });
            },
          );
        },
      ),
    );
  }
}

// Separate Card widget
class ExpandableCard extends StatelessWidget {
  final GameDayTitle gameDayTitle;
  final List<Game> games;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableCard({
    Key? key,
    required this.gameDayTitle,
    required this.games,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
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
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isExpanded ? Colors.blue[50] : Colors.white,
          borderRadius: isExpanded
              ? BorderRadius.only(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          gameDayTitle.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isExpanded ? Colors.blue[700] : Colors.black87,
          ),
        ),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: isExpanded ? Colors.blue[700] : Colors.grey[600],
        ),
      ],
    );
  }

  List<Row> _buildGameDateAndClubs() {
    final dateAndClubs = _extractDateAndClubs();
    return dateAndClubs
        .map(
          (dac) => Row(
            children: [
              Text(
                dac,
                style: TextStyle(
                  fontSize: 14,
                  color: isExpanded ? Colors.blue[700] : Colors.black87,
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  List<String> _extractDateAndClubs() {
    var eventList = games
        .map((game) => "${game.date} @ ${game.hostingClub}")
        .toSet()
        .toList();
    eventList.sort();
    return eventList;
  }

  Widget _buildExpandableContent() {
    // Expandable content
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      child: isExpanded
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: _buildGamesTable(),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildGamesTable() {
    final host = 'https://saisonmanager.de';
    final gameData = games
        .map(
          (game) => GameResultRow(
            homeTeamName: game.homeTeamName ?? 'tbd',
            homeTeamLogo: '${host}${game.homeTeamSmallLogo!}',
            result: game.resultString ?? '- : -',
            guestTeamLogo: '${host}${game.guestTeamSmallLogo!}',
            guestTeamName: game.guestTeamName ?? 'tbd',
          ),
        )
        .toList();
    return SportGamesTable(
      subday: GameSubdayRows(info: Text('Huhu subday'), games: gameData),
    );
  }
}
