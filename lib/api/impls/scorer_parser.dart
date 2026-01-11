import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/scorer.dart';

Scorer parseScorer(Map<String, dynamic> json) => Scorer(
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
  teamName: parseString(json, 'team_name'),
  firstName: parseString(json, 'first_name'),
  lastName: parseString(json, 'last_name'),
  image: parseNullableString(json, 'image'),
  imageSmall: parseNullableString(json, 'image_small'),
  sort: parseInt(json, 'sort'),
  position: parseInt(json, 'position'),
);
