import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final log = Logger('SaisonmanagerLink');

class LabeledSaisonmanagerButton extends LabeledValue {
  final Widget _button;

  LabeledSaisonmanagerButton(super.label, game, federationPath)
    : _button = _buildButton(game, federationPath);

  @override
  Widget getValue() => _button;

  static Widget _buildButton(DetailedGame game, String federationPath) =>
      IconTextButton(
        icon: Icons.exit_to_app,
        onPressed: () async {
          final uri = _buildSaisonmanagerLink(game, federationPath);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      );

  static Uri _buildSaisonmanagerLink(DetailedGame game, String federationPath) {
    final fed = federationPath;
    game.federationShortName.toLowerCase();
    final nameComponent = _pathComponentFromLeagueName(game.leagueName);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    final path = '$fed/${game.leagueId}-$nameComponent/spiel/${game.gameId}';
    log.info("Opening $path");

    return Uri.https('saisonmanager.de', path);
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
}
