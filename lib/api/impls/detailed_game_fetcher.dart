import 'package:floorball/net/rest_client.dart';

import 'package:floorball/api/models/logo_host.dart';
import 'package:floorball/api/models/detailed_game.dart';

import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

import 'package:floorball/api/impls/game_result_parser.dart';
import 'package:floorball/api/impls/period_title_parser.dart';
import 'package:floorball/api/impls/referee_parser.dart';
import 'package:floorball/api/impls/game_day_parser.dart';
import 'package:floorball/api/impls/game_event_parser.dart';
import 'package:floorball/api/impls/player_parser.dart';
import 'package:floorball/api/impls/starting_player_parser.dart';
import 'package:floorball/api/impls/award_parser.dart';

DetailedGame _parseDetailedGame(Map<String, dynamic> json) {
  var eventsJson = json['events'] as List;
  var periodTitlesJson = json['period_titles'] as List;
  var refereesJson = json['referees'] as List;
  var startingPlayers = (json['starting_players'] == null)
      ? null
      : parseStartingPlayers(json['starting_players']);
  final awards = (json['awards'] == null) ? null : parseAwards(json['awards']);

  return DetailedGame(
    id: parseInt(json, 'id'),
    gameNumber: parseString(json, 'game_number'),
    startTime: parseNullableString(json, 'start_time'),
    actualStartTime: parseNullableString(json, 'actual_start_time'),
    date: parseString(json, 'date'),
    gameDay: parseGameDay(json['game_day']),
    gameStatus: parseNullableString(json, 'game_status'),
    ingameStatus: parseNullableString(json, 'ingame_status'),
    audience: parseNullableInt(json, 'audience'),
    homeTeamName: parseString(json, 'home_team_name'),
    guestTeamName: parseString(json, 'guest_team_name'),
    homeTeamId: parseInt(json, 'home_team_id'),
    guestTeamId: parseInt(json, 'guest_team_id'),
    homeTeamLogo: parseString(json, 'home_team_logo'),
    homeTeamSmallLogo: parseString(json, 'home_team_small_logo'),
    guestTeamLogo: parseString(json, 'guest_team_logo'),
    guestTeamSmallLogo: parseString(json, 'guest_team_small_logo'),
    liveStreamLink: parseNullableString(json, 'live_stream_link'),
    vodLink: parseNullableString(json, 'vod_link'),
    events: eventsJson.map((event) => parseGameEvent(event)).toList(),
    players: parsePlayers(json['players'] ?? {}),
    startingPlayers: startingPlayers,
    awards: awards,
    started: json['started'] as bool,
    ended: json['ended'] as bool,
    resultString: parseNullableString(json, 'result_string'),
    result: json['result'] != null ? parseGameResult(json['result']) : null,
    leagueId: parseInt(json, 'league_id'),
    leagueName: parseString(json, 'league_name'),
    leagueShortName: parseString(json, 'league_short_name'),
    gameOperationId: parseInt(json, 'game_operation_id'),
    gameOperationName: parseString(json, 'game_operation_name'),
    gameOperationShortName: parseString(json, 'game_operation_short_name'),
    gameOperationSlug: parseString(json, 'game_operation_slug'),
    periodTitles: periodTitlesJson
        .map((title) => parsePeriodTitle(title))
        .toList(),
    currentPeriodTitle: json['current_period_title'] != null
        ? parsePeriodTitle(json['current_period_title'])
        : null,
    arena: parseInt(json, 'arena'),
    arenaName: parseString(json, 'arena_name'),
    arenaAddress: parseString(json, 'arena_address'),
    arenaShort: parseString(json, 'arena_short'),
    nominatedReferees: parseNullableString(json, 'nominated_referees'),
    deletable: json['deletable'] as bool,
    noticeType: parseNullableString(json, 'notice_type'),
    noticeString: parseNullableString(json, 'notice_string'),
    referees: refereesJson.map((referee) => parseReferee(referee)).toList(),
  );
}

// Static method to fetch game data from server
Stream<Future<DetailedGame>> fetchDetailedGame(RestClient client, int gameId) {
  return client.streamApiData(
    '/api/v2/games/$gameId.json',
    (data) => _parseDetailedGame(data as Map<String, dynamic>),
  );
}
