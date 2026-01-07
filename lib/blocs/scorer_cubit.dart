import 'package:bloc/bloc.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/api/models/scorer.dart';

class _ScorerData {
  _ScorerData(this.version, this.scorers);

  final int version;
  final List<Scorer> scorers;
}

class ScorerState {
  ScorerState() : _state = {};

  ScorerState._(Map<int, _ScorerData> state) : _state = state;

  final Map<int, _ScorerData> _state;

  List<Scorer> scorersOf(int leagueId) {
    final data = _state[leagueId];
    return data?.scorers ?? [];
  }

  ScorerState copyWith(int leagueId, List<Scorer> scorers) {
    final newState = Map<int, _ScorerData>.fromEntries(_state.entries);
    newState.update(
      leagueId,
      (oldEntry) => _ScorerData(oldEntry.version + 1, scorers),
      ifAbsent: () => _ScorerData(1, scorers),
    );
    return ScorerState._(newState);
  }

  bool wasUpdated(int leagueId, ScorerState newState) {
    final oldVersion = _state[leagueId]?.version;
    final newVersion = newState._state[leagueId]?.version;
    return oldVersion != newVersion;
  }

  int countScorers(int leagueId) => _state[leagueId]?.scorers.length ?? 0;
}

class ScorerCubit extends Cubit<ScorerState> {
  ScorerCubit(ApiRepository repository)
    : _repository = repository,
      super(ScorerState());

  final ApiRepository _repository;

  void updateScorersFor(int leagueId) => _repository
      .getLeagueScorers(leagueId)
      .then(
        (stream) =>
            stream.forEach((list) => emit(state.copyWith(leagueId, list))),
      );

  int countScorer(int leagueId) => state.countScorers(leagueId);
}
