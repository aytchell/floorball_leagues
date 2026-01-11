import 'dart:convert';
import 'dart:io';

import 'package:floorball/net/cache_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logging/logging.dart';

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
