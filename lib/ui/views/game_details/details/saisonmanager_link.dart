import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final log = Logger('SaisonmanagerLink');

class LabeledSaisonmanagerButton extends LabeledValue {
  final Widget _button;

  LabeledSaisonmanagerButton(super.label, context, game, federationPath)
    : _button = _buildButton(_getSeason(context), game, federationPath);

  @override
  Widget getValue() => _button;

  static Widget _buildButton(
    SeasonInfo season,
    DetailedGame game,
    String federationPath,
  ) => IconTextButton(
    icon: Icons.exit_to_app,
    onPressed: () async {
      final uri = _buildSaisonmanagerLink(season, game, federationPath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    },
  );

  static SeasonInfo _getSeason(BuildContext context) =>
      BlocProvider.of<SelectedSeasonCubit>(context).state!;

  static Uri _buildSaisonmanagerLink(
    SeasonInfo season,
    DetailedGame game,
    String federationPath,
  ) {
    final fed = federationPath;
    game.federationShortName.toLowerCase();
    final nameComponent = _pathComponentFromLeagueName(game.leagueName);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    final path = '$fed/${game.leagueId}-$nameComponent/spiel/${game.gameId}';
    log.info("Opening $path");

    if (season.current) {
      return Uri.https('saisonmanager.de', path);
    } else {
      // this is even more awful :-D
      // For past seasons we have to adapt the host part
      // so we can access the archive
      final seasonHost = _buildHostnameFromSeason(season);
      return Uri.https('$seasonHost.saisonmanager.de', path);
    }
  }

  static final _regExRemoveStuff = RegExp('[/.()]');
  static final _regExMultiDash = RegExp('--*');
  static String _pathComponentFromLeagueName(String leagueName) => leagueName
      .toLowerCase()
      .replaceAll(' ', '-')
      .replaceAll(_regExRemoveStuff, '')
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll(_regExMultiDash, '-');

  static final _regExSeasonName = RegExp(r'^20(\d{2})/20(\d{2})$');
  static String _buildHostnameFromSeason(SeasonInfo season) {
    final match = _regExSeasonName.firstMatch(season.name);
    if (match != null && match.groupCount == 2) {
      log.info('Group count is ${match.groupCount}');
      return '${match.group(1)}${match.group(2)}.archiv';
    } else {
      return 'archiv';
    }
  }
}
