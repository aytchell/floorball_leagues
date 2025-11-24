import 'package:floorball/ui/widgets/panel_title.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildVoidTablePanel(int identifier, String text) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) =>
        PanelTitle(text: text, color: Colors.black45, bold: false),
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
