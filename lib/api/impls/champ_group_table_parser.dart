import 'package:floorball/api/impls/league_table_row_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/api/models/champ_group_table.dart';

ChampGroupTable parseChampGroupTable(Map<String, dynamic> json) {
  final tableJson = json['table'] as List<dynamic>;

  return ChampGroupTable(
    groupIdentifier: parseString(json, 'group_identifier'),
    name: parseString(json, 'name'),
    table: tableJson.map((entry) => parseLeagueTableRow(entry)).toList(),
  );
}
