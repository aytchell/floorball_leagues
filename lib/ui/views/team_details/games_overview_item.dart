import 'package:floorball/api/models/game.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/game_result_texts.dart';
import 'package:floorball/ui/widgets/icon_text_button.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';

class GamesOverviewItem extends StatelessWidget {
  final String teamName;
  final Game game;

  const GamesOverviewItem({
    super.key,
    required this.teamName,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    if (game.ended) {
      return _PastGame(teamName: teamName, game: game);
    } else {
      return _FutureGame(teamName: teamName, game: game);
    }
  }
}

class _PastGame extends StatelessWidget {
  final String teamName;
  final Game game;

  const _PastGame({required this.teamName, required this.game});

  static const _iconSpacer = SizedBox(width: 8);
  static const _normal = TextStyles.teamDetailsPastGames;
  static const _bold = TextStyles.teamDetailsPastGamesBold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderDateTime(),
        const SizedBox(height: 8),
        _renderOpponent(),
        const SizedBox(height: 16),
        _renderLogosAndResult(),
      ],
    );
  }

  Widget _renderDateTime() => Row(
    children: [
      const Icon(Icons.schedule, size: 22, color: Colors.grey),
      _iconSpacer,
      _printDateTime(),
      SizedBox(width: 12),
      IconTextButton(
        icon: Icons.read_more,
        onContextPressed: (BuildContext ctxt) {
          return () => GameDetailsPageRoute(gameId: game.gameId).push(ctxt);
        },
      ),
    ],
  );

  Widget _printDateTime() => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: 'Am ', style: _normal),
        TextSpan(text: game.dateTime.beautifiedDate, style: _bold),
        TextSpan(text: ' um ', style: _normal),
        TextSpan(text: '${game.time}', style: _bold),
        TextSpan(text: ' Uhr', style: _normal),
      ],
    ),
  );

  Widget _renderOpponent() => Row(
    children: [
      const Icon(Icons.compare_arrows, size: 22, color: Colors.grey),
      _iconSpacer,
      Text(_opponentName() ?? '???', style: TextStyles.teamDetailsPastOpponent),
    ],
  );

  String? _opponentName() {
    if (teamName == game.guestTeamName) {
      return game.homeTeamName;
    } else {
      return game.guestTeamName;
    }
  }

  Widget _renderLogosAndResult() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TeamLogo(uri: game.homeLogoUri, height: 50, width: 50),
      SizedBox(width: 20),
      Column(children: buildResultTexts(game)),
      SizedBox(width: 20),
      TeamLogo(uri: game.guestLogoUri, height: 50, width: 50),
    ],
  );
}

class _FutureGame extends StatelessWidget {
  final String teamName;
  final Game game;

  static const _iconSpacer = SizedBox(width: 8);
  static const _normal = TextStyles.teamDetailsFutureGames;
  static const _bold = TextStyles.teamDetailsFutureGamesBold;
  static const _gray = TextStyles.teamDetailsFutureGamesGray;

  const _FutureGame({required this.teamName, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderOpponentLogo(),
        const SizedBox(height: 12),
        _renderDateTime(),
        const SizedBox(height: 8),
        _renderHostingTeam(),
        const SizedBox(height: 8),
        _renderOpponent(),
      ],
    );
  }

  Widget _renderDateTime() => Row(
    children: [
      const Icon(Icons.schedule, size: 22, color: Colors.grey),
      _iconSpacer,
      _printDateTime(),
      SizedBox(width: 12),
      IconTextButton(
        icon: Icons.read_more,
        onContextPressed: (BuildContext ctxt) {
          return () => GameDetailsPageRoute(gameId: game.gameId).push(ctxt);
        },
      ),
    ],
  );

  Widget _printDateTime() {
    final time = (game.time == null)
        ? [TextSpan(text: ' (Zeit noch unbekannt)', style: _normal)]
        : [
            TextSpan(text: ' um ', style: _normal),
            TextSpan(text: '${game.time}', style: _bold),
            TextSpan(text: ' Uhr', style: _normal),
          ];
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Am ', style: _normal),
          TextSpan(text: game.dateTime.beautifiedDate, style: _bold),
          ...time,
        ],
      ),
    );
  }

  Widget _renderHostingTeam() => Row(
    children: [
      const Icon(Icons.location_on, size: 22, color: Colors.grey),
      _iconSpacer,
      Text(_printHostingClub(), style: _gray),
      ...maybeRenderNavigationArrow(
        address: game.arenaAddress,
        locationName: game.arenaName,
        prepend: SizedBox(width: 12),
      ),
    ],
  );

  String _printHostingClub() {
    if (game.hostingClub == null) {
      return 'Veranstalter noch unbekannt';
    }
    return 'Bei ${game.hostingClub}';
  }

  Widget _renderOpponent() {
    if (teamName == game.homeTeamName) {
      return _fillOpponentTemplate(Icons.home, [
        const TextSpan(text: 'Heim gegen\n', style: _normal),
        TextSpan(text: '${game.guestTeamName}', style: _bold),
      ]);
    } else {
      return _fillOpponentTemplate(Icons.train, [
        const TextSpan(text: 'Gast gegen\n', style: _normal),
        TextSpan(text: '${game.homeTeamName}', style: _bold),
      ]);
    }
  }

  Widget _fillOpponentTemplate(IconData icon, List<TextSpan> texts) => Row(
    children: [
      Icon(icon, size: 22, color: Colors.grey),
      _iconSpacer,
      Text.rich(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        TextSpan(children: texts),
      ),
    ],
  );

  Widget _renderOpponentLogo() => TeamLogo(
    uri: (teamName == game.homeTeamName) ? game.guestLogoUri : game.homeLogoUri,
    height: 50,
    width: 50,
  );
}
