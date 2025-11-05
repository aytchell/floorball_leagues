import 'package:floorball/api/models/game.dart';

import 'package:floorball/api/impls/game_result_parser.dart';
import 'package:floorball/api/impls/referee_parser.dart';
import 'package:floorball/api/impls/period_title_parser.dart';
import 'package:floorball/api/impls/int_parser.dart';

Game parseGame(Map<String, dynamic> json) {
  var refereesJson = json['referees'] as List;
  var rawTitle = json['current_period_title'] as Map<String, dynamic>?;
  var rawResult = json['result'] as Map<String, dynamic>?;

  return Game(
    gameId: parseInt(json, 'game_id'),
    gameNumber: parseInt(json, 'game_number'),
    gameDay: parseInt(json, 'game_day'),
    arenaId: parseNullableInt(json, 'arena'),
    arenaName: json['arena_name'] as String?,
    arenaAddress: json['arena_address'] as String?,
    arenaShort: json['arena_short'] as String?,
    hostingClub: json['hosting_club'] as String?,
    gameDayId: parseInt(json, 'game_day_id'),
    date: json['date'] as String?,
    time: json['time'] as String?,
    started: json['started'] as bool,
    ended: json['ended'] as bool,
    homeTeamName: json['home_team_name'] as String?,
    homeTeamLogo: json['home_team_logo'] as String?,
    homeTeamSmallLogo: json['home_team_small_logo'] as String?,
    guestTeamName: json['guest_team_name'] as String?,
    guestTeamLogo: json['guest_team_logo'] as String?,
    guestTeamSmallLogo: json['guest_team_small_logo'] as String?,
    nominatedRefereeString: json['nominated_referee_string'] as String?,
    referees: refereesJson.map((referee) => parseReferee(referee)).toList(),
    noticeType: json['notice_type'] as String?,
    noticeString: json['notice_string'] as String?,
    state: json['state'] as String,
    currentPeriodTitle: rawTitle != null ? parsePeriodTitle(rawTitle) : null,
    groupIdentifier: json['group_identifier'] as String?,
    seriesTitle: json['series_title'] as String?,
    seriesNumber: json['series_number'] as String?,
    homeTeamFillingRule: json['home_team_filling_rule'] as String?,
    homeTeamFillingTitle: json['home_team_filling_title'] as String?,
    homeTeamFillingParameter: parseNullableInt(
      json,
      'home_team_filling_parameter',
    ),
    guestTeamFillingRule: json['guest_team_filling_rule'] as String?,
    guestTeamFillingTitle: json['guest_team_filling_title'] as String?,
    guestTeamFillingParameter: parseNullableInt(
      json,
      'guest_team_filling_parameter',
    ),
    resultString: json['result_string'] as String?,
    result: rawResult != null ? parseGameResult(rawResult) : null,
  );
}
