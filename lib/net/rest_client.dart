import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:floorball/net/cache_manager.dart';

final log = Logger('RestClient');
final String scheme = 'https';
final String host = 'saisonmanager.de';

class RestClient {
  static Future<RestClient>? _instanceFuture;
  final FloorballCacheManager cacheManager;

  // private constructor
  RestClient._() : cacheManager = FloorballCacheManager();

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
      headers: headers,
    );

    return json.decode(await file.readAsString());
  }

  Stream<Future<T>> streamApiData<T>(
    String path,
    T Function(dynamic data) convert,
  ) {
    return getJsonStreamFromPath(path).map((futureData) {
      return futureData.then((data) => convert(data));
    });
  }

  Stream<Future<dynamic>> getJsonStreamFromPath(String path) {
    return getJsonStream(Uri(scheme: scheme, host: host, path: path));
  }

  Stream<Future<dynamic>> getJsonStream(Uri uri) {
    log.info('Fetching "$uri" as stream');

    Map<String, String> headers = {'Accept': 'application/json'};

    final stream = cacheManager
        .getFileStream(uri.toString(), headers: headers, withProgress: false)
        .where((data) => data is FileInfo)
        .map((data) {
          final info = data as FileInfo;
          log.info('Received data: ${info.file.path}');
          return info.file.readAsString().then(
            (content) => json.decode(content),
          );
        });
    return stream;
  }

  Stream<T> streamApiDataSync<T>(
    String path,
    T Function(dynamic data) convert,
  ) {
    return getJsonStreamFromPathSync(path).map((data) => convert(data));
  }

  Stream<dynamic> getJsonStreamFromPathSync(String path) {
    return getJsonStreamSync(Uri(scheme: scheme, host: host, path: path));
  }

  Stream<dynamic> getJsonStreamSync(Uri uri) => getFileStreamSync(uri)
      .map((file) => file.readAsStringSync())
      .map((content) => json.decode(content));

  Stream<File> getFileStreamSync(Uri uri) {
    log.info('Fetching "$uri" as sync stream');

    Map<String, String> headers = {'Accept': 'application/json'};

    final stream = cacheManager
        .getFileStream(uri.toString(), headers: headers, withProgress: false)
        .where((data) => data is FileInfo)
        .map((data) {
          final info = data as FileInfo;
          log.info('Received data: ${info.file.path}');
          return info.file;
        });

    return stream;
  }
}
