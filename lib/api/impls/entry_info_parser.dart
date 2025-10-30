import 'package:floorball/api/impls/int_parser.dart';

import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/impls/season_info_parser.dart';
import 'package:floorball/api/impls/game_operation_parser.dart';

EntryInfo parseEntryInfo(Map<String, dynamic> json) {
  var seasonsJson = json['seasons'] as List? ?? [];
  var operationsJson = json['game_operations'] as List? ?? [];
  return EntryInfo(
    seasons: seasonsJson
        .map((seasonJson) => parseSeasonInfo(seasonJson))
        .toList(),
    currentSeasonId: parseNullableInt(json, 'current_season_id'),
    gameOperations: operationsJson
        .map((operationJson) => parseGameOperation(operationJson))
        .toList(),
  );
}
