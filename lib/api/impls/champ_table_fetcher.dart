import 'package:floorball/api/impls/string_parser.dart';
import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/champ_group_table.dart';
import 'package:floorball/api/impls/league_table_fetcher.dart';

ChampGroupTable parseChampGroupTable(Map<String, dynamic> json) {
  final tableJson = json['table'] as List<dynamic>;

  return ChampGroupTable(
    groupIdentifier: parseString(json, 'group_identifier'),
    name: parseString(json, 'name'),
    table: tableJson.map((entry) => parseLeagueTableRow(entry)).toList(),
  );
}

Stream<Future<List<ChampGroupTable>>> fetchChampTableFromServer(
  RestClient client,
  int leagueId,
) {
  return client.streamApiData('/api/v2/leagues/$leagueId/grouped_table.json', (
    data,
  ) {
    final json = data as Map<String, dynamic>;
    return json
        .map((key, value) => MapEntry(key, parseChampGroupTable(value)))
        .values
        .toList();
  });
}
