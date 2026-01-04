import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/team_repository.dart';

class TeamInfoState {
  TeamInfoState() : _state = {};

  TeamInfoState._(Map<int, TeamInfo> newState) : _state = newState;

  final Map<int, TeamInfo> _state;

  TeamInfo? infoOf(int leagueId, int teamId) =>
      _state[_leagueTeamKey(leagueId, teamId)];

  int _leagueTeamKey(int leagueId, int teamId) => leagueId * 1000 + teamId;

  TeamInfoState copyAndAdd({required TeamInfo teamInfo}) {
    final newState = Map<int, TeamInfo>.fromEntries(_state.entries);
    newState[_leagueTeamKey(teamInfo.leagueId, teamInfo.teamId)] = teamInfo;

    return TeamInfoState._(newState);
  }

  bool hasTeamInfo(int leagueId, int teamId) =>
      _state[_leagueTeamKey(leagueId, teamId)] != null;
}

class TeamInfoCubit extends Cubit<TeamInfoState> {
  TeamInfoCubit(TeamRepository repository)
    : _repository = repository,
      super(TeamInfoState());

  final TeamRepository _repository;

  void ensureInfoFor(int leagueId, LeagueType leagueType, int teamId) {
    if (state.hasTeamInfo(leagueId, teamId)) {
      // team information doesn't change that often
      // so we only fetch it once per app run
      return;
    }

    _repository
        .getTeamInfo(leagueId, leagueType, teamId)
        .then(
          (stream) =>
              stream.forEach((info) => emit(state.copyAndAdd(teamInfo: info))),
        );
  }
}
