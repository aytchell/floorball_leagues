import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/game_operation_league.dart';

class LeaguesState {
  LeaguesState() : _leaguesPerGameOp = {}, _leaguesById = {};

  LeaguesState._(
    Map<int, List<GameOperationLeague>> perGameOp,
    Map<int, GameOperationLeague> byId,
  ) : _leaguesPerGameOp = perGameOp,
      _leaguesById = byId;

  final Map<int, List<GameOperationLeague>> _leaguesPerGameOp;
  final Map<int, GameOperationLeague> _leaguesById;

  List<GameOperationLeague> leaguesOf(int? seasonId, int gameOperationId) {
    if (seasonId == null) {
      return [];
    } else {
      return _leaguesPerGameOp[_seasonGameOpKey(seasonId, gameOperationId)] ??
          [];
    }
  }

  GameOperationLeague? byId(int leagueId) => _leaguesById[leagueId];

  int _seasonGameOpKey(int seasonId, int gameOperationId) =>
      seasonId * 1000 + gameOperationId;

  LeaguesState copyWith({
    required int seasonId,
    required int gameOperationId,
    required List<GameOperationLeague> leagues,
  }) {
    final newPerGameOpMap = Map<int, List<GameOperationLeague>>.fromEntries(
      _leaguesPerGameOp.entries,
    );
    newPerGameOpMap[_seasonGameOpKey(seasonId, gameOperationId)] = leagues;

    final newByIdMap = Map<int, GameOperationLeague>.fromEntries(
      _leaguesById.entries,
    );
    newByIdMap.addEntries(leagues.map((league) => MapEntry(league.id, league)));

    return LeaguesState._(newPerGameOpMap, newByIdMap);
  }

  bool hasLeagues(int seasonId, int gameOperationId) =>
      _leaguesPerGameOp[_seasonGameOpKey(seasonId, gameOperationId)] != null;
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
