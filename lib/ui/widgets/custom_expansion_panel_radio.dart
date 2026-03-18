import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/panel_title.dart';
import 'package:flutter/material.dart';

ExpansionPanelRadio buildExpansionPanelRadio({
  required int value,
  required String panelText,
  TextStyle panelStyle = TextStyles.genericPanelTitle,
  required Widget body,
}) => buildExpansionHeaderPanelRadio(
  value: value,
  header: PanelTitle(text: panelText, style: panelStyle),
  body: body,
);

ExpansionPanelRadio buildExpansionHeaderPanelRadio({
  required int value,
  required Widget header,
  required Widget body,
}) => buildExpansionHeaderBuilderPanelRadio(
  value: value,
  headerBuilder: (BuildContext context, bool isExpanded) => header,
  body: body,
);

ExpansionPanelRadio buildExpansionHeaderBuilderPanelRadio({
  required int value,
  required Widget Function(BuildContext, bool) headerBuilder,
  required Widget body,
}) => ExpansionPanelRadio(
  value: value,
  canTapOnHeader: true,
  headerBuilder: headerBuilder,
  body: body,
  backgroundColor: FloorballColors.gray250,
  splashColor: FloorballColors.gray231,
  highlightColor: FloorballColors.gray231,
);
