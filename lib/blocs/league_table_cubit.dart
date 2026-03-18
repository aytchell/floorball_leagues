import 'package:bloc/bloc.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/api/models/league_table_row.dart';

class LeagueTableState {
  LeagueTableState() : _byLeagueId = {};

  LeagueTableState._(Map<int, List<LeagueTableRow>> state)
    : _byLeagueId = state;

  final Map<int, List<LeagueTableRow>> _byLeagueId;

  List<LeagueTableRow> leagueTableOf(int leagueId) {
    final data = _byLeagueId[leagueId];
    return data ?? [];
  }

  LeagueTableState copyWith(int leagueId, List<LeagueTableRow> leagueTable) {
    final newState = Map<int, List<LeagueTableRow>>.fromEntries(
      _byLeagueId.entries,
    );
    newState[leagueId] = leagueTable;
    return LeagueTableState._(newState);
  }
}

class LeagueTableCubit extends Cubit<LeagueTableState> {
  LeagueTableCubit(ApiRepository repository)
    : _repository = repository,
      super(LeagueTableState());

  final ApiRepository _repository;

  void refreshLeagueTableFor(int leagueId) => _repository
      .getLeagueTable(leagueId)
      .then(
        (stream) =>
            stream.forEach((list) => emit(state.copyWith(leagueId, list))),
      );
}
