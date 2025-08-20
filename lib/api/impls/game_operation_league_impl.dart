import '../../net/rest_client.dart';
import '../models/game_operation_league.dart';
import '../models/game_day_title.dart';
import '../models/scorer.dart';
import '../../api_models/game.dart';
import 'game_day_title_parser.dart';
import 'scorer_fetcher.dart';
import 'int_parser.dart';

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

  Future<List<Game>> getGames(int gameDayNumber) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/leagues/$id/game_days/$gameDayNumber/schedule.json',
    );

    final jsonData = await client.getJson(uri) as List<dynamic>;
    return jsonData.map((game) => Game.fromJson(game)).toList();
  }

  Future<List<Scorer>> getScorers() async {
    return fetchScorers(client, id);
  }
}
