import 'package:floorball/api/models/breaking_changes.dart';
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
  String buildNewStylePath() {
    final fed = federationPath;
    final nameComponent = _pathComponentFromLeagueName(game.leagueName);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    return '$fed/${game.leagueId}-$nameComponent/spiel/${game.gameId}';
  }

  @override
  Map<String, String> buildPhpStyleParameters() => {
    'seite': 'game',
    'game': '${game.gameId}',
  };
}

class _LeagueButton extends _SaisonmanagerButton {
  final League league;

  const _LeagueButton({
    required super.season,
    required this.league,
    required super.federationPath,
  });

  @override
  String buildNewStylePath() {
    final fed = federationPath;
    final nameComponent = _pathComponentFromLeagueName(league.name);

    // this is very awful. The path to the game is not delivered via the API;
    // instead we have to compute it ourselves from several identifiers
    return '$fed/${league.id}-$nameComponent';
  }

  @override
  Map<String, String> buildPhpStyleParameters() => {
    'seite': 'spielplan',
    'table': '${league.id}',
  };
}

abstract class _SaisonmanagerButton extends StatelessWidget {
  final SeasonInfo season;
  final String federationPath;

  const _SaisonmanagerButton({
    required this.season,
    required this.federationPath,
  });

  String buildNewStylePath();

  Map<String, String> buildPhpStyleParameters();

  @override
  Widget build(BuildContext context) => IconTextButton(
    icon: Icons.exit_to_app,
    onPressed: () async {
      final uri = _buildSaisonmanagerLink(season, federationPath);
      log.info('Computed Saisonmanager URL is ${uri.toString()}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    },
  );

  Uri _buildSaisonmanagerLink(SeasonInfo season, String federationPath) {
    if (season.id > BreakingChanges.lastPhpSeasonId) {
      return _buildNewStyleGameLink(season, federationPath);
    } else {
      return _buildPhpStyleGameLink(season, federationPath);
    }
  }

  Uri _buildNewStyleGameLink(SeasonInfo season, String federationPath) {
    final path = buildNewStylePath();

    if (season.current) {
      return Uri.https('saisonmanager.de', path);
    } else {
      // For past seasons we have to adapt the host part
      // so we can access the archive
      final seasonHost = _buildHostnameFromSeason(season);
      return Uri.https(seasonHost, path);
    }
  }

  Uri _buildPhpStyleGameLink(SeasonInfo season, String federationPath) {
    final hostSuffix = _buildHostnameFromSeason(season);
    final host = '$federationPath-$hostSuffix';

    final path = 'index.php';
    final parameters = buildPhpStyleParameters();
    return Uri.https(host, path, parameters);
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

final _regExSeasonName = RegExp(r'^20(\d{2})/20(\d{2})$');
String _buildHostnameFromSeason(SeasonInfo season) {
  final match = _regExSeasonName.firstMatch(season.name);
  if (match != null && match.groupCount == 2) {
    log.info('Group count is ${match.groupCount}');
    return '${match.group(1)}${match.group(2)}.archiv.saisonmanager.de';
  } else {
    // This shouldn't happen ... at least send the user to the archive
    return 'archiv.saisonmanager.de';
  }
}
