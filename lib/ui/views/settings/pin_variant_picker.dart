import 'package:floorball/ui/views/settings/show_settings_picker.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';

Future<PinVariant?> showPinVariantPicker(
  BuildContext context,
  PinVariant? selected,
  List<PinVariant> available,
) => showSettingsPicker(
  context,
  'Favoriten-Icon auswählen',
  selected,
  available,
  titleBuilder: (item) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(item.name),
      Row(children: [item.unpinned, Text(' / '), item.pinned]),
    ],
  ),
);
