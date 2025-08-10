import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  Future<void> addToCache(Map<String, dynamic> values) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    for (var entry in values.entries) {
      if (entry.value is List) {
        sharedPrefs.setStringList(entry.key, entry.value);
      } else {
        sharedPrefs.setString(entry.key, '${entry.value}');
      }
    }
  }

  Future<int?> readInt(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getInt(key);
  }

  Future<void> addIntValue(String key, int value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setInt(key, value);
  }

  Future<String?> readCacheString(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(key);
  }

  Future<List<String>?> readCacheStringList(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getStringList(key);
  }

  Future<bool?> readCacheBool(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool(key, value);
  }

  Future<void> deleteCache(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove(key);
  }
}
