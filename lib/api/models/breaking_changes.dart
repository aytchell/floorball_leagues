class BreakingChanges {
  // Up to season 13 (2021/22) the Saisonmanager was written in php
  // and the API for these seasons serve 'similar data fields' but far less.
  // Starting from season 14 the served data is much more detailed and parts of
  // the app rely on this additional data
  static const int lastPhpSeasonId = 13;

  // Up to season 13 (2021/2022) we had penalties 2', 5', 10' as well as
  // match penalty 1, 2 and 3. This changed with season 14; now we have
  // 2', 2+2', 10' and technical and "full" match penalty
  static const int firstSeasonIdWithNewPenalties = 14;
}
