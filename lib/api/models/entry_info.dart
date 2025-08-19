// Data models for init.json from saisonmanager
class SeasonInfo {
  int id;
  String name;
  bool current = false;

  SeasonInfo({required this.id, required this.name, this.current = false});
}

class GameOperation {
  int id;
  String name;
  String? shortName;
  String path;
  Uri? logoUrl;
  Uri? logoQuadUrl;

  GameOperation({
    required this.id,
    required this.name,
    this.shortName,
    required this.path,
    this.logoUrl,
    this.logoQuadUrl,
  });
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
}
