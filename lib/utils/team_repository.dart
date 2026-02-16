import 'package:floorball/ui/views/game_details/game_league_info.dart';

class TeamInfo {
  final int leagueId;
  final int teamId;
  final String teamName;
  final Uri? teamLogoUri;
  final GameLeagueInfo gameLeagueInfo;

  const TeamInfo({
    required this.leagueId,
    required this.teamId,
    required this.teamName,
    this.teamLogoUri,
    required this.gameLeagueInfo,
  });
}
