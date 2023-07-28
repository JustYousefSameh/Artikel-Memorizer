import 'package:shared_preferences/shared_preferences.dart';

class MyThemePreferences {
  static const THEME_KEY = "theme_key";

  Future<bool> toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final currentTheme = await getTheme();
    sharedPreferences.setBool(THEME_KEY, !currentTheme);
    return !currentTheme;
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_KEY) ?? false;
  }
}
