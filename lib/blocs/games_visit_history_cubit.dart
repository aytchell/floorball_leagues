import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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
    this.isPinned = false,
    required this.gameLeagueInfo,
    required this.leagueName,
    required this.gameData,
  });
}

VisitedGame _update(VisitedGame game, GameBase update) => VisitedGame(
  gameId: game.gameId,
  leagueId: game.leagueId,
  isPinned: game.isPinned,
  gameLeagueInfo: game.gameLeagueInfo,
  leagueName: game.leagueName,
  gameData: update,
);

VisitedGame _changePin(VisitedGame game, bool isPinned) => VisitedGame(
  gameId: game.gameId,
  leagueId: game.leagueId,
  isPinned: isPinned,
  gameLeagueInfo: game.gameLeagueInfo,
  leagueName: game.leagueName,
  gameData: game.gameData,
);

VisitedGame _pin(VisitedGame game) => _changePin(game, true);
VisitedGame _unpin(VisitedGame game) => _changePin(game, false);

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

  void addVisitedGame(VisitedGame visitedGame) {
    if (visitedGame.isPinned) {
      // by convention pinned history entries don't change their place
      // (in theory a caller could add a new visited game which is
      // already 'pinned' by the caller ... we don't do this)
      return;
    }

    final firstUnpinnedEntry = state.visitedGames.firstWhereOrNull(
      (game) => !game.isPinned,
    );
    if (visitedGame.gameId == firstUnpinnedEntry?.gameId) {
      // the first (unpinned) game in the list should be 'added' -> noop
      return;
    }

    _emitUpdatedHistory(visitedGame);
  }

  void remove(int gameId) {
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == gameId);
    emit(GamesVisitHistory(newList));
  }

  void toggle(VisitedGame visitedGame) {
    if (visitedGame.isPinned) {
      emit(_unpinVisitedGame(visitedGame));
    } else {
      emit(_pinVisitedGame(visitedGame));
    }
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

  void _emitUpdatedHistory(VisitedGame visitedGame) {
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == visitedGame.gameId);

    final idx = _indexOfFirstUnpinned(newList);
    if (idx == maxGames) {
      // seems like this list is already filled with pinned games
      return;
    }

    newList.insert(idx, visitedGame);

    if (newList.length > maxGames) {
      newList.removeLast();
    }
    emit(GamesVisitHistory(newList));
  }

  GamesVisitHistory _pinVisitedGame(VisitedGame visitedGame) {
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == visitedGame.gameId);

    final idx = _indexOfFirstUnpinned(newList);
    newList.insert(idx, _pin(visitedGame));

    // the concept says, that a visitedGame can only get pinned
    // if it's only contained in the history. So we deleted one and added one
    // => no need to check length

    return GamesVisitHistory(newList);
  }

  GamesVisitHistory _unpinVisitedGame(VisitedGame visitedGame) {
    final newList = List<VisitedGame>.from(state.visitedGames);
    newList.removeWhere((game) => game.gameId == visitedGame.gameId);

    final idx = _indexOfFirstUnpinned(newList);
    newList.insert(idx, _unpin(visitedGame));

    // the concept says, that a visitedGame can only get pinned
    // if it's only contained in the history. So we deleted one and added one
    // => no need to check length

    return GamesVisitHistory(newList);
  }

  int _indexOfFirstUnpinned(List<VisitedGame> visitedGames) {
    for (int i = 0; i < visitedGames.length; ++i) {
      if (!visitedGames[i].isPinned) {
        return i;
      }
    }
    return visitedGames.length;
  }
}
