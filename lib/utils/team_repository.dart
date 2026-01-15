import 'package:floorball/api/models/league.dart';

class TeamInfo {
  final int leagueId;
  final LeagueType leagueType;
  final int teamId;
  final String teamName;
  final Uri? teamLogoUri;

  const TeamInfo({
    required this.leagueId,
    required this.leagueType,
    required this.teamId,
    required this.teamName,
    this.teamLogoUri,
  });
}
