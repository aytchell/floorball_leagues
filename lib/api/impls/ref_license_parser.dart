import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/ref_license.dart';

RefLicense parseRefLicense(Map<String, dynamic> json) => RefLicense(
  licenseId: parseInt(json, 'lizenznummer'),
  licenseType: parseString(json, 'lizenzstufe'),
  validUntil: parseString(json, 'gueltigkeit'),
  club: parseString(json, 'verein'),
  federation: parseString(json, 'landesverband'),
);

/*
Example of a json response
{
  "lizenznummer":2685,
  "lizenzstufe":"L2",
  "gueltigkeit":"31.07.2026",
  "landesverband":" Floorball Verband Bayern e.V.",
  "verein":"Floorball-Club München",
  "qualifications":[]
}
*/
