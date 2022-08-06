abstract class CacheManager {
  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] return the value of the key
  String getString({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [String] will return which value is just removed
  String deleteString({required String key});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setString({required String key, required String value});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  /// Output: [bool] will tell whether its set or not.
  bool setDynamicType({required String key, required dynamic value});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [bool] will tell whether its removed or not.
  bool deleteCacheDynamic({required String key});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  dynamic getDynamicType({required String key});
}

class CacheManagerImp extends CacheManager {
  Map<String, dynamic> cache = {};

  @override
  String deleteString({required String key}) {
    if (cache.containsKey(key)) {
      return cache.remove(key);
    }
    return '';
  }

  @override
  bool deleteCacheDynamic({required String key}) {
    if (cache.containsKey(key)) {
      cache.remove(key);
      return true;
    }
    return false;
  }

  @override
  dynamic getDynamicType({required String key}) {
    if (cache.containsKey(key)) {
      return cache[key];
    }
  }

  @override
  String getString({required String key}) {
    if (cache.containsKey(key)) {
      return cache[key];
    }
    return '';
  }

  @override
  bool setDynamicType({required String key, required value}) {
    cache[key] = value;
    return true;
  }

  @override
  void setString({required String key, required String value}) {
    cache[key] = value;
  }
}
