import 'package:floorball/api/impls/game_impl.dart';
import 'package:floorball/api/impls/scorer_parser.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/impls/entry_info_parser.dart';
import 'package:flutter/cupertino.dart';

import 'impls/game_operation_league_impl.dart';
import 'impls/league_table_fetcher.dart';
import 'models/game_operation_league.dart';

class ApiRepository {
  Future<Stream<EntryInfo>> getStart() {
    return RestClient.instance.then(
      (client) => client.streamApiDataSync(
        '/api/v2/init.json',
        (data) => parseEntryInfo(data as Map<String, dynamic>),
      ),
    );
  }

  Future<Stream<List<GameOperationLeague>>> getLeagues(
    int seasonId,
    int gameOperationId,
  ) => RestClient.instance.then(
    (client) => client.streamApiDataSync(
      '/api/v2/game_operations/$gameOperationId/leagues/$seasonId.json',
      (data) {
        final json = data as List<dynamic>;
        return json
            .map((gameOp) => GameOperationLeagueImpl.fromJson(client, gameOp))
            .toList();
      },
    ),
  );

  Future<Stream<List<Game>>> getGamesOfGameDay(
    int leagueId,
    int gameDayNumber,
  ) => RestClient.instance.then(
    (client) => client.streamApiDataSync(
      '/api/v2/leagues/$leagueId/game_days/$gameDayNumber/schedule.json',
      (data) {
        final json = data as List<dynamic>;
        return json.map((game) => GameImpl.fromJson(client, game)).toList();
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
}
