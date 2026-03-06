import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:logging/logging.dart';

final log = Logger('VisitHistory');

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
  GamesVisitHistoryCubit(ApiRepository repository)
    : _repository = repository,
      super(GamesVisitHistory([]));

  final ApiRepository _repository;

  static final maxGames = 5;

  void addVisitedGame(VisitedGame visitedGame) =>
      emit(_updateHistory(state, visitedGame));

  Future<void> checkForUpdates() async {
    DateTime now = DateTime.now();
    final gameFutures = state.visitedGames.map(
      (game) => _updateIfRunning(game, now),
    );
    List<VisitedGame> games = await Future.wait(gameFutures);
    emit(GamesVisitHistory(games));
  }

  Future<VisitedGame> _updateIfRunning(VisitedGame game, DateTime now) async {
    if (game.detailedGame.isGameRunning(now)) {
      log.info(
        'Updating ${game.detailedGame.homeTeamName} vs ${game.detailedGame.guestTeamName}',
      );
      return _repository
          .getDetailedGame(game.gameId)
          .then((stream) => stream.last)
          .then(
            (updatedGame) => VisitedGame(
              gameId: game.gameId,
              gameLeagueInfo: game.gameLeagueInfo,
              leagueName: game.leagueName,
              detailedGame: updatedGame,
            ),
          );
    } else {
      log.info('No update required');
      return Future<VisitedGame>.value(game);
    }
  }

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

    if (newList.length > maxGames) {
      newList.removeLast();
    }
    return GamesVisitHistory(newList);
  }
}
