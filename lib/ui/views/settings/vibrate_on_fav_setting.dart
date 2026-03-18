import 'package:floorball/blocs/vibrate_on_fav_cubit.dart';
import 'package:floorball/ui/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VibrateOnFavSetting extends StatelessWidget {
  const VibrateOnFavSetting({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VibrateOnFavCubit, VibrateOnFavState>(
        builder: (_, state) {
          return _buildTile(context, state.vibrate);
        },
      );

  Widget _buildTile(BuildContext context, bool vibrate) {
    return ListTile(
      title: const Text('Haptisches Feedback'),
      subtitle: const Text('Vibriert beim Hinzufügen/Entfernen von Favoriten'),
      leading: Icon(FloorballIcons.vibrate, size: 20),
      trailing: Switch(
        value: vibrate,
        onChanged: (value) => BlocProvider.of<VibrateOnFavCubit>(
          context,
        ).changeVibrateOnFav(value),
      ),
    );
  }
}
