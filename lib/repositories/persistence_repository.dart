import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = Logger('PersistenceRepository');

class PersistenceRepository {
  static const pinnedFederationsKey = 'pinnedFederations';
  static const pinnedLeaguesKey = 'pinnedLeagues';
  static const pinVariantKey = 'pinVariant';
  static const selectedNavAppKey = 'selectedNavApp';
  static const vibrateOnFavKey = 'vibrateOnFav';

  SharedPreferencesWithCache? _prefsWithCache;

  Future<SharedPreferencesWithCache> get _instance async {
    if (_prefsWithCache != null) {
      return _prefsWithCache!;
    }

    _prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{
          pinnedFederationsKey,
          pinnedLeaguesKey,
          pinVariantKey,
          selectedNavAppKey,
          vibrateOnFavKey,
        },
      ),
    );
    return _prefsWithCache!;
  }

  void removeEntry(String key) async =>
      _instance.then((prefs) => prefs.remove(key)).ignore();

  void persistString(String key, String value) async =>
      _instance.then((prefs) => prefs.setString(key, value)).ignore();

  Future<String?> loadString(String key) async =>
      _instance.then((prefs) => prefs.getString(key));
}
