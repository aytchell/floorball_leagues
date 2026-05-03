import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/models/breaking_changes.dart';

import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/impls/season_info_parser.dart';
import 'package:floorball/api/impls/federation_parser.dart';
import 'package:floorball/api/models/season_info.dart';

EntryInfo parseEntryInfo(Map<String, dynamic> json) {
  var seasonsJson = json['seasons'] as List? ?? [];
  var federationsListJson = json['game_operations'] as List? ?? [];
  return EntryInfo(
    seasons: seasonsJson
        .map((seasonJson) => parseSeasonInfo(seasonJson))
        .where((season) => _isActuallyAvailable(season))
        .toList(),
    currentSeasonId: parseNullableInt(json, 'current_season_id'),
    frederations: federationsListJson
        .map((federationJson) => parseFederation(federationJson))
        .toList(),
  );
}

// The Saisonmanager announces some seasons which are actually not available
bool _isActuallyAvailable(SeasonInfo season) =>
    season.id >= BreakingChanges.earliestAvailableSeasonId;
