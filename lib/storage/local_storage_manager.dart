import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  late SharedPreferences _preferences;

  LocalStorageManager() {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setData(String key, bool value) async {
    await _init();
    await _preferences.setBool(key, value);
  }

  Future<bool?> getData(String key) async {
    await _init();
    return _preferences.getBool(key);
  }
}
