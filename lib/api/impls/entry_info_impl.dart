import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/impls/int_parser.dart';

import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/api/models/game_operation.dart';
import 'package:floorball/api/impls/season_info_parser.dart';
import 'package:floorball/api/impls/game_operation_impl.dart';

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
