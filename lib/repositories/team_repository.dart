import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/api/models/league.dart';
import 'package:logging/logging.dart';

final log = Logger('TeamRepository');

class TeamInfo {
  final int leagueId;
  final LeagueType leagueType;
  final int teamId;
  final String teamName;
  final Uri? teamLogoUri;
  final Uri? teamLogoSmallUri;

  const TeamInfo({
    required this.leagueId,
    required this.leagueType,
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
        log.info('Loading team info for league team $teamId');
        return _teamInfoForLeague(leagueId, leagueType, teamId);
      case LeagueType.cup:
        log.info('Loading team info for cup team $teamId');
        return _teamInfoForCup(leagueId, leagueType, teamId);
      case LeagueType.champ:
        log.info('Loading team info for championship team $teamId');
        return _teamInfoForChamp(leagueId, leagueType, teamId);
    }
  }

  Future<Stream<TeamInfo>> _teamInfoForLeague(
    int leagueId,
    LeagueType leagueType,
    int teamId,
  ) => apiRepository
      .getLeagueTable(leagueId)
      .then(
        (stream) => stream.map((tableRowList) {
          final teamRow = tableRowList
              .where((row) => row.teamId == teamId)
              .first;
          return TeamInfo(
            leagueId: leagueId,
            leagueType: leagueType,
            teamId: teamId,
            teamName: teamRow.teamName,
            teamLogoUri: teamRow.teamLogoUri,
            teamLogoSmallUri: teamRow.teamLogoSmallUri,
          );
        }),
      );

  Future<Stream<TeamInfo>> _teamInfoForCup(
    int leagueId,
    LeagueType leagueType,
    int teamId,
  ) {
    // TODO
    throw Exception("Not yet implemented");
  }

  Future<Stream<TeamInfo>> _teamInfoForChamp(
    int leagueId,
    LeagueType leagueType,
    int teamId,
  ) => apiRepository
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
            leagueType: leagueType,
            teamId: teamId,
            teamName: teamRow.teamName,
            teamLogoUri: teamRow.teamLogoUri,
            teamLogoSmallUri: teamRow.teamLogoSmallUri,
          );
        }),
      );
}
