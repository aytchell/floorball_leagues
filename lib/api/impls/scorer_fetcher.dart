import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/models/scorer.dart';

Scorer _parseScorer(Map<String, dynamic> json) {
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

Stream<Future<List<Scorer>>> fetchScorers(RestClient client, int leagueId) {
  return client.streamApiData('/api/v2/leagues/$leagueId/scorer.json', (data) {
    final json = data as List<dynamic>;
    return json.map((entry) => _parseScorer(entry)).toList();
  });
}
