import '../net/rest_client.dart';

// Data models for a league table from saisonmanager
class TeamTableEntry {
  int games;
  int won;
  int draw;
  int lost;
  int wonOt;
  int lostOt;
  int goalsScored;
  int goalsReceived;
  int goalsDiff;
  int points;
  String teamName;
  int teamId;
  String? teamLogo;
  String? teamLogoSmall;
  int? pointCorrections;
  int sort;
  int position;

  TeamTableEntry({
    required this.games,
    required this.won,
    required this.draw,
    required this.lost,
    required this.wonOt,
    required this.lostOt,
    required this.goalsScored,
    required this.goalsReceived,
    required this.goalsDiff,
    required this.points,
    required this.teamName,
    required this.teamId,
    this.teamLogo,
    this.teamLogoSmall,
    this.pointCorrections,
    required this.sort,
    required this.position,
  });

  factory TeamTableEntry.fromJson(Map<String, dynamic> json) {
    return TeamTableEntry(
      games: json['games'] as int,
      won: json['won'] as int,
      draw: json['draw'] as int,
      lost: json['lost'] as int,
      wonOt: json['won_ot'] as int,
      lostOt: json['lost_ot'] as int,
      goalsScored: json['goals_scored'] as int,
      goalsReceived: json['goals_received'] as int,
      goalsDiff: json['goals_diff'] as int,
      points: json['points'] as int,
      teamName: json['team_name'] as String,
      teamId: json['team_id'] as int,
      teamLogo: json['team_logo'] as String?,
      teamLogoSmall: json['team_logo_small'] as String?,
      pointCorrections: json['point_corrections'] as int?,
      sort: json['sort'] as int,
      position: json['position'] as int,
    );
  }
}

class TeamTable {
  static Future<List<TeamTableEntry>> fetchLeagueTableFromServer(
    RestClient client,
    int leagueId,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/leagues/$leagueId/table.json',
    );

    final jsonData = await client.getJson(uri) as List<dynamic>;
    return jsonData.map((entry) => TeamTableEntry.fromJson(entry)).toList();
  }
}
