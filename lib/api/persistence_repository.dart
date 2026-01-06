import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = Logger('PersistenceRepository');

class PersistenceRepository {
  static const pinnedFederationsKey = 'pinnedFederations';

  SharedPreferencesWithCache? _prefsWithCache;

  Future<SharedPreferencesWithCache> get _instance async {
    if (_prefsWithCache != null) {
      return _prefsWithCache!;
    }

    _prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{pinnedFederationsKey},
      ),
    );
    return _prefsWithCache!;
  }

  void persistString(String key, String value) async =>
      _instance.then((prefs) => prefs.setString(key, value)).ignore();

  Future<String?> loadString(String key) async =>
      _instance.then((prefs) => prefs.getString(key));
}
