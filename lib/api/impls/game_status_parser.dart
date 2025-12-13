import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/game_status.dart';
import 'package:logging/logging.dart';

final log = Logger('GameParser');

GameStatus _parseGameStatus(String state) {
  // this method might grow in the future as I don't have a spec on
  // how to interpret the various result types
  switch (state) {
    case 'ended':
      return GameStatus.ended;
    case 'no_record':
      return GameStatus.noRecord;
    case 'record_created':
      return GameStatus.recordCreated;
    case 'running':
      return GameStatus.running;
    case 'match_record_closed':
      return GameStatus.matchRecordClosed;
    default:
      {
        log.warning('Unknown game status: "$state"');
        return GameStatus.recordCreated;
      }
  }
}

GameStatus parseGameStatus(Map<String, dynamic> json, String key) {
  final state = parseString(json, key);
  return _parseGameStatus(state);
}

GameStatus? parseNullableGameStatus(Map<String, dynamic> json, String key) {
  final state = parseNullableString(json, key);

  if (state == null) {
    return null;
  }
  return _parseGameStatus(state);
}
