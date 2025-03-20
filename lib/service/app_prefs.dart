import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static late final SharedPreferences instance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  // sets
  static Future<bool> setBool(String key, bool value) async =>
      await instance.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await instance.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await instance.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await instance.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await instance.setStringList(key, value);

  // gets
  static bool getBool(String key) => instance.getBool(key) ?? false;

  static double getDouble(String key) => instance.getDouble(key) ?? 0;

  static int getInt(String key) => instance.getInt(key) ?? 0;

  static String? getString(String key) => instance.getString(key);

  // deletes
  static Future<bool> remove(String key) async => await instance.remove(key);

  static Future<bool> clear() async => await instance.clear();
}
