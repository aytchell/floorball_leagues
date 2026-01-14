import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/views/league_details/game_day/single_game_day_content.dart';
import 'package:flutter/material.dart';

class SingleDefaultGameDayContent extends SingleGameDayContent {
  final LeagueType leagueType;

  const SingleDefaultGameDayContent({
    super.key,
    required this.leagueType,
    required super.leagueId,
    required super.gameDayNumber,
  });

  @override
  Widget buildGameDays(List<Game> games) =>
      StripedGamesRowsList(games, leagueType);
}
