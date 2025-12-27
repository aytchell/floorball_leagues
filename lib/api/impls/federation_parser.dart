import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/federation.dart';

Federation parseFederation(Map<String, dynamic> json) {
  final logoUrlStr = parseNullableString(json, 'logo_url');
  final logoQuadUrlStr = parseNullableString(json, 'logo_quad_url');

  return Federation(
    id: parseInt(json, 'id'),
    name: parseString(json, 'name'),
    shortName: parseNullableString(json, 'short_name'),
    path: parseString(json, 'path'),
    logoUrl: logoUrlStr != null ? Uri.parse(logoUrlStr.trim()) : null,
    logoQuadUrl: logoQuadUrlStr != null
        ? Uri.parse(logoQuadUrlStr.trim())
        : null,
  );
}
