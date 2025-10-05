import 'package:floorball/net/rest_client.dart';
import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/impls/entry_info_impl.dart';

class SaisonManager {
  final RestClient _client;

  SaisonManager({required RestClient client}) : _client = client;

  static Future<SaisonManager> init() {
    return RestClient.instance.then((clnt) => SaisonManager(client: clnt));
  }

  Stream<Future<EntryInfo>> getStart() {
    return EntryInfoImpl.fetchFromServer(_client);
  }
}
