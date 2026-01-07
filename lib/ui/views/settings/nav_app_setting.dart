import 'package:floorball/api/navigation_repository.dart';
import 'package:floorball/blocs/navigation_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_app_picker.dart';

class NavAppSetting extends StatelessWidget {
  const NavAppSetting({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NavigationAppCubit, NavigationAppState>(
        builder: (_, state) =>
            _buildTile(context, state.selectedApp, state.availableApps),
      );

  Widget _buildTile(
    BuildContext context,
    NavigationApp? selected,
    List<NavigationApp> available,
  ) {
    return ListTile(
      title: const Text('Navigations-App'),
      subtitle: selected != null
          ? Text(selected.name)
          : const Text('Keine App ausgewählt'),
      leading: (selected == null) ? null : selected.svg(32),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        final cubit = BlocProvider.of<NavigationAppCubit>(context);
        showNavigationAppPicker(
          context,
          selected,
          available,
        ).then((app) => cubit.changeSelectedApp(app));
      },
    );
  }
}
