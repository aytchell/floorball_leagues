import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/detailed_game.dart';

class _DetailedGameData {
  _DetailedGameData(this.version, this.detailedGame);

  final int version;
  final DetailedGame detailedGame;
}

class DetailedGamesState {
  DetailedGamesState() : _state = {};

  DetailedGamesState._(Map<int, _DetailedGameData> state) : _state = state;

  final Map<int, _DetailedGameData> _state;

  DetailedGame? detailedVersionOf(int gameId) {
    final data = _state[gameId];
    return data?.detailedGame;
  }

  DetailedGamesState copyWith(int gameId, DetailedGame game) {
    final newState = Map<int, _DetailedGameData>.fromEntries(_state.entries);
    newState.update(
      gameId,
      (oldEntry) => _DetailedGameData(oldEntry.version + 1, game),
      ifAbsent: () => _DetailedGameData(1, game),
    );
    return DetailedGamesState._(newState);
  }

  bool wasUpdated(int gameId, DetailedGamesState newState) {
    final oldVersion = _state[gameId]?.version;
    final newVersion = newState._state[gameId]?.version;
    return oldVersion != newVersion;
  }
}

class DetailedGamesCubit extends Cubit<DetailedGamesState> {
  DetailedGamesCubit(ApiRepository repository)
    : _repository = repository,
      super(DetailedGamesState());

  final ApiRepository _repository;

  void updateGame(int gameId) => _repository
      .getDetailedGame(gameId)
      .then(
        (stream) =>
            stream.forEach((game) => emit(state.copyWith(gameId, game))),
      );
}
