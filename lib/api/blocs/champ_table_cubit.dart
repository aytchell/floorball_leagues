import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/champ_group_table.dart';

class ChampTableState {
  ChampTableState() : _byLeagueId = {};

  ChampTableState._(Map<int, List<ChampGroupTable>> state)
    : _byLeagueId = state;

  final Map<int, List<ChampGroupTable>> _byLeagueId;

  bool hasChampTableOf(int leagueId) => _byLeagueId[leagueId] != null;

  List<ChampGroupTable> champTableOf(int leagueId) {
    final data = _byLeagueId[leagueId];
    return data ?? [];
  }

  ChampTableState copyWith(int leagueId, List<ChampGroupTable> champTable) {
    final newState = Map<int, List<ChampGroupTable>>.fromEntries(
      _byLeagueId.entries,
    );
    newState[leagueId] = champTable;
    return ChampTableState._(newState);
  }
}

class ChampTableCubit extends Cubit<ChampTableState> {
  ChampTableCubit(ApiRepository repository)
    : _repository = repository,
      super(ChampTableState());

  final ApiRepository _repository;

  void ensureChampTableFor(int leagueId) {
    if (state.hasChampTableOf(leagueId)) {
      // champ table for a league is only refreshed on user request
      return;
    }
    refreshChampTableFor(leagueId);
  }

  void refreshChampTableFor(int leagueId) => _repository
      .getChampTable(leagueId)
      .then(
        (stream) =>
            stream.forEach((list) => emit(state.copyWith(leagueId, list))),
      );
}
