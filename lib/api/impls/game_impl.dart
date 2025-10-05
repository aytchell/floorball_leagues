import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/game.dart';

import 'package:floorball/api/models/referee.dart';
import 'package:floorball/api/models/period_title.dart';
import 'package:floorball/api/models/game_result.dart';
import 'package:floorball/api/models/detailed_game.dart';

import 'package:floorball/api/impls/game_result_parser.dart';
import 'package:floorball/api/impls/referee_parser.dart';
import 'package:floorball/api/impls/period_title_parser.dart';
import 'package:floorball/api/impls/detailed_game_fetcher.dart';
import 'package:floorball/api/impls/int_parser.dart';

class GameImpl extends Game {
  RestClient client;

  GameImpl({
    required RestClient this.client,
    required int gameId,
    required int gameNumber,
    required int gameDay,
    int? arenaId,
    String? arenaName,
    String? arenaAddress,
    String? arenaShort,
    String? hostingClub,
    required int gameDayId,
    String? date,
    String? time,
    required bool started,
    required bool ended,
    String? homeTeamName,
    String? homeTeamLogo,
    String? homeTeamSmallLogo,
    String? guestTeamName,
    String? guestTeamLogo,
    String? guestTeamSmallLogo,
    String? nominatedRefereeString,
    required List<Referee> referees,
    String? noticeType,
    String? noticeString,
    required String state,
    PeriodTitle? currentPeriodTitle,
    String? groupIdentifier,
    String? seriesTitle,
    String? seriesNumber,
    String? homeTeamFillingRule,
    String? homeTeamFillingTitle,
    int? homeTeamFillingParameter,
    String? guestTeamFillingRule,
    String? guestTeamFillingTitle,
    int? guestTeamFillingParameter,
    String? resultString,
    GameResult? result,
  }) : super(
         gameId: gameId,
         gameNumber: gameNumber,
         gameDay: gameDay,
         arenaId: arenaId,
         arenaName: arenaName,
         arenaAddress: arenaAddress,
         arenaShort: arenaShort,
         hostingClub: hostingClub,
         gameDayId: gameDayId,
         date: date,
         time: time,
         started: started,
         ended: ended,
         homeTeamName: homeTeamName,
         homeTeamLogo: homeTeamLogo,
         homeTeamSmallLogo: homeTeamSmallLogo,
         guestTeamName: guestTeamName,
         guestTeamLogo: guestTeamLogo,
         guestTeamSmallLogo: guestTeamSmallLogo,
         nominatedRefereeString: nominatedRefereeString,
         referees: referees,
         noticeType: noticeType,
         noticeString: noticeString,
         state: state,
         currentPeriodTitle: currentPeriodTitle,
         groupIdentifier: groupIdentifier,
         seriesTitle: seriesTitle,
         seriesNumber: seriesNumber,
         homeTeamFillingRule: homeTeamFillingRule,
         homeTeamFillingTitle: homeTeamFillingTitle,
         homeTeamFillingParameter: homeTeamFillingParameter,
         guestTeamFillingRule: guestTeamFillingRule,
         guestTeamFillingTitle: guestTeamFillingTitle,
         guestTeamFillingParameter: guestTeamFillingParameter,
         resultString: resultString,
         result: result,
       );

  factory GameImpl.fromJson(RestClient client, Map<String, dynamic> json) {
    var refereesJson = json['referees'] as List;
    var rawTitle = json['current_period_title'] as Map<String, dynamic>?;
    var rawResult = json['result'] as Map<String, dynamic>?;

    return GameImpl(
      client: client,
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

  @override
  Stream<Future<DetailedGame>> getDetailedVersion() {
    return fetchDetailedGame(client, gameId);
  }
}
