import 'package:floorball/api/impls/champ_table_fetcher.dart';
import 'package:floorball/api/impls/detailed_game_fetcher.dart';
import 'package:floorball/api/impls/game_parser.dart';
import 'package:floorball/api/impls/scorer_fetcher.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/impls/entry_info_parser.dart';

import 'impls/league_parser.dart';
import 'impls/league_table_fetcher.dart';
import 'models/league.dart';

class ApiRepository {
  Future<Stream<EntryInfo>> getStart() {
    return RestClient.instance.then(
      (client) => client.streamApiDataSync(
        '/api/v2/init.json',
        (data) => parseEntryInfo(data as Map<String, dynamic>),
      ),
    );
  }

  Future<Stream<List<League>>> getLeagues(int seasonId, int federationId) =>
      RestClient.instance.then(
        (client) => client.streamApiDataSync(
          '/api/v2/game_operations/$federationId/leagues/$seasonId.json',
          (data) {
            final json = data as List<dynamic>;
            return json.map((league) => parseLeague(league)).toList();
          },
        ),
      );

  Future<Stream<League>> getLeagueById(int leagueId) =>
      RestClient.instance.then(
        (client) =>
            client.streamApiDataSync('/api/v2/leagues/$leagueId.json', (data) {
              final json = data as Map<String, dynamic>;
              return parseLeague(json);
            }),
      );

  Future<Stream<List<Game>>> getGamesOfGameDay(
    int leagueId,
    int gameDayNumber,
  ) => RestClient.instance.then(
    (client) => client.streamApiDataSync(
      '/api/v2/leagues/$leagueId/game_days/$gameDayNumber/schedule.json',
      (data) {
        final json = data as List<dynamic>;
        return json.map((game) => parseGame(game)).toList();
      },
    ),
  );

  Future<Stream<List<LeagueTableRow>>> getLeagueTable(int leagueId) =>
      RestClient.instance.then(
        (client) => client.streamApiDataSync(
          '/api/v2/leagues/$leagueId/table.json',
          (data) {
            final json = data as List<dynamic>;
            return json.map((row) => parseLeagueTableRow(row)).toList();
          },
        ),
      );

  Future<Stream<List<ChampGroupTable>>> getChampTable(int leagueId) =>
      RestClient.instance.then(
        (client) => client.streamApiDataSync(
          '/api/v2/leagues/$leagueId/grouped_table.json',
          (data) {
            final json = data as Map<String, dynamic>;
            return json
                .map((key, value) => MapEntry(key, parseChampGroupTable(value)))
                .values
                .toList();
          },
        ),
      );

  Future<Stream<List<Scorer>>> getLeagueScorers(int leagueId) =>
      RestClient.instance.then(
        (client) => client.streamApiDataSync(
          '/api/v2/leagues/$leagueId/scorer.json',
          (data) {
            final json = data as List<dynamic>;
            return json.map((entry) => parseScorer(entry)).toList();
          },
        ),
      );

  Future<Stream<DetailedGame>> getDetailedGame(int gameId) =>
      RestClient.instance.then(
        (client) => client.streamApiDataSync(
          '/api/v2/games/$gameId.json',
          (data) => parseDetailedGame(data as Map<String, dynamic>),
        ),
      );
}
