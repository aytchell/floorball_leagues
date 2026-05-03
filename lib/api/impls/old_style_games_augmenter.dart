import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/api/models/period_title.dart';

DetailedGame augmentVeryOldGame(DetailedGame input) {
  final (ingameStatus, currentPeriod) = _computeCurrentStatusAndPeriod(input);
  return DetailedGame(
    id: input.id,
    gameNumber: input.gameNumber,
    startTime: input.startTime,
    actualStartTime: input.actualStartTime,
    date: input.date,
    gameDay: input.gameDay,
    gameStatus: DetailedGameStatus.matchRecordClosed,
    ingameStatus: ingameStatus,
    audience: input.audience,
    homeTeamName: input.homeTeamName,
    guestTeamName: input.guestTeamName,
    homeTeamId: input.homeTeamId,
    guestTeamId: input.guestTeamId,
    homeTeamLogo: input.homeTeamLogo,
    homeTeamSmallLogo: input.homeTeamSmallLogo,
    guestTeamLogo: input.guestTeamLogo,
    guestTeamSmallLogo: input.guestTeamSmallLogo,
    liveStreamLink: input.liveStreamLink,
    vodLink: input.vodLink,
    events: input.events,
    players: input.players,
    startingPlayers: input.startingPlayers,
    awards: input.awards,
    started: input.started,
    ended: input.ended,
    resultString: input.resultString,
    result: input.result,
    leagueId: input.leagueId,
    leagueName: input.leagueName,
    leagueShortName: input.leagueShortName,
    federationId: input.federationId,
    federationName: input.federationName,
    federationShortName: input.federationShortName,
    federationSlug: input.federationSlug,
    periodTitles: input.periodTitles,
    currentPeriodTitle: currentPeriod,
    arena: input.arena,
    arenaName: input.arenaName,
    arenaAddress: input.arenaAddress,
    arenaShort: input.arenaShort,
    nominatedReferees: input.nominatedReferees,
    deletable: input.deletable,
    noticeType: input.noticeType,
    noticeString: input.noticeString,
    referees: input.referees,
  );
}

// This is hacky ... I know
(DetailedIngameStatus?, PeriodTitle?) _computeCurrentStatusAndPeriod(
  DetailedGame input,
) {
  if (!input.started) {
    return (null, null);
  }

  final hasHalfes = input.periodTitles[0].title == "1. Hälfte";
  int extras = _computeExtraPeriods(input);

  if (hasHalfes) {
    return _computeStatusForHalfes(input, extras);
  } else {
    return _computeStatusForThirds(input, extras);
  }
}

int _computeExtraPeriods(DetailedGame input) {
  final hasOvertime = input.result?.overtime ?? false;
  if (!hasOvertime) {
    return 0;
  }

  final hasPenaltyShootout = input.resultString?.endsWith('PS') ?? false;
  if (hasPenaltyShootout) {
    return 2;
  }

  return 1;
}

(DetailedIngameStatus, PeriodTitle) _computeStatusForHalfes(
  DetailedGame input,
  int extras,
) {
  // 'period_id'  title                           index
  //    1.0       1. halftime                       0
  //    1.5       1. pause                          1
  //    2.0       2. halftime                       2
  //    2.5       pause before overtime             3
  //    3.0       overtime                          4
  //    3.5       pause before penalty shootout     5
  //    4.0       penalty shootout                  6
  final status = switch (extras) {
    1 => DetailedIngameStatus.overtime,
    2 => DetailedIngameStatus.penaltyShots,
    _ => DetailedIngameStatus.periodTwo,
  };
  return (status, input.periodTitles[2 + 2 * extras]);
}

(DetailedIngameStatus, PeriodTitle) _computeStatusForThirds(
  DetailedGame input,
  int extras,
) {
  // 'period_id'  title                           index
  //    1.0       1. third                          0
  //    1.5       1. pause                          1
  //    2.0       2. third                          2
  //    2.5       2. pause                          3
  //    3.0       3. third                          4
  //    3.5       pause before overtime             5
  //    4.0       overtime                          6
  //    4.5       pause before penalty shootout     7
  //    5.0       penalty shootout                  8
  final status = switch (extras) {
    1 => DetailedIngameStatus.overtime,
    2 => DetailedIngameStatus.penaltyShots,
    _ => DetailedIngameStatus.periodThree,
  };
  return (status, input.periodTitles[4 + 2 * extras]);
}
