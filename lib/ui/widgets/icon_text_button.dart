import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

// Sometimes we need the BuildContext inside the onPressed callback but
// TextButton doesn't provide it. By using this higher level function
// one can use the BuildContext of the IconTextButton inside the onPressed
// callback.
typedef OnPressedFactory = void Function() Function(BuildContext);

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final OnPressedFactory? onContextPressed;

  const IconTextButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onContextPressed,
  });

  @override
  Widget build(BuildContext context) => TextButton(
    style: TextButton.styleFrom(
      minimumSize: const Size(8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: FloorballColors.gray153, width: 1.5),
      ),
    ),
    onPressed: (onContextPressed != null)
        ? onContextPressed!(context)
        : onPressed,
    child: Icon(icon, size: 22, color: Colors.grey),
  );
}

List<Widget> maybeRenderNavigationArrow(String? arenaAddress, Widget? prepend) {
  if (arenaAddress == null) {
    return [];
  }

  final List<Widget> result = (prepend != null) ? [prepend] : [];
  result.add(
    IconTextButton(
      icon: Icons.keyboard_double_arrow_right,
      onPressed: () => openNavigation(arenaAddress),
    ),
  );

  return result;
}
