import '../net/rest_client.dart';

// Data models for top scorers from saisonmanager
class ScorerEntry {
  int games;
  int goals;
  int assists;
  int penalty2;
  int penalty2and2;
  int penalty5;
  int penalty10;
  int penaltyMsTech;
  int penaltyMsFull;
  int penaltyMs1;
  int penaltyMs2;
  int penaltyMs3;
  int playerId;
  int teamId;
  String teamName;
  String firstName;
  String lastName;
  String? image;
  String? imageSmall;
  int sort;
  int position;

  ScorerEntry({
    required this.games,
    required this.goals,
    required this.assists,
    required this.penalty2,
    required this.penalty2and2,
    required this.penalty5,
    required this.penalty10,
    required this.penaltyMsTech,
    required this.penaltyMsFull,
    required this.penaltyMs1,
    required this.penaltyMs2,
    required this.penaltyMs3,
    required this.playerId,
    required this.teamId,
    required this.teamName,
    required this.firstName,
    required this.lastName,
    this.image,
    this.imageSmall,
    required this.sort,
    required this.position,
  });

  factory ScorerEntry.fromJson(Map<String, dynamic> json) {
    return ScorerEntry(
      games: json['games'] as int,
      goals: json['goals'] as int,
      assists: json['assists'] as int,
      penalty2: json['penalty_2'] as int,
      penalty2and2: json['penalty_2and2'] as int,
      penalty5: json['penalty_5'] as int,
      penalty10: json['penalty_10'] as int,
      penaltyMsTech: json['penalty_ms_tech'] as int,
      penaltyMsFull: json['penalty_ms_full'] as int,
      penaltyMs1: json['penalty_ms1'] as int,
      penaltyMs2: json['penalty_ms2'] as int,
      penaltyMs3: json['penalty_ms3'] as int,
      playerId: json['player_id'] as int,
      teamId: json['team_id'] as int,
      teamName: json['team_name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      image: json['image'] as String?,
      imageSmall: json['image_small'] as String?,
      sort: json['sort'] as int,
      position: json['position'] as int,
    );
  }

  // Convenience getters
  String get fullName => '$firstName $lastName';
  int get points => goals + assists;
  double get goalsPerGame => games > 0 ? goals / games : 0.0;
  double get pointsPerGame => games > 0 ? points / games : 0.0;
  double get assistsPerGame => games > 0 ? assists / games : 0.0;
}

class Scorers {
  static Future<List<ScorerEntry>> fetchFromServer(
    RestClient client,
    int leagueId,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/leagues/$leagueId/scorer.json',
    );

    try {
      final jsonData = await client.getJson(uri) as List<dynamic>;
      return jsonData.map((entry) => ScorerEntry.fromJson(entry)).toList();
    } catch (e) {
      throw Exception('Failed to fetch scorers: $e');
    }
  }
}
