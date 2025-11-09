import 'game_day_title.dart';
import 'scorer.dart';
import 'game.dart';
import 'league_table_row.dart';
import 'champ_group_table.dart';
import 'date_formatter.dart';

enum LeagueType { league, champ, cup }

abstract class League {
  int id;
  int federationId;
  String federationName;
  String? federationShortName;
  String? federationSlug;
  String? leagueCategoryId;
  String? leagueClassId;
  String? leagueSystemId;
  LeagueType leagueType;
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

  League({
    required this.id,
    required this.federationId,
    required this.federationName,
    this.federationShortName,
    this.federationSlug,
    this.leagueCategoryId,
    this.leagueClassId,
    this.leagueSystemId,
    required this.leagueType,
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

  Stream<Future<List<Scorer>>> getScorers();
  Stream<Future<List<LeagueTableRow>>> getLeagueTable();
  Stream<Future<List<ChampGroupTable>>> getChampTable();
}
