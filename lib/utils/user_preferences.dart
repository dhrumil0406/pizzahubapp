import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyUserId = "userid";

  // Save userId
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  // Get userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Clear all user data (Logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Clear particular user
  static Future<void> logoutUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId); // only clears userid
  }
}