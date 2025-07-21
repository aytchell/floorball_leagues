import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

final log = Logger('RestClient');

class RestClient {
  late SharedPreferencesWithCache _prefs;
  late Directory _cache;

  // private constructor
  RestClient._();

  static Future<RestClient> create() async {
    final client = RestClient._();
    await client._initialize();
    return client;
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    _cache = await getApplicationDocumentsDirectory();
  }

  String _etagKeyFromUri(Uri uri) {
    return "etag:${uri.host}:${uri.path}";
  }

  CacheObj _cacheObjFromUri(Uri uri) {
    final host = uri.host;
    final pathSegments = uri.pathSegments;

    final filename = pathSegments.last;
    final directories = path.joinAll(
      pathSegments.sublist(0, pathSegments.length - 1),
    );

    return CacheObj(
      absPath: path.join('cache', host, directories, filename),
      baseDirectory: path.join('cache', host, directories),
    );
  }

  Future<dynamic> getJson(Uri uri) async {
    log.info('Fetching "$uri"');

    // Prepare headers with ETag if we have one cached
    Map<String, String> headers = {'Content-Type': 'application/json'};

    final etag = _prefs.getString(_etagKeyFromUri(uri));
    if (etag != null) {
      log.info('Adding stored etag "$etag" to the query');
      headers['If-None-Match'] = etag;
    }

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // Fresh data received
      log.info('Got response 200');
      return _cacheAndReturnJson(uri, response);
    } else if (response.statusCode == 304) {
      // Not Modified - use cached data
      log.info('Got response 304');
      final body = await _loadFromCache(uri);
      return json.decode(body);
    } else {
      throw Exception('Failed to fetch "$uri"');
    }
  }

  Future<dynamic> _cacheAndReturnJson(Uri uri, http.Response response) async {
    final jsonData = json.decode(response.body);

    // Cache the ETag and response
    final etag = response.headers['etag'];
    if (etag != null) {
      log.info('Response contains etag "$etag"; caching response');
      _prefs.setString(_etagKeyFromUri(uri), etag);
      _saveBodyToCache(uri, response.body);
    }

    return jsonData;
  }

  Future<void> _saveBodyToCache(Uri uri, String body) async {
    final obj = _cacheObjFromUri(uri);

    final dir = Directory(path.join(_cache.path, obj.baseDirectory));
    log.info('Creating directory "$dir"');
    await dir.create(recursive: true);

    final file = File(path.join(_cache.path, obj.absPath));
    log.info('Storing body to "$file"');
    file.writeAsString(body);
  }

  Future<String> _loadFromCache(Uri uri) {
    final obj = _cacheObjFromUri(uri);
    final file = File(path.join(_cache.path, obj.absPath));
    log.info('Loading body from "$file"');
    return file.readAsString();
  }
}

class CacheObj {
  final String absPath;
  final String baseDirectory;

  CacheObj({required this.absPath, required this.baseDirectory});
}
