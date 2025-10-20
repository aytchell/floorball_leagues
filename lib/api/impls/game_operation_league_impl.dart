import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/impls/game_impl.dart';
import 'package:floorball/api/impls/game_day_title_parser.dart';
import 'package:floorball/api/impls/scorer_fetcher.dart';
import 'package:floorball/api/impls/league_table_fetcher.dart';
import 'package:floorball/api/impls/champ_table_fetcher.dart';

import 'package:floorball/api/impls/int_parser.dart';

class GameOperationLeagueImpl extends GameOperationLeague {
  final RestClient client;

  GameOperationLeagueImpl({
    required this.client,
    required int id,
    required int gameOperationId,
    required String gameOperationName,
    String? gameOperationShortName,
    String? gameOperationSlug,
    String? leagueCategoryId,
    String? leagueClassId,
    String? leagueSystemId,
    String? leagueType,
    required String name,
    bool? female,
    bool? enableScorer,
    String? shortName,
    String? seasonId,
    String? orderKey,
    required List<int> gameDayNumbers,
    required List<GameDayTitle> gameDayTitles,
    String? deadline,
    bool? beforeDeadline,
    bool? legacyLeague,
    String? fieldSize,
    String? leagueModus,
    bool? hasPreround,
    String? tableModus,
    int? periods,
    int? periodLength,
    int? overtimeLength,
  }) : super(
         id: id,
         gameOperationId: gameOperationId,
         gameOperationName: gameOperationName,
         gameOperationShortName: gameOperationShortName,
         gameOperationSlug: gameOperationSlug,
         leagueCategoryId: leagueCategoryId,
         leagueClassId: leagueClassId,
         leagueSystemId: leagueSystemId,
         leagueType: leagueType,
         name: name,
         female: female,
         enableScorer: enableScorer,
         shortName: shortName,
         seasonId: seasonId,
         orderKey: orderKey,
         gameDayNumbers: gameDayNumbers,
         gameDayTitles: gameDayTitles,
         deadline: deadline,
         beforeDeadline: beforeDeadline,
         legacyLeague: legacyLeague,
         fieldSize: fieldSize,
         leagueModus: leagueModus,
         hasPreround: hasPreround,
         tableModus: tableModus,
         periods: periods,
         periodLength: periodLength,
         overtimeLength: overtimeLength,
       );

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

  Stream<Future<List<Game>>> getGames(int gameDayNumber) {
    return client.streamApiData(
      '/api/v2/leagues/$id/game_days/$gameDayNumber/schedule.json',
      (data) {
        final json = data as List<dynamic>;
        return json.map((game) => GameImpl.fromJson(client, game)).toList();
      },
    );
  }

  @override
  Stream<Future<List<Scorer>>> getScorers() {
    return fetchScorers(client, id);
  }

  Stream<Future<List<LeagueTableRow>>> getLeagueTable() {
    return fetchLeagueTableFromServer(client, id);
  }

  Stream<Future<List<ChampGroupTable>>> getChampTable() {
    return fetchChampTableFromServer(client, id);
  }
}
