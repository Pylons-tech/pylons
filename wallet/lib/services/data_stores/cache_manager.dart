abstract class MyCacheManager {
  /// This method will return the saved bool if exists
  /// Input: [key] the key of the value
  /// Output: [bool] return the value of the key
  bool getBool({required String key});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setBool({required String key, required bool value});
}

class CacheManagerImp extends MyCacheManager {
  Map<String, dynamic> cache = {};

  @override
  bool getBool({required String key}) {
    if (cache.containsKey(key)) {
      return cache[key] as bool;
    }
    return false;
  }

  @override
  void setBool({required String key, required bool value}) {
    cache[key] = value;
  }
}
