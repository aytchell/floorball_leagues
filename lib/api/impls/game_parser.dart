import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/game.dart';

import 'package:floorball/api/impls/game_result_parser.dart';
import 'package:floorball/api/impls/referee_parser.dart';
import 'package:floorball/api/impls/period_title_parser.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:logging/logging.dart';

final log = Logger('GameParser');

Game parseGame(Map<String, dynamic> json) {
  var refereesJson = json['referees'] as List;
  var rawTitle = json['current_period_title'] as Map<String, dynamic>?;
  var rawResult = json['result'] as Map<String, dynamic>?;

  return Game(
    gameId: parseInt(json, 'game_id'),
    gameNumber: parseInt(json, 'game_number'),
    gameDay: parseInt(json, 'game_day'),
    arenaId: parseNullableInt(json, 'arena'),
    arenaName: parseNullableString(json, 'arena_name'),
    arenaAddress: parseNullableString(json, 'arena_address'),
    arenaShort: parseNullableString(json, 'arena_short'),
    hostingClub: parseNullableString(json, 'hosting_club'),
    gameDayId: parseInt(json, 'game_day_id'),
    date: parseNullableString(json, 'date'),
    time: parseNullableString(json, 'time'),
    started: json['started'] as bool,
    ended: json['ended'] as bool,
    homeTeamName: parseNullableString(json, 'home_team_name'),
    homeTeamLogo: parseNullableString(json, 'home_team_logo'),
    homeTeamSmallLogo: parseNullableString(json, 'home_team_small_logo'),
    guestTeamName: parseNullableString(json, 'guest_team_name'),
    guestTeamLogo: parseNullableString(json, 'guest_team_logo'),
    guestTeamSmallLogo: parseNullableString(json, 'guest_team_small_logo'),
    nominatedRefereeString: parseNullableString(
      json,
      'nominated_referee_string',
    ),
    referees: refereesJson.map((referee) => parseReferee(referee)).toList(),
    noticeType: parseNullableString(json, 'notice_type'),
    noticeString: parseNullableString(json, 'notice_string'),
    state: _parseGameState(json, 'state'),
    currentPeriodTitle: rawTitle != null ? parsePeriodTitle(rawTitle) : null,
    groupIdentifier: parseNullableString(json, 'group_identifier'),
    seriesTitle: parseNullableString(json, 'series_title'),
    seriesNumber: parseNullableString(json, 'series_number'),
    homeTeamFillingRule: parseNullableString(json, 'home_team_filling_rule'),
    homeTeamFillingTitle: parseNullableString(json, 'home_team_filling_title'),
    homeTeamFillingParameter: parseNullableInt(
      json,
      'home_team_filling_parameter',
    ),
    guestTeamFillingRule: parseNullableString(json, 'guest_team_filling_rule'),
    guestTeamFillingTitle: parseNullableString(
      json,
      'guest_team_filling_title',
    ),
    guestTeamFillingParameter: parseNullableInt(
      json,
      'guest_team_filling_parameter',
    ),
    resultString: parseNullableString(json, 'result_string'),
    result: rawResult != null ? parseGameResult(rawResult) : null,
  );
}

GameState _parseGameState(Map<String, dynamic> json, String key) {
  final state = parseString(json, key);

  // this method might grow in the future as I don't have a spec on
  // how to interpret the various result types
  switch (state) {
    case 'no_record':
      return GameState.noRecord;
    case 'record_created':
      return GameState.recordCreated;
    case 'running':
      return GameState.running;
    case 'ended':
      return GameState.ended;
    case 'match_record_closed':
      return GameState.matchRecordClosed;
    default:
      {
        log.warning('Unknown game state: "$state"');
        return GameState.recordCreated;
      }
  }
}
