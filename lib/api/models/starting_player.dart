class StartingPlayer {
  String position;
  String team;
  int? playerId;
  String? playerFirstname;
  String? playerName;
  int? trikotNumber;

  StartingPlayer({
    required this.position,
    required this.team,
    this.playerId,
    this.playerFirstname,
    this.playerName,
    this.trikotNumber,
  });

  String get name => '$playerFirstname $playerName';
  bool get notGiven => (trikotNumber == null);
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
