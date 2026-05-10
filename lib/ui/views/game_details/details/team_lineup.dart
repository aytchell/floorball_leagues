import 'package:equatable/equatable.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/player.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/views/game_details/details/player_table.dart';

class PlayerAdapter extends Equatable
    implements TableContentProvider, Comparable<PlayerAdapter> {
  final Player player;

  const PlayerAdapter({required this.player});

  @override
  String get jerseyNumber {
    if (player.jerseyNumber != null) {
      return '${player.jerseyNumber}';
    } else {
      // in older seasons there are players without a jersey number
      return '??';
    }
  }

  @override
  String get playerName => player.name;

  @override
  String? get position => player.position;

  @override
  bool? get goaly => player.position == 'Tor';

  @override
  bool? get captain => player.captain;

  @override
  List<Object?> get props => [player.playerId];

  @override
  int compareTo(PlayerAdapter other) {
    if (player.jerseyNumber != null && other.player.jerseyNumber != null) {
      return player.jerseyNumber!.compareTo(other.player.jerseyNumber!);
    }
    if (player.jerseyNumber != null && other.player.jerseyNumber == null) {
      return 1;
    }
    if (player.jerseyNumber == null && other.player.jerseyNumber != null) {
      return -1;
    }
    // both are null
    return 0;
  }
}

class TeamLineup extends StatelessWidget {
  final DetailedGame game;

  const TeamLineup({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aufstellung', style: TextStyles.gameDetailsSection),
        const SizedBox(height: 16),

        // Home team table
        _buildListForTeam(
          game.homeTeamName ?? 'Teamname unbekannt',
          game.players.home,
        ),

        const SizedBox(height: 24),

        // Guest team table
        _buildListForTeam(
          game.guestTeamName ?? 'Teamname unbekannt',
          game.players.guest,
        ),
      ],
    );
  }

  Widget _buildListForTeam(final String teamName, final List<Player> players) {
    final playersList = players.map((p) => PlayerAdapter(player: p)).toList();
    playersList.sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team name header
        Text(teamName, style: TextStyles.gameDetailsSubSection),
        const SizedBox(height: 8),

        PlayerTable(providers: playersList),
      ],
    );
  }
}
