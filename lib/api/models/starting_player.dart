class StartingPlayer {
  String position;
  String team;
  int? playerId;
  String? playerFirstname;
  String? playerName;
  int? jerseyNumber;

  StartingPlayer({
    required this.position,
    required this.team,
    this.playerId,
    this.playerFirstname,
    this.playerName,
    this.jerseyNumber,
  });

  String get name => '$playerFirstname $playerName';
  bool get notGiven => (jerseyNumber == null);
}

class StartingPlayers {
  List<StartingPlayer> home;
  List<StartingPlayer> guest;

  StartingPlayers({required this.home, required this.guest});

  bool get notGiven {
    return (home.isEmpty || home.every((p) => p.notGiven)) &&
        (guest.isEmpty || guest.every((p) => p.notGiven));
  }
}
