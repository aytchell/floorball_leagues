import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/models/league.dart';

class TeamInfo {
  final int leagueId;
  final int teamId;
  final String teamName;
  final Uri? teamLogoUri;
  final Uri? teamLogoSmallUri;

  const TeamInfo({
    required this.leagueId,
    required this.teamId,
    required this.teamName,
    this.teamLogoUri,
    this.teamLogoSmallUri,
  });
}

class TeamRepository {
  final ApiRepository apiRepository;

  TeamRepository(this.apiRepository);

  Future<Stream<TeamInfo>> getTeamInfo(
    int leagueId,
    LeagueType leagueType,
    int teamId,
  ) {
    switch (leagueType) {
      case LeagueType.league:
        return _teamInfoForLeague(leagueId, teamId);
      case LeagueType.cup:
        return _teamInfoForCup(leagueId, teamId);
      case LeagueType.champ:
        return _teamInfoForChamp(leagueId, teamId);
    }
  }

  Future<Stream<TeamInfo>> _teamInfoForLeague(int leagueId, int teamId) =>
      apiRepository
          .getLeagueTable(leagueId)
          .then(
            (stream) => stream.map((tableRowList) {
              final teamRow = tableRowList
                  .where((row) => row.teamId == teamId)
                  .first;
              return TeamInfo(
                leagueId: leagueId,
                teamId: teamId,
                teamName: teamRow.teamName,
                teamLogoUri: teamRow.teamLogoUri,
                teamLogoSmallUri: teamRow.teamLogoSmallUri,
              );
            }),
          );

  Future<Stream<TeamInfo>> _teamInfoForCup(int leagueId, int teamId) {
    // TODO
    throw Exception("Not yet implemented");
  }

  Future<Stream<TeamInfo>> _teamInfoForChamp(int leagueId, int teamId) =>
      apiRepository
          .getChampTable(leagueId)
          .then(
            (stream) => stream.map((champGroupList) {
              final teamRow = champGroupList
                  .map((group) => group.table)
                  .expand((i) => i)
                  .where((row) => row.teamId == teamId)
                  .first;

              return TeamInfo(
                leagueId: leagueId,
                teamId: teamId,
                teamName: teamRow.teamName,
                teamLogoUri: teamRow.teamLogoUri,
                teamLogoSmallUri: teamRow.teamLogoSmallUri,
              );
            }),
          );
}
