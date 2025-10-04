import 'package:floorball/api/models/award.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

Award parseAward(Map<String, dynamic> json) {
  return Award(
    award: parseString(json, 'award'),
    team: parseString(json, 'team'),
    playerId: parseNullableInt(json, 'player_id'),
    playerFirstname: parseNullableString(json, 'player_firstname'),
    playerName: parseNullableString(json, 'player_name'),
    trikotNumber: parseNullableInt(json, 'trikot_number'),
  );
}

Awards parseAwards(Map<String, dynamic> json) {
  var homeJson = json['home'] as List? ?? [];
  var guestJson = json['guest'] as List? ?? [];

  return Awards(
    home: homeJson.map((award) => parseAward(award)).toList(),
    guest: guestJson.map((award) => parseAward(award)).toList(),
  );
}
