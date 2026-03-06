import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';
import 'package:floorball/ui/views/league_details/game_day/extract_dates_and_clubs.dart';
import 'package:floorball/ui/views/league_details/game_day/single_game_day_content.dart';
import 'package:floorball/ui/widgets/left_labeled_content.dart';
import 'package:floorball/ui/widgets/striped_games_row_list.dart';
import 'package:flutter/material.dart';

class SingleDefaultGameDayContent extends SingleGameDayContent {
  final GameLeagueInfo gameLeagueInfo;

  const SingleDefaultGameDayContent({
    super.key,
    required this.gameLeagueInfo,
    required super.leagueId,
    required super.gameDayNumber,
  });

  @override
  Widget buildGameDays(List<Game> games) {
    final dacs = extractDatesAndClubs(games);
    if (dacs.length == 2) {
      return Column(
        children: [
          _labeledGamesOf(dacs[0], games),
          _labeledGamesOf(dacs[1], games),
        ],
      );
    } else {
      return StripedGamesRowsList(games, gameLeagueInfo);
    }
  }

  Widget _labeledGamesOf(DateAndClub dac, List<Game> allGames) {
    // I don't know why this is required but things look better with this
    // extra tad (regardless of the number of rows). Really no clue.
    final extraHeight = 2;

    final games = allGames
        .where((game) => game.hostingClub == dac.hostingClub)
        .toList();

    return _LabeledContent(
      labelText: dac.hostingClub,
      labelHeight:
          StripedGamesRowsList.heightPerRow * games.length + extraHeight,
      games: games,
      gameLeagueInfo: gameLeagueInfo,
    );
  }
}

class _LabeledContent extends LeftLabeledContent {
  final List<Game> games;
  final GameLeagueInfo gameLeagueInfo;

  const _LabeledContent({
    required super.labelText,
    required super.labelHeight,
    required this.games,
    required this.gameLeagueInfo,
  });

  @override
  Widget buildContent() => StripedGamesRowsList(games, gameLeagueInfo);
}
