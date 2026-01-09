import 'package:floorball/repositories/navigation_app.dart';
import 'package:floorball/ui/views/settings/show_settings_picker.dart';
import 'package:flutter/material.dart';

Future<NavigationApp?> showNavigationAppPicker(
  BuildContext context,
  NavigationApp? selected,
  List<NavigationApp> available,
) => showSettingsPicker(
  context,
  'Navigations-App auswählen',
  selected,
  available,
  trailingBuilder: (item) => item.svg(32),
  titleBuilder: (item) => Text(item.name),
);
