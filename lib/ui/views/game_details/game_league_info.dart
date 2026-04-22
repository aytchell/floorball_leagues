import 'package:floorball/api/models/league.dart';

class GameLeagueInfo {
  final String federationPath;
  final LeagueType leagueType;
  final String? leagueName;
  final String fieldSize;
  final int numPeriods;

  GameLeagueInfo({
    required this.federationPath,
    required this.leagueType,
    this.leagueName,
    required this.fieldSize,
    required this.numPeriods,
  });

  factory GameLeagueInfo.from(League league, String federationPath) =>
      GameLeagueInfo(
        federationPath: federationPath,
        leagueType: league.leagueType,
        leagueName: league.name,
        fieldSize: league.fieldSize ?? 'GF',
        numPeriods: league.periods ?? 3,
      );
}
