import 'dart:convert';

import 'package:floorball/repositories/navigation_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

enum NavType { apple, google, osmand }

class WebNavApp {
  final String mapName;
  final NavType mapType;
  final String icon;

  WebNavApp({required this.mapName, required this.mapType})
    : icon = 'packages/map_launcher/assets/icons/${mapType.name}.svg';

  factory WebNavApp.fromJson(dynamic json) {
    final NavType navType = NavType.values.byName(json['mapType']);
    return WebNavApp(mapName: json['mapName'], mapType: navType);
  }
}

class WebNavigationApp extends NavigationApp {
  final WebNavApp _app;

  WebNavigationApp(this._app);

  factory WebNavigationApp.fromJson(String jsonString) =>
      WebNavigationApp(WebNavApp.fromJson(json.decode(jsonString)));

  @override
  String toJson() =>
      json.encode({'mapName': _app.mapName, 'mapType': _app.mapType.name});

  @override
  String get name => _app.mapName;

  @override
  NavType get type => _app.mapType;

  @override
  Widget svg(double widthAndHeight) => SvgPicture.asset(
    _app.icon,
    height: widthAndHeight,
    width: widthAndHeight,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebNavigationApp && other._app.mapType == _app.mapType;
  }

  @override
  int get hashCode => _app.mapType.hashCode;

  @override
  Future<void> openNavigation(String address, String? locationName) {
    switch (type) {
      case NavType.google:
        return _openGoogleMaps(address, locationName);
      case NavType.apple:
        return _openAppleMaps(address, locationName);
      case NavType.osmand:
        return _openOpenStreetMap(address);
    }
  }

  Future<void> _openGoogleMaps(String address, String? locationName) async {
    final encodedAddress = (locationName == null)
        ? Uri.encodeComponent(address)
        : Uri.encodeComponent('($locationName)$address');

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
    );

    _launchUrl(url);
  }

  Future<void> _openAppleMaps(String address, String? locationName) async {
    final encodedAddress = Uri.encodeComponent(address);
    final nameComponent = (locationName == null)
        ? ''
        : '&name=${Uri.encodeComponent(locationName)}';

    final url = Uri.parse(
      'https://maps.apple.com/place?address=$encodedAddress$nameComponent',
    );
    _launchUrl(url);
  }

  Future<void> _openOpenStreetMap(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = Uri.parse(
      'https://www.openstreetmap.org/search?query=$encodedAddress',
    );
    _launchUrl(url);
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open maps in browser');
    }
  }
}

class NavigationAppFactoryImpl extends NavigationAppFactory {
  @override
  NavigationApp fromJson(String jsonString) =>
      WebNavigationApp.fromJson(jsonString);
}

Future<List<NavigationApp>> getAvailableWebNavApps() => Future.value(
  [
    WebNavApp(mapName: 'Google Maps', mapType: NavType.google),
    WebNavApp(mapName: 'Apple Maps', mapType: NavType.apple),
    WebNavApp(mapName: 'OpenStreetMap', mapType: NavType.osmand),
  ].map((app) => WebNavigationApp(app)).toList(),
);
