import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';

const _bottomSheetTitle = Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Favoriten-Icon auswählen',
    style: TextStyles.navBottomSheetTitle,
  ),
);

Future<PinVariant?> showPinVariantPicker(
  BuildContext context,
  PinVariant? selected,
  List<PinVariant> available,
) {
  return showModalBottomSheet<PinVariant>(
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _bottomSheetTitle,
          const Divider(height: 1),
          _bottomSheetSelector(context, selected, available),
        ],
      );
    },
  );
}

Widget _bottomSheetSelector(
  BuildContext context,
  PinVariant? selected,
  List<PinVariant> available,
) => Flexible(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: available.length,
    itemBuilder: (context, index) {
      final variant = available[index];
      final isSelected = variant == selected;
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(variant.name),
            Row(children: [variant.unpinned, Text(' / '), variant.pinned]),
          ],
        ),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.blue)
            // align the 'title' of each row by adding an invisible checkmark
            : const Icon(Icons.check, color: Colors.white),
        selected: isSelected,
        onTap: () => Navigator.of(context).pop(variant),
      );
    },
  ),
);
