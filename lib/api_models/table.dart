import '../net/rest_client.dart';
import '../api/impls/int_parser.dart';
import 'logo_host.dart';

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

  Uri? get teamLogoUri => buildLogoUri(teamLogo);
  Uri? get teamLogoSmallUri => buildLogoUri(teamLogoSmall);

  factory TeamTableEntry.fromJson(Map<String, dynamic> json) {
    return TeamTableEntry(
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
}

class GroupTable {
  String groupIdentifier;
  String name;
  List<TeamTableEntry> table;
  bool hidePoints;

  GroupTable({
    required this.groupIdentifier,
    required this.name,
    required this.table,
    this.hidePoints = false,
  });

  factory GroupTable.fromJson(Map<String, dynamic> json) {
    final tableJson = json['table'] as List<dynamic>;

    return GroupTable(
      groupIdentifier: json['group_identifier'] as String,
      name: json['name'] as String,
      table: tableJson.map((entry) => TeamTableEntry.fromJson(entry)).toList(),
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

  static Future<List<GroupTable>> fetchChampTableFromServer(
    RestClient client,
    int leagueId,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/leagues/$leagueId/grouped_table.json',
    );

    final jsonData = await client.getJson(uri) as Map<String, dynamic>;
    return jsonData
        .map((key, value) => MapEntry.new(key, GroupTable.fromJson(value)))
        .values
        .toList();
  }
}
