import '../../net/rest_client.dart';
import 'int_parser.dart';

import '../models/entry_info.dart';
import '../models/season_info.dart';
import '../models/game_operation.dart';
import 'season_info_parser.dart';
import 'game_operation_impl.dart';

class EntryInfoImpl extends EntryInfo {
  EntryInfoImpl({
    required List<SeasonInfo> seasons,
    int? currentSeasonId,
    required List<GameOperation> gameOperations,
  }) : super(
         seasons: seasons,
         currentSeasonId: currentSeasonId,
         gameOperations: gameOperations,
       );

  static Future<EntryInfo?> fetchFromServer(RestClient client) async {
    final path = '/api/v2/init.json';
    final jsonData = await client.getJsonFromPath(path) as Map<String, dynamic>;
    return EntryInfoImpl.fromJson(client, jsonData);
    return null;
  }

  factory EntryInfoImpl.fromJson(RestClient client, Map<String, dynamic> json) {
    var seasonsJson = json['seasons'] as List? ?? [];
    var operationsJson = json['game_operations'] as List? ?? [];
    return EntryInfoImpl(
      seasons: seasonsJson
          .map((seasonJson) => parseSeasonInfo(seasonJson))
          .toList(),
      currentSeasonId: parseNullableInt(json, 'current_season_id'),
      gameOperations: operationsJson
          .map(
            (operationJson) =>
                GameOperationImpl.fromJson(client, operationJson),
          )
          .toList(),
    );
  }
}
