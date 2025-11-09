import 'package:floorball/api/models/league.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/ui/widgets/expandable_card.dart';
import 'package:floorball/api/models/game.dart';

final log = Logger('ChampTableCard');

class ExpandableChampTableCard extends StatefulWidget {
  final String title;
  final League league;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableChampTableCard({
    super.key,
    required this.title,
    required this.league,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _ChampTableState();
}

class _ChampTableState extends State<ExpandableChampTableCard> {
  List<ChampGroupTable> baseTables = [];
  List<Game> games = [];
  ChampGroupTable finalTable = _buildDummyChampGroupTable();

  List<ChampGroupTable> champTables = [];

  @override
  void initState() {
    super.initState();

    widget.league.getChampTable().forEach((futureList) {
      futureList.then((list) {
        setState(() {
          baseTables = list;
          champTables = List<ChampGroupTable>.from(baseTables);
          champTables.add(finalTable);
        });
      });
    });

    widget.league.gameDayTitles.map((gdt) => gdt.gameDayNumber).forEach((
      number,
    ) {
      widget.league.getGames(number).forEach((futureList) {
        futureList.then((streamedGames) {
          final newIds = streamedGames.map((game) => game.gameId).toSet();
          final newGames = games
              .where((game) => !newIds.contains(game.gameId))
              .toList();
          newGames.addAll(streamedGames);

          final newFinalTable = _computeFinalTable(newGames);
          setState(() {
            games = newGames;
            finalTable = newFinalTable;
            champTables = List<ChampGroupTable>.from(baseTables);
            champTables.add(finalTable);
          });
        });
      });
    });
  }

  static ChampGroupTable _buildDummyChampGroupTable() {
    return ChampGroupTable(
      groupIdentifier: 'final_round',
      name: 'Endstand',
      table: [_buildTeamTableEntry(1, 'Noch unbekannt', null, null)],
      hidePoints: true,
    );
  }

  ChampGroupTable _computeFinalTable(List<Game> allGames) {
    log.info('cft: received ${allGames.length} games with seriesTitles ...');
    for (var game in allGames) {
      log.info(game.seriesTitle);
    }
    final finalGame = allGames
        .where((game) => game.seriesTitle == 'Finale')
        .first;

    final placements = allGames
        .where(
          (game) =>
              game.seriesTitle != null &&
              game.seriesTitle!.startsWith('Spiel '),
        )
        .toList();
    log.info('cft: found ${placements.length} placement games');
    placements.sort(
      (Game a, Game b) => a.seriesTitle!.compareTo(b.seriesTitle!),
    );
    var endRound = [finalGame];
    endRound.addAll(placements);
    log.info('cft: endRound has ${endRound.length} games');

    final finalTable = endRound
        .asMap()
        .map(
          (index, game) =>
              MapEntry(index, _buildMicroTable(game, 2 * index + 1)),
        )
        .values
        .expand((i) => i)
        .toList();

    finalTable.sort((a, b) => a.position.compareTo(b.position));
    return ChampGroupTable(
      groupIdentifier: 'final_round',
      name: 'Endstand',
      table: finalTable,
      hidePoints: true,
    );
  }

  List<LeagueTableRow> _buildMicroTable(Game game, int position) {
    if (!game.ended) {
      return [
        _buildTeamTableEntry(position, 'Noch unbekannt', null, null),
        _buildTeamTableEntry(position + 1, 'Noch unbekannt', null, null),
      ];
    }

    final homeWin = game.result!.homeGoals > game.result!.guestGoals;

    return [
      _buildTeamTableEntry(
        position + (homeWin ? 0 : 1),
        game.homeTeamName!,
        game.homeTeamLogo!,
        game.homeTeamSmallLogo!,
      ),
      _buildTeamTableEntry(
        position + (homeWin ? 1 : 0),
        game.guestTeamName!,
        game.guestTeamLogo!,
        game.guestTeamSmallLogo!,
      ),
    ];
  }

  static LeagueTableRow _buildTeamTableEntry(
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
    // If no group tables, show simple non-expandable card
    if (champTables.isEmpty) {
      return _buildEmptyCard();
    }

    // Otherwise show expandable card
    return ExpandableCard(
      title: widget.title,
      isExpanded: widget.isExpanded,
      onTap: widget.onTap,
      child: _buildTablesContent(),
    );
  }

  Widget _buildEmptyCard() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: AppTextStyles.gameDayTitleCollapsed),
            Text(
              'Noch keine Tabelle vorhanden',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTablesContent() {
    if (champTables.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Tabellen werden geladen...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
        ),
      );
    }

    return Column(
      children: champTables.map((group) => _buildGroupTable(group)).toList(),
    );
  }

  Widget _buildGroupTable(ChampGroupTable group) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Group name column (rotated 90°)
          _buildGroupNameColumn(group.name, group.table.length),

          // Right side: Team table
          Expanded(child: _buildTeamTable(group.table, group.hidePoints)),
        ],
      ),
    );
  }

  Widget _buildGroupNameColumn(String name, int teamCount) {
    return Container(
      width: 20.0,
      height: (teamCount * 40.0) + 16.0, // Adjust height based on team count
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3, // 270 degrees (90 degrees counterclockwise)
          child: Text(
            name,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamTable(List<LeagueTableRow> table, bool hidePoints) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: table
            .map((entry) => _buildTableRow(entry, hidePoints))
            .toList(),
      ),
    );
  }

  Widget _buildTableRow(LeagueTableRow entry, bool hidePoints) {
    return Container(
      height: 36.0,
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          // Position
          SizedBox(
            width: 24.0,
            child: Text(
              '${entry.position}.',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(width: 8.0),

          // Team logo
          TeamLogo(uri: entry.teamLogoSmallUri, height: 20, width: 20),

          SizedBox(width: 8.0),

          // Team name
          Expanded(
            child: Text(
              entry.teamName,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            hidePoints ? '' : '${entry.points}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
