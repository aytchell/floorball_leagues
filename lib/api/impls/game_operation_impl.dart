import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/api/impls/game_operation_league_impl.dart';
import 'package:floorball/net/rest_client.dart';

import 'package:floorball/api/models/game_operation.dart';

class GameOperationImpl extends GameOperation {
  final RestClient client;

  GameOperationImpl({
    required this.client,
    required super.id,
    required super.name,
    super.shortName,
    required super.path,
    super.logoUrl,
    super.logoQuadUrl,
  });

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
  Stream<Future<List<GameOperationLeague>>> getLeagues(int seasonId) {
    return client.streamApiData(
      '/api/v2/game_operations/$id/leagues/$seasonId.json',
      (data) {
        final json = data as List<dynamic>;
        return json
            .map((gameOp) => GameOperationLeagueImpl.fromJson(client, gameOp))
            .toList();
      },
    );
  }
}
