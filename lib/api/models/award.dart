class Award {
  String award;
  String team;
  int? playerId;
  String? playerFirstname;
  String? playerName;
  int? jerseyNumber;

  Award({
    required this.award,
    required this.team,
    this.playerId,
    this.playerFirstname,
    this.playerName,
    this.jerseyNumber,
  });

  String get name => '$playerFirstname $playerName';
  bool get notGiven => (jerseyNumber == null);
}

class Awards {
  List<Award> home;
  List<Award> guest;

  Awards({required this.home, required this.guest});

  bool get notGiven {
    return (home.isEmpty || home.every((p) => p.notGiven)) &&
        (guest.isEmpty || guest.every((p) => p.notGiven));
  }
}
