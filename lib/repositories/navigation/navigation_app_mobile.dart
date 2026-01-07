import 'dart:convert';

import 'package:floorball/repositories/navigation_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';

Future<List<NavigationApp>> getAvailableMobileNavApps() async => MapLauncher
    .installedMaps
    .then((list) => list.map((app) => MobileNavigationApp(app)).toList());

class MobileNavigationApp extends NavigationApp {
  final AvailableMap _app;

  MobileNavigationApp(this._app);

  factory MobileNavigationApp.fromJson(String jsonString) =>
      MobileNavigationApp(AvailableMap.fromJson(json.decode(jsonString)));

  @override
  String toJson() =>
      json.encode({'mapName': _app.mapName, 'mapType': _app.mapType.name});

  @override
  String get name => _app.mapName;

  @override
  MapType get type => _app.mapType;

  @override
  Widget svg(double widthAndHeight) => SvgPicture.asset(
    _app.icon,
    height: widthAndHeight,
    width: widthAndHeight,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MobileNavigationApp && other._app.mapType == _app.mapType;
  }

  @override
  int get hashCode => _app.mapType.hashCode;

  @override
  Future<void> openNavigation(String address, String? locationName) =>
      MapLauncher.showMarkerByAddress(
        mapType: type,
        address: address,
        title: locationName ?? address,
        description: address,
      );
}

class NavigationAppFactoryImpl extends NavigationAppFactory {
  @override
  NavigationApp fromJson(String jsonString) =>
      MobileNavigationApp.fromJson(jsonString);
}
