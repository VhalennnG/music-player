import 'package:flutter/material.dart';
import 'package:musicplayer/themes/dark-mode.dart';
import 'package:musicplayer/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePrefKey = 'themeMode';

  // initial light mode
  ThemeData _themeData = lightMode;

  // constructor to load the save theme
  ThemeProvider() {
    _loadTheme();
  }

  // get theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme(_themeData == darkMode);

    // update ui
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }

  //  save theme preference
  Future<void> _saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, isDarkMode);
  }

  //  load theme preference
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool(_themePrefKey) ?? false;
    _themeData = isDarkMode ? darkMode : lightMode;

    // notify
    notifyListeners();
  }
}
