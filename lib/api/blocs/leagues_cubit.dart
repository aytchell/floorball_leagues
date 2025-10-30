import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/game_operation_league.dart';

class LeaguesState {
  LeaguesState() : _state = {};

  LeaguesState._(Map<int, List<GameOperationLeague>> state) : _state = state;

  final Map<int, List<GameOperationLeague>> _state;

  List<GameOperationLeague> leaguesOf(int? seasonId, int gameOperationId) {
    if (seasonId == null) {
      return [];
    } else {
      return _state[_stateKey(seasonId, gameOperationId)] ?? [];
    }
  }

  int _stateKey(int seasonId, int gameOperationId) =>
      seasonId * 1000 + gameOperationId;

  LeaguesState copyWith({
    required int seasonId,
    required int gameOperationId,
    required List<GameOperationLeague> leagues,
  }) {
    final newState = Map<int, List<GameOperationLeague>>.fromEntries(
      _state.entries,
    );
    newState[_stateKey(seasonId, gameOperationId)] = leagues;
    return LeaguesState._(newState);
  }

  bool hasLeagues(int seasonId, int gameOperationId) =>
      _state[_stateKey(seasonId, gameOperationId)] != null;
}

class LeaguesCubit extends Cubit<LeaguesState> {
  LeaguesCubit(ApiRepository repository)
    : _repository = repository,
      super(LeaguesState());

  final ApiRepository _repository;

  void ensureLeaguesFor(int seasonId, int gameOperationId) {
    if (state.hasLeagues(seasonId, gameOperationId)) {
      // list of leagues for an association doesn't change that often
      // so we only fetch it once per app run
      return;
    }

    _repository
        .getLeagues(seasonId, gameOperationId)
        .then(
          (stream) => stream.forEach(
            (list) => emit(
              state.copyWith(
                seasonId: seasonId,
                gameOperationId: gameOperationId,
                leagues: list,
              ),
            ),
          ),
        );
  }
}
