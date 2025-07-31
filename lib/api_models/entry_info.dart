import '../net/rest_client.dart';

// Data models for init.json from saisonmanager
class SeasonInfo {
  int? id;
  String? name;
  bool current = false;

  SeasonInfo({this.id, this.name, this.current = false});

  factory SeasonInfo.fromJson(Map<String, dynamic> json) {
    return SeasonInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      current: json['current'] as bool? ?? false,
    );
  }
}

class GameOperation {
  int? id;
  String? name;
  String? shortName;
  String? path;
  Uri? logoUrl;
  Uri? logoQuadUrl;

  GameOperation({
    this.id,
    this.name,
    this.shortName,
    this.path,
    this.logoUrl,
    this.logoQuadUrl,
  });

  factory GameOperation.fromJson(Map<String, dynamic> json) {
    final logoUrlStr = json['logo_url'] as String?;
    final logoQuadUrlStr = json['logo_quad_url'] as String?;

    return GameOperation(
      id: json['id'] as int?,
      name: json['name'] as String?,
      shortName: json['short_name'] as String?,
      path: json['path'] as String?,
      logoUrl: logoUrlStr != null ? Uri.parse(logoUrlStr.trim()) : null,
      logoQuadUrl: logoQuadUrlStr != null
          ? Uri.parse(logoQuadUrlStr.trim())
          : null,
    );
  }
}

class EntryInfo {
  final List<SeasonInfo> seasons;
  final int? currentSeasonId;
  final List<GameOperation> gameOperations;

  EntryInfo({
    required this.seasons,
    this.currentSeasonId,
    required this.gameOperations,
  });

  static Future<EntryInfo?> fetchFromServer(RestClient client) async {
    final uri = Uri.parse('https://www.saisonmanager.de/api/v2/init.json');
    final jsonData = await client.getJson(uri) as Map<String, dynamic>;
    return EntryInfo.fromJson(jsonData);
    return null;
  }

  factory EntryInfo.fromJson(Map<String, dynamic> json) {
    var seasonsJson = json['seasons'] as List? ?? [];
    var operationsJson = json['game_operations'] as List? ?? [];
    return EntryInfo(
      seasons: seasonsJson
          .map((seasonJson) => SeasonInfo.fromJson(seasonJson))
          .toList(),
      currentSeasonId: json['current_season_id'] as int?,
      gameOperations: operationsJson
          .map((operationJson) => GameOperation.fromJson(operationJson))
          .toList(),
    );
  }
}
