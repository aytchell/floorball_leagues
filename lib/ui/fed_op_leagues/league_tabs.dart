import 'dart:collection';
import 'package:logging/logging.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../api_models/game_operations.dart';
import '../../api_models/game_day.dart';
import '../../net/rest_client.dart';
import '../game_day/game_day_table.dart';

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

class DateAndClub implements Comparable<DateAndClub> {
  final String date;
  final String hostingClub;
  final String combined;

  DateAndClub({required this.date, required this.hostingClub})
    : combined = '$date @ $hostingClub';

  @override
  int compareTo(DateAndClub other) {
    return combined.compareTo(other.combined);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DateAndClub) return false;
    return combined == other.combined;
  }

  @override
  int get hashCode => Object.hash(date, hostingClub);
}

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

    return _gameDaySubTitles(dateAndClubs)
        .map(
          (text) => Row(
            children: [
              Text(
                text,
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

  List<String> _gameDaySubTitles(List<DateAndClub> dateAndClubs) {
    if (dateAndClubs.length <= 3)
      return dateAndClubs.map((dac) => dac.combined).toList();
    else
      return ["von ${dateAndClubs.first.date} bis ${dateAndClubs.last.date}"];
  }

  List<DateAndClub> _extractDateAndClubs() {
    var eventList = games
        .map(
          (game) =>
              DateAndClub(date: game.date!, hostingClub: game.hostingClub!),
        )
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
    final host = 'https://saisonmanager.de';
    final gameData = _groupBySubday(games).entries
        .map(
          (sub) => GameSubdayRows(
            info: _buildGameSubDayInfoCard(sub.value),
            games: sub.value.games
                .map(
                  (game) => GameResultRow(
                    homeTeamName: game.homeTeamName ?? 'tbd',
                    homeTeamLogo: '${host}${game.homeTeamSmallLogo!}',
                    result: game.resultString ?? '- : -',
                    guestTeamLogo: '${host}${game.guestTeamSmallLogo!}',
                    guestTeamName: game.guestTeamName ?? 'tbd',
                  ),
                )
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
            title: Text(
              info.dateAtClub,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              info.arenaName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
