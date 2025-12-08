import 'package:floorball/api/models/player.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

Player parsePlayer(Map<String, dynamic> json) {
  return Player(
    playerId: parseInt(json, 'player_id'),
    playerName: parseString(json, 'player_name'),
    jerseyNumber: parseInt(json, 'trikot_number'),
    playerFirstname: parseString(json, 'player_firstname'),
    position: parseString(json, 'position'),
    goalkeeper: json['goalkeeper'] as bool?,
    captain: json['captain'] as bool?,
  );
}

Players parsePlayers(Map<String, dynamic> json) {
  var homeJson = json['home'] as List? ?? [];
  var guestJson = json['guest'] as List? ?? [];

  return Players(
    home: homeJson.map((player) => parsePlayer(player)).toList(),
    guest: guestJson.map((player) => parsePlayer(player)).toList(),
  );
}
