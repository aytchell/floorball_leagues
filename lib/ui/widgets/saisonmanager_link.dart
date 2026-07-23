import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:floorball/ui/widgets/striped_key_value_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final log = Logger('SaisonmanagerLink');

class LabeledSaisonmanagerGameButton extends LabeledValue {
  final Widget _button;

  LabeledSaisonmanagerGameButton(super.label, context, game, federationPath)
    : _button = _GameButton(
        season: _getSeason(context),
        game: game,
        federationPath: federationPath,
      );

  @override
  Widget getValue() => _button;

  static SeasonInfo _getSeason(BuildContext context) =>
      BlocProvider.of<SelectedSeasonCubit>(context).state!;
}

class LabeledSaisonmanagerLeagueButton extends LabeledValue {
  final Widget _button;

  LabeledSaisonmanagerLeagueButton(super.label, context, league, federationPath)
    : _button = _LeagueButton(
        season: _getSeason(context),
        league: league,
        federationPath: federationPath,
      );

  @override
  Widget getValue() => _button;

  static SeasonInfo _getSeason(BuildContext context) =>
      BlocProvider.of<SelectedSeasonCubit>(context).state!;
}

class _GameButton extends _SaisonmanagerButton {
  final DetailedGame game;

  const _GameButton({
    required super.season,
    required this.game,
    required super.federationPath,
  });

  @override
  String buildSaisonmanagerPath() {
    final fed = federationPath;
    final nameComponent = _pathComponentFromLeagueName(game.leagueName);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    return '$fed/${game.leagueId}-$nameComponent/spiel/${game.gameId}';
  }
}

class _LeagueButton extends _SaisonmanagerButton {
  final League league;

  const _LeagueButton({
    required super.season,
    required this.league,
    required super.federationPath,
  });

  @override
  String buildSaisonmanagerPath() {
    final fed = federationPath;
    final nameComponent = _pathComponentFromLeagueName(league.name);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    return '$fed/${league.id}-$nameComponent';
  }
}

abstract class _SaisonmanagerButton extends StatelessWidget {
  final SeasonInfo season;
  final String federationPath;

  const _SaisonmanagerButton({
    required this.season,
    required this.federationPath,
  });

  String buildSaisonmanagerPath();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: IconTextButton(
      icon: Icons.exit_to_app,
      minimumWidth: 80,
      onPressed: () async {
        final uri = _buildSaisonmanagerLink(season, federationPath);
        log.info('Computed Saisonmanager URL is ${uri.toString()}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    ),
  );

  Uri _buildSaisonmanagerLink(SeasonInfo season, String federationPath) {
    final path = buildSaisonmanagerPath();
    return Uri.https('saisonmanager.de', path);
  }
}

final _regExRemoveStuff = RegExp('[/.()]');
final _regExMultiDash = RegExp('--*');
String _pathComponentFromLeagueName(String leagueName) => leagueName
    .toLowerCase()
    .replaceAll(' ', '-')
    .replaceAll(_regExRemoveStuff, '')
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .replaceAll(_regExMultiDash, '-');
