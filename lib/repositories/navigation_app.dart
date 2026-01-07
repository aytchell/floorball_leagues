import 'dart:io';

import 'package:floorball/repositories/navigation/navigation_app_desktop.dart';
import 'package:floorball/repositories/navigation/navigation_app_mobile.dart';
import 'package:flutter/material.dart';

abstract class NavigationApp {
  String get name;
  dynamic get type;
  Widget svg(double widthAndHeight);
  Future<void> openNavigation(String address, String? locationName);

  String toJson();
}

class NavigationAppFactory {
  NavigationApp fromJson(String jsonString) {
    if (Platform.isAndroid || Platform.isIOS) {
      return MobileNavigationApp.fromJson(jsonString);
    } else {
      return WebNavigationApp.fromJson(jsonString);
    }
  }

  Future<List<NavigationApp>> getAvailableApps() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return getAvailableMobileNavApps();
    } else {
      return getAvailableWebNavApps();
    }
  }
}
