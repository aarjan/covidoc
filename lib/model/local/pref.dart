import 'package:shared_preferences/shared_preferences.dart';

abstract class Pref {
  Future<int?> getInt(String key);
  Future<bool?> getBool(String key);
  Future<bool> delString(String key);
  Future<String?> getString(String key);
  Future<bool> saveInt(String key, int value);
  Future<bool> saveBool(String key, bool value);
  Future<bool> flushAll({List<String>? exceptions});
  Future<bool> saveString(String key, String value);
}

class LocalPref extends Pref {
  @override
  Future<bool?> getBool(String key) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.getBool(key);
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.getInt(key);
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.setInt(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.getString(key);
  }

  @override
  Future<bool> saveString(String key, String value) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.setString(key, value);
  }

  @override
  Future<bool> delString(String key) async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.remove(key);
  }

  @override
  Future<bool> flushAll({List<String>? exceptions = const []}) async {
    final _pref = await SharedPreferences.getInstance();
    for (final k in _pref.getKeys()) {
      if (!exceptions!.contains(k)) {
        await _pref.remove(k);
      }
    }
    return true;
  }
}

class MemPref extends Pref {
  Map<String, Object> memoryMap = <String, Object>{};

  @override
  Future<String> getString(String key) async {
    return Future.value(memoryMap[key] as String?);
  }

  @override
  Future<bool> saveString(String key, String value) async {
    memoryMap[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> delString(String key) {
    memoryMap.remove(key);
    return Future.value(true);
  }

  @override
  Future<bool> flushAll({List<String>? exceptions = const []}) async {
    for (final k in memoryMap.keys) {
      if (!exceptions!.contains(k)) {
        memoryMap.remove(k);
      }
    }
    return Future.value(true);
  }

  @override
  Future<int> getInt(String key) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveInt(String key, int value) {
    throw UnimplementedError();
  }

  @override
  Future<bool> getBool(String key) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveBool(String key, bool value) {
    throw UnimplementedError();
  }
}
