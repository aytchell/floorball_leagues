import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/models/game_operation.dart';

GameOperation parseGameOperation(Map<String, dynamic> json) {
  final logoUrlStr = json['logo_url'] as String?;
  final logoQuadUrlStr = json['logo_quad_url'] as String?;

  return GameOperation(
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
