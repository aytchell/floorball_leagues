import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final log = Logger('RestClient');
final String scheme = 'https';
final String host = 'saisonmanager.de';

class RestClient {
  static Future<RestClient>? _instanceFuture;
  final CacheManager cacheManager;

  // private constructor
  RestClient._() : cacheManager = DefaultCacheManager();

  static Future<RestClient> get instance {
    _instanceFuture ??= _create();
    return _instanceFuture!;
  }

  static Future<RestClient> _create() async {
    return RestClient._();
  }

  Future<dynamic> getJsonFromPath(String path) async {
    return getJson(Uri(scheme: scheme, host: host, path: path));
  }

  Future<dynamic> getJson(Uri uri) async {
    log.info('Fetching "$uri"');

    Map<String, String> headers = {'Accept': 'application/json'};
    final file = await cacheManager.getSingleFile(
      uri.toString(),
      headers: {'Accept': 'application/json'},
    );
    return json.decode(await file.readAsString());
  }
}
