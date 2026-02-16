import 'package:floorball/api/models/game.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/widgets/all_game_days_provider.dart';
import 'package:floorball/ui/widgets/generic_striped_table.dart';
import 'package:floorball/ui/widgets/left_labeled_content.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:floorball/utils/map_extensions.dart';
import 'package:floorball/utils/team_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:material_table_view/material_table_view.dart';

final log = Logger('ChampResultTable');

class ChampResultTable extends AllLeagueGamesProvider {
  final Map<String, int> teamNameToId;
  final GameLeagueInfo gameLeagueInfo;

  const ChampResultTable({
    super.key,
    required super.leagueId,
    required this.teamNameToId,
    required this.gameLeagueInfo,
  });

  @override
  Widget buildWithLeagueGames(List<Game> games) {
    final seriesGames = _extractSeriesGames(games);
    if (seriesGames.isEmpty()) {
      return SizedBox();
    }

    return _NamedChampSeriesTable(
      leagueId: leagueId,
      labelText: 'Endstand',
      headerHeight: 60.0,
      rowHeight: 50.0,
      teamNameToId: teamNameToId,
      gameLeagueInfo: gameLeagueInfo,
      tableRows: _sortSeriesTeams(seriesGames),
    );
  }

  SeriesGames _extractSeriesGames(List<Game> games) {
    final result = SeriesGames();
    for (var game in games) {
      if (game.seriesTitle == 'Finale') {
        result.finalGame = game;
      }
      if (_isPlacementGame(game)) {
        result.placements.add(game);
      }
    }
    return result;
  }

  bool _isPlacementGame(Game game) =>
      game.seriesTitle != null && game.seriesTitle!.startsWith('Spiel ');

  List<SeriesTableRow> _sortSeriesTeams(SeriesGames seriesGames) {
    final List<SeriesTableRow> result = [];
    result.addAll(_extractFinalTeams(seriesGames.finalGame));
    result.addAll(_extractPlacementTeams(seriesGames.placements));
    result.addAll(_createMissingDummies(result, seriesGames.length));

    result.sort();
    return result;
  }

  Iterable<SeriesTableRow> _extractFinalTeams(Game? game) {
    if (game != null && game.ended) {
      return _createTableEntries(game, 1);
    }
    return [];
  }

  Iterable<SeriesTableRow> _extractPlacementTeams(List<Game> placements) {
    return placements
        .mapNotNull((game) {
          final position = _extractPlace(game.seriesTitle!);
          if (position > 0) {
            return _createTableEntries(game, position);
          } else {
            return null;
          }
        })
        .expand((e) => e);
  }

  int _extractPlace(String series) {
    final match = RegExp(r'(\d+)$').firstMatch(series);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    log.severe("Didn't find place in '$series'");
    return 0;
  }

  Iterable<SeriesTableRow> _createTableEntries(Game game, int place) {
    bool homeWin = _homeWin(game);
    return [
      SeriesTableRow(
        position: homeWin ? place : (place + 1),
        teamLogoUri: game.homeLogoUri,
        teamLogoSmallUri: game.homeLogoSmallUri,
        teamName: game.homeTeamName,
      ),
      SeriesTableRow(
        position: homeWin ? (place + 1) : place,
        teamLogoUri: game.guestLogoUri,
        teamLogoSmallUri: game.guestLogoSmallUri,
        teamName: game.guestTeamName,
      ),
    ];
  }

  bool _homeWin(Game game) => game.result!.homeGoals > game.result!.guestGoals;

  Iterable<SeriesTableRow> _createMissingDummies(
    List<SeriesTableRow> result,
    int numGames,
  ) {
    final foundPlacement = createPrefilledMap(numGames * 2);
    for (var row in result) {
      foundPlacement[row.position] = true;
    }
    return foundPlacement.toList().mapNotNull((entry) {
      if (entry.value) return null;
      return _createDummyTableEntry(entry.key);
    });
  }

  SeriesTableRow _createDummyTableEntry(int position) => SeriesTableRow(
    position: position,
    teamLogoUri: null,
    teamLogoSmallUri: null,
    teamName: null,
  );

  Map<int, bool> createPrefilledMap(int max) {
    return {for (var i = 1; i <= max; i++) i: false};
  }
}

class SeriesGames {
  Game? finalGame;
  final List<Game> placements = [];

  bool isEmpty() => placements.isEmpty && finalGame == null;
  int get length => placements.length + 1;
}

class SeriesTableRow implements Comparable<SeriesTableRow> {
  final int position;
  final Uri? teamLogoUri;
  final Uri? teamLogoSmallUri;
  final String? teamName;

  SeriesTableRow({
    required this.position,
    required this.teamLogoUri,
    required this.teamLogoSmallUri,
    required this.teamName,
  });

  @override
  int compareTo(SeriesTableRow other) {
    return position.compareTo(other.position);
  }
}

class _NamedChampSeriesTable extends LeftLabeledContent {
  final int leagueId;
  final double headerHeight;
  final double rowHeight;
  final Map<String, int> teamNameToId;
  final GameLeagueInfo gameLeagueInfo;
  final List<SeriesTableRow> tableRows;

  _NamedChampSeriesTable({
    required super.labelText,
    required this.leagueId,
    required this.headerHeight,
    required this.rowHeight,
    required this.teamNameToId,
    required this.gameLeagueInfo,
    required this.tableRows,
  }) : super(
         labelHeight: _computeLabelHeight(
           headerHeight,
           rowHeight,
           tableRows.length,
         ),
       );

  static double _computeLabelHeight(
    double headerHeight,
    double rowHeight,
    int rowCount,
  ) {
    return headerHeight + (rowCount * rowHeight);
  }

  @override
  Widget buildContent() {
    return _ChampSeriesTable(
      leagueId: leagueId,
      teamNameToId: teamNameToId,
      gameLeagueInfo: gameLeagueInfo,
      rows: tableRows,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
    );
  }
}

class _ChampSeriesTable extends GenericStripedTable<SeriesTableRow> {
  final int leagueId;
  final Map<String, int> teamNameToId;
  final GameLeagueInfo gameLeagueInfo;
  final List<SeriesTableRow> rows;
  final double headerHeight;
  final double rowHeight;

  const _ChampSeriesTable({
    required this.leagueId,
    required this.teamNameToId,
    required this.gameLeagueInfo,
    required this.rows,
    required this.headerHeight,
    required this.rowHeight,
  });

  @override
  Widget build(BuildContext context) {
    return buildTable(
      _tableDefinition,
      rows,
      headerHeight: headerHeight,
      rowHeight: rowHeight,
      onTapBuilder: (ctxt, rowId) {
        final teamName = rows[rowId].teamName;
        final teamId = teamNameToId[teamName];
        return (teamId == null)
            ? null
            : () => TeamDetailsFullPageRoute(
                $extra: TeamInfo(
                  leagueId: leagueId,
                  teamId: teamId,
                  teamName: teamName!,
                  teamLogoUri: rows[rowId].teamLogoUri,
                  gameLeagueInfo: gameLeagueInfo,
                ),
              ).push(context);
      },
    );
  }

  static final List<TableColumnDefinition<SeriesTableRow>> _tableDefinition = [
    TableColumnDefinition(
      column: const TableColumn(width: 25), // position
      headerBuilder: () => buildHeaderCell('#', align: Alignment.bottomRight),
      contentBuilder: (row) => buildTextCell('${row.position}'),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 40), // logo
      headerBuilder: () => const SizedBox.shrink(),
      contentBuilder: (row) =>
          TeamLogo(uri: row.teamLogoSmallUri, height: 32, width: 32),
    ),
    TableColumnDefinition(
      column: const TableColumn(width: 180), // team name
      headerBuilder: () =>
          buildHeaderCell('Mannschaft', align: Alignment.bottomLeft),
      contentBuilder: (row) =>
          buildTextCell(row.teamName ?? '', align: Alignment.centerLeft),
    ),
  ];
}
