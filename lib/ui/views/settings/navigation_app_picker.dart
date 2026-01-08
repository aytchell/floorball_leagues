import 'package:floorball/repositories/navigation_app.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';

const _bottomSheetTitle = Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Navigations-App auswählen',
    style: TextStyles.navBottomSheetTitle,
  ),
);

Future<NavigationApp?> showNavigationAppPicker(
  BuildContext context,
  NavigationApp? selected,
  List<NavigationApp> available,
) {
  return showModalBottomSheet<NavigationApp>(
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
  NavigationApp? selected,
  List<NavigationApp> available,
) => Flexible(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: available.length,
    itemBuilder: (context, index) {
      final app = available[index];
      final isSelected = app == selected;
      return ListTile(
        leading: app.svg(32),
        title: Text(app.name),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.blue)
            : null,
        selected: isSelected,
        onTap: () => Navigator.of(context).pop(app),
      );
    },
  ),
);
