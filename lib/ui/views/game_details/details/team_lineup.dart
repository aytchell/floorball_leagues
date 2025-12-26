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
  String get jerseyNumber => '${player.jerseyNumber}';

  @override
  String get playerName => player.name;

  @override
  String? get position => player.position;

  @override
  List<Object?> get props => [player.playerId];

  @override
  int compareTo(PlayerAdapter other) {
    return player.jerseyNumber.compareTo(other.player.jerseyNumber);
  }

  @override
  bool? get captain => player.captain;
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
        _buildListForTeam(game.homeTeamName, game.players.home),

        const SizedBox(height: 24),

        // Guest team table
        _buildListForTeam(game.guestTeamName, game.players.guest),
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
