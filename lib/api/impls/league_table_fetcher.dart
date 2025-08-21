import '../../net/rest_client.dart';
import '../models/league_table_row.dart';
import 'int_parser.dart';

LeagueTableRow parseLeagueTableRow(Map<String, dynamic> json) {
  return LeagueTableRow(
    games: parseInt(json, 'games'),
    won: parseInt(json, 'won'),
    draw: parseInt(json, 'draw'),
    lost: parseInt(json, 'lost'),
    wonOt: parseInt(json, 'won_ot'),
    lostOt: parseInt(json, 'lost_ot'),
    goalsScored: parseInt(json, 'goals_scored'),
    goalsReceived: parseInt(json, 'goals_received'),
    goalsDiff: parseInt(json, 'goals_diff'),
    points: parseInt(json, 'points'),
    teamName: json['team_name'] as String,
    teamId: parseInt(json, 'team_id'),
    teamLogo: json['team_logo'] as String?,
    teamLogoSmall: json['team_logo_small'] as String?,
    pointCorrections: parseNullableInt(json, 'point_corrections'),
    sort: parseInt(json, 'sort'),
    position: parseInt(json, 'position'),
  );
}

Future<List<LeagueTableRow>> fetchLeagueTableFromServer(
  RestClient client,
  int leagueId,
) async {
  final path = '/api/v2/leagues/$leagueId/table.json';

  final jsonData = await client.getJsonFromPath(path) as List<dynamic>;
  return jsonData.map((row) => parseLeagueTableRow(row)).toList();
}
