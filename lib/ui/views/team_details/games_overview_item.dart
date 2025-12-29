import 'package:floorball/api/models/game.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
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
      return InkWell(
        onTap: () => GameDetailsPageRoute(gameId: game.gameId).push(context),
        child: _PastGame(teamName: teamName, game: game),
      );
    } else {
      return _FutureGame(teamName: teamName, game: game);
    }
  }

  Widget foo(BuildContext context) {
    return InkWell(
      onTap: () => GameDetailsPageRoute(gameId: game.gameId).push(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zeit (Date & Time)
            Row(
              children: [
                const Icon(Icons.schedule, size: 22, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ort
            if (game.hostingClub != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on, size: 22, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${game.hostingClub}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),

            // Gegner
            if (game.hostingClub != null) ...[
              Row(
                children: [
                  // const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: _buildOpponentsName(game)),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Teams and Result
            Row(
              children: [
                // Home Team
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      TeamLogo(
                        uri: game.homeLogoSmallUri,
                        height: 25,
                        width: 25,
                      ),
                    ],
                  ),
                ),

                // VS divider and result
                _buildResult(game),

                // Guest Team
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TeamLogo(
                        uri: game.guestLogoSmallUri,
                        height: 25,
                        width: 25,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime() {
    final date = game.beautifiedDate!;
    final time = game.time ?? '';

    return '$date $time';
  }

  String _homeOrGuest(Game game) {
    return (teamName == game.homeTeamName) ? 'Heim' : 'Gast';
  }

  Widget _buildOpponentsName(Game game) {
    final raw = (teamName == game.homeTeamName)
        ? game.guestTeamName
        : game.homeTeamName;
    final opponentsName = raw ?? 'TBD';
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black, // Make sure to set the base color
        ),
        children: [
          TextSpan(text: '${_homeOrGuest(game)} gegen '),
          TextSpan(
            text: opponentsName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildResult(Game game) {
    if (game.result == null) {
      return Expanded(
        flex: 2,
        child: Column(
          children: [
            const Text(
              ':',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      final res = game.result!;
      final postfix = res.postfix?.short;
      return Expanded(
        flex: 2,
        child: Column(
          children: [
            Text(
              '${res.homeGoals} : ${res.guestGoals}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (postfix != null) ...[
              const SizedBox(height: 4),
              Text(
                postfix,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }
  }
}

class _PastGame extends StatelessWidget {
  final String teamName;
  final Game game;

  const _PastGame({required this.teamName, required this.game});

  @override
  Widget build(BuildContext context) {
    return Text("past game --- ${game.homeTeamName} vs ${game.guestTeamName}");
  }
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
    return Expanded(
      child: Column(
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
      ),
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
    if (game.beautifiedDate == null) {
      return Text('Datum noch unbekannt', style: _normal);
    }

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
          TextSpan(text: game.beautifiedDate, style: _bold),
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
