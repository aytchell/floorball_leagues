import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/game_operation_league.dart';

class _LeagueData {
  _LeagueData(this.version, this.leagues);

  final int version;
  final List<GameOperationLeague> leagues;
}

class LeaguesState {
  LeaguesState() : _state = {};

  LeaguesState._(Map<int, _LeagueData> state) : _state = state;

  final Map<int, _LeagueData> _state;

  List<GameOperationLeague> leaguesOf(int gameOperationId) {
    final data = _state[gameOperationId];
    return data?.leagues ?? [];
  }

  LeaguesState copyWith(
    int gameOperationId,
    List<GameOperationLeague> leagues,
  ) {
    final newState = Map<int, _LeagueData>.fromEntries(_state.entries);
    newState.update(
      gameOperationId,
      (oldEntry) => _LeagueData(oldEntry.version + 1, leagues),
      ifAbsent: () => _LeagueData(1, leagues),
    );
    return LeaguesState._(newState);
  }

  bool wasUpdated(int gameOperationId, LeaguesState newState) {
    final oldVersion = _state[gameOperationId]?.version;
    final newVersion = newState._state[gameOperationId]?.version;
    return oldVersion != newVersion;
  }
}

class LeaguesCubit extends Cubit<LeaguesState> {
  LeaguesCubit(ApiRepository repository)
    : _repository = repository,
      super(LeaguesState());

  final ApiRepository _repository;

  void updateLeaguesFor(int seasonId, int gameOperationId) => _repository
      .getLeagues(seasonId, gameOperationId)
      .then(
        (stream) => stream.forEach(
          (list) => emit(state.copyWith(gameOperationId, list)),
        ),
      );
}
