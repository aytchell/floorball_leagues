import '../net/rest_client.dart';
import 'models/entry_info.dart';
import 'impls/entry_info_impl.dart';

class Saisonmanager {
  final RestClient _client;
  final String baseUrl;

  static final String _defaultBaseUrl = 'https://saisonmanager.de';
  static final String _entryPath = '/api/v2/init.json';

  Saisonmanager({required RestClient client, String? baseUrl = null})
    : _client = client,
      baseUrl = baseUrl ?? _defaultBaseUrl;

  Future<EntryInfo?> getStart() async {
    final uri = Uri.parse('${baseUrl}${_entryPath}');
    final json = await _client.getJson(uri) as Map<String, dynamic>;
    return EntryInfoImpl.fromJson(json);
    return null;
  }
}
