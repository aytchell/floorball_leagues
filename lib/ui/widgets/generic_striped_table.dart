import 'package:floorball/ui/widgets/striped_table_row.dart';
import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';

class TableColumnDefinition<T> {
  final TableColumn column;
  final Widget Function() headerBuilder;
  final Widget Function(T row) contentBuilder;

  const TableColumnDefinition({
    required this.column,
    required this.headerBuilder,
    required this.contentBuilder,
  });
}

abstract class GenericStripedTable<T> extends StatelessWidget {
  const GenericStripedTable({super.key});

  @protected
  Widget buildTable(
    List<TableColumnDefinition<T>> tableDefinition,
    List<T> rows, {
    Function(BuildContext context, int rowId)? onTapBuilder,
    double headerHeight = 85.0,
    double rowHeight = 50.0,
  }) => TableView.builder(
    columns: tableDefinition.map((def) => def.column).toList(),
    rowCount: rows.length,
    rowHeight: rowHeight,
    headerHeight: headerHeight,
    headerBuilder: (context, contentBuilder) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: contentBuilder(
          context,
          (context, columnId) => tableDefinition[columnId].headerBuilder(),
        ),
      );
    },
    rowBuilder: (context, rowId, contentBuilder) {
      final row = rows[rowId];
      return StripedTableRow(
        index: rowId,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        onTap: onTapBuilder?.call(context, rowId),
        child: contentBuilder(
          context,
          (context, columnId) => tableDefinition[columnId].contentBuilder(row),
        ),
      );
    },
  );
}

Widget buildTextCell(
  String text, {
  Alignment align = Alignment.center,
  FontWeight weight = FontWeight.normal,
}) {
  return Container(
    alignment: align,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(text, style: TextStyle(fontWeight: weight, fontSize: 14)),
  );
}

Widget buildHeaderCell(
  String text, {
  bool rotated = false,
  Alignment align = Alignment.bottomCenter,
}) {
  final textColor = Colors.grey[800];

  return Container(
    alignment: align,
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
              ],
            ),
          )
        : _tableHeaderText(text, textColor),
  );
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
