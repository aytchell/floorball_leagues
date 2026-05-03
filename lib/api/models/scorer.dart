class Scorer {
  int games;
  int goals;
  int assists;
  int penalty2;
  int penalty2and2;
  int penalty5;
  int penalty10;
  int penaltyMsTech;
  int penaltyMsFull;
  int penaltyMs1;
  int penaltyMs2;
  int penaltyMs3;
  int playerId;
  int teamId;
  String teamName;
  String firstName;
  String lastName;
  String? image;
  String? imageSmall;
  int sort;
  int position;

  Scorer({
    required this.games,
    required this.goals,
    required this.assists,
    required this.penalty2,
    required this.penalty2and2,
    required this.penalty5,
    required this.penalty10,
    required this.penaltyMsTech,
    required this.penaltyMsFull,
    required this.penaltyMs1,
    required this.penaltyMs2,
    required this.penaltyMs3,
    required this.playerId,
    required this.teamId,
    required this.teamName,
    required this.firstName,
    required this.lastName,
    this.image,
    this.imageSmall,
    required this.sort,
    required this.position,
  });

  // Convenience getters
  String get fullName => '$firstName $lastName';
  int get points => goals + assists;
  double get goalsPerGame => games > 0 ? goals / games : 0.0;
  double get pointsPerGame => games > 0 ? points / games : 0.0;
  double get assistsPerGame => games > 0 ? assists / games : 0.0;
}
