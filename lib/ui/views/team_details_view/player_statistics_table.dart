import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/ui/views/team_details_view/indexed_scorer.dart';

enum SortColumn {
  rank,
  name,
  games,
  points,
  goals,
  assists,
  penalty2,
  penalty2and2,
  penalty10,
  penaltyMsTech,
  penaltyMsFull,
}

class PlayerStatisticsTable extends StatefulWidget {
  final List<IndexedScorer> scorers;
  final maxRank;

  PlayerStatisticsTable({required this.scorers})
    : maxRank = (scorers.isEmpty
          ? 0
          : scorers.map((idx) => idx.index).reduce(math.max));

  @override
  _PlayerStatisticsTableState createState() => _PlayerStatisticsTableState();
}

class _PlayerStatisticsTableState extends State<PlayerStatisticsTable> {
  List<IndexedScorer> _sortedScorers = [];
  SortColumn? _currentSortColumn;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _sortedScorers = List.from(widget.scorers);
  }

  @override
  void didUpdateWidget(PlayerStatisticsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scorers != oldWidget.scorers) {
      _sortedScorers = List.from(widget.scorers);
      _applySorting();
    }
  }

  void _sortBy(SortColumn column) {
    setState(() {
      if (_currentSortColumn == column) {
        _isAscending = !_isAscending;
      } else {
        _currentSortColumn = column;
        _isAscending = true;
      }
      _applySorting();
    });
  }

  void _applySorting() {
    if (_currentSortColumn == null) return;

    _sortedScorers.sort((a, b) {
      int comparison = 0;

      switch (_currentSortColumn!) {
        case SortColumn.rank:
          comparison = a.index.compareTo(b.index);
          break;
        case SortColumn.name:
          comparison = a.scorer.fullName.compareTo(b.scorer.fullName);
          break;
        case SortColumn.games:
          comparison = a.scorer.games.compareTo(b.scorer.games);
          break;
        case SortColumn.points:
          comparison = a.scorer.points.compareTo(b.scorer.points);
          break;
        case SortColumn.goals:
          comparison = a.scorer.goals.compareTo(b.scorer.goals);
          break;
        case SortColumn.assists:
          comparison = a.scorer.assists.compareTo(b.scorer.assists);
          break;
        case SortColumn.penalty2:
          comparison = a.scorer.penalty2.compareTo(b.scorer.penalty2);
          break;
        case SortColumn.penalty2and2:
          comparison = a.scorer.penalty2and2.compareTo(b.scorer.penalty2and2);
          break;
        case SortColumn.penalty10:
          comparison = a.scorer.penalty10.compareTo(b.scorer.penalty10);
          break;
        case SortColumn.penaltyMsTech:
          comparison = a.scorer.penaltyMsTech.compareTo(b.scorer.penaltyMsTech);
          break;
        case SortColumn.penaltyMsFull:
          comparison = a.scorer.penaltyMsFull.compareTo(b.scorer.penaltyMsFull);
          break;
      }

      return _isAscending ? comparison : -comparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty scorers list
    if (widget.scorers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Keine Spielerinfo verfügbar',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    final rankColumnWidth = (widget.maxRank >= 100) ? 30.0 : 20.0;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TableView.builder(
        columns: [
          TableColumn(width: rankColumnWidth), // ranking column
          const TableColumn(
            width: 150.0,
            freezePriority: 100,
          ), // Player name column
          const TableColumn(width: 30.0), // games column
          const TableColumn(width: 40.0), // points column
          const TableColumn(width: 40.0), // goals column
          const TableColumn(width: 40.0), // assists column
          const TableColumn(width: 40.0), // penalty: 2'
          const TableColumn(width: 40.0), // penalty: 2+2
          const TableColumn(width: 40.0), // penalty: 10'
          const TableColumn(width: 40.0), // technical match penalty
          const TableColumn(width: 40.0), // match penalty
        ],
        rowCount: _sortedScorers.length,
        rowHeight: 34.0,
        headerHeight: 85.0, // Increased height for rotated text
        headerBuilder: (context, contentBuilder) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: contentBuilder(context, (context, column) {
              switch (column) {
                case 0:
                  return _buildSortableHeader('Platz', SortColumn.rank, true);
                case 1:
                  return _buildSortableHeader('Name', SortColumn.name, false);
                case 2:
                  return _buildSortableHeader('Spiele', SortColumn.games, true);
                case 3:
                  return _buildSortableHeader(
                    'Punkte',
                    SortColumn.points,
                    true,
                  );
                case 4:
                  return _buildSortableHeader('Tore', SortColumn.goals, true);
                case 5:
                  return _buildSortableHeader(
                    'Assists',
                    SortColumn.assists,
                    true,
                  );
                case 6:
                  return _buildSortableHeader(
                    "Strafe 2'",
                    SortColumn.penalty2,
                    true,
                  );
                case 7:
                  return _buildSortableHeader(
                    'Strafe 2+2',
                    SortColumn.penalty2and2,
                    true,
                  );
                case 8:
                  return _buildSortableHeader(
                    "Strafe 10'",
                    SortColumn.penalty10,
                    true,
                  );
                case 9:
                  return _buildSortableHeader(
                    'MS (tech)',
                    SortColumn.penaltyMsTech,
                    true,
                  );
                case 10:
                  return _buildSortableHeader(
                    'MS',
                    SortColumn.penaltyMsFull,
                    true,
                  );
                default:
                  return const SizedBox.shrink();
              }
            }),
          );
        },
        rowBuilder: (context, row, contentBuilder) {
          final rank = _sortedScorers[row].index;
          final scorer = _sortedScorers[row].scorer;

          return Material(
            type: MaterialType.transparency,
            child: InkWell(
              child: contentBuilder(context, (context, column) {
                switch (column) {
                  case 0:
                    return Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$rank',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  case 1:
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        scorer.fullName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  case 2:
                    return _scorerData('${scorer.games}');
                  case 3:
                    return _scorerData('${scorer.points}');
                  case 4:
                    return _scorerData('${scorer.goals}');
                  case 5:
                    return _scorerData('${scorer.assists}');
                  case 6:
                    return _scorerData('${scorer.penalty2}');
                  case 7:
                    return _scorerData('${scorer.penalty2and2}');
                  case 8:
                    return _scorerData('${scorer.penalty10}');
                  case 9:
                    return _scorerData('${scorer.penaltyMsTech}');
                  case 10:
                    return _scorerData('${scorer.penaltyMsFull}');
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortableHeader(String text, SortColumn column, bool rotated) {
    final isCurrentSort = _currentSortColumn == column;
    final sortIcon = isCurrentSort
        ? (_isAscending ? Icons.arrow_upward : Icons.arrow_downward)
        : Icons.unfold_more;

    final iconColor = isCurrentSort ? Colors.blue[700] : Colors.grey[600];
    final textColor = isCurrentSort ? Colors.blue[800] : Colors.grey[800];

    Widget content = InkWell(
      onTap: () => _sortBy(column),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: rotated
            ? RotatedBox(
                quarterTurns: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 4),
                    _tableHeaderText(text, textColor),
                    const SizedBox(width: 4),
                    RotatedBox(
                      quarterTurns: 1, // Counter-rotate the icon
                      child: Icon(sortIcon, size: 12, color: iconColor),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tableHeaderText(text, textColor),
                  const SizedBox(width: 4),
                  Icon(sortIcon, size: 12, color: iconColor),
                ],
              ),
      ),
    );

    return content;
  }

  Widget _tableHeaderText(String text, Color? color) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: color ?? Colors.grey[800],
      ),
    );
  }

  Widget _scorerData(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}
