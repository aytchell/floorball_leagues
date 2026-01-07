import 'dart:convert';
import 'dart:io';

import 'package:floorball/api/persistence_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class _NavAppJson {
  final String mapName;
  final String mapType;

  _NavAppJson({required this.mapName, required this.mapType});
}

class NavigationApp {
  final AvailableMap _app;

  NavigationApp(this._app);

  factory NavigationApp.fromJson(String jsonString) =>
      NavigationApp(AvailableMap.fromJson(json.decode(jsonString)));

  String toJson() => json.encode(
    _NavAppJson(mapName: _app.mapName, mapType: _app.mapType.name),
  );

  String get name => _app.mapName;

  MapType get type => _app.mapType;

  Widget svg(double widhtAndHeight) => SvgPicture.asset(
    _app.icon,
    height: widhtAndHeight,
    width: widhtAndHeight,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationApp && other._app.mapType == _app.mapType;
  }

  @override
  int get hashCode => _app.mapType.hashCode;
}

class NavigationRepository {
  final PersistenceRepository _persistence;
  static const _persistenceKey = PersistenceRepository.selectedNavAppKey;

  NavigationRepository(this._persistence);

  Future<NavigationApp?> loadSelection() async =>
      _persistence.loadString(_persistenceKey).then((jsonString) {
        if (jsonString != null) {
          log.info("Loading persisted selection of navigation app");
          final loaded = NavigationApp.fromJson(jsonString);
          getAvailableNavigationApps().then((available) {
            if (available.contains(loaded)) {
              return loaded;
            } else {
              log.info(
                'Selected nav app "${loaded.name}" is no longer available',
              );
            }
          });
        }
        return null;
      });

  void persistSelection(NavigationApp app) {
    _persistence.persistString(_persistenceKey, app.toJson());
  }

  Future<List<NavigationApp>> getAvailableNavigationApps() async => MapLauncher
      .installedMaps
      .then((list) => list.map((app) => NavigationApp(app)).toList());

  Future<void> openNavigation(
    NavigationApp app,
    String address,
    String? locationName,
  ) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return _openMobileApp(app, address, locationName);
    } else {
      return _openInBrowser(address, locationName);
    }
  }

  Future<void> _openMobileApp(
    NavigationApp app,
    String address,
    String? locationName,
  ) async => MapLauncher.showMarkerByAddress(
    mapType: app.type,
    address: address,
    title: locationName ?? address,
    description: address,
  );

  Future<void> _openInBrowser(String address, String? locationName) async {
    final encodedAddress = (locationName == null)
        ? Uri.encodeComponent(address)
        : Uri.encodeComponent('($locationName)$address');

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open maps in browser');
    }
  }
}
