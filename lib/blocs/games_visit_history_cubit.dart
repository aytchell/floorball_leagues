import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/game_base.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:logging/logging.dart';

final log = Logger('VisitHistory');

class VisitedGame {
  final int gameId;
  final int leagueId;
  final bool isPinned;
  final GameLeagueInfo gameLeagueInfo;
  final String leagueName;
  final GameBase gameData;

  VisitedGame({
    required this.gameId,
    required this.leagueId,
    required this.isPinned,
    required this.gameLeagueInfo,
    required this.leagueName,
    required this.gameData,
  });
}

VisitedGame _update(VisitedGame game, GameBase updatedGame) => VisitedGame(
  gameId: game.gameId,
  leagueId: game.leagueId,
  isPinned: game.isPinned,
  gameLeagueInfo: game.gameLeagueInfo,
  leagueName: game.leagueName,
  gameData: updatedGame,
);

VisitedGame _togglePin(VisitedGame game) => VisitedGame(
  gameId: game.gameId,
  leagueId: game.leagueId,
  isPinned: !game.isPinned,
  gameLeagueInfo: game.gameLeagueInfo,
  leagueName: game.leagueName,
  gameData: game.gameData,
);

class GamesVisitHistory {
  GamesVisitHistory(this.visitedGames);

  final List<VisitedGame> visitedGames;
}

class GamesVisitHistoryCubit extends Cubit<GamesVisitHistory> {
  GamesVisitHistoryCubit(ApiRepository repository)
    : _repository = repository,
      super(GamesVisitHistory([]));

  final ApiRepository _repository;
  final _idToGame = <int, VisitedGame>{};

  static final maxGames = 5;

  void addVisitedGame(
    int leagueId,
    String leagueName,
    GameLeagueInfo gameLeagueInfo,
    GameBase gameData,
  ) {
    if (state.visitedGames.isEmpty) {
      emit(
        GamesVisitHistory([
          _getOrCreate(leagueId, leagueName, gameLeagueInfo, gameData),
        ]),
      );
      return;
    }

    if (_isPinned(gameData.gameId)) {
      // by convention pinned history entries don't change their place
      return;
    }

    final idx = _indexOfFirstUnpinned(state.visitedGames);
    if (idx == maxGames ||
        (idx < state.visitedGames.length &&
            state.visitedGames[idx].gameId == gameData.gameId)) {
      // seems like this list is already filled with pinned games
      // -or- the game to be 'added' is already the first unpinned entry
      return;
    }

    final visitedGame = _getOrCreate(
      leagueId,
      leagueName,
      gameLeagueInfo,
      gameData,
    );
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == visitedGame.gameId);
    newList.insert(idx, visitedGame);

    if (newList.length > maxGames) {
      _idToGame.remove(newList.last.gameId);
      newList.removeLast();
    }
    emit(GamesVisitHistory(newList));
  }

  VisitedGame _getOrCreate(
    int leagueId,
    String leagueName,
    GameLeagueInfo gameLeagueInfo,
    GameBase gameData,
  ) {
    final storedGame = _idToGame[gameData.gameId];
    if (storedGame != null) {
      return storedGame;
    }

    final createGame = VisitedGame(
      gameId: gameData.gameId,
      leagueId: leagueId,
      isPinned: false,
      gameLeagueInfo: gameLeagueInfo,
      leagueName: leagueName,
      gameData: gameData,
    );
    _idToGame[gameData.gameId] = createGame;
    return createGame;
  }

  void remove(int gameId) {
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == gameId);
    _idToGame.remove(gameId);
    emit(GamesVisitHistory(newList));
  }

  void toggle(int gameId) {
    final visitedGame = _idToGame[gameId];
    if (visitedGame != null) {
      log.info('Toggling game $gameId (from ${visitedGame.isPinned})');
      final toggledGame = _togglePin(visitedGame);
      _idToGame[gameId] = toggledGame;
      _reinsertToggledGame(toggledGame);
    } else {
      log.info('Game $gameId not found for toggling');
    }
  }

  void _reinsertToggledGame(VisitedGame visitedGame) {
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == visitedGame.gameId);

    final idx = _indexOfFirstUnpinned(newList);
    newList.insert(idx, visitedGame);

    emit(GamesVisitHistory(newList));
  }

  Future<void> checkForUpdates() async {
    DateTime now = DateTime.now();
    final gameFutures = state.visitedGames.map(
      (game) => _updateIfRunning(game, now),
    );
    List<VisitedGame> games = await Future.wait(gameFutures);
    emit(GamesVisitHistory(games));
  }

  Future<VisitedGame> _updateIfRunning(VisitedGame game, DateTime now) async {
    if (game.gameData.isGameRunning(now)) {
      log.info(
        'Updating ${game.gameData.homeTeamName} vs ${game.gameData.guestTeamName}',
      );
      return _repository
          .getDetailedGame(game.gameId)
          .then((stream) => stream.last)
          .then((updatedGame) => _update(game, updatedGame));
    } else {
      log.info('No update required');
      return Future<VisitedGame>.value(game);
    }
  }

  int _indexOfFirstUnpinned(List<VisitedGame> visitedGames) {
    for (int i = 0; i < visitedGames.length; ++i) {
      if (!visitedGames[i].isPinned) {
        return i;
      }
    }
    return visitedGames.length;
  }

  bool _isPinned(int gameId) =>
      // this also handles 'null', when 'gameId' is not contained in the Map
      true == _idToGame[gameId]?.isPinned;
}
