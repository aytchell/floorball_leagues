import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/rem.dart';
import 'package:flutter/material.dart';

class TextStyles {
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
  static const _bold1 = TextStyle(fontSize: rem_1, fontWeight: FontWeight.w700);

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

  static const mainScaffoldTitle = _bold1125;
  static const mainScaffoldSubTitle = _normal0875;
  static const mainScaffoldSeason = _normal0875;

  static const gameHeaderTeamName = _bold1;
  static const gameHeaderVersus = TextStyle(
    fontSize: rem_1_125,
    fontWeight: FontWeight.w700,
    color: FloorballColors.gray156,
  );
  static const gameHeaderScore = TextStyle(
    fontSize: rem_2_625,
    fontWeight: FontWeight.w700,
  );
  static const gameHeaderResultPostfix = _normal1125;
  static const gameHeaderDatePast = _bold1grey153;
  static const gameHeaderDateFuture = _bold1;
  static const gameHeaderArenaInfo = _normal1grey153;
  static const gameHeaderPeriods = _bold1;

  static const gameDetailsSection = _bold1125;
  static const gameDetailsSubSection = _bold1;

  static const gameMetadataKey = _normal0875;
  static const gameMetadataValue = _bold0875;

  static const teamLineupJersey = _bold0875;
  static const teamLineupName = _normal0875;
  static const teamLineupType = _normal0875;

  static const gameEventType = _bold0875;
  static const gameEventScorer = _normal0875;
  static const gameEventAssist = _normal0875grey153;

  static const gameEventPenalizedPlayer = _normal0875;
  static const gameEventPenaltyReason = _normal0875grey153;

  static const gameEventNewScore = _normal0875;
  static const gameEventTime = _normal0875;

  static const federationName = _bold1;

  static const genericLoadingData = _bold1125grey153;
}
