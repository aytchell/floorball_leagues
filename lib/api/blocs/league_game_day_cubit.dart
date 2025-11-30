import 'package:bloc/bloc.dart';
import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/game.dart';

class GameDaysState {
  GameDaysState() : _state = {};

  GameDaysState._(Map<int, List<Game>> newState) : _state = newState;

  final Map<int, List<Game>> _state;

  List<Game> gamesOf(int leagueId, int gameDayId) =>
      _state[_leagueAndGameDayKey(leagueId, gameDayId)] ?? [];

  List<Game> gamesOfDays(int leagueId, List<int> gameDayIds) {
    final List<Game> result = [];
    gameDayIds.forEach((id) => result.addAll(gamesOf(leagueId, id)));
    return result;
  }

  int _leagueAndGameDayKey(int leagueId, int gameDayId) =>
      leagueId * 1000 + gameDayId;

  GameDaysState copyWith({
    required int leagueId,
    required int gameDayId,
    required List<Game> games,
  }) {
    final newState = Map<int, List<Game>>.fromEntries(_state.entries);
    newState[_leagueAndGameDayKey(leagueId, gameDayId)] = games;

    return GameDaysState._(newState);
  }

  bool hasGamesFor(int leagueId, int gameDayId) =>
      _state[_leagueAndGameDayKey(leagueId, gameDayId)] != null;
}

class LeagueGameDayCubit extends Cubit<GameDaysState> {
  LeagueGameDayCubit(ApiRepository repository)
    : _repository = repository,
      super(GameDaysState());

  final ApiRepository _repository;

  void ensureGamesFor(int leagueId, int gameDayId) {
    if (!state.hasGamesFor(leagueId, gameDayId)) {
      refreshGamesOf(leagueId, gameDayId);
    }
  }

  void refreshGamesOf(int leagueId, int gameDayId) {
    _repository
        .getGamesOfGameDay(leagueId, gameDayId)
        .then(
          (stream) => stream.forEach(
            (list) => emit(
              state.copyWith(
                leagueId: leagueId,
                gameDayId: gameDayId,
                games: list,
              ),
            ),
          ),
        );
  }
}
