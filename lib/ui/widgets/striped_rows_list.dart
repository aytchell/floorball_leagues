import 'package:floorball/ui/widgets/striped_table_row.dart';
import 'package:flutter/material.dart';

abstract class StripedRowsList<T> extends StatelessWidget {
  final List<T> entries;
  final EdgeInsetsGeometry? padding;
  final void Function(BuildContext context, T entry)? onTap;

  const StripedRowsList(
    this.entries, {
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.onTap,
  });

  Widget buildRow(BuildContext context, T entry);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .asMap()
          .entries
          .map(
            (entry) => StripedTableRow(
              index: entry.key,
              child: _buildFramedRow(context, entry.value),
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
    if (padding != null) {
      response = Padding(padding: padding!, child: response);
    }
    return response;
  }
}
