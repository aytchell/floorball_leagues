import 'package:floorball/repositories/navigation_repository.dart';
import 'package:floorball/blocs/navigation_app_cubit.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/views/settings/navigation_app_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        side: BorderSide(color: FloorballColors.gray231, width: 1.5),
      ),
    ),
    onPressed: (onContextPressed != null)
        ? onContextPressed!(context)
        : onPressed,
    child: Icon(icon, size: 22, color: Colors.grey),
  );
}

List<Widget> maybeRenderNavigationArrow({
  String? address,
  String? locationName,
  Widget? prepend,
}) {
  if (address == null) {
    return [];
  }

  final List<Widget> result = (prepend != null) ? [prepend] : [];
  result.add(_NavigateButton(address: address, locationName: locationName));

  return result;
}

class _NavigateButton extends StatelessWidget {
  final String address;
  final String? locationName;

  const _NavigateButton({required this.address, this.locationName});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NavigationAppCubit, NavigationAppState>(
        builder: (_, state) {
          if (state.availableApps.isEmpty) {
            return SizedBox(width: 0);
          }
          if (state.selectedApp != null) {
            return IconTextButton(
              icon: Icons.keyboard_double_arrow_right,
              onPressed: () => RepositoryProvider.of<NavigationRepository>(
                context,
              ).openNavigation(state.selectedApp!, address, locationName),
            );
          }
          return IconTextButton(
            icon: Icons.keyboard_double_arrow_right,
            onPressed: () {
              final navCubit = BlocProvider.of<NavigationAppCubit>(context);
              final navRepo = RepositoryProvider.of<NavigationRepository>(
                context,
              );
              showNavigationAppPicker(context, null, state.availableApps).then((
                app,
              ) {
                navCubit.changeSelectedApp(app);
                if (app != null) {
                  navRepo.openNavigation(app, address, locationName);
                }
              });
            },
          );
        },
      );
}
