import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:flutter/material.dart';

class LabeledValue {
  final String label;
  final String value;

  const LabeledValue({required this.label, required this.value});
}

class StripedLabeledValueTable extends StripedRowsList<LabeledValue> {
  const StripedLabeledValueTable(super.entries, {super.key});

  @override
  Widget buildRow(BuildContext context, LabeledValue entry) =>
      _LabeledValueRow(label: entry.label, value: entry.value);
}

class _LabeledValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label, style: TextStyles.genericLabeledValueLabel)),
      Text(value, style: TextStyles.genericLabeledValueValue),
    ],
  );
}
