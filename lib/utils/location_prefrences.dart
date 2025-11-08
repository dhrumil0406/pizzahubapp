import 'package:shared_preferences/shared_preferences.dart';

class LocationPreferences {
  static const String _keyLatitude = "latitude";
  static const String _keyLongitude = "longitude";

  // 🟢 Save latitude & longitude
  static Future<void> saveLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLatitude, latitude);
    await prefs.setDouble(_keyLongitude, longitude);
  }

  // 🟣 Get latitude
  static Future<double?> getLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyLatitude);
  }

  // 🔵 Get longitude
  static Future<double?> getLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyLongitude);
  }

  // 🟠 Clear location data
  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLatitude);
    await prefs.remove(_keyLongitude);
  }

  // 🌍 Default coordinates (e.g., fallback location)
  static const double _defaultLatitude = 20.949584767464962;
  static const double _defaultLongitude = 72.91402425098836;

  // 🟢 Get default latitude
  static double getDefaultLatitude() {
    return _defaultLatitude;
  }

  // 🔵 Get default longitude
  static double getDefaultLongitude() {
    return _defaultLongitude;
  }
}
