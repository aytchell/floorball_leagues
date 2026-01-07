import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';

const _bottomSheetTitle = Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Navigations-App auswählen',
    style: TextStyles.navBottomSheetTitle,
  ),
);

Future<AvailableMap?> showNavigationAppPicker(
  BuildContext context,
  AvailableMap? selected,
  List<AvailableMap> available,
) {
  return showModalBottomSheet<AvailableMap>(
    context: context,
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
  AvailableMap? selected,
  List<AvailableMap> available,
) => Flexible(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: available.length,
    itemBuilder: (context, index) {
      final app = available[index];
      final isSelected = app.mapType == selected?.mapType;
      return ListTile(
        leading: SvgPicture.asset(app.icon, width: 32, height: 32),
        title: Text(app.mapName),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.blue)
            : null,
        selected: isSelected,
        onTap: () {
          Navigator.of(context).pop(app);
        },
      );
    },
  ),
);
