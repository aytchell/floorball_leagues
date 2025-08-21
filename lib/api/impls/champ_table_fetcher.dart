import '../../net/rest_client.dart';
import '../models/champ_group_table.dart';
import 'league_table_fetcher.dart';

ChampGroupTable parseChampGroupTable(Map<String, dynamic> json) {
  final tableJson = json['table'] as List<dynamic>;

  return ChampGroupTable(
    groupIdentifier: json['group_identifier'] as String,
    name: json['name'] as String,
    table: tableJson.map((entry) => parseLeagueTableRow(entry)).toList(),
  );
}

Future<List<ChampGroupTable>> fetchChampTableFromServer(
  RestClient client,
  int leagueId,
) async {
  final path = '/api/v2/leagues/$leagueId/grouped_table.json';

  final jsonData = await client.getJsonFromPath(path) as Map<String, dynamic>;
  return jsonData
      .map((key, value) => MapEntry.new(key, parseChampGroupTable(value)))
      .values
      .toList();
}
