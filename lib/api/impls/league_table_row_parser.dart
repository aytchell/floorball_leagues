import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/league_table_row.dart';

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
    teamName: parseString(json, 'team_name'),
    teamId: parseInt(json, 'team_id'),
    teamLogo: parseNullableString(json, 'team_logo'),
    teamLogoSmall: parseNullableString(json, 'team_logo_small'),
    pointCorrections: parseNullableInt(json, 'point_corrections'),
    sort: parseInt(json, 'sort'),
    position: parseInt(json, 'position'),
  );
}
