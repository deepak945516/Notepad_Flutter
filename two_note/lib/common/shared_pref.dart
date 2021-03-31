import 'package:shared_preferences/shared_preferences.dart';

class PreferenceData {
  
  static Future<SharedPreferences> _getPref() {
    final shared = SharedPreferences.getInstance();
    return shared;
  }

  static void setStringData(String key, String value) async {
    SharedPreferences pref = await _getPref();
    pref.setString(key, value);
  }

  static Future<String> getStringData(String key) async {
    SharedPreferences pref = await _getPref();
    final String value = pref.getString(key);
    return value;
  }
  
}