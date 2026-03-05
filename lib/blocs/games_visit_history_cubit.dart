import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';

class VisitedGame {
  final int gameId;
  final GameLeagueInfo gameLeagueInfo;
  final String leagueName;
  final DetailedGame detailedGame;

  VisitedGame({
    required this.gameId,
    required this.gameLeagueInfo,
    required this.leagueName,
    required this.detailedGame,
  });
}

class GamesVisitHistory {
  GamesVisitHistory(this.visitedGames);

  final List<VisitedGame> visitedGames;
}

class GamesVisitHistoryCubit extends Cubit<GamesVisitHistory> {
  GamesVisitHistoryCubit() : super(GamesVisitHistory([]));

  static final maxGames = 5;

  void addVisitedGame(VisitedGame visitedGame) =>
      emit(_updateHistory(state, visitedGame));

  GamesVisitHistory _updateHistory(
    GamesVisitHistory state,
    VisitedGame visitedGame,
  ) {
    if (state.visitedGames.isNotEmpty &&
        state.visitedGames.first.gameId == visitedGame.gameId) {
      return state;
    }

    final newList = state.visitedGames
        .where((game) => game.gameId != visitedGame.gameId)
        .toList();
    newList.insert(0, visitedGame);

    if (state.visitedGames.length > maxGames) {
      newList.removeLast();
    }
    return GamesVisitHistory(newList);
  }
}
