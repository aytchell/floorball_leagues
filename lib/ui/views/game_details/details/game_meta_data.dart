import 'package:floorball/api/models/date_formatter.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/details/ref_details_snackbar.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final log = Logger('GameMetaData');

class GameMetaData extends StatelessWidget {
  final DetailedGame game;

  const GameMetaData({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final entries = [
      LabeledString('Liga', game.leagueName),
      LabeledString('Spielnummer', game.gameNumber),
      LabeledString('Datum', beautifyNullableDate(game.date) ?? game.date),
      LabeledString('Spielbeginn', _printStartTime(game)),
      LabeledString('Austragungshalle', game.arenaName),
      LabeledString('Austragungsort', game.arenaAddress),
      LabeledString('Zuschauerzahl', game.audience?.toString() ?? '-'),
      LabeledString(
        'Schiedsrichter',
        _printReferees(game),
        onTap: (game.referees.isEmpty)
            ? null
            : showRefereeLicenseDetails(context, game),
      ),
      _LabeledSaisonmanagerButton('Saisonmanager', game),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text('Spielinfo', style: TextStyles.gameDetailsSection),
        ),
        StripedLabeledValueTable(entries),
      ],
    );
  }

  String _printStartTime(DetailedGame game) =>
      game.actualStartTime ?? game.startTime ?? '-';

  String _printReferees(DetailedGame game) {
    if (game.referees.isNotEmpty) {
      return game.referees
          .map((ref) => '${ref.firstName} ${ref.lastName}')
          .join('\n');
    } else {
      return game.nominatedReferees ?? '-';
    }
  }
}

class _LabeledSaisonmanagerButton extends LabeledValue {
  final DetailedGame game;
  final Widget _button;

  _LabeledSaisonmanagerButton(super.label, this.game)
    : _button = _buildButton(game);

  @override
  Widget getValue() => _button;

  static Widget _buildButton(DetailedGame game) => IconTextButton(
    icon: Icons.exit_to_app,
    onPressed: () async {
      final uri = _buildSaisonmanagerLink(game);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    },
  );

  static Uri _buildSaisonmanagerLink(DetailedGame game) {
    final fed = game.federationShortName.toLowerCase();
    final nameComponent = _pathComponentFromLeagueName(game.leagueName);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    final path = '$fed/${game.leagueId}-$nameComponent/spiel/${game.gameId}';

    return Uri.https('saisonmanager.de', path);
  }

  static final _regExSlashDot = RegExp('[/.]');
  static final _regExMultiDash = RegExp('--*');
  static String _pathComponentFromLeagueName(String leagueName) => leagueName
      .toLowerCase()
      .replaceAll(' ', '-')
      .replaceAll(_regExSlashDot, '')
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll(_regExMultiDash, '-');
}
