class BreakingChanges {
  // Up to season 13 (2021/22) the Saisonmanager was written in php
  // and the API for these seasons serve 'similar data fields' but far less.
  // Starting from season 14 the served data is much more detailed and parts of
  // the app rely on this additional data
  static const int lastPhpSeasonId = 13;

  // The years of the first season where the new backend was used.
  // This string is used in a warning Toast that appears when the user enters
  // one of the older seasons.
  static const String yearsOfFirstNewSeasons = '2022/23';

  // This is the last game_id which is served by the old php Saisonmanager.
  // All games with a greater id are served by the new Saisonmanager (and thus
  // contain the nice details)
  static const int lastGameIdOfPhpManager = 27204;

  // Up to season 13 (2021/2022) we had penalties 2', 5', 10' as well as
  // match penalty 1, 2 and 3. This changed with season 14; now we have
  // 2', 2+2', 10' and technical and "full" match penalty
  static const int firstSeasonIdWithNewPenalties = 14;

  // Although the initial json from Saisonmanager states there there are
  // seasons with id 1 to 6 in reality they can't be found on the server.
  // So we better filter these early seasons so the user isn't disappointed.
  static const int earliestAvailableSeasonId = 7;
}
