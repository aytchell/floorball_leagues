import 'package:collection/collection.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/league_details/game_day/single_game_day_content.dart';
import 'package:floorball/ui/widgets/left_labeled_content.dart';
import 'package:flutter/material.dart';

const String seriesIdentifier = 'series';

class SingleChampGameDayContent extends SingleGameDayContent {
  const SingleChampGameDayContent({
    super.key,
    required super.leagueId,
    required super.gameDayNumber,
  });

  @override
  Widget buildGameDays(List<Game> games) {
    final groups =
        groupBy(games, (game) => game.groupIdentifier ?? seriesIdentifier)
            .map(
              (key, value) =>
                  MapEntry(key, GameGroup(groupIdentifier: key, games: value)),
            )
            .values
            .toList()
            .sorted();
    return Column(
      children: groups.map((group) => _buildGameGroup(group)).toList(),
    );
  }

  Widget _buildGameGroup(GameGroup group) {
    if (group.groupIdentifier == seriesIdentifier) {
      return StripedGamesRowsList(group.games);
    }
    return LabeledStripedGamesRowsList(
      labelText: _translateGroupIdentifier(group.groupIdentifier),
      games: group.games,
    );
  }

  String _translateGroupIdentifier(String groupIdentifier) {
    RegExp validGroups = RegExp(r'^group_[a-z]$');

    if (!validGroups.hasMatch(groupIdentifier)) return groupIdentifier;

    var groupId = groupIdentifier.substring(groupIdentifier.length - 1);

    return 'Gruppe ${groupId.toUpperCase()}';
  }
}

class GameGroup implements Comparable<GameGroup> {
  final String groupIdentifier;
  final List<Game> games;

  GameGroup({required this.groupIdentifier, required this.games});

  @override
  int compareTo(GameGroup other) {
    return groupIdentifier.compareTo(other.groupIdentifier);
  }
}

class LabeledStripedGamesRowsList extends LeftLabeledContent {
  final List<Game> games;

  const LabeledStripedGamesRowsList({
    super.key,
    required super.labelText,
    required this.games,
  }) : super(labelHeight: games.length * StripedGamesRowsList.heightPerRow);

  @override
  Widget buildContent() {
    return StripedGamesRowsList(games);
  }
}
