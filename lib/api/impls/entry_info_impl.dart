import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/impls/int_parser.dart';

import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/impls/season_info_parser.dart';
import 'package:floorball/api/impls/game_operation_impl.dart';

class EntryInfoImpl extends EntryInfo {
  EntryInfoImpl({
    required super.seasons,
    super.currentSeasonId,
    required super.gameOperations,
  });

  static Stream<Future<EntryInfo>> fetchFromServer(RestClient client) {
    return client.streamApiData(
      '/api/v2/init.json',
      (data) => EntryInfoImpl.fromJson(client, data as Map<String, dynamic>),
    );
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
