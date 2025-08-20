class Player {
  int playerId;
  String playerName;
  int trikotNumber;
  String playerFirstname;
  String position;
  bool? goalkeeper;
  bool? captain;

  Player({
    required this.playerId,
    required this.playerName,
    required this.trikotNumber,
    required this.playerFirstname,
    required this.position,
    this.goalkeeper,
    this.captain,
  });

  String get name => '$playerFirstname $playerName';
}
