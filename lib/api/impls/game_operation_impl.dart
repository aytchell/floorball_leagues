import 'int_parser.dart';
import '../models/game_operation_league.dart';
import 'game_operation_league_impl.dart';
import '../../net/rest_client.dart';

import '../models/game_operation.dart';

class GameOperationImpl extends GameOperation {
  final RestClient client;

  GameOperationImpl({
    required this.client,
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

  factory GameOperationImpl.fromJson(
    RestClient client,
    Map<String, dynamic> json,
  ) {
    final logoUrlStr = json['logo_url'] as String?;
    final logoQuadUrlStr = json['logo_quad_url'] as String?;

    return GameOperationImpl(
      client: client,
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

  @override
  Future<List<GameOperationLeague>?> getLeagues(int seasonId) async {
    final path = '/api/v2/game_operations/$id/leagues/$seasonId.json';

    final jsonData = await client.getJsonFromPath(path) as List<dynamic>;
    return jsonData
        .map((gameOp) => GameOperationLeagueImpl.fromJson(client, gameOp))
        .toList();
    return null;
  }
}
