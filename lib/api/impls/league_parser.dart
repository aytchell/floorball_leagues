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
      federationName: json['game_operation_name'] as String,
      federationShortName: json['game_operation_short_name'] as String?,
      federationSlug: json['game_operation_slug'] as String?,
      leagueCategoryId: json['league_category_id'] as String?,
      leagueClassId: json['league_class_id'] as String?,
      leagueSystemId: json['league_system_id'] as String?,
      leagueType: _parseLeagueType(json['league_type'] as String),
      name: json['name'] as String,
      female: json['female'] as bool?,
      enableScorer: json['enable_scorer'] as bool?,
      shortName: json['short_name'] as String?,
      seasonId: json['season_id'] as String?,
      orderKey: json['order_key'] as String?,
      gameDayNumbers: parseListOfInt(json, 'game_day_numbers'),
      gameDayTitles: gameDayTitlesJson
          .map((title) => parseGameDayTitle(title))
          .toList(),
      deadline: json['deadline'] as String?,
      beforeDeadline: json['before_deadline'] as bool?,
      legacyLeague: json['legacy_league'] as bool?,
      fieldSize: json['field_size'] as String?,
      leagueModus: json['league_modus'] as String?,
      hasPreround: json['has_preround'] as bool?,
      tableModus: json['table_modus'] as String?,
      periods: parseNullableInt(json, 'periods'),
      periodLength: parseNullableInt(json, 'period_length'),
      overtimeLength: parseNullableInt(json, 'overtime_length'),
    );
  }
