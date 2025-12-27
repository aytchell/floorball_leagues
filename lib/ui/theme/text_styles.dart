import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/rem.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const _normal075gray153 = TextStyle(
    fontSize: rem_0_75,
    color: FloorballColors.gray153,
  );
  static const _bold075 = TextStyle(
    fontSize: rem_0_75,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const _normal0875 = TextStyle(
    fontSize: rem_0_875,
    color: Colors.black,
  );
  static const _normal0875grey153 = TextStyle(
    fontSize: rem_0_875,
    color: FloorballColors.gray153,
  );
  static const _bold0875 = TextStyle(
    fontSize: rem_0_875,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static const _bold0875grey153 = TextStyle(
    fontSize: rem_0_875,
    fontWeight: FontWeight.w700,
    color: FloorballColors.gray153,
  );

  static const _normal1grey153 = TextStyle(
    fontSize: rem_1,
    color: FloorballColors.gray153,
  );
  static const _bold1grey153 = TextStyle(
    fontSize: rem_1,
    fontWeight: FontWeight.w700,
    color: FloorballColors.gray153,
  );
  static const _bold1grey169 = TextStyle(
    fontSize: rem_1,
    fontWeight: FontWeight.w700,
    color: FloorballColors.gray169,
  );
  static const _bold1 = TextStyle(
    fontSize: rem_1,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const _normal1125 = TextStyle(fontSize: rem_1_125);
  static const _bold1125 = TextStyle(
    fontSize: rem_1_125,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static const _bold1125grey153 = TextStyle(
    fontSize: rem_1_125,
    fontWeight: FontWeight.w700,
    color: FloorballColors.gray153,
  );

  static const _bold15 = TextStyle(
    fontSize: rem_1_5,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  // main app scaffold
  static const mainScaffoldTitle = _bold1125;
  static const mainScaffoldSubTitle = _normal0875;
  static const mainScaffoldSeason = _normal0875;

  // landing page
  static const landingFederationName = _bold1;

  // leagues list
  static const leaguesListHeader = _bold1grey169;
  static const leaguesListDark = _bold1;
  static const leaguesListLight = TextStyle(
    color: FloorballColors.gray97,
    fontSize: rem_1,
    fontWeight: FontWeight.w600,
  );

  // league detail
  static const leagueInfoKey = _normal0875;
  static const leagueInfoValue = _bold0875;

  static const gameDayTeamName = _bold0875;
  static const gameDayDate = _normal075gray153;
  static const gameDayResult = _bold15;
  static const gameDayResultPostfix = _bold075;

  static const gameDayHeaderFuture = _normal0875;
  static const gameDayHeaderFutureBold = _bold0875;
  static const gameDayHeaderPast = _normal0875grey153;
  static const gameDayHeaderPastBold = _bold0875grey153;

  // game detail page
  static const gameDetailHeaderTeamName = _bold1;
  static const gameDetailHeaderVersus = TextStyle(
    fontSize: rem_1_125,
    fontWeight: FontWeight.w700,
    color: FloorballColors.gray156,
  );
  static const gameDetailHeaderScore = TextStyle(
    fontSize: rem_2_625,
    fontWeight: FontWeight.w700,
  );
  static const gameDetailHeaderResultPostfix = _normal1125;
  static const gameDetailHeaderDatePast = _bold1grey153;
  static const gameDetailHeaderDateFuture = _bold1;
  static const gameDetailHeaderArenaInfo = _normal1grey153;
  static const gameDetailHeaderPeriods = _bold1;

  static const gameDetailNoDetails = _normal1grey153;

  static const gameDetailsSection = _bold1125;
  static const gameDetailsSubSection = _bold1;

  static const gameEventNoEvents = _normal1grey153;
  static const gameEventType = _bold0875;
  static const gameEventScorer = _normal0875;
  static const gameEventAssist = _normal0875grey153;
  static const gameEventNewScore = _normal0875;
  static const gameEventPenalizedPlayer = _normal0875;
  static const gameEventPenaltyReason = _normal0875grey153;
  static const gameEventTime = _normal0875;

  static const teamLineupJersey = _bold0875;
  static const teamLineupName = _normal0875;
  static const teamLineupType = _normal0875;

  static const gameMetadataKey = _normal0875;
  static const gameMetadataValue = _bold0875;

  // generic styles
  static const genericLoadingData = _bold1125grey153;
}
