import 'package:floorball/api/models/scorer.dart';

class TeamPenalties {
  int seasonId;
  int penalty2;
  int penalty2and2;
  int penalty5;
  int penalty10;
  int penaltyMsTech;
  int penaltyMsFull;
  int penaltyMs1;
  int penaltyMs2;
  int penaltyMs3;

  TeamPenalties({
    required this.seasonId,
    this.penalty2 = 0,
    this.penalty2and2 = 0,
    this.penalty5 = 0,
    this.penalty10 = 0,
    this.penaltyMsTech = 0,
    this.penaltyMsFull = 0,
    this.penaltyMs1 = 0,
    this.penaltyMs2 = 0,
    this.penaltyMs3 = 0,
  });

  factory TeamPenalties.extract(List<Scorer> scorers, int seasonId) {
    return scorers.fold(
      TeamPenalties(seasonId: seasonId),
      (penalties, scorer) => penalties.plus(scorer),
    );
  }

  TeamPenalties plus(Scorer scorer) {
    penalty2 = penalty2 + scorer.penalty2;
    penalty2and2 = penalty2and2 + scorer.penalty2and2;
    penalty5 = penalty5 + scorer.penalty5;
    penalty10 = penalty10 + scorer.penalty10;
    penaltyMsTech = penaltyMsTech + scorer.penaltyMsTech;
    penaltyMsFull = penaltyMsFull + scorer.penaltyMsFull;
    penaltyMs1 = penaltyMs1 + scorer.penaltyMs1;
    penaltyMs2 = penaltyMs2 + scorer.penaltyMs2;
    penaltyMs3 = penaltyMs3 + scorer.penaltyMs3;
    return this;
  }

  String expiringTitle() {
    if (seasonId >= firstSeasonIdWithNewPenalties) {
      return 'Strafen (2, 2+2, 10)';
    } else {
      return 'Strafen (2, 5, 10)';
    }
  }

  String expiringPenaltiesAsString() {
    if (seasonId >= firstSeasonIdWithNewPenalties) {
      return '$penalty2, $penalty2and2, $penalty10';
    } else {
      return '$penalty2, $penalty5, $penalty10';
    }
  }

  String matchTitle() {
    if (seasonId >= firstSeasonIdWithNewPenalties) {
      return 'Matchstrafen (technisch, voll)';
    } else {
      return 'Matchstrafen (MS1, MS2, MS3)';
    }
  }

  String matchPenaltiesAsString() {
    if (seasonId >= firstSeasonIdWithNewPenalties) {
      return '$penaltyMsTech, $penaltyMsFull';
    } else {
      return '$penaltyMs1, $penaltyMs2, $penaltyMs3';
    }
  }
}
