import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/league.dart';

class LeaguesState {
  LeaguesState() : _leaguesPerGameOp = {}, _leaguesById = {};

  LeaguesState._(Map<int, List<League>> perGameOp, Map<int, League> byId)
    : _leaguesPerGameOp = perGameOp,
      _leaguesById = byId;

  final Map<int, List<League>> _leaguesPerGameOp;
  final Map<int, League> _leaguesById;

  List<League> leaguesOf(int? seasonId, int gameOperationId) {
    if (seasonId == null) {
      return [];
    } else {
      return _leaguesPerGameOp[_seasonGameOpKey(seasonId, gameOperationId)] ??
          [];
    }
  }

  League? byId(int leagueId) => _leaguesById[leagueId];

  int _seasonGameOpKey(int seasonId, int gameOperationId) =>
      seasonId * 1000 + gameOperationId;

  LeaguesState copyWith({
    required int seasonId,
    required int gameOperationId,
    required List<League> leagues,
  }) {
    final newPerGameOpMap = Map<int, List<League>>.fromEntries(
      _leaguesPerGameOp.entries,
    );
    newPerGameOpMap[_seasonGameOpKey(seasonId, gameOperationId)] = leagues;

    final newByIdMap = Map<int, League>.fromEntries(_leaguesById.entries);
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
