import '../models/player.dart';
import 'int_parser.dart';
import 'string_parser.dart';

Player parsePlayer(Map<String, dynamic> json) {
  return Player(
    playerId: parseInt(json, 'player_id'),
    playerName: parseString(json, 'player_name'),
    trikotNumber: parseInt(json, 'trikot_number'),
    playerFirstname: parseString(json, 'player_firstname'),
    position: parseString(json, 'position'),
    goalkeeper: json['goalkeeper'] as bool?,
    captain: json['captain'] as bool?,
  );
}
