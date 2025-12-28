import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:flutter/material.dart';

class LabeledValue {
  final String label;
  final String value;

  const LabeledValue(this.label, this.value);
}

class StripedLabeledValueTable extends StripedRowsList<LabeledValue> {
  const StripedLabeledValueTable(super.entries, {super.key})
    : super(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8));

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
      Text(
        label,
        style: TextStyles.genericLabeledValueLabel,
        textAlign: TextAlign.left,
      ),
      SizedBox(width: 16),
      Expanded(
        child: Text(
          value,
          style: TextStyles.genericLabeledValueValue,
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
