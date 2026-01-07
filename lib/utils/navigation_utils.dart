import 'dart:io';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<AvailableMap>> getAvailableNavigations() async =>
    MapLauncher.installedMaps;

/// Opens navigation to the given address in a map application.
///
/// On mobile platforms (Android/iOS), this will show available map apps
/// and let the user choose their preferred one.
///
/// On desktop platforms (Linux/Windows/macOS), this will open Google Maps
/// in the default web browser.
Future<void> openNavigation(String address, String? locationName) async {
  if (Platform.isAndroid || Platform.isIOS) {
    // Mobile: Use map_launcher to show available map apps
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isEmpty) {
      // Fallback to browser if no map apps are installed
      await _openInBrowser(address, locationName);
      return;
    }

    // Show map picker or use first available map
    await MapLauncher.showMarkerByAddress(
      mapType: availableMaps.first.mapType,
      address: address,
      title: locationName ?? address,
      description: address,
    );
  } else {
    // Desktop: Open in browser
    await _openInBrowser(address, locationName);
  }
}

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
