import 'league_table_row.dart';

class ChampGroupTable {
  String groupIdentifier;
  String name;
  List<LeagueTableRow> table;
  bool hidePoints;

  ChampGroupTable({
    required this.groupIdentifier,
    required this.name,
    required this.table,
    this.hidePoints = false,
  });
}
