import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildVoidTablePanel(int identifier, String text) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: text,
    panelStyle: const TextStyle(color: FloorballColors.gray153),
    body: const ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste_off,
            color: FloorballColors.gray153,
            size: 42,
          ),
        ],
      ),
    ),
  );
}
