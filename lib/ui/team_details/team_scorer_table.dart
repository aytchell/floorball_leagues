import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';
import '../../api/models/scorer.dart';

class IndexedScorer {
  final int index;
  final Scorer scorer;

  IndexedScorer({required this.index, required this.scorer});
}

class TeamScorerTable extends StatelessWidget {
  final List<IndexedScorer> scorers;

  TeamScorerTable({required this.scorers});

  @override
  Widget build(BuildContext context) {
    // Handle empty scorers list
    if (scorers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Keine Torschützen verfügbar',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    final rankColumnWidth = (scorers.last.index >= 100) ? 30.0 : 20.0;

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
        ],
        rowCount: scorers.length,
        rowHeight: 34.0,
        headerHeight: 60.0, // Increased height for rotated text
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
                  return _rotatedTableHeader('Platz');
                case 1:
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _tableHeaderText('Name'),
                  );
                case 2:
                  return _rotatedTableHeader('Spiele');
                case 3:
                  return _rotatedTableHeader('Punkte');
                case 4:
                  return _rotatedTableHeader('Tore');
                case 5:
                  return _rotatedTableHeader('Assists');
                default:
                  return const SizedBox.shrink();
              }
            }),
          );
        },
        rowBuilder: (context, row, contentBuilder) {
          final rank = scorers[row].index;
          final scorer = scorers[row].scorer;

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

  Widget _rotatedTableHeader(String text) {
    return Container(
      alignment: Alignment.center,
      child: RotatedBox(quarterTurns: 3, child: _tableHeaderText(text)),
    );
  }

  Widget _tableHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.grey[800],
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
