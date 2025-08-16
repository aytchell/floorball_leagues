import '../net/rest_client.dart';
import 'int_parser.dart';

// Data models for leagues and cups from saisonmanager
class GameDayTitle {
  int gameDayNumber;
  String title;

  GameDayTitle({required this.gameDayNumber, required this.title});

  factory GameDayTitle.fromJson(Map<String, dynamic> json) {
    return GameDayTitle(
      gameDayNumber: parseInt(json, 'game_day_number'),
      title: json['title'] as String,
    );
  }
}

class GameOperationLeague {
  int id;
  int gameOperationId;
  String gameOperationName;
  String? gameOperationShortName;
  String? gameOperationSlug;
  String? leagueCategoryId;
  String? leagueClassId;
  String? leagueSystemId;
  String? leagueType;
  String name;
  bool? female;
  bool? enableScorer;
  String? shortName;
  String? seasonId;
  String? orderKey;
  List<int> gameDayNumbers;
  List<GameDayTitle> gameDayTitles;
  String? deadline;
  bool? beforeDeadline;
  bool? legacyLeague;
  String? fieldSize;
  String? leagueModus;
  bool? hasPreround;
  String? tableModus;
  int? periods;
  int? periodLength;
  int? overtimeLength;

  GameOperationLeague({
    required this.id,
    required this.gameOperationId,
    required this.gameOperationName,
    this.gameOperationShortName,
    this.gameOperationSlug,
    this.leagueCategoryId,
    this.leagueClassId,
    this.leagueSystemId,
    this.leagueType,
    required this.name,
    this.female,
    this.enableScorer,
    this.shortName,
    this.seasonId,
    this.orderKey,
    required this.gameDayNumbers,
    required this.gameDayTitles,
    this.deadline,
    this.beforeDeadline,
    this.legacyLeague,
    this.fieldSize,
    this.leagueModus,
    this.hasPreround,
    this.tableModus,
    this.periods,
    this.periodLength,
    this.overtimeLength,
  });

  factory GameOperationLeague.fromJson(Map<String, dynamic> json) {
    var gameDayTitlesJson = json['game_day_titles'] as List;

    return GameOperationLeague(
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
          .map((title) => GameDayTitle.fromJson(title))
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
}

class AllOperationLeagues {
  static Future<List<GameOperationLeague>?> fetchFromServer(
    RestClient client,
    int gameOperationId,
    int seasonId,
  ) async {
    final uri = Uri.parse(
      'https://www.saisonmanager.de/api/v2/game_operations/$gameOperationId/leagues/$seasonId.json',
    );

    final jsonData = await client.getJson(uri) as List<dynamic>;
    return jsonData
        .map((gameOp) => GameOperationLeague.fromJson(gameOp))
        .toList();
    return null;
  }
}
