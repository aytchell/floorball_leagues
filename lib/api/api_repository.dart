import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/impls/entry_info_parser.dart';

import 'impls/game_operation_league_impl.dart';
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
}
