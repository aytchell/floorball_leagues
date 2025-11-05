import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/impls/game_parser.dart';
import 'package:floorball/api/impls/game_day_title_parser.dart';
import 'package:floorball/api/impls/scorer_parser.dart';
import 'package:floorball/api/impls/league_table_fetcher.dart';
import 'package:floorball/api/impls/champ_table_fetcher.dart';

import 'package:floorball/api/impls/int_parser.dart';

class GameOperationLeagueImpl extends GameOperationLeague {
  final RestClient client;

  GameOperationLeagueImpl({
    required this.client,
    required super.id,
    required super.gameOperationId,
    required super.gameOperationName,
    super.gameOperationShortName,
    super.gameOperationSlug,
    super.leagueCategoryId,
    super.leagueClassId,
    super.leagueSystemId,
    super.leagueType,
    required super.name,
    super.female,
    super.enableScorer,
    super.shortName,
    super.seasonId,
    super.orderKey,
    required super.gameDayNumbers,
    required super.gameDayTitles,
    super.deadline,
    super.beforeDeadline,
    super.legacyLeague,
    super.fieldSize,
    super.leagueModus,
    super.hasPreround,
    super.tableModus,
    super.periods,
    super.periodLength,
    super.overtimeLength,
  });

  factory GameOperationLeagueImpl.fromJson(
    RestClient client,
    Map<String, dynamic> json,
  ) {
    var gameDayTitlesJson = json['game_day_titles'] as List;

    return GameOperationLeagueImpl(
      client: client,
      id: parseInt(json, 'id'),
      gameOperationId: parseInt(json, 'game_operation_id'),
      gameOperationName: json['game_operation_name'] as String,
      gameOperationShortName: json['game_operation_short_name'] as String?,
      gameOperationSlug: json['game_operation_slug'] as String?,
      leagueCategoryId: json['league_category_id'] as String?,
      leagueClassId: json['league_class_id'] as String?,
      leagueSystemId: json['league_system_id'] as String?,
      leagueType: json['league_type'] as String?,
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

  @override
  Stream<Future<List<Game>>> getGames(int gameDayNumber) {
    return client.streamApiData(
      '/api/v2/leagues/$id/game_days/$gameDayNumber/schedule.json',
      (data) {
        final json = data as List<dynamic>;
        return json.map((game) => parseGame(game)).toList();
      },
    );
  }

  @override
  Stream<Future<List<Scorer>>> getScorers() {
    return fetchScorers(client, id);
  }

  @override
  Stream<Future<List<LeagueTableRow>>> getLeagueTable() {
    return fetchLeagueTableFromServer(client, id);
  }

  @override
  Stream<Future<List<ChampGroupTable>>> getChampTable() {
    return fetchChampTableFromServer(client, id);
  }
}
