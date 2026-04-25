import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  static const _keyRegistered = 'is_registered';
  static const _keyUserName = 'user_name';
  static const _keyLoggedIn = 'is_logged_in';

  Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRegistered) ?? false;
  }

  Future<void> setRegistered({required String userName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRegistered, true);
    await prefs.setString(_keyUserName, userName);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? '';
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, username);
    await prefs.setBool(_keyLoggedIn, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserName);
  }
}
