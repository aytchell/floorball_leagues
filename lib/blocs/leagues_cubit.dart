import 'package:bloc/bloc.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/api/models/league.dart';

class LeaguesState {
  LeaguesState() : _leaguesOfFederation = {}, _leaguesById = {};

  LeaguesState._(
    Map<int, List<League>> leaguesOfFed,
    Map<int, League> leaguesById,
  ) : _leaguesOfFederation = leaguesOfFed,
      _leaguesById = leaguesById;

  final Map<int, List<League>> _leaguesOfFederation;
  final Map<int, League> _leaguesById;

  List<League> leaguesOf(int? seasonId, int federationId) {
    if (seasonId == null) {
      return [];
    } else {
      return _leaguesOfFederation[_seasonFederationKey(
            seasonId,
            federationId,
          )] ??
          [];
    }
  }

  League? byId(int leagueId) => _leaguesById[leagueId];

  int _seasonFederationKey(int seasonId, int federationId) =>
      seasonId * 1000 + federationId;

  LeaguesState copyWith({
    required int seasonId,
    required int federationId,
    required List<League> leagues,
  }) {
    final newPerFedMap = Map<int, List<League>>.fromEntries(
      _leaguesOfFederation.entries,
    );
    newPerFedMap[_seasonFederationKey(seasonId, federationId)] = leagues;

    final newByIdMap = Map<int, League>.fromEntries(_leaguesById.entries);
    newByIdMap.addEntries(leagues.map((league) => MapEntry(league.id, league)));

    return LeaguesState._(newPerFedMap, newByIdMap);
  }

  LeaguesState copyAndAdd({required League league}) {
    final newByIdMap = Map<int, League>.fromEntries(_leaguesById.entries);
    newByIdMap[league.id] = league;

    return LeaguesState._(_leaguesOfFederation, newByIdMap);
  }

  bool hasLeagues(int seasonId, int federationId) =>
      _leaguesOfFederation[_seasonFederationKey(seasonId, federationId)] !=
      null;

  bool hasLeague(int leagueId) => _leaguesById[leagueId] != null;
}

class LeaguesCubit extends Cubit<LeaguesState> {
  LeaguesCubit(ApiRepository repository)
    : _repository = repository,
      super(LeaguesState());

  final ApiRepository _repository;

  void ensureLeaguesFor(int seasonId, int federationId) {
    if (state.hasLeagues(seasonId, federationId)) {
      // list of leagues for an association doesn't change that often
      // so we only fetch it once per app run
      return;
    }

    _repository
        .getLeagues(seasonId, federationId)
        .then(
          (stream) => stream.forEach(
            (list) => emit(
              state.copyWith(
                seasonId: seasonId,
                federationId: federationId,
                leagues: list,
              ),
            ),
          ),
        );
  }

  void ensureLeague(int leagueId) {
    if (state.hasLeague(leagueId)) {
      // information of leagues don't change that often
      // so we only fetch it once per app run
      return;
    }

    _repository
        .getLeagueById(leagueId)
        .then(
          (stream) => stream.forEach(
            (league) => emit(state.copyAndAdd(league: league)),
          ),
        );
  }
}
