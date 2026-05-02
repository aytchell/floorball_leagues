import 'package:floorball/api/models/player.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

Player parsePlayer(Map<String, dynamic> json) {
  return Player(
    playerId: parseInt(json, 'player_id'),
    playerName: _parsePlayerName(json),
    jerseyNumber: parseNullableInt(json, 'trikot_number'),
    playerFirstname: parseString(json, 'player_firstname'),
    position: parseString(json, 'position'),
    goalkeeper: json['goalkeeper'] as bool?,
    captain: json['captain'] as bool?,
  );
}

// ok, this is super weird: there is this one single game at
// https://2324.archiv.saisonmanager.de/ost/1475-u11-junioren-kleinfeld-platzierungsrunde-ost/spiel/35372
// Where Floor Fighters player nr 80 doesn't have a "player_name" but instead
// a "plaayer_name". I don't have any idea how this can happen ...
String _parsePlayerName(Map<String, dynamic> json) =>
    parseNullableString(json, 'player_name') ??
    parseNullableString(json, 'plaayer_name') ??
    "";

Players parsePlayers(Map<String, dynamic> json) {
  var homeJson = json['home'] as List? ?? [];
  var guestJson = json['guest'] as List? ?? [];

  return Players(
    home: homeJson.map((player) => parsePlayer(player)).toList(),
    guest: guestJson.map((player) => parsePlayer(player)).toList(),
  );
}
