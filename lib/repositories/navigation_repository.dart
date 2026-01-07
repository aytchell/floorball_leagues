import 'dart:async';

import 'package:floorball/repositories/navigation_app.dart';
import 'package:floorball/repositories/persistence_repository.dart';

class NavigationRepository {
  final PersistenceRepository _persistence;
  static const _persistenceKey = PersistenceRepository.selectedNavAppKey;
  final _factory = NavigationAppFactory();

  NavigationRepository(this._persistence);

  Future<NavigationApp?> loadSelection() async =>
      _persistence.loadString(_persistenceKey).then((jsonString) {
        if (jsonString == null) {
          return null;
        }

        log.info("Loading persisted selection of navigation app");
        final loaded = _factory.fromJson(jsonString);
        return _loadedSelectionIfStillAvailable(loaded);
      });

  void persistSelection(NavigationApp app) {
    log.info('Storing "${app.name} (${app.type})" as preferred navigation app');
    _persistence.persistString(_persistenceKey, app.toJson());
  }

  Future<List<NavigationApp>> getAvailableNavigationApps() async =>
      _factory.getAvailableApps();

  Future<void> openNavigation(
    NavigationApp app,
    String address,
    String? locationName,
  ) async => app.openNavigation(address, locationName);

  Future<NavigationApp?> _loadedSelectionIfStillAvailable(
    NavigationApp loaded,
  ) => getAvailableNavigationApps().then((available) {
    final loadedApp = '${loaded.name} (${loaded.type})';
    if (available.contains(loaded)) {
      log.info('Loaded "$loadedApp" as preferred navigation app');
      return loaded;
    } else {
      log.info('Selected nav app "$loadedApp" is no longer available');
      return null;
    }
  });
}
