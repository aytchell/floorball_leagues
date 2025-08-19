import '../../net/rest_client.dart';
import '../models/entry_info.dart';
import '../../api_models/int_parser.dart';

// Data models for init.json from saisonmanager
class SeasonInfoImpl extends SeasonInfo {
  SeasonInfoImpl({required int id, required String name, bool current = false})
    : super(id: id, name: name, current: current);

  factory SeasonInfoImpl.fromJson(Map<String, dynamic> json) {
    return SeasonInfoImpl(
      id: parseInt(json, 'id'),
      name: json['name'] as String,
      current: json['current'] as bool? ?? false,
    );
  }
}

class GameOperationImpl extends GameOperation {
  GameOperationImpl({
    required int id,
    required String name,
    String? shortName,
    required String path,
    Uri? logoUrl,
    Uri? logoQuadUrl,
  }) : super(
         id: id,
         name: name,
         shortName: shortName,
         path: path,
         logoUrl: logoUrl,
         logoQuadUrl: logoQuadUrl,
       );

  factory GameOperationImpl.fromJson(Map<String, dynamic> json) {
    final logoUrlStr = json['logo_url'] as String?;
    final logoQuadUrlStr = json['logo_quad_url'] as String?;

    return GameOperationImpl(
      id: parseInt(json, 'id'),
      name: json['name'] as String,
      shortName: json['short_name'] as String?,
      path: json['path'] as String,
      logoUrl: logoUrlStr != null ? Uri.parse(logoUrlStr.trim()) : null,
      logoQuadUrl: logoQuadUrlStr != null
          ? Uri.parse(logoQuadUrlStr.trim())
          : null,
    );
  }
}

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
    final uri = Uri.parse('https://www.saisonmanager.de/api/v2/init.json');
    final jsonData = await client.getJson(uri) as Map<String, dynamic>;
    return EntryInfoImpl.fromJson(jsonData);
    return null;
  }

  factory EntryInfoImpl.fromJson(Map<String, dynamic> json) {
    var seasonsJson = json['seasons'] as List? ?? [];
    var operationsJson = json['game_operations'] as List? ?? [];
    return EntryInfoImpl(
      seasons: seasonsJson
          .map((seasonJson) => SeasonInfoImpl.fromJson(seasonJson))
          .toList(),
      currentSeasonId: parseNullableInt(json, 'current_season_id'),
      gameOperations: operationsJson
          .map((operationJson) => GameOperationImpl.fromJson(operationJson))
          .toList(),
    );
  }
}
