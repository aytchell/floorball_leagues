import '../../api_models/int_parser.dart';

import '../models/game_operation.dart';

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
