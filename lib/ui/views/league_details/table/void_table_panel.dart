import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildVoidTablePanel(int identifier, String text) {
  return buildExpansionPanelRadio(
    value: identifier,
    panelText: text,
    panelStyle: TextStyle(color: Colors.black45),
    body: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.content_paste_off, color: Colors.black45, size: 42),
        ],
      ),
    ),
  );
}
