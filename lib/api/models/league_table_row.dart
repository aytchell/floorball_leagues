import 'logo_host.dart';

class LeagueTableRow {
  int games;
  int won;
  int draw;
  int lost;
  int wonOt;
  int lostOt;
  int goalsScored;
  int goalsReceived;
  int goalsDiff;
  int points;
  String teamName;
  int teamId;
  String? teamLogo;
  String? teamLogoSmall;
  int? pointCorrections;
  int sort;
  int position;

  LeagueTableRow({
    required this.games,
    required this.won,
    required this.draw,
    required this.lost,
    required this.wonOt,
    required this.lostOt,
    required this.goalsScored,
    required this.goalsReceived,
    required this.goalsDiff,
    required this.points,
    required this.teamName,
    required this.teamId,
    this.teamLogo,
    this.teamLogoSmall,
    this.pointCorrections,
    required this.sort,
    required this.position,
  });

  Uri? get teamLogoUri => buildLogoUri(teamLogo);
  Uri? get teamLogoSmallUri => buildLogoUri(teamLogoSmall);
}
