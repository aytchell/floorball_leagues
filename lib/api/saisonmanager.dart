import '../net/rest_client.dart';
import 'models/entry_info.dart';
import 'impls/entry_info_impl.dart';

class Saisonmanager {
  final RestClient _client;

  Saisonmanager({required RestClient client}) : _client = client;

  Future<EntryInfo?> getStart() async {
    return EntryInfoImpl.fetchFromServer(_client);
  }
}
