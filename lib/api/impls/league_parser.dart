import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/impls/game_day_title_parser.dart';

import 'package:floorball/api/impls/int_parser.dart';
import 'package:logging/logging.dart';

final log = Logger('LeagueParser');

LeagueType _parseLeagueType(String leagueTypeString) {
  switch (leagueTypeString) {
    case "league":
      return LeagueType.league;
    case "champ":
      return LeagueType.champ;
    case "cup":
      return LeagueType.cup;
    default:
      {
        log.warning('Unknown league_type: "$leagueTypeString"');
        return LeagueType.league;
      }
  }
}

League parseLeague(Map<String, dynamic> json) {
  var gameDayTitlesJson = json['game_day_titles'] as List;

  return League(
    id: parseInt(json, 'id'),
    federationId: parseInt(json, 'game_operation_id'),
    federationName: parseString(json, 'game_operation_name'),
    federationShortName: parseNullableString(json, 'game_operation_short_name'),
    federationSlug: parseNullableString(json, 'game_operation_slug'),
    leagueCategoryId: parseNullableString(json, 'league_category_id'),
    leagueClassId: parseNullableString(json, 'league_class_id'),
    leagueSystemId: parseNullableString(json, 'league_system_id'),
    leagueType: _parseLeagueType(parseString(json, 'league_type')),
    name: parseString(json, 'name'),
    female: json['female'] as bool?,
    enableScorer: json['enable_scorer'] as bool?,
    shortName: parseNullableString(json, 'short_name'),
    seasonId: parseNullableString(json, 'season_id'),
    orderKey: parseNullableString(json, 'order_key'),
    gameDayNumbers: parseListOfInt(json, 'game_day_numbers'),
    gameDayTitles: gameDayTitlesJson
        .map((title) => parseGameDayTitle(title))
        .toList(),
    deadline: parseNullableString(json, 'deadline'),
    beforeDeadline: json['before_deadline'] as bool?,
    legacyLeague: json['legacy_league'] as bool?,
    fieldSize: parseNullableString(json, 'field_size'),
    leagueModus: parseNullableString(json, 'league_modus'),
    hasPreround: json['has_preround'] as bool?,
    tableModus: parseNullableString(json, 'table_modus'),
    periods: parseNullableInt(json, 'periods'),
    periodLength: parseNullableInt(json, 'period_length'),
    overtimeLength: parseNullableInt(json, 'overtime_length'),
  );
}
