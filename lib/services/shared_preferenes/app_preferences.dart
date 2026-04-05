import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _showLocationMessageKey = 'show_location_message';

  static Future<bool> shouldShowLocationMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showLocationMessageKey) != true;
  }

  static Future<void> setShowLocationMessage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showLocationMessageKey, !value);
  }

  static Future<void> resetPreferences() async {
    await setShowLocationMessage(true);
  }
}
