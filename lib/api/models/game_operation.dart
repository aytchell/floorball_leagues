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
