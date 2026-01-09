import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';

Future<V?> showSettingsPicker<V extends Object>(
  BuildContext context,
  String title,
  V? selected,
  List<V> available, {
  Widget Function(V item)? trailingBuilder,
  required Widget Function(V item) titleBuilder,
}) {
  return showModalBottomSheet<V>(
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _bottomSheetTitle(title),
          const Divider(height: 1),
          _bottomSheetSelector<V>(
            context,
            selected,
            available,
            trailingBuilder,
            titleBuilder,
          ),
        ],
      );
    },
  );
}

Widget _bottomSheetTitle(String text) => Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text(text, style: TextStyles.navBottomSheetTitle),
);

Widget _bottomSheetSelector<V extends Object>(
  BuildContext context,
  V? selected,
  List<V> available,
  Widget Function(V item)? trailingBuilder,
  Widget Function(V item) titleBuilder,
) => Flexible(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: available.length,
    itemBuilder: (context, index) {
      final item = available[index];
      final isSelected = item == selected;
      return ListTile(
        leading: trailingBuilder?.call(item),
        title: titleBuilder(item),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.blue)
            // align the 'title' of each row by adding an invisible checkmark
            : const Icon(Icons.check, color: Colors.white),
        selected: isSelected,
        onTap: () => Navigator.of(context).pop(item),
      );
    },
  ),
);
