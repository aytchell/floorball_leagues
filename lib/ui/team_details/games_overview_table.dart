import 'package:flutter/material.dart';
import '../../api/models/league_table_row.dart';
import '../../api/models/game.dart';
import '../widgets/team_logo.dart';

class GamesOverviewTable extends StatelessWidget {
  final LeagueTableRow team;
  final List<Game> games;

  GamesOverviewTable({required this.team, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Keine Spiele verfügbar',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Insgesamt: ${games.length}',
              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final game = games[index];
              return _GameListItem(teamName: team.teamName, game: game);
            },
          ),
        ],
      ),
    );
  }
}

class _GameListItem extends StatelessWidget {
  final String teamName;
  final Game game;

  const _GameListItem({required this.teamName, required this.game});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                '${_formatDateTime()}',
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
                    TeamLogo(uri: game.homeLogoSmallUri, height: 25, width: 25),
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

  String _formatDateTime() {
    final date = game.beautifiedDate!;
    if (date == null) {
      return 'TBD';
    }

    final time = game.time ?? '';

    return '${date} ${time}';
  }
}
