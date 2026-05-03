import 'package:floorball/api/models/player.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

Player parsePlayer(Map<String, dynamic> json) {
  final (playerFirstName, playerName) = _parseCompleteName(json);
  return Player(
    playerId: parseNullableInt(json, 'player_id'),
    playerName: playerName,
    jerseyNumber: parseNullableInt(json, 'trikot_number'),
    playerFirstname: playerFirstName,
    position: parseString(json, 'position'),
    goalkeeper: json['goalkeeper'] as bool?,
    captain: json['captain'] as bool?,
  );
}

(String, String) _parseCompleteName(Map<String, dynamic> json) {
  final playerName = _parsePlayerName(json);
  final playerFirstName = parseNullableString(json, 'player_firstname');

  if (playerFirstName != null) {
    return (playerFirstName, playerName);
  }

  // In some very old games (2020 and before) we have players where the
  // player_firstname is null and the player_name contains both parts, e.g
  //        "player_firstname": null,
  //        "player_name": "Mustermann, Max",
  // Since there are also names with two commas, a simple 'split' is
  // not sufficient
  final match = RegExp(r'^(.*?),(.*)$').firstMatch(playerName);
  if (match != null && match.groupCount == 2) {
    return (match.group(2)!.trim(), match.group(1)!.trim());
  }

  // Everything else will be takes as-is (which is better then throwing
  // an exception ...)
  return ('', playerName);
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
