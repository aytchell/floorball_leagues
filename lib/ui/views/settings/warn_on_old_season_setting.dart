import 'package:floorball/api/models/breaking_changes.dart';
import 'package:floorball/blocs/warn_on_old_season_cubit.dart';
import 'package:floorball/ui/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarnOnOldSeasonSetting extends StatelessWidget {
  const WarnOnOldSeasonSetting({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<WarnOnOldSeasonCubit, WarnOnOldSeasonState>(
        builder: (_, state) {
          return _buildTile(context, state.warn);
        },
      );

  Widget _buildTile(BuildContext context, bool vibrate) {
    return ListTile(
      title: const Text('Warnung für ältere Saisons'),
      subtitle: const Text(
        'Der Datenbestand für Saisons vor '
        '${BreakingChanges.yearsOfFirstNewSeasons} kann unvollständig oder '
        'fehlerhaft sein. Warnung anzeigen?',
      ),
      leading: Icon(FloorballIcons.warn, size: 20),
      trailing: Switch(
        value: vibrate,
        onChanged: (value) => BlocProvider.of<WarnOnOldSeasonCubit>(
          context,
        ).changeWarnOnOldSeason(value),
      ),
    );
  }
}
