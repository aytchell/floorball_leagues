import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:flutter/material.dart';

abstract class LabeledValue {
  final String label;
  final void Function()? onTap;

  const LabeledValue(this.label, {this.onTap});

  Widget getValue();
}

class LabeledString extends LabeledValue {
  final String value;

  const LabeledString(super.label, this.value, {super.onTap});

  @override
  Widget getValue() => Text(
    value,
    style: TextStyles.genericLabeledValueValue,
    textAlign: TextAlign.right,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}

class StripedLabeledValueTable extends StripedRowsList<LabeledValue> {
  const StripedLabeledValueTable(super.entries, {super.key})
    : super(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8));

  @override
  Widget buildRow(BuildContext context, LabeledValue entry) =>
      _LabeledValueRow(entry);
}

class _LabeledValueRow extends StatelessWidget {
  final LabeledValue entry;

  const _LabeledValueRow(this.entry);

  @override
  Widget build(BuildContext context) {
    if (entry.onTap == null) {
      return Row(children: _keyValueEntries());
    } else {
      return InkWell(
        onTap: entry.onTap,
        child: Row(
          children: [
            ..._keyValueEntries(),
            SizedBox(width: 8),
            Icon(Icons.info_outline, size: 20),
          ],
        ),
      );
    }
  }

  List<Widget> _keyValueEntries() => [
    Text(
      entry.label,
      style: TextStyles.genericLabeledValueLabel,
      textAlign: TextAlign.left,
    ),
    const SizedBox(width: 16),
    Expanded(child: entry.getValue()),
  ];
}
