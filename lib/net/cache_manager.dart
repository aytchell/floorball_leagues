import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FloorballCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'libCachedImageData';
  static final FloorballCacheManager _instance = FloorballCacheManager._();

  factory FloorballCacheManager() {
    return _instance;
  }

  FloorballCacheManager._()
    : super(
        Config(
          key,
          maxNrOfCacheObjects: 300,
          durationOnMaxAgeZero: Duration(seconds: 29),
        ),
      );
}
