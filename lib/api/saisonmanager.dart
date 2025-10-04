import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/impls/entry_info_impl.dart';

class Saisonmanager {
  final RestClient _client;

  Saisonmanager({required RestClient client}) : _client = client;

  Future<EntryInfo?> getStart() async {
    return EntryInfoImpl.fetchFromServer(_client);
  }
}
