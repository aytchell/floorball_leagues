import 'package:collection/collection.dart';
import 'package:floorball/ui/widgets/striped_table_row.dart';
import 'package:flutter/material.dart';

abstract class StripedRowsList<T> extends StatelessWidget {
  final List<T> entries;
  final EdgeInsetsGeometry padding;
  final void Function(BuildContext context, T entry)? onTap;

  static const double _verticalPadding = 12.0;
  static const double defaultPaddingPerRow = 2 * _verticalPadding;

  const StripedRowsList(
    this.entries, {
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: _verticalPadding,
    ),
    this.onTap,
  });

  Widget buildRow(BuildContext context, T entry);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .mapIndexed(
            (index, value) => StripedTableRow(
              index: index,
              padding: padding,
              child: _buildFramedRow(context, value),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFramedRow(BuildContext context, T entry) {
    var response = buildRow(context, entry);
    if (onTap != null) {
      response = InkWell(onTap: () => onTap!(context, entry), child: response);
    }
    return response;
  }
}
