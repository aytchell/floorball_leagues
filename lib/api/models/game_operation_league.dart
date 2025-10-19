import 'game_day_title.dart';
import 'scorer.dart';
import 'game.dart';
import 'league_table_row.dart';
import 'champ_group_table.dart';
import 'date_formatter.dart';

abstract class GameOperationLeague {
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

  String? get beautifiedDeadline => beautifyDate(deadline!);

  Stream<Future<List<Game>>> getGames(int gameDayNumber);

  Future<List<Game>> getGamesTheOldWay(int gameDayNumber);
  Future<List<Scorer>> getScorers();
  Future<List<LeagueTableRow>> getLeagueTable();
  Future<List<ChampGroupTable>> getChampTable();
}
