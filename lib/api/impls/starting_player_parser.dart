import '../models/starting_player.dart';
import 'int_parser.dart';
import 'string_parser.dart';

StartingPlayer parseStartingPlayer(Map<String, dynamic> json) {
  return StartingPlayer(
    position: parseString(json, 'position'),
    team: parseString(json, 'team'),
    playerId: parseNullableInt(json, 'player_id'),
    playerFirstname: parseNullableString(json, 'player_firstname'),
    playerName: parseNullableString(json, 'player_name'),
    trikotNumber: parseNullableInt(json, 'trikot_number'),
  );
}

StartingPlayers parseStartingPlayers(Map<String, dynamic> json) {
  var homeJson = json['home'] as List? ?? [];
  var guestJson = json['guest'] as List? ?? [];

  return StartingPlayers(
    home: homeJson.map((player) => parseStartingPlayer(player)).toList(),
    guest: guestJson.map((player) => parseStartingPlayer(player)).toList(),
  );
}
