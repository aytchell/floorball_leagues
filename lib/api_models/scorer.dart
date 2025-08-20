import '../net/rest_client.dart';
import '../api/impls/int_parser.dart';

// Data models for top scorers from saisonmanager
class Scorer {
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

  Scorer({
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

  factory Scorer.fromJson(Map<String, dynamic> json) {
    return Scorer(
      games: parseInt(json, 'games'),
      goals: parseInt(json, 'goals'),
      assists: parseInt(json, 'assists'),
      penalty2: parseInt(json, 'penalty_2'),
      penalty2and2: parseInt(json, 'penalty_2and2'),
      penalty5: parseInt(json, 'penalty_5'),
      penalty10: parseInt(json, 'penalty_10'),
      penaltyMsTech: parseInt(json, 'penalty_ms_tech'),
      penaltyMsFull: parseInt(json, 'penalty_ms_full'),
      penaltyMs1: parseInt(json, 'penalty_ms1'),
      penaltyMs2: parseInt(json, 'penalty_ms2'),
      penaltyMs3: parseInt(json, 'penalty_ms3'),
      playerId: parseInt(json, 'player_id'),
      teamId: parseInt(json, 'team_id'),
      teamName: json['team_name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      image: json['image'] as String?,
      imageSmall: json['image_small'] as String?,
      sort: parseInt(json, 'sort'),
      position: parseInt(json, 'position'),
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
  static Future<List<Scorer>> fetchFromServer(
    RestClient client,
    int leagueId,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/leagues/$leagueId/scorer.json',
    );

    try {
      final jsonData = await client.getJson(uri) as List<dynamic>;
      return jsonData.map((entry) => Scorer.fromJson(entry)).toList();
    } catch (e) {
      throw Exception('Failed to fetch scorers: $e');
    }
  }
}
